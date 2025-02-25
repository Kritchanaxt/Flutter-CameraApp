plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.flutter_camerapp"
    compileSdk = project.findProperty("flutter.compileSdkVersion")?.toString()?.toInt() ?: 34
    ndkVersion = project.findProperty("flutter.ndkVersion")?.toString() ?: "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.flutter_camerapp"
        minSdk = project.findProperty("flutter.minSdkVersion")?.toString()?.toInt() ?: 21
        targetSdk = project.findProperty("flutter.targetSdkVersion")?.toString()?.toInt() ?: 34
        versionCode = project.findProperty("flutter.versionCode")?.toString()?.toInt() ?: 2
        versionName = project.findProperty("flutter.versionName")?.toString() ?: "1.1.0"
    }

    signingConfigs {
        create("release") {
            storeFile = file("~/Flutter-CameraApp/flutter_cameraApp/android/app/my-new-release-key.jks")
            storePassword = project.findProperty("KEYSTORE_PASSWORD")?.toString()
            keyAlias = "KEY_ALIAS"
            keyPassword = project.findProperty("KEY_PASSWORD")?.toString()
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("release")
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.." // เส้นทางของโปรเจกต์ Flutter
}
