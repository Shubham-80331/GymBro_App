import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/nutrition_model.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onDelete;

  const MealCard({
    super.key,
    required this.meal,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: Text(
                  meal.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete,
                  color: AppTheme.orange,
                  size: 20,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Text(
            '${meal.timestamp.hour.toString().padLeft(2, '0')}:${meal.timestamp.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.grey,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              _buildNutrientChip(
                'Calories',
                '${meal.calories}',
                AppTheme.orange,
              ),
              const SizedBox(width: 8),
              _buildNutrientChip(
                'Protein',
                '${meal.protein.toStringAsFixed(1)}g',
                AppTheme.neonGreen,
              ),
              const SizedBox(width: 8),
              _buildNutrientChip(
                'Carbs',
                '${meal.carbs.toStringAsFixed(1)}g',
                Colors.blue,
              ),
              const SizedBox(width: 8),
              _buildNutrientChip(
                'Fat',
                '${meal.fat.toStringAsFixed(1)}g',
                Colors.yellow,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
