🏋️ GymBro Tracker

A full-featured fitness tracking mobile application built with Flutter and Firebase.
Designed to help users track workouts, monitor nutrition, and measure progress with structured, data-driven insights.

🚀 Core Features
1. Workout Tracking
Log sets, reps, and weights
Built-in exercise library with muscle grouping
Custom exercise creation
Weekly workout planner (Push/Pull/Legs, etc.)
Workout history and performance stats

3. Nutrition Tracking
Daily calorie and protein tracking
Water intake monitoring
Macronutrient breakdown (protein, carbs, fats)
Personalized nutrition targets

3. Progress Monitoring
Weight tracking with charts
Body measurements tracking
BMI calculation
Progress photos

4. User System
Profile setup (age, weight, goals, activity level)
Automatic calorie/protein calculation
Fitness goal modes: Cut / Maintain / Bulk

5. Notifications
Workout reminders
Hydration alerts
Goal tracking notifications

##🛠️ Tech Stack

# Frontend
  Flutter
  Provider (State Management)
  fl_chart

# Backend (Firebase)
  Firebase Authentication
  Cloud Firestore
  Firebase Storage
  Firebase Cloud Messaging

  ⚙️ Setup
  git clone https://github.com/Shubham-80331/GymBro_App.git
 cd GymBro_App
 flutter pub get
 flutter run 

 Firebase Setup
Create Firebase project
Add Android app
Add google-services.json → android/app/
Enable:
  Authentication
  Firestore
  Storage
  Cloud Messaging

📁 Project Structure
  lib/
├── core/          # Theme, services, utilities
├── features/      # App modules (auth, workout, nutrition, etc.)
├── models/        # Data models
└── main.dart      # Entry point

📊 Database Design
-users
 -workouts
 -nutrition
 -progress
 -workoutPlans
 -exercises
 -weightEntries
 -progressPhotos
 
 🔮 Future Improvements
  AI-based workout recommendations
  Diet planning system
  Social features (sharing, leaderboard)
  Advanced analytics dashboard

  
