import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/workout_model.dart';

class ExerciseLibraryScreen extends StatefulWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  State<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  MuscleGroup? _selectedMuscleGroup;

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, workoutProvider, child) {
        final exercises = _selectedMuscleGroup != null
            ? workoutProvider.getExercisesByMuscleGroup(_selectedMuscleGroup!)
            : workoutProvider.exercises;
        
        return Scaffold(
          backgroundColor: AppTheme.darkBackground,
          appBar: AppBar(
            title: const Text('Exercise Library'),
          ),
          body: Column(
            children: [
              // Muscle Group Filter
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: MuscleGroup.values.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // All option
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: const Text('All'),
                          selected: _selectedMuscleGroup == null,
                          onSelected: (selected) {
                            setState(() {
                              _selectedMuscleGroup = null;
                            });
                          },
                          backgroundColor: AppTheme.cardColor,
                          selectedColor: AppTheme.neonGreen,
                          labelStyle: TextStyle(
                            color: _selectedMuscleGroup == null
                                ? AppTheme.darkBackground
                                : AppTheme.white,
                          ),
                        ),
                      );
                    }
                    
                    final muscleGroup = MuscleGroup.values[index - 1];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(muscleGroup.name.toUpperCase()),
                        selected: _selectedMuscleGroup == muscleGroup,
                        onSelected: (selected) {
                          setState(() {
                            _selectedMuscleGroup = selected ? muscleGroup : null;
                          });
                        },
                        backgroundColor: AppTheme.cardColor,
                        selectedColor: AppTheme.neonGreen,
                        labelStyle: TextStyle(
                          color: _selectedMuscleGroup == muscleGroup
                              ? AppTheme.darkBackground
                              : AppTheme.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Exercise List
              Expanded(
                child: exercises.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fitness_center,
                              color: AppTheme.grey,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No exercises found',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: exercises.length,
                        itemBuilder: (context, index) {
                          final exercise = exercises[index];
                          return _buildExerciseCard(exercise);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
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
            children: [
              Container(
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
              
              const SizedBox(width: 12),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.white,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      '${exercise.defaultSets} sets × ${exercise.defaultReps} reps',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          if (exercise.instructions != null) ...[
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.darkGrey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                exercise.instructions!,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.grey,
                ),
              ),
            ),
          ],
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.neonGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  exercise.muscleGroup.name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.neonGreen,
                  ),
                ),
              ),
              
              if (exercise.isCustom) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'CUSTOM',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.orange,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
