import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/nutrition_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/nutrition_model.dart';
import '../widgets/nutrition_progress_card.dart';
import '../widgets/meal_card.dart';
import '../widgets/water_tracker.dart';
import '../screens/add_meal_screen.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen>
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
    final nutritionProvider = Provider.of<NutritionProvider>(context, listen: false);
    
    final userId = authProvider.user?.uid ?? authProvider.userModel?.id;
    if (userId != null) {
      await Future.wait([
        nutritionProvider.loadTodayNutrition(userId),
        nutritionProvider.loadTodayWaterIntake(userId),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Nutrition'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.neonGreen,
          labelColor: AppTheme.neonGreen,
          unselectedLabelColor: AppTheme.grey,
          tabs: const [
            Tab(text: 'TODAY'),
            Tab(text: 'WATER'),
            Tab(text: 'MEALS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          TodayTab(),
          WaterTab(),
          MealsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddMealScreen(),
            ),
          );
        },
        backgroundColor: AppTheme.neonGreen,
        child: const Icon(
          Icons.add,
          color: AppTheme.darkBackground,
        ),
      ),
    );
  }
}

class TodayTab extends StatelessWidget {
  const TodayTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, NutritionProvider>(
      builder: (context, authProvider, nutritionProvider, child) {
        final userModel = authProvider.userModel;
        final todayNutrition = nutritionProvider.todayNutrition;
        
        if (userModel == null || nutritionProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle case where todayNutrition might still be null after loading
        final safeNutrition = todayNutrition ?? NutritionEntry(
          userId: userModel.id ?? 'guest_user',
          date: DateTime.now(),
          calories: 0,
          protein: 0,
          carbs: 0,
          fat: 0,
          water: 0,
          meals: [],
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today\'s Nutrition',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              
              const SizedBox(height: 24),
              
              NutritionProgressCard(
                title: 'Calories',
                current: safeNutrition.calories.toDouble(),
                target: userModel.calorieTarget.toDouble(),
                unit: 'kcal',
                color: AppTheme.orange,
                icon: Icons.local_fire_department,
              ),
              
              const SizedBox(height: 16),
              
              NutritionProgressCard(
                title: 'Protein',
                current: safeNutrition.protein,
                target: userModel.proteinTarget,
                unit: 'g',
                color: AppTheme.neonGreen,
                icon: Icons.fitness_center,
              ),
              
              const SizedBox(height: 16),
              
              NutritionProgressCard(
                title: 'Water',
                current: nutritionProvider.getTodayWaterTotal(),
                target: userModel.waterTarget,
                unit: 'L',
                color: Colors.blue,
                icon: Icons.water_drop,
              ),
              
              const SizedBox(height: 24),
              
              Text(
                'Quick Add',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final userId = authProvider.user?.uid ?? authProvider.userModel?.id;
                        if (userId != null) {
                          nutritionProvider.addWaterIntake(
                            userId,
                            0.25,
                          );
                        }
                      },
                      icon: const Icon(Icons.water_drop),
                      label: const Text('+250ml'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final userId = authProvider.user?.uid ?? authProvider.userModel?.id;
                        if (userId != null) {
                          nutritionProvider.addWaterIntake(
                            userId,
                            0.5,
                          );
                        }
                      },
                      icon: const Icon(Icons.water_drop),
                      label: const Text('+500ml'),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    final userId = authProvider.user?.uid ?? authProvider.userModel?.id;
                    if (userId != null) {
                      nutritionProvider.addWaterIntake(
                        userId,
                        1.0,
                      );
                    }
                  },
                  icon: const Icon(Icons.water_drop),
                  label: const Text('+1L'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class WaterTab extends StatelessWidget {
  const WaterTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, NutritionProvider>(
      builder: (context, authProvider, nutritionProvider, child) {
        final userModel = authProvider.userModel;
        
        if (userModel == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Water Intake',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              
              const SizedBox(height: 24),
              
              WaterTracker(
                current: nutritionProvider.getTodayWaterTotal(),
                target: userModel.waterTarget,
                onAddWater: (amount) {
                  final userId = authProvider.user?.uid ?? authProvider.userModel?.id;
                  if (userId != null) {
                    nutritionProvider.addWaterIntake(userId, amount);
                  }
                },
              ),
              
              const SizedBox(height: 24),
              
              Text(
                'Today\'s Intake',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              
              const SizedBox(height: 16),
              
              Expanded(
                child: nutritionProvider.todayWaterIntake.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.water_drop,
                              color: AppTheme.grey,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No water intake recorded',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Start tracking your water intake',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: nutritionProvider.todayWaterIntake.length,
                        itemBuilder: (context, index) {
                          final water = nutritionProvider.todayWaterIntake[index];
                          return ListTile(
                            leading: Icon(
                              Icons.water_drop,
                              color: Colors.blue,
                            ),
                            title: Text(
                              '${water.amount.toStringAsFixed(2)}L',
                              style: const TextStyle(color: AppTheme.white),
                            ),
                            subtitle: Text(
                              '${water.timestamp.hour.toString().padLeft(2, '0')}:${water.timestamp.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(color: AppTheme.grey),
                            ),
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

class MealsTab extends StatelessWidget {
  const MealsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, NutritionProvider>(
      builder: (context, authProvider, nutritionProvider, child) {
        final todayNutrition = nutritionProvider.todayNutrition;
        
        if (nutritionProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today\'s Meals',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              
              const SizedBox(height: 24),
              
              Expanded(
                child: (todayNutrition == null || todayNutrition.meals.isEmpty)
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.restaurant,
                              color: AppTheme.grey,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No meals recorded',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Add your first meal to start tracking',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: todayNutrition.meals.length,
                        itemBuilder: (context, index) {
                          final meal = todayNutrition.meals[index];
                          return MealCard(
                            meal: meal,
                            onDelete: () {
                              final userId = authProvider.user?.uid ?? authProvider.userModel?.id;
                              if (userId != null) {
                                nutritionProvider.deleteMeal(userId, meal);
                              }
                            },
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
