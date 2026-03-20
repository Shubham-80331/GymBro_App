import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/auth_wrapper.dart';
import 'features/home/providers/home_provider.dart';
import 'features/workout/providers/workout_provider.dart';
import 'features/nutrition/providers/nutrition_provider.dart';
import 'features/profile/providers/profile_provider.dart';
import 'features/progress/providers/progress_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  final notificationService = NotificationService();
  await notificationService.initialize();
  
  FirebaseMessaging.onBackgroundMessage(FirebaseMessagingBackgroundHandler);

  runApp(const GymBroTracker());
}

@pragma('vm:entry-point')
Future<void> FirebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class GymBroTracker extends StatelessWidget {
  const GymBroTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ChangeNotifierProvider(create: (_) => NutritionProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
      ],
      child: MaterialApp(
        title: 'Gym Bro Tracker',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}
