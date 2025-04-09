# 🚀 Attendance App with Face Detection - Flutter
Welcome to the Attendance App with Face Detection project! This Flutter application allows users to mark their attendance using their face. The app integrates with Firebase for real-time data storage and Firebase ML Kit for face detection.

## 🛠 Tech Stack
**Backend**:
- Firebase Firestore (Database)
- Firebase Storage
- Google ML Kit Face Detection

**Frontend**:
- Flutter 3.22
- Dart 3.2
- Camera Plugin
- Geolocator
- Intl for Localization

## 🌟 Key Features
- 📸 Real-time Face Detection using ML Kit
- 📍 Location Tracking with Geolocator
- 🔥 Firebase Integration (Auth/Firestore/Storage)
- 📅 Attendance History with Date/Time
- 🖼 Image Capture & Storage
- 📱 Cross-platform (Android/iOS)

## 📂 Project Structure
```
lib/
├── main.dart
├── page/
│   ├── absen/       # Attendance page
│   ├── history/     # Attendance history
│   ├── leave/       # Leave management
│   └── main_page.dart
├── utils/
│   └── facedetection/ # Face detection logic
android/
├── app/
│   └── google-services.json # Firebase config
assets/
├── images/          # App icons
└── raw/             # Lottie animations
```

## 🖥 Local Setup
```bash
flutter pub get
flutter run
```

## 🔑 Firebase Configuration
1. Download `google-services.json` from Firebase Console
2. Place in `android/app` directory

## 👨💻 Author
- GitHub: [@hashiifabdillah](https://github.com/hashiifab)
- LinkedIn: [Hashiif Abdillah](https://www.linkedin.com/in/hashiif-abdillah-665373297/)
