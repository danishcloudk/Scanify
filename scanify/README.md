# Scanify 📄🔍

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)

**Scanify** is a sleek, feature-rich Flutter application that empowers you to digitize your physical documents effortlessly. Built with a modern dark-mode aesthetic, Scanify combines document scanning, Optical Character Recognition (OCR), and even location-based weather tagging into a seamless user experience.

## ✨ Features

- **📸 Smart Document Scanning**: High-quality document scanning leveraging Google ML Kit.
- **📝 Optical Character Recognition (OCR)**: Extract text from your scanned documents instantly.
- **🌤️ Smart Tagging**: Automatically tags your scans with the current weather and location data.
- **📄 PDF Export**: Save your scanned documents directly as PDF files.
- **💾 History & Local Storage**: Keeps a secure local record of all your previous scans using `SharedPreferences`.
- **📤 Easy Sharing**: Share your scanned PDFs or extracted text with a single tap.
- **🎨 Modern UI**: A beautiful, fluid dark-mode interface built with custom Google Fonts, Shimmer effects, and Lottie animations.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (SDK ^3.11.5)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Core Services**:
  - `google_mlkit_document_scanner` (Document Scanning)
  - `google_mlkit_text_recognition` (OCR)
  - `geolocator` & `geocoding` (Location)
  - `http` (Weather API / Networking)
- **Storage & Utilities**:
  - `pdf` (PDF Generation)
  - `path_provider` (File System Access)
  - `shared_preferences` (Local History)
  - `share_plus` (Sharing Capabilities)
  - `permission_handler` (Permissions Management)
- **UI Enhancements**:
  - `lottie` (Animations)
  - `shimmer` (Loading Effects)
  - `google_fonts` (Typography)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (version ^3.11.5 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- A physical device or emulator for testing camera features

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository_url>
   cd scanify
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## 📂 Project Structure

```text
lib/
├── controllers/      # Provider controllers for state management
├── models/           # Data models (Scans, Weather, etc.)
├── services/         # Core business logic
│   ├── history_service.dart
│   ├── ocr_service.dart
│   ├── permissions_service.dart
│   ├── save_service.dart
│   ├── scanner_service.dart
│   ├── sharing_service.dart
│   └── weather_service.dart
├── ui/               # User interface components
│   ├── screens/      # Main application screens (Home, Preview, etc.)
│   └── widgets/      # Reusable UI components
└── main.dart         # Entry point and theme configuration
```

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!
Feel free to check [issues page](#) if you want to contribute.

