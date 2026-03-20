import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../workout/screens/workout_screen.dart';
import '../../nutrition/screens/nutrition_screen.dart';
import '../../progress/screens/progress_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/user_model.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/progress_bar.dart';
import '../widgets/streak_counter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardTab(),
    const WorkoutScreen(),
    const NutritionScreen(),
    const ProgressScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    
    if (authProvider.user != null) {
      await homeProvider.loadHomeData(authProvider.user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Nutrition',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, HomeProvider>(
      builder: (context, authProvider, homeProvider, child) {
        final userModel = authProvider.userModel;
        
        if (userModel == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.grey,
                          ),
                        ),
                        Text(
                          userModel.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.white,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    StreakCounter(
                      workoutStreak: userModel.workoutStreak,
                      waterStreak: userModel.waterStreak,
                      proteinStreak: userModel.proteinStreak,
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Today's Workout
                DashboardCard(
                  title: 'Today\'s Workout',
                  subtitle: homeProvider.getTodayWorkoutName() ?? 'Rest Day',
                  icon: Icons.fitness_center,
                  color: AppTheme.neonGreen,
                  onTap: () {
                    // Navigate to workout screen
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Nutrition Progress
                DashboardCard(
                  title: 'Nutrition Progress',
                  child: Column(
                    children: [
                      _buildNutritionRow(
                        'Calories',
                        homeProvider.getTodayCalorieProgress(),
                        userModel.calorieTarget.toDouble(),
                        'kcal',
                        AppTheme.orange,
                      ),
                      const SizedBox(height: 12),
                      _buildNutritionRow(
                        'Protein',
                        homeProvider.getTodayProteinProgress(),
                        userModel.proteinTarget,
                        'g',
                        AppTheme.neonGreen,
                      ),
                      const SizedBox(height: 12),
                      _buildNutritionRow(
                        'Water',
                        homeProvider.getTodayWaterProgress(),
                        userModel.waterTarget,
                        'L',
                        Colors.blue,
                      ),
                    ],
                  ),
                  icon: Icons.restaurant,
                  color: AppTheme.orange,
                  onTap: () {
                    // Navigate to nutrition screen
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Recent Workouts
                DashboardCard(
                  title: 'Recent Workouts',
                  child: Column(
                    children: homeProvider.recentWorkouts.take(3).map((workout) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.neonGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.fitness_center,
                            color: AppTheme.neonGreen,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          workout.name,
                          style: const TextStyle(
                            color: AppTheme.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${workout.date.day}/${workout.date.month}/${workout.date.year}',
                          style: const TextStyle(color: AppTheme.grey),
                        ),
                        trailing: Text(
                          '${workout.duration.inMinutes} min',
                          style: const TextStyle(color: AppTheme.grey),
                        ),
                      );
                    }).toList(),
                  ),
                  icon: Icons.history,
                  color: AppTheme.darkGrey,
                  onTap: () {
                    // Navigate to workout history
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Quick Actions
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Start workout
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('START WORKOUT'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Log water
                        },
                        icon: const Icon(Icons.water_drop),
                        label: const Text('LOG WATER'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNutritionRow(
    String label,
    double current,
    double target,
    String unit,
    Color color,
  ) {
    final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${current.round()} / ${target.round()} $unit',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ProgressBar(
          progress: progress,
          color: color,
        ),
      ],
    );
  }
}
