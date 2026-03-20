import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/workout_model.dart';

class WorkoutPlanCard extends StatelessWidget {
  final WorkoutPlan? workoutPlan;
  final VoidCallback? onEdit;

  const WorkoutPlanCard({
    super.key,
    this.workoutPlan,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    return Container(
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
              const Text(
                'Weekly Schedule',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.white,
                ),
              ),
              if (onEdit != null)
                TextButton(
                  onPressed: onEdit,
                  child: const Text('EDIT'),
                ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          ...days.asMap().entries.map((entry) {
            final dayIndex = entry.key + 1; // 1-7 for Monday-Sunday
            final dayName = entry.value;
            final workout = workoutPlan?.weeklyPlan[dayIndex];
            final isToday = DateTime.now().weekday == dayIndex;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isToday
                          ? AppTheme.neonGreen.withOpacity(0.2)
                          : AppTheme.darkGrey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: isToday
                          ? Border.all(color: AppTheme.neonGreen)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        dayName.substring(0, 3),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isToday
                              ? AppTheme.neonGreen
                              : AppTheme.white,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: workout != null
                            ? AppTheme.neonGreen.withOpacity(0.1)
                            : AppTheme.darkGrey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: workout != null
                              ? AppTheme.neonGreen.withOpacity(0.3)
                              : AppTheme.darkGrey,
                        ),
                      ),
                      child: Text(
                        workout ?? 'Rest Day',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: workout != null
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: workout != null
                              ? AppTheme.neonGreen
                              : AppTheme.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
