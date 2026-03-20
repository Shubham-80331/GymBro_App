import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../../models/user_model.dart';
import '../../../core/theme/app_theme.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  
  Gender _selectedGender = Gender.male;
  ActivityLevel _selectedActivityLevel = ActivityLevel.moderately;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    if (user != null) {
      final userModel = UserModel(
        id: user.uid,
        name: _nameController.text.trim(),
        email: user.email ?? '',
        age: int.parse(_ageController.text),
        gender: _selectedGender,
        height: double.parse(_heightController.text),
        weight: double.parse(_weightController.text),
        activityLevel: _selectedActivityLevel,
        fitnessGoal: FitnessGoal.maintain, // Will be set in next step
        createdAt: DateTime.now(),
      );

      authProvider.createUserProfile(userModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profile Setup',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.white,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                const Text(
                  'Tell us about yourself to personalize your experience',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.grey,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Age',
                          prefixIcon: Icon(Icons.cake),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your age';
                          }
                          final age = int.tryParse(value);
                          if (age == null || age < 10 || age > 100) {
                            return 'Please enter a valid age';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Gender Selection
                      const Text(
                        'Gender',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.white,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Row(
                        children: Gender.values.map((gender) {
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: gender != Gender.other ? 8 : 0),
                              child: ChoiceChip(
                                label: Text(gender.name.toUpperCase()),
                                selected: _selectedGender == gender,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _selectedGender = gender;
                                    });
                                  }
                                },
                                backgroundColor: AppTheme.cardColor,
                                selectedColor: AppTheme.neonGreen,
                                labelStyle: TextStyle(
                                  color: _selectedGender == gender
                                      ? AppTheme.darkBackground
                                      : AppTheme.white,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Height (cm)',
                          prefixIcon: Icon(Icons.height),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your height';
                          }
                          final height = double.tryParse(value);
                          if (height == null || height < 100 || height > 250) {
                            return 'Please enter a valid height';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Weight (kg)',
                          prefixIcon: Icon(Icons.monitor_weight),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your weight';
                          }
                          final weight = double.tryParse(value);
                          if (weight == null || weight < 30 || weight > 300) {
                            return 'Please enter a valid weight';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Activity Level Selection
                      const Text(
                        'Activity Level',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.white,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Column(
                        children: ActivityLevel.values.map((level) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: RadioListTile<ActivityLevel>(
                              title: Text(
                                _getActivityLevelDescription(level),
                                style: const TextStyle(color: AppTheme.white),
                              ),
                              subtitle: Text(
                                _getActivityLevelDetail(level),
                                style: const TextStyle(color: AppTheme.grey),
                              ),
                              value: level,
                              groupValue: _selectedActivityLevel,
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedActivityLevel = value;
                                  });
                                }
                              },
                              activeColor: AppTheme.neonGreen,
                              contentPadding: EdgeInsets.zero,
                            ),
                          );
                        }).toList(),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      ElevatedButton(
                        onPressed: _saveProfile,
                        child: const Text('CONTINUE'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getActivityLevelDescription(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 'Sedentary';
      case ActivityLevel.lightly:
        return 'Lightly Active';
      case ActivityLevel.moderately:
        return 'Moderately Active';
      case ActivityLevel.very:
        return 'Very Active';
    }
  }

  String _getActivityLevelDetail(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 'Little to no exercise';
      case ActivityLevel.lightly:
        return 'Light exercise 1-3 days/week';
      case ActivityLevel.moderately:
        return 'Moderate exercise 3-5 days/week';
      case ActivityLevel.very:
        return 'Hard exercise 6-7 days/week';
    }
  }
}
