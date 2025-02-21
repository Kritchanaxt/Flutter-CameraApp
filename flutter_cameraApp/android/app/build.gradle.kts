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
        versionCode = project.findProperty("flutter.versionCode")?.toString()?.toInt() ?: 1
        versionName = project.findProperty("flutter.versionName")?.toString() ?: "1.0.0"
    }

    signingConfigs {
    create("release") {
        storeFile = file("../keystore/my-release-key.jks") // ใช้ path ที่ถูกต้อง
        storePassword = System.getenv("KEYSTORE_PASSWORD") ?: "default-password"
        keyAlias = System.getenv("KEY_ALIAS") ?: "myKeyWafer"
        keyPassword = System.getenv("KEY_PASSWORD") ?: "default-key-password"
    }
}

buildTypes {
    release {
        isMinifyEnabled = false
        isShrinkResources = false
    }
}


}

flutter {
    source = "../.." // เส้นทางของโปรเจกต์ Flutter
}
