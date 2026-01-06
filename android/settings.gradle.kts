pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        val localPropsFile = file("local.properties")

        val sdkFromProps = if (localPropsFile.exists()) {
            localPropsFile.inputStream().use { properties.load(it) }
            properties.getProperty("flutter.sdk")
        } else null

        // Fallbacks if local.properties is missing or doesn't contain flutter.sdk:
        // 1) Environment variable FLUTTER_ROOT
        // 2) Environment variable FLUTTER_HOME
        // 3) $HOME/flutter
        sdkFromProps
            ?: System.getenv("FLUTTER_ROOT")
            ?: System.getenv("FLUTTER_HOME")
            ?: "${System.getProperty("user.home")}/flutter"
    }

    val flutterSdkDir = file(flutterSdkPath)
    if (flutterSdkDir.exists()) {
        includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")
    } else {
        // Avoid failing the build; warn and continue (CI builds can set the path separately).
        println("Warning: Flutter SDK not found at '$flutterSdkPath'. Skipping includeBuild for flutter_tools.")
    }

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.7.3" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

include(":app")
