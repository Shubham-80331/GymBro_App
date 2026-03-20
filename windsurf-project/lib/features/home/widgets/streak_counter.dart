import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class StreakCounter extends StatelessWidget {
  final int workoutStreak;
  final int waterStreak;
  final int proteinStreak;

  const StreakCounter({
    super.key,
    required this.workoutStreak,
    required this.waterStreak,
    required this.proteinStreak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.neonGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.neonGreen),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department,
            color: AppTheme.neonGreen,
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(
            '$workoutStreak',
            style: const TextStyle(
              color: AppTheme.neonGreen,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
