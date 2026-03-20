import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/progress_model.dart';

class AddWeightScreen extends StatefulWidget {
  const AddWeightScreen({super.key});

  @override
  State<AddWeightScreen> createState() => _AddWeightScreenState();
}

class _AddWeightScreenState extends State<AddWeightScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _addWeight() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final progressProvider = Provider.of<ProgressProvider>(context, listen: false);

    final weightEntry = WeightEntry(
      userId: authProvider.user!.uid,
      weight: double.parse(_weightController.text),
      date: DateTime.now(),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    await progressProvider.addWeightEntry(weightEntry);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Weight logged successfully!'),
          backgroundColor: AppTheme.neonGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Log Weight'),
        actions: [
          TextButton(
            onPressed: _addWeight,
            child: const Text('SAVE'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Weight Display
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  final userModel = authProvider.userModel;
                  
                  if (userModel != null) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.darkGrey),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info,
                            color: AppTheme.neonGreen,
                            size: 20,
                          ),
                          
                          const SizedBox(width: 12),
                          
                          Expanded(
                            child: Text(
                              'Current weight: ${userModel.weight.toStringAsFixed(1)} kg',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return const SizedBox.shrink();
                },
              ),
              
              const SizedBox(height: 24),
              
              const Text(
                'Enter Today\'s Weight',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.white,
                ),
              ),
              
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  prefixIcon: Icon(Icons.monitor_weight),
                  hintText: 'Enter your weight',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  final weight = double.tryParse(value);
                  if (weight == null || weight < 30 || weight > 300) {
                    return 'Please enter a valid weight (30-300 kg)';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                  prefixIcon: Icon(Icons.note),
                  hintText: 'Add any notes about today\'s weight',
                ),
                maxLines: 3,
              ),
              
              const SizedBox(height: 32),
              
              // Quick Entry Buttons
              const Text(
                'Quick Entry',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.white,
                ),
              ),
              
              const SizedBox(height: 12),
              
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  final currentWeight = authProvider.userModel?.weight ?? 70.0;
                  
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _quickEntryButton(
                        '${(currentWeight - 1).toStringAsFixed(1)} kg',
                        () => _weightController.text = (currentWeight - 1).toStringAsFixed(1),
                      ),
                      _quickEntryButton(
                        '${currentWeight.toStringAsFixed(1)} kg',
                        () => _weightController.text = currentWeight.toStringAsFixed(1),
                      ),
                      _quickEntryButton(
                        '${(currentWeight + 1).toStringAsFixed(1)} kg',
                        () => _weightController.text = (currentWeight + 1).toStringAsFixed(1),
                      ),
                    ],
                  );
                },
              ),
              
              const SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addWeight,
                  child: const Text('LOG WEIGHT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickEntryButton(String label, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
