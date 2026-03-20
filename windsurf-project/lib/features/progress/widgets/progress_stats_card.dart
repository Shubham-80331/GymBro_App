import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ProgressStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final double change;
  final String changeLabel;
  final IconData icon;
  final Color color;

  const ProgressStatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.change,
    required this.changeLabel,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = change >= 0;
    
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
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
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
                        fontSize: 14,
                        color: AppTheme.grey,
                      ),
                    ),
                    
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.white,
                      ),
                    ),
                    
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isPositive
                  ? AppTheme.neonGreen.withOpacity(0.1)
                  : AppTheme.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isPositive ? AppTheme.neonGreen : AppTheme.orange,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: isPositive ? AppTheme.neonGreen : AppTheme.orange,
                  size: 16,
                ),
                
                const SizedBox(width: 4),
                
                Text(
                  '${isPositive ? '+' : ''}${change.abs().toStringAsFixed(1)} kg $changeLabel',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isPositive ? AppTheme.neonGreen : AppTheme.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
