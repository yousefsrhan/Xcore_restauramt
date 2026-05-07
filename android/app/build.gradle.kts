plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // 1. ضيف السطر ده هنا لتفعيل الفايربيس
}

android {
    namespace = "com.example.xcore_restaurant"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.xcore_restaurant"

        // 2. غير دي خليها 23 عشان الفايربيس و Flutter يشتغلوا
        minSdk = 23

        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // 3. ضيف السطر ده عشان حجم المكتبات كبير
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // 4. ضيف السطر ده لدعم الـ MultiDex
    implementation("androidx.multidex:multidex:2.0.1")
}

flutter {
    source = "../.."
}
