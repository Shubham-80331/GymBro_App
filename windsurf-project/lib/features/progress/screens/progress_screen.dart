import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/progress_model.dart';
import '../widgets/weight_chart.dart';
import '../widgets/progress_stats_card.dart';
import '../widgets/measurement_card.dart';
import '../screens/add_weight_screen.dart';
import '../screens/add_measurements_screen.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final progressProvider = Provider.of<ProgressProvider>(context, listen: false);
    
    final userId = authProvider.user?.uid ?? authProvider.userModel?.id;
    if (userId != null) {
      await progressProvider.loadProgressData(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Progress'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.neonGreen,
          labelColor: AppTheme.neonGreen,
          unselectedLabelColor: AppTheme.grey,
          tabs: const [
            Tab(text: 'OVERVIEW'),
            Tab(text: 'WEIGHT'),
            Tab(text: 'MEASUREMENTS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          OverviewTab(),
          WeightTab(),
          MeasurementsTab(),
        ],
      ),
    );
  }
}

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, ProgressProvider>(
      builder: (context, authProvider, progressProvider, child) {
        final userModel = authProvider.userModel;
        final weightChange = progressProvider.getWeightChange();
        final totalChange = progressProvider.getTotalWeightChange();
        
        if (userModel == null || progressProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progress Overview',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              
              const SizedBox(height: 24),
              
              // Current Stats
              ProgressStatsCard(
                title: 'Current Weight',
                value: '${userModel.weight.toStringAsFixed(1)} kg',
                subtitle: 'BMI: ${userModel.bmi.toStringAsFixed(1)}',
                change: weightChange,
                changeLabel: 'vs last week',
                icon: Icons.monitor_weight,
                color: AppTheme.neonGreen,
              ),
              
              const SizedBox(height: 16),
              
              ProgressStatsCard(
                title: 'Total Progress',
                value: '${totalChange.abs().toStringAsFixed(1)} kg',
                subtitle: totalChange > 0 ? 'Weight gained' : 'Weight lost',
                change: totalChange,
                changeLabel: 'since start',
                icon: Icons.trending_up,
                color: totalChange > 0 ? AppTheme.orange : AppTheme.neonGreen,
              ),
              
              const SizedBox(height: 24),
              
              // Quick Actions
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddWeightScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('LOG WEIGHT'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddMeasurementsScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.straighten),
                      label: const Text('MEASUREMENTS'),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Recent Progress
              Text(
                'Recent Progress',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              
              const SizedBox(height: 16),
              
              if (progressProvider.progressEntries.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.darkGrey),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.trending_up,
                        color: AppTheme.grey,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No progress recorded yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Start logging your weight and measurements',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: progressProvider.progressEntries.take(5).length,
                  itemBuilder: (context, index) {
                    final entry = progressProvider.progressEntries[index];
                    return ListTile(
                      leading: Icon(
                        Icons.calendar_today,
                        color: AppTheme.neonGreen,
                      ),
                      title: Text(
                        '${entry.date.day}/${entry.date.month}/${entry.date.year}',
                        style: const TextStyle(color: AppTheme.white),
                      ),
                      subtitle: entry.weight != null
                          ? Text(
                              'Weight: ${entry.weight?.toStringAsFixed(1)} kg',
                              style: const TextStyle(color: AppTheme.grey),
                            )
                          : null,
                      trailing: entry.notes != null
                          ? Icon(
                              Icons.note,
                              color: AppTheme.grey,
                              size: 20,
                            )
                          : null,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class WeightTab extends StatelessWidget {
  const WeightTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressProvider>(
      builder: (context, progressProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Weight History',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddWeightScreen(),
                        ),
                      );
                    },
                    child: const Text('ADD'),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              if (progressProvider.weightHistory.isNotEmpty)
                WeightChart(
                  data: progressProvider.getWeightChartData(),
                )
              else
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.darkGrey),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.monitor_weight,
                          color: AppTheme.grey,
                          size: 48,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No weight data yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Start tracking your weight',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
              const SizedBox(height: 24),
              
              Expanded(
                child: ListView.builder(
                  itemCount: progressProvider.weightHistory.length,
                  itemBuilder: (context, index) {
                    final entry = progressProvider.weightHistory[index];
                    return ListTile(
                      leading: Icon(
                        Icons.monitor_weight,
                        color: AppTheme.neonGreen,
                      ),
                      title: Text(
                        '${entry.weight.toStringAsFixed(1)} kg',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.white,
                        ),
                      ),
                      subtitle: Text(
                        '${entry.date.day}/${entry.date.month}/${entry.date.year}',
                        style: const TextStyle(color: AppTheme.grey),
                      ),
                      trailing: entry.notes != null
                          ? Icon(
                              Icons.note,
                              color: AppTheme.grey,
                              size: 20,
                            )
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MeasurementsTab extends StatelessWidget {
  const MeasurementsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressProvider>(
      builder: (context, progressProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Body Measurements',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddMeasurementsScreen(),
                        ),
                      );
                    },
                    child: const Text('ADD'),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              if (progressProvider.progressEntries.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.darkGrey),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.straighten,
                        color: AppTheme.grey,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No measurements yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Track your body measurements',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.grey,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: progressProvider.progressEntries.length,
                    itemBuilder: (context, index) {
                      final entry = progressProvider.progressEntries[index];
                      if (entry.measurements == null) return const SizedBox.shrink();
                      
                      final measurements = entry.measurements!;
                      
                      return MeasurementCard(
                        date: entry.date,
                        measurements: measurements,
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
