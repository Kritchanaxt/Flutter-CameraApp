// Declare Kotlin version in buildscript
buildscript {
    val kotlin_version = "1.5.31" // You can update this to the latest Kotlin version

    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version")
    }
}

plugins {
    id("com.android.application")
    id("kotlin-android") // Android Kotlin plugin
    id("dev.flutter.flutter-gradle-plugin") // Flutter plugin
    kotlin("android") // Kotlin Android support
    id("kotlin-parcelize") // Parcelize plugin
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
            storeFile = file("/Users/kritchanaxt_./Desktop/Flutter-CameraApp/flutter_cameraApp/android/app/my-new-release-key.jks")
            storePassword = project.findProperty("KEYSTORE_PASSWORD")?.toString()
            keyAlias = "KeyStoreWafer"
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

    viewBinding {
        enable = true // Corrected here
    }
}

dependencies {
    val kotlin_version = "1.8.10" // Update Kotlin version

    // CameraX dependencies
    implementation("androidx.camera:camera-core:1.3.0")
    implementation("androidx.camera:camera-camera2:1.3.0")
    implementation("androidx.camera:camera-lifecycle:1.3.0")
    implementation("androidx.camera:camera-view:1.3.0")
    implementation("androidx.camera:camera-video:1.1.0")

    // AppCompat and Core dependencies
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("androidx.core:core-ktx:1.12.0")

    // Guava for Android
    implementation("com.google.guava:guava:32.1.2-android") // Ensure Guava is up-to-date

    // Kotlin standard library
    implementation("org.jetbrains.kotlin:kotlin-stdlib:$kotlin_version")

    // Activity Result API (For using registerForActivityResult)
    implementation("androidx.activity:activity-ktx:1.2.4")
}


flutter {
    source = "../.." // Path to your Flutter project
}
