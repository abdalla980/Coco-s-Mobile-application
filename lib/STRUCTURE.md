# Project Structure

This document describes the folder structure of Coco's Mobile Application

## Directory Structure

```
lib/
├── main.dart                          # Application entry point
├── firebase_options.dart              # Firebase configuration (to be moved to core/config)
│
├── core/                              # Core functionality
│   ├── config/                       # Configuration files
│   │   └── env_config.dart           # Environment configuration
│   └── services/                      # Business logic services
│       ├── auth_service.dart          # Authentication service
│       ├── facebook_auth_service.dart # Facebook authentication
│       ├── facebook_api_service.dart  # Facebook API integration
│       ├── instagram_api_service.dart # Instagram API integration
│       ├── social_connection_service.dart # Social media connections
│       ├── ai_caption_service.dart    # AI caption generation
│       └── location_service.dart      # Location services
│
├── features/                          # Feature-based modules
│   ├── auth/                         # Authentication features
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   │
│   ├── onboarding/                   # User onboarding flow
│   │   ├── welcomePage.dart
│   │   ├── splash_screen.dart
│   │   └── questions/               # Onboarding questions
│   │       ├── Question1.dart
│   │       ├── Question2.dart
│   │       ├── Question3.dart
│   │       ├── Question4.dart
│   │       └── Question5.dart
│   │
│   ├── dashboard/                    # Main dashboard
│   │   ├── Dashboard.dart
│   │   └── HomeScreen.dart
│   │
│   ├── settings/                     # Settings and preferences
│   │   └── Settings.dart
│   │
│   ├── website_maker/                # Website builder feature
│   │   ├── webQuestion1.dart
│   │   ├── webQuestion2.dart
│   │   ├── webQuestion3.dart
│   │   └── WebsiteRequested.dart
│   │
│   └── social/                       # Social media features
│       ├── connect_social_page.dart
│       ├── camera_capture_page.dart
│       └── post_preview_page.dart
│
└── utils/                            # Utility files
    └── key_hash_temp.dart            # Temporary key hash utility
```



