# Chat StartKit

A modern Flutter chat application built with Clean Architecture and the BLoC pattern.

## 🚀 Features

- Clean Architecture pattern
- BLoC for state management
- GoRouter for navigation
- Dio for network requests
- Dark/Light theme support
- Environment configuration
- Logging

## 🛠️ Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (included with Flutter)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/chat-startkit-flutter.git
   cd chat-startkit-flutter
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Copy the `.env.example` to `.env` and update the values:
   ```bash
   cp .env.example .env
   ```

4. Run the app:
   - For Web (Chrome):
     ```bash
     flutter run -d chrome
     ```
   - For iOS (Simulator):
     ```bash
     flutter run -d ios
     ```
   - For Android (Emulator/Device):
     ```bash
     flutter run -d android
     ```
   - For all connected devices:
     ```bash
     flutter run -d all
     ```

## 📝 Environment Variables

Create a `.env` file in the root directory with the following variables:

```env
# Environment
FLAVOR=development

# API
API_BASE_URL=https://api.example.com
API_TIMEOUT=30000

# Logging
LOG_LEVEL=debug
ENABLE_LOGGING=true
```

## 📱 Screenshots

*Screenshots will be added here*

## 🤝 Contributing

Contributions are welcome! Please read our [contributing guidelines](CONTRIBUTING.md) to get started.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.