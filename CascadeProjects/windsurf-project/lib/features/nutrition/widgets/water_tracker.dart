import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class WaterTracker extends StatelessWidget {
  final double current;
  final double target;
  final Function(double) onAddWater;

  const WaterTracker({
    super.key,
    required this.current,
    required this.target,
    required this.onAddWater,
  });

  @override
  Widget build(BuildContext context) {
    final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          // Water Glass Animation
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 3),
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              Container(
                width: 100,
                height: 100,
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ),
              Icon(
                Icons.water_drop,
                color: Colors.blue,
                size: 40,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          Text(
            '${current.toStringAsFixed(1)}L / ${target.toStringAsFixed(1)}L',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.white,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            '${(progress * 100).round()}% of daily goal',
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.grey,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Quick Add Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => onAddWater(0.25),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.withOpacity(0.2),
                    foregroundColor: Colors.blue,
                  ),
                  child: const Text('+250ml'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => onAddWater(0.5),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.withOpacity(0.2),
                    foregroundColor: Colors.blue,
                  ),
                  child: const Text('+500ml'),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => onAddWater(1.0),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.withOpacity(0.2),
                foregroundColor: Colors.blue,
              ),
              child: const Text('+1L'),
            ),
          ),
        ],
      ),
    );
  }
}
