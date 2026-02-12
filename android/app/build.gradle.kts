import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load key.properties for production release signing
val keyPropertiesFile = rootProject.file("key.properties")
val keyProperties = Properties()
if (keyPropertiesFile.exists()) {
    keyProperties.load(keyPropertiesFile.inputStream())
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

    // Production release signing config from key.properties
    signingConfigs {
        if (keyPropertiesFile.exists()) {
            create("release") {
                keyAlias = keyProperties["keyAlias"]?.toString()
                keyPassword = keyProperties["keyPassword"]?.toString()
                val storeFilePath = keyProperties["storeFile"]?.toString()
                storeFile = storeFilePath?.let { project.file(it) }
                storePassword = keyProperties["storePassword"]?.toString()
            }
        }
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
            // Use release key when key.properties exists (for production release).
            // Otherwise fall back to debug so other flavors can build.
            signingConfig = if (keyPropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}
