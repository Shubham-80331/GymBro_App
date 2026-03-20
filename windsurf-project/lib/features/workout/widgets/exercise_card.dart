import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/workout_model.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.darkGrey),
        ),
        child: Row(
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
                  
                  if (exercise.muscleGroup != null)
                    Text(
                      exercise.muscleGroup.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.neonGreen,
                        fontWeight: FontWeight.w600,
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
