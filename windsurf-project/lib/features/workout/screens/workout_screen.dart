import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/workout_model.dart';
import '../widgets/exercise_card.dart';
import '../widgets/workout_plan_card.dart';
import '../screens/workout_planner_screen.dart';
import '../screens/exercise_library_screen.dart';
import '../screens/workout_tracking_screen.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen>
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
    final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    
    final userId = authProvider.user?.uid ?? authProvider.userModel?.id;
    if (userId != null) {
      await Future.wait([
        workoutProvider.loadExercises(),
        workoutProvider.loadUserWorkouts(userId),
        workoutProvider.loadWorkoutPlan(userId),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Workout'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.neonGreen,
          labelColor: AppTheme.neonGreen,
          unselectedLabelColor: AppTheme.grey,
          tabs: const [
            Tab(text: 'TODAY'),
            Tab(text: 'PLAN'),
            Tab(text: 'HISTORY'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const TodayTab(),
          const PlanTab(),
          const HistoryTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WorkoutTrackingScreen(),
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
    return Consumer<WorkoutProvider>(
      builder: (context, workoutProvider, child) {
        final todayWorkout = workoutProvider.workoutPlan?.weeklyPlan[DateTime.now().weekday];
        
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today\'s Workout',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              
              const SizedBox(height: 16),
              
              if (todayWorkout != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.neonGreen),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.fitness_center,
                            color: AppTheme.neonGreen,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            todayWorkout,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.neonGreen,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WorkoutTrackingScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('START WORKOUT'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                    ],
                  ),
                )
              else
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
                        Icons.timer,
                        color: AppTheme.grey,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Rest Day',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Take time to recover and grow',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              
              const SizedBox(height: 24),
              
              Text(
                'Quick Exercises',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              
              const SizedBox(height: 16),
              
              Expanded(
                child: ListView.builder(
                  itemCount: workoutProvider.exercises.take(5).length,
                  itemBuilder: (context, index) {
                    final exercise = workoutProvider.exercises[index];
                    return ExerciseCard(
                      exercise: exercise,
                      onTap: () {
                        // Quick add to workout
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

class PlanTab extends StatelessWidget {
  const PlanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, workoutProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Weekly Plan',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WorkoutPlannerScreen(),
                        ),
                      );
                    },
                    child: const Text('EDIT'),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              WorkoutPlanCard(
                workoutPlan: workoutProvider.workoutPlan,
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WorkoutPlannerScreen(),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 24),
              
              Text(
                'Workout Templates',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              
              const SizedBox(height: 16),
              
              Expanded(
                child: ListView(
                  children: [
                    _buildTemplateCard(
                      context,
                      'Push Pull Legs',
                      '3-day split focusing on compound movements',
                      Icons.fitness_center,
                      () {
                        // Apply template
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildTemplateCard(
                      context,
                      'Upper/Lower Split',
                      '4-day split alternating upper and lower body',
                      Icons.sync_alt,
                      () {
                        // Apply template
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildTemplateCard(
                      context,
                      'Full Body',
                      '3-day full body workout for beginners',
                      Icons.accessibility,
                      () {
                        // Apply template
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTemplateCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.darkGrey),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.neonGreen.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppTheme.neonGreen,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, workoutProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Workout History',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              
              const SizedBox(height: 16),
              
              Expanded(
                child: workoutProvider.workouts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              color: AppTheme.grey,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No workouts yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppTheme.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Start your first workout to see history',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: workoutProvider.workouts.length,
                        itemBuilder: (context, index) {
                          final workout = workoutProvider.workouts[index];
                          return _buildWorkoutCard(context, workout);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWorkoutCard(BuildContext context, Workout workout) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.darkGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                workout.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.white,
                ),
              ),
              Text(
                '${workout.date.day}/${workout.date.month}/${workout.date.year}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.grey,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              Icon(
                Icons.fitness_center,
                color: AppTheme.neonGreen,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${workout.exercises.length} exercises',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.grey,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.timer,
                color: AppTheme.neonGreen,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${workout.duration.inMinutes} min',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.grey,
                ),
              ),
            ],
          ),
          
          if (workout.exercises.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...workout.exercises.take(3).map((exercise) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppTheme.neonGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        exercise.exerciseName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            if (workout.exercises.length > 3)
              Text(
                '+${workout.exercises.length - 3} more',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.neonGreen,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
