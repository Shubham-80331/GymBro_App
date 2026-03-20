import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/workout_model.dart';

class WorkoutPlannerScreen extends StatefulWidget {
  const WorkoutPlannerScreen({super.key});

  @override
  State<WorkoutPlannerScreen> createState() => _WorkoutPlannerScreenState();
}

class _WorkoutPlannerScreenState extends State<WorkoutPlannerScreen> {
  final Map<int, String> _weeklyPlan = {};
  final List<String> _workoutOptions = [
    'Chest Day',
    'Back Day',
    'Legs Day',
    'Shoulders Day',
    'Arms Day',
    'Cardio',
    'Rest',
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentPlan();
  }

  void _loadCurrentPlan() {
    final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    final currentPlan = workoutProvider.workoutPlan;
    
    if (currentPlan != null) {
      _weeklyPlan.clear();
      _weeklyPlan.addAll(currentPlan.weeklyPlan);
    } else {
      // Default plan
      _weeklyPlan.addAll({
        1: 'Chest Day',    // Monday
        2: 'Back Day',     // Tuesday
        3: 'Legs Day',     // Wednesday
        4: 'Shoulders Day', // Thursday
        5: 'Arms Day',     // Friday
        6: 'Cardio',       // Saturday
        7: 'Rest',         // Sunday
      });
    }
  }

  Future<void> _savePlan() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    
    if (authProvider.user != null) {
      final plan = WorkoutPlan(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: authProvider.user!.uid,
        weeklyPlan: _weeklyPlan,
      );
      
      await workoutProvider.updateWorkoutPlan(plan);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Workout plan updated!'),
            backgroundColor: AppTheme.neonGreen,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Workout Planner'),
        actions: [
          TextButton(
            onPressed: _savePlan,
            child: const Text('SAVE'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Plan Your Week',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.white,
              ),
            ),
            
            const SizedBox(height: 8),
            
            const Text(
              'Assign workouts for each day of the week',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.grey,
              ),
            ),
            
            const SizedBox(height: 24),
            
            ...days.asMap().entries.map((entry) {
              final dayIndex = entry.key + 1;
              final dayName = entry.value;
              final selectedWorkout = _weeklyPlan[dayIndex];
              final isToday = DateTime.now().weekday == dayIndex;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isToday
                        ? AppTheme.neonGreen.withOpacity(0.1)
                        : AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isToday
                          ? AppTheme.neonGreen
                          : AppTheme.darkGrey,
                      width: isToday ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            dayName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isToday
                                  ? AppTheme.neonGreen
                                  : AppTheme.white,
                            ),
                          ),
                          if (isToday) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.neonGreen,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'TODAY',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.darkBackground,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      DropdownButtonFormField<String>(
                        value: selectedWorkout,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: AppTheme.darkBackground,
                        ),
                        items: _workoutOptions.map((workout) {
                          return DropdownMenuItem<String>(
                            value: workout,
                            child: Text(
                              workout,
                              style: const TextStyle(color: AppTheme.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _weeklyPlan[dayIndex] = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
            
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _savePlan,
                child: const Text('SAVE WORKOUT PLAN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
