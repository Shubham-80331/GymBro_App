import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/progress_model.dart';

class MeasurementCard extends StatelessWidget {
  final DateTime date;
  final BodyMeasurements measurements;

  const MeasurementCard({
    super.key,
    required this.date,
    required this.measurements,
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
            children: [
              Icon(
                Icons.straighten,
                color: AppTheme.neonGreen,
                size: 20,
              ),
              
              const SizedBox(width: 8),
              
              Text(
                '${date.day}/${date.month}/${date.year}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.white,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildMeasurementItem(
                  'Chest',
                  '${measurements.chest.toStringAsFixed(1)} cm',
                  AppTheme.neonGreen,
                ),
              ),
              
              Expanded(
                child: _buildMeasurementItem(
                  'Arms',
                  '${measurements.arms.toStringAsFixed(1)} cm',
                  AppTheme.orange,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildMeasurementItem(
                  'Waist',
                  '${measurements.waist.toStringAsFixed(1)} cm',
                  Colors.blue,
                ),
              ),
              
              Expanded(
                child: _buildMeasurementItem(
                  'Thighs',
                  '${measurements.thighs.toStringAsFixed(1)} cm',
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 4),
          
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.white,
            ),
          ),
        ],
      ),
    );
  }
}
