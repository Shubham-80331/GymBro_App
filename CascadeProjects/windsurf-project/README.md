# Gym Bro Tracker

A comprehensive fitness tracking application designed specifically for gym enthusiasts. Built with Flutter and Firebase, this app helps users track workouts, nutrition, progress, and stay consistent with their fitness goals.

## Features

### 🏋️ Workout Tracking
- Complete workout logging with sets, reps, and weight
- Built-in exercise library with muscle group categorization
- Custom exercise creation
- Rest timer with customizable durations
- Workout planner with weekly scheduling
- Workout history and statistics
- Pre-built workout templates (Push Pull Legs, Upper/Lower Split, Full Body)

### 🍎 Nutrition Tracking
- Daily calorie and protein tracking
- Water intake monitoring with quick-add buttons
- Meal logging with macronutrient breakdown
- Personalized nutrition targets based on fitness goals
- Visual progress indicators

### 📊 Progress Tracking
- Weight tracking with interactive charts
- Body measurements (chest, arms, waist, thighs)
- BMI calculation and categorization
- Progress photos
- Historical data visualization

### 🔥 Streak System
- Workout streak tracking
- Water intake streak
- Protein goal streak
- Motivational streak counters on dashboard

### 👤 User Profile
- Complete profile setup with age, gender, height, weight
- Activity level selection
- Fitness goal setting (Cut, Maintain, Bulk)
- Automatic calorie and protein calculations
- Profile customization

### 🔔 Notifications
- Workout reminders
- Hydration reminders
- Protein goal notifications
- Firebase Cloud Messaging integration

## Tech Stack

### Frontend
- **Flutter** - Cross-platform mobile development
- **Provider** - State management
- **fl_chart** - Interactive charts
- **intl** - Internationalization
- **image_picker** - Image handling

### Backend
- **Firebase** - Backend-as-a-Service
- **Firebase Authentication** - User authentication
- **Cloud Firestore** - NoSQL database
- **Firebase Storage** - File storage
- **Firebase Cloud Messaging** - Push notifications

### Design
- **Dark Theme** - Modern, masculine aesthetic
- **Neon Green & Orange** - Accent colors
- **Minimal UI** - Clean and simple interface
- **Fast Interactions** - Optimized for gym use

## Installation

### Prerequisites
- Flutter SDK (>=3.10.0)
- Android Studio / VS Code
- Firebase account

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd gym-bro-tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add an Android app with package name `com.example.gym_bro_tracker`
   - Download `google-services.json` and place it in `android/app/`
   - Enable Authentication (Email, Google), Firestore, Storage, and Cloud Messaging

4. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/
│   ├── theme/           # App theme and colors
│   ├── services/        # Firebase services
│   └── utils/           # Utility functions
├── features/
│   ├── auth/            # Authentication screens and providers
│   ├── home/            # Home dashboard
│   ├── workout/         # Workout tracking
│   ├── nutrition/       # Nutrition tracking
│   ├── progress/        # Progress tracking
│   └── profile/         # User profile
├── models/              # Data models
└── main.dart           # App entry point
```

## Key Features Explained

### BMI & Calorie Calculator
The app automatically calculates BMI and provides personalized calorie targets based on:
- Age, gender, height, weight
- Activity level (Sedentary, Lightly, Moderately, Very active)
- Fitness goals (Cut, Maintain, Bulk)

### Workout System
- **Exercise Library**: Pre-loaded with common exercises for all muscle groups
- **Workout Tracking**: Log sets, reps, and weight for each exercise
- **Rest Timer**: Automatic rest periods between sets with visual countdown
- **Weekly Planner**: Schedule workouts for each day of the week

### Nutrition Tracking
- **Daily Targets**: Automatically calculated based on user profile and goals
- **Quick Logging**: Fast meal and water intake logging
- **Macronutrients**: Track calories, protein, carbs, and fat
- **Visual Progress**: See daily and weekly nutrition progress

### Progress Monitoring
- **Weight Charts**: Visual representation of weight changes over time
- **Body Measurements**: Track measurements for all major muscle groups
- **Progress Photos**: Visual comparison of physical changes
- **Statistics**: Comprehensive progress analytics

## Database Schema

### Collections
- **users**: User profiles and settings
- **workouts**: Workout logs and exercise data
- **nutrition**: Daily nutrition entries
- **progress**: Progress tracking data
- **workoutPlans**: Weekly workout schedules
- **exercises**: Exercise library
- **weightEntries**: Weight tracking history
- **progressPhotos**: Progress photo storage

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please open an issue in the GitHub repository.

---

**Built with ❤️ for fitness enthusiasts**
