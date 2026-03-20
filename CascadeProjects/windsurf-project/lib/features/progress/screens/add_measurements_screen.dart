import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/progress_model.dart';

class AddMeasurementsScreen extends StatefulWidget {
  const AddMeasurementsScreen({super.key});

  @override
  State<AddMeasurementsScreen> createState() => _AddMeasurementsScreenState();
}

class _AddMeasurementsScreenState extends State<AddMeasurementsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _chestController = TextEditingController();
  final _armsController = TextEditingController();
  final _waistController = TextEditingController();
  final _thighsController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _chestController.dispose();
    _armsController.dispose();
    _waistController.dispose();
    _thighsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _addMeasurements() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final progressProvider = Provider.of<ProgressProvider>(context, listen: false);

    final measurements = BodyMeasurements(
      chest: double.parse(_chestController.text),
      arms: double.parse(_armsController.text),
      waist: double.parse(_waistController.text),
      thighs: double.parse(_thighsController.text),
      date: DateTime.now(),
    );

    final progressEntry = ProgressEntry(
      userId: authProvider.user!.uid,
      date: DateTime.now(),
      measurements: measurements,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    await progressProvider.addProgressEntry(progressEntry);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Measurements logged successfully!'),
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
        title: const Text('Log Measurements'),
        actions: [
          TextButton(
            onPressed: _addMeasurements,
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
              const Text(
                'Body Measurements',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.white,
                ),
              ),
              
              const SizedBox(height: 8),
              
              const Text(
                'Measure in centimeters (cm)',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.grey,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Chest Measurement
              TextFormField(
                controller: _chestController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Chest',
                  prefixIcon: Icon(Icons.accessibility),
                  hintText: 'Enter chest measurement',
                  suffixText: 'cm',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter chest measurement';
                  }
                  final measurement = double.tryParse(value);
                  if (measurement == null || measurement < 50 || measurement > 200) {
                    return 'Please enter a valid measurement (50-200 cm)';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Arms Measurement
              TextFormField(
                controller: _armsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Arms',
                  prefixIcon: Icon(Icons.fitness_center),
                  hintText: 'Enter arms measurement',
                  suffixText: 'cm',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter arms measurement';
                  }
                  final measurement = double.tryParse(value);
                  if (measurement == null || measurement < 20 || measurement > 80) {
                    return 'Please enter a valid measurement (20-80 cm)';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Waist Measurement
              TextFormField(
                controller: _waistController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Waist',
                  prefixIcon: Icon(Icons.straighten),
                  hintText: 'Enter waist measurement',
                  suffixText: 'cm',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter waist measurement';
                  }
                  final measurement = double.tryParse(value);
                  if (measurement == null || measurement < 50 || measurement > 200) {
                    return 'Please enter a valid measurement (50-200 cm)';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Thighs Measurement
              TextFormField(
                controller: _thighsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Thighs',
                  prefixIcon: Icon(Icons.accessibility_new),
                  hintText: 'Enter thighs measurement',
                  suffixText: 'cm',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter thighs measurement';
                  }
                  final measurement = double.tryParse(value);
                  if (measurement == null || measurement < 30 || measurement > 100) {
                    return 'Please enter a valid measurement (30-100 cm)';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                  prefixIcon: Icon(Icons.note),
                  hintText: 'Add any notes about today\'s measurements',
                ),
                maxLines: 3,
              ),
              
              const SizedBox(height: 32),
              
              // Measurement Tips
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.neonGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.neonGreen.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          color: AppTheme.neonGreen,
                          size: 20,
                        ),
                        
                        const SizedBox(width: 8),
                        
                        const Text(
                          'Measurement Tips',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.neonGreen,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    const Text(
                      '• Measure at the same time of day\n'
                      '• Use a flexible measuring tape\n'
                      '• Keep the tape level and snug\n'
                      '• Don\'t pull too tight\n'
                      '• Take measurements while relaxed',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.grey,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addMeasurements,
                  child: const Text('LOG MEASUREMENTS'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
