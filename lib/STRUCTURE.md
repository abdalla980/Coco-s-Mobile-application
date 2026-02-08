# Project Structure

This document describes the folder structure of Coco's Mobile Application

## Directory Structure

```
lib/
├── main.dart                          # Application entry point
├── firebase_options.dart              # Firebase configuration
│
├── config/                            # Configuration files
│   └── env_config.dart                # Environment configuration
│
├── core/                              # Core functionality
│   ├── di/                            # Dependency injection
│   │   └── service_locator.dart       # GetIt service locator
│   ├── providers/                     # Riverpod providers
│   │   └── providers.dart             # Auth and user data providers
│   ├── router/                        # Navigation
│   │   └── app_router.dart            # GoRouter configuration
│   └── services/                      # Business logic services
│       ├── auth_service.dart
│       ├── facebook_auth_service.dart
│       ├── facebook_api_service.dart
│       ├── instagram_api_service.dart
│       ├── social_connection_service.dart
│       ├── ai_caption_service.dart
│       └── location_service.dart
│
├── features/                          # Feature-based modules
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   │
│   ├── onboarding/
│   │   ├── welcome_page.dart
│   │   ├── splash_screen.dart
│   │   └── questions/
│   │       ├── question_1.dart
│   │       ├── question_2.dart
│   │       ├── question_3.dart
│   │       ├── question_4.dart
│   │       └── question_5.dart
│   │
│   ├── dashboard/
│   │   ├── dashboard.dart
│   │   └── home_screen.dart
│   │
│   ├── settings/
│   │   └── settings.dart
│   │
│   ├── website_maker/
│   │   ├── web_question_1.dart
│   │   ├── web_question_2.dart
│   │   ├── web_question_3.dart
│   │   └── website_requested.dart
│   │
│   └── social/
│       ├── connect_social_page.dart
│       ├── camera_capture_page.dart
│       └── post_preview_page.dart
│
└── utils/
    └── key_hash_temp.dart

test/
├── helpers/
│   └── mocks.dart                     # Mock classes for testing
├── unit/
│   └── services/
│       └── auth_service_test.dart
└── widget/
    └── login_screen_test.dart
```
<<<<<<< HEAD




=======
>>>>>>> f6c78c94e720d7358fe8ee55ce3975c649576953
