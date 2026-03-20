import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/workout_model.dart';
import '../widgets/exercise_card.dart';
import '../widgets/rest_timer_widget.dart';

class WorkoutTrackingScreen extends StatefulWidget {
  const WorkoutTrackingScreen({super.key});

  @override
  State<WorkoutTrackingScreen> createState() => _WorkoutTrackingScreenState();
}

class _WorkoutTrackingScreenState extends State<WorkoutTrackingScreen> {
  final List<WorkoutExercise> _exercises = [];
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _setsController = TextEditingController(text: '1');
  
  bool _isWorkoutActive = false;
  DateTime? _workoutStartTime;
  int _currentExerciseIndex = 0;
  bool _showRestTimer = false;

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    _setsController.dispose();
    super.dispose();
  }

  void _startWorkout() {
    setState(() {
      _isWorkoutActive = true;
      _workoutStartTime = DateTime.now();
    });
  }

  void _finishWorkout() async {
    if (_exercises.isEmpty || _workoutStartTime == null) return;
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);
    
    final workout = Workout(
      userId: authProvider.user!.uid,
      date: DateTime.now(),
      name: 'Quick Workout',
      primaryMuscleGroup: _exercises.isNotEmpty
          ? _exercises.first.muscleGroup
          : MuscleGroup.chest,
      exercises: _exercises,
      duration: DateTime.now().difference(_workoutStartTime!),
      totalVolume: _calculateTotalVolume(),
      completedAt: DateTime.now(),
    );
    
    await workoutProvider.createWorkout(workout);
    
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Workout completed!'),
          backgroundColor: AppTheme.neonGreen,
        ),
      );
    }
  }

  int _calculateTotalVolume() {
    int totalVolume = 0;
    for (final exercise in _exercises) {
      for (final set in exercise.sets) {
        totalVolume += (set.weight * set.reps).round();
      }
    }
    return totalVolume;
  }

  void _addSet() {
    if (_weightController.text.isEmpty || _repsController.text.isEmpty) return;
    
    final weight = double.parse(_weightController.text);
    final reps = int.parse(_repsController.text);
    
    // This is a simplified version - in reality you'd select an exercise first
    final exerciseSet = ExerciseSet(reps: reps, weight: weight);
    
    setState(() {
      // Add to current exercise (simplified)
      if (_exercises.isEmpty) {
        _exercises.add(
          WorkoutExercise(
            exerciseId: 'custom',
            exerciseName: 'Custom Exercise',
            muscleGroup: MuscleGroup.chest,
            sets: [exerciseSet],
          ),
        );
      } else {
        _exercises.last.sets.add(exerciseSet);
      }
      
      // Clear inputs
      _weightController.clear();
      _repsController.clear();
      _setsController.text = '1';
      
      // Show rest timer
      _showRestTimer = true;
    });
  }

  void _onRestTimerComplete() {
    setState(() {
      _showRestTimer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: Text(_isWorkoutActive ? 'Workout in Progress' : 'Start Workout'),
        actions: [
          if (_isWorkoutActive)
            TextButton(
              onPressed: _finishWorkout,
              child: const Text('FINISH'),
            ),
        ],
      ),
      body: _showRestTimer
          ? RestTimerWidget(
              duration: 60, // 60 seconds rest
              onComplete: _onRestTimerComplete,
            )
          : _buildWorkoutContent(),
    );
  }

  Widget _buildWorkoutContent() {
    if (!_isWorkoutActive) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center,
              color: AppTheme.neonGreen,
              size: 80,
            ),
            const SizedBox(height: 24),
            const Text(
              'Ready to Workout?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Track your exercises, sets, and progress',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.grey,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _startWorkout,
              icon: const Icon(Icons.play_arrow),
              label: const Text('START WORKOUT'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Workout Timer
          if (_workoutStartTime != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.neonGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.neonGreen),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer,
                    color: AppTheme.neonGreen,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Workout Duration:',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.white,
                    ),
                  ),
                  const Spacer(),
                  StreamBuilder(
                    stream: Stream.periodic(const Duration(seconds: 1)),
                    builder: (context, snapshot) {
                      final duration = DateTime.now().difference(_workoutStartTime!);
                      final hours = duration.inHours;
                      final minutes = duration.inMinutes % 60;
                      final seconds = duration.inSeconds % 60;
                      
                      return Text(
                        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.neonGreen,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          
          const SizedBox(height: 24),
          
          // Exercise Entry
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
                const Text(
                  'Add Exercise',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.white,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Weight (kg)',
                          filled: true,
                          fillColor: AppTheme.darkBackground,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _repsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Reps',
                          filled: true,
                          fillColor: AppTheme.darkBackground,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        controller: _setsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Sets',
                          filled: true,
                          fillColor: AppTheme.darkBackground,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                ElevatedButton(
                  onPressed: _addSet,
                  child: const Text('ADD SET'),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Exercise List
          const Text(
            'Today\'s Exercises',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.white,
            ),
          ),
          
          const SizedBox(height: 16),
          
          if (_exercises.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.darkGrey),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.fitness_center,
                    color: AppTheme.grey,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No exercises added yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.grey,
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _exercises.length,
              itemBuilder: (context, index) {
                final exercise = _exercises[index];
                return _buildExerciseItem(exercise);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildExerciseItem(WorkoutExercise exercise) {
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
          Text(
            exercise.exerciseName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.white,
            ),
          ),
          
          const SizedBox(height: 12),
          
          ...exercise.sets.asMap().entries.map((entry) {
            final setIndex = entry.key + 1;
            final set = entry.value;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppTheme.neonGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        setIndex.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.neonGreen,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  Expanded(
                    child: Text(
                      '${set.weight}kg × ${set.reps} reps',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.white,
                      ),
                    ),
                  ),
                  
                  IconButton(
                    onPressed: () {
                      setState(() {
                        exercise.sets.removeAt(entry.key);
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: AppTheme.orange,
                      size: 20,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
