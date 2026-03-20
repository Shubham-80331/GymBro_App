import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/user_model.dart';

class ProfileStats extends StatelessWidget {
  final UserModel userModel;

  const ProfileStats({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.darkGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Targets',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.white,
            ),
          ),
          
          const SizedBox(height: 16),
          
          _buildTargetRow(
            'Calories',
            '${userModel.calorieTarget} kcal',
            Icons.local_fire_department,
            AppTheme.orange,
          ),
          
          const SizedBox(height: 12),
          
          _buildTargetRow(
            'Protein',
            '${userModel.proteinTarget.toStringAsFixed(1)} g',
            Icons.fitness_center,
            AppTheme.neonGreen,
          ),
          
          const SizedBox(height: 12),
          
          _buildTargetRow(
            'Water',
            '${userModel.waterTarget.toStringAsFixed(1)} L',
            Icons.water_drop,
            Colors.blue,
          ),
          
          const SizedBox(height: 20),
          
          const Text(
            'Activity Level',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.white,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.neonGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.neonGreen),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.directions_run,
                  color: AppTheme.neonGreen,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _getActivityLevelText(userModel.activityLevel),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.neonGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),
        
        const SizedBox(width: 12),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getActivityLevelText(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 'Sedentary - Little to no exercise';
      case ActivityLevel.lightly:
        return 'Lightly Active - Light exercise 1-3 days/week';
      case ActivityLevel.moderately:
        return 'Moderately Active - Moderate exercise 3-5 days/week';
      case ActivityLevel.very:
        return 'Very Active - Hard exercise 6-7 days/week';
    }
  }
}
