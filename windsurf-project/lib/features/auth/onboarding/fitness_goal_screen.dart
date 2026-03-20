import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../../models/user_model.dart';
import '../../../core/theme/app_theme.dart';
import '../../home/screens/home_screen.dart';

class FitnessGoalScreen extends StatefulWidget {
  const FitnessGoalScreen({super.key});

  @override
  State<FitnessGoalScreen> createState() => _FitnessGoalScreenState();
}

class _FitnessGoalScreenState extends State<FitnessGoalScreen> {
  FitnessGoal _selectedGoal = FitnessGoal.maintain;

  void _saveGoal() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userModel = authProvider.userModel;

    if (userModel != null) {
      final updatedUser = userModel.copyWith(fitnessGoal: _selectedGoal);
      authProvider.updateUserProfile(updatedUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final userModel = authProvider.userModel;
        
        if (userModel == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Fitness Goal',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.white,
                ),
              ),
              
              const SizedBox(height: 8),
              
              const Text(
                'What\'s your primary fitness goal?',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.grey,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // BMI Information
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.darkGrey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your BMI: ${userModel.bmi.toStringAsFixed(1)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.neonGreen,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      'Category: ${userModel.bmiCategory}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppTheme.white,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      'Suggested goal: ${userModel.goalSuggestion}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.grey,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Goal Selection
              ...FitnessGoal.values.map((goal) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedGoal = goal;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _selectedGoal == goal
                            ? AppTheme.neonGreen.withOpacity(0.1)
                            : AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedGoal == goal
                              ? AppTheme.neonGreen
                              : AppTheme.darkGrey,
                          width: _selectedGoal == goal ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _getGoalIcon(goal),
                                color: _selectedGoal == goal
                                    ? AppTheme.neonGreen
                                    : AppTheme.grey,
                                size: 24,
                              ),
                              
                              const SizedBox(width: 12),
                              
                              Text(
                                goal.name.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedGoal == goal
                                      ? AppTheme.neonGreen
                                      : AppTheme.white,
                                ),
                              ),
                              
                              const Spacer(),
                              
                              if (_selectedGoal == goal)
                                const Icon(
                                  Icons.check_circle,
                                  color: AppTheme.neonGreen,
                                  size: 24,
                                ),
                            ],
                          ),
                          
                          const SizedBox(height: 8),
                          
                          Text(
                            _getGoalDescription(goal),
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.grey,
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          Text(
                            _getGoalCalories(goal, userModel),
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
              
              const Spacer(),
              
              ElevatedButton(
                onPressed: () {
                  _saveGoal();
                },
                child: const Text('COMPLETE SETUP'),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getGoalIcon(FitnessGoal goal) {
    switch (goal) {
      case FitnessGoal.cut:
        return Icons.fitness_center;
      case FitnessGoal.maintain:
        return Icons.balance;
      case FitnessGoal.bulk:
        return Icons.trending_up;
    }
  }

  String _getGoalDescription(FitnessGoal goal) {
    switch (goal) {
      case FitnessGoal.cut:
        return 'Lose body fat while preserving muscle mass';
      case FitnessGoal.maintain:
        return 'Maintain current weight and body composition';
      case FitnessGoal.bulk:
        return 'Build muscle mass and increase strength';
    }
  }

  String _getGoalCalories(FitnessGoal goal, UserModel user) {
    final calories = user.calorieTarget;
    final protein = user.proteinTarget;
    
    switch (goal) {
      case FitnessGoal.cut:
        return 'Target: $calories calories/day, ${protein.toStringAsFixed(1)}g protein';
      case FitnessGoal.maintain:
        return 'Target: $calories calories/day, ${protein.toStringAsFixed(1)}g protein';
      case FitnessGoal.bulk:
        return 'Target: $calories calories/day, ${protein.toStringAsFixed(1)}g protein';
    }
  }
}
