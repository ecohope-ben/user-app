plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.ecohope.user_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.ecohope.user_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += "environment"

    productFlavors {
        create("production") {
            dimension = "environment"
            applicationId = "com.ecohope.user_app" // Production 的 package name
            resValue("string", "app_name", "EcoHope") // App 名稱
        }
        create("staging") {
            dimension = "environment"
            applicationId = "com.ecohope.user_app"
            resValue("string", "app_name", "EcoHope(Stg)")
            applicationIdSuffix = ".staging" // 可選：自動加後綴
        }

        create("int") {
            dimension = "environment"
            applicationId = "com.ecohope.user_app"
            resValue("string", "app_name", "EcoHope(int)")
            applicationIdSuffix = ".int"
        }
        create("uat") {
            dimension = "environment"
            applicationId = "com.ecohope.user_app"
            resValue("string", "app_name", "EcoHope(UAT)")
            applicationIdSuffix = ".uat"
        }
        create("dev") {
            dimension = "environment"
            applicationId = "com.ecohope.user_app"
            resValue("string", "app_name", "EcoHope(Dev)")
            applicationIdSuffix = ".dev"
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
