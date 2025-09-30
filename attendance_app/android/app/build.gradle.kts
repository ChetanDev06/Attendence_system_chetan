plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.attendance_app"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.attendance_app"
        minSdk = 21            // keep as is or higher if needed
        targetSdk = 36          // match compileSdk or higher
        versionCode = 1
        versionName = "1.0"
    }

    ndkVersion = "27.0.12077973"

    buildTypes {
        debug {
            isMinifyEnabled = false
            isShrinkResources = false // <--- turn this off
        }
        release {
            isMinifyEnabled = true
            isShrinkResources = true
        }
    }
}

flutter {
    source = "../.."
}
