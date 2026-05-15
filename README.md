# Sanayee - Home Services Platform

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.2+-blue.svg)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-2.10.3+-green.svg)](https://supabase.com)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20-lightgrey.svg)]()

> **🎓 University Graduation Project** | **🤖 Developed with Significant AI Assistance**

---

## 📱 Overview

**Sanayee** is a cross-platform mobile application designed to bridge the gap between clients seeking home repair and construction services and skilled professionals such as electricians, plumbers, carpenters, and other tradesmen.

The application leverages modern development practices to create a seamless experience for both service providers and customers, enabling them to connect, negotiate, and complete projects efficiently.

### ✨ Key Features

- **Secure Authentication**: Secure login and registration system with role-based access control (Clients & Professionals)
- **Professional Discovery**: Explore and browse different professionals and available services
- **Service Requests**: Create and manage service requests with various specialization categories
- **Real-time Negotiation System**: Chat-based system for negotiating service terms and pricing
- **Professional Profiles**: Comprehensive profiles showcasing professional details and ratings
- **Geolocation Support**: Find professionals near your location
- **Real-time Chat**: Direct messaging between clients and professionals
- **Request Management**: Track and manage all service requests
- **Rating & Review System**: Rate and review completed services
- **Admin Dashboard**: Comprehensive admin tools for platform monitoring

## 🛠 Technology Stack

### Frontend
| Tool | Version | Description |
|------|---------|-------------|
| **Flutter** | 3.9.2+ | Cross-platform development framework |
| **Dart** | 3.9.2+ | Programming language |
| **BLoC** | 9.0.1+ | State management (`flutter_bloc: 9.1.1`) |
| **Go Router** | 14.6.2+ | Navigation and routing |
| **Material Design** | Built-in | UI/UX design patterns |

### Backend & Database
| Tool | Version | Description |
|------|---------|-------------|
| **Supabase** | 2.10.3+ | Backend as a Service (BaaS) |
| **PostgreSQL** | - | Database |
| **Hive** | 2.2.3+ | Local data persistence |
| **Real-time Subscriptions** | - | Live notifications |

### Additional Key Packages
| Package | Version | Usage |
|---------|---------|-------|
| **google_maps_flutter** | 2.10.0+ | Geolocation & maps |
| **image_picker** | 1.0.4+ | Image selection |
| **flutter_rating_bar** | 4.0.1+ | Rating system |
| **cached_network_image** | 3.4.1+ | Image caching |
| **geolocator** | 13.0.2+ | GPS & geolocation services |
| **formz** | 0.7.0+ | Form validation |
| **dartz** | 0.10.1+ | Functional programming |
| **injectable** | 2.5.0+ | Dependency injection |
| **intl** | 0.20.2+ | Internationalization |
| **freezed** | 2.5.7+ | Code generation |
| **flutter_local_notifications** | 19.4.2+ | Local notifications |
| **flutter_carousel_widget** | 3.1.0+ | Image carousel |

## 📦 Project Structure

```
sanayee_app/
├── lib/                              # Main application code
│   ├── app/                          # Application configuration
│   │   ├── app.dart                  # Root app widget
│   │   ├── router.dart               # Navigation configuration
│   │   ├── bootstrap.dart            # App initialization
│   │   ├── injection.dart            # Dependency injection
│   │   ├── admin_app.dart            # Admin application
│   │   ├── env.dart                  # Environment variables
│   │   └── supabase_module.dart      # Supabase module
│   │
│   ├── core/                         # Core utilities & constants
│   │   ├── config/                   # App configuration
│   │   │   ├── app_colors.dart       # Color palette
│   │   │   ├── app_theme.dart        # Theme settings
│   │   │   ├── app_typography.dart   # Font styles
│   │   │   └── app_spacing.dart      # Spacing system
│   │   ├── constants/                # App constants
│   │   │   ├── app_strings.dart      # String constants
│   │   │   └── specializations.dart  # Available specializations
│   │   ├── error/                    # Error handling
│   │   ├── services/                 # Core services
│   │   ├── utils/                    # Utility functions
│   │   └── widgets/                  # Shared widgets
│   │
│   ├── features/                     # Feature modules
│   │   ├── auth/                     # Authentication & Registration
│   │   │   ├── data/                 # Data layer
│   │   │   ├── domain/               # Business logic layer
│   │   │   └── presentation/         # UI layer
│   │   │
│   │   ├── hiring/                   # Service search & hiring
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │
│   │   ├── chat/                     # Chat & messaging
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │
│   │   ├── professionals/            # Professional management
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │
│   │   ├── profile/                  # User profiles
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │
│   │   ├── requests/                 # Service requests management
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │
│   │   ├── ratings/                  # Ratings & reviews
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │
│   │   ├── notifications/            # Notifications
│   │   │   └── domain/
│   │   │
│   │   └── admin/                    # Admin dashboard
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   │
│   ├── shared/                       # Shared components
│   │   └── widgets/                  # Shared widgets
│   │
│   ├── main.dart                     # Main entry point
│   └── main_admin.dart               # Admin entry point
│
├── assets/                           # Static assets
│   ├── images/                       # UI images
│   │   ├── sanayee_logo.png
│   │   ├── splash.png
│   │   ├── photo_onboarding.png
│   │   └── placeholders/
│   ├── fonts/                        # Custom fonts
│   │   ├── Cairo-Regular.ttf
│   │   └── Cairo-Bold.ttf
│   └── data/                         # Data files
│       └── west_bank_localities_ar.json
│
├── screenshots/                      # App screenshots
├── android/                          # Android native code
├── ios/                              # iOS native code
├── web/                              # Web platform code
├── windows/                          # Windows platform code
├── macos/                            # macOS platform code
├── linux/                            # Linux platform code
│
├── pubspec.yaml                      # Dependencies & configuration
├── pubspec.lock                      # Dependency lock file
├── analysis_options.yaml             # Dart analysis configuration
│
└── scripts/                          # Helper scripts
    ├── run_supabase.ps1              # Run Supabase locally
    ├── run_dual_recommended.bat      # Recommended run configuration
    ├── run_dual_smart.ps1            # Smart run configuration
    └── run_admin.ps1                 # Admin tools
```

## 🎨 Screenshots

### Authentication & Registration
| Login | Register (Client) | Register (Professional 1) |
|-------|-------------------|---------------------------|
| ![Login](screenshots/Login%20Page.png) | ![Register Client](screenshots/register%20page%20for%20client.png) | ![Register Pro 1](screenshots/register%20page%20for%20professional%201.png) |

| Register (Professional 2) | Home Page |  |
|---------------------------|-----------|---|
| ![Register Pro 2](screenshots/register%20page%20for%20professional%202.png) | ![Register](screenshots/Register%20Page.png) |  |

### User Profiles & Settings
| Profile | Account Settings |  |
|---------|-----------------|---|
| ![Profile](screenshots/Profile%20Page.png) | ![Account Settings](screenshots/Register%20Page.png) |  |

### Service Request Management
| Create New Request | Request Details |  |
|-------------------|-----------------|---|
| ![New Request](screenshots/New%20Request%20%20Page.png) | ![Request Details](screenshots/Request%20Details%20Page.png) |  |

### Negotiation & Communication
| Negotiation 1 | Negotiation 2 | Chat |
|--------------|--------------|------|
| ![Negotiation 1](screenshots/Negotiation%20Page.png) | ![Negotiation 2](screenshots/Negotiation%20Page%202.png) | ![Chat](screenshots/Chat%20Page.png) |

## 🚀 Getting Started

### Prerequisites
- Flutter 3.9.2 or higher
- Dart SDK
- Android Studio and/or Xcode (for native development)
- Git
- Supabase account (for backend and authentication)

### Installation & Setup

#### 1. Clone the Repository
```bash
git clone https://github.com/OdayJaradat/sanayee-APP.git
cd sanayee_app
```

#### 2. Install Dependencies
```bash
flutter pub get
```

#### 3. Generate Code (Code Generation)
```bash
# Generates code for Freezed, Hive, Injectable, etc.
flutter pub run build_runner build --delete-conflicting-outputs

# Or use
dart run build_runner build --delete-conflicting-outputs
```

#### 4. Setup Supabase
```bash
# 1. Create account at supabase.com
# 2. Create a new project
# 3. Get your credentials:
#    - SUPABASE_URL
#    - SUPABASE_ANON_KEY

# 4. Configure environment variables in lib/app/env.dart
# or set them as system environment variables
```

#### 5. Run the Application

### Helper Scripts

Several PowerShell scripts are provided for convenience:

```bash
# Run Supabase locally
powershell .\run_supabase.ps1

# Run with recommended configuration
powershell .\run_dual_recommended.bat

# Run with smart configuration
powershell .\run_dual_smart.ps1

# Run admin dashboard
powershell .\run_admin.ps1
```

## 🏗 Architecture & Structure

This project follows **Clean Architecture** principles with clear separation of concerns:

### Application Layers

```
┌─────────────────────────────────────────┐
│    Presentation Layer (UI)              │
│  - Pages                                │
│  - Widgets                              │
│  - BLoC/Cubit (State Management)        │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│     Domain Layer (Business Logic)       │
│  - Entities                             │
│  - Use Cases                            │
│  - Repository Contracts                 │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│     Data Layer (Data Access)            │
│  - Models                               │
│  - Data Sources                         │
│  - Repository Implementations           │
└─────────────────────────────────────────┘
```

**Benefits:**
- Easy to test and maintain
- Separation of Concerns
- Reusability and flexibility
- Scalability and extensibility

## 📝 Features Documentation

### User Roles

#### 👤 Client Role
- **Search & Explore**: Browse available professionals and services
- **Create Requests**: Create detailed service requests with specific requirements
- **Communicate**: Direct messaging with professionals
- **Negotiate**: Discuss pricing, terms, and timelines
- **Rate & Review**: Rate completed services and leave reviews
- **Track Requests**: Monitor the status of all your requests

#### 🔧 Professional Role
- **Service Management**: Create and manage your service offerings
- **View Requests**: See incoming service requests
- **Negotiate**: Respond to requests and provide quotes
- **Schedule Management**: Manage your availability and schedule
- **Build Reputation**: Gain ratings and positive reviews
- **Project Tracking**: Monitor completed projects and earnings

## 🤖 AI-Assisted Development

This project was developed with significant assistance from **Artificial Intelligence**:

### Areas of AI Assistance
- ✅ Code generation and structure optimization
- ✅ Feature implementation
- ✅ Documentation and code comments
- ✅ UI/UX pattern recommendations
- ✅ Architecture and design suggestions
- ✅ Bug identification and fixes
- ✅ Performance optimization

> **Important Note**: While AI provided substantial support, all code has been reviewed, tested, and refined to ensure quality and functionality.

## 📱 Supported Platforms

| Platform | Status | Notes |
|----------|--------|-------|
| Android | ✅ Primary | Smartphones & tablets |
| iOS | ✅ Supported | iPhone & iPad |
| Web | ✅ Supported | Browser (Chrome, Firefox, Safari) |
| Windows | ✅ Supported | Desktop application |
| macOS | ✅ Supported | Desktop application |
| Linux | ✅ Supported | Desktop application |

## 🔐 Security Considerations

- **Secure Authentication**: Handled securely through Supabase
- **Local Data Encryption**: Sensitive data stored with Hive encryption
- **Secure Communications**: All communications use HTTPS
- **JWT Tokens**: Secure API access using JWT tokens
- **Input Validation**: Form validation and input sanitization
- **Role-Based Access Control**: RBAC system for authorization
- **Error Handling**: Safe error handling and exception management

## 🧪 Testing & Building

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test directory
flutter test test/features/auth/
```

### Building for Release

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```


## 📊 Project Progress

- **Current Version**: 1.0.0+1
- **Development Status**: Active development & continuous improvement
- **Repository**: [OdayJaradat/sanayee-APP](https://github.com/OdayJaradat/sanayee-APP)

## 📋 Planned Features

- [ ] Integrated payment system
- [ ] Advanced rating system
- [ ] AI-powered recommendations
- [ ] Advanced financial management
- [ ] Social media integration
- [ ] Analytics dashboard

## 📚 Resources & Documentation

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Supabase Documentation](https://supabase.com/docs)
- [BLoC Documentation](https://bloclibrary.dev/)
- [Go Router Documentation](https://pub.dev/packages/go_router)

## 👥 Contributors

| Role | Name | Notes |
|------|------|-------|
| **Student Developer** | Oday Jaradat | Project Owner |
| **University** | AAUP | Educational Institution |
| **Academic Year** | 2025/2026 | Graduation Year |

## 🙏 Acknowledgments

Special thanks to the following:

- **Flutter Team** for the excellent framework and comprehensive documentation
- **Supabase** for powerful and reliable backend services
- **Open Source Community** for all the useful packages
- **University Faculty** for continuous support and guidance
- **AI Assistants** for accelerating development and improving quality

---

<div align="center">

**Built with ❤️ as a University Graduation Project with AI Assistance**

</div>
