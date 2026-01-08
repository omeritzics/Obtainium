#!/bin/bash
# High-level environment sync and cleanup script

echo "Starting deep environment cleanup..."

# 1. Clean native Android legacy references
# This removes manual inclusions of plugins that might be missing
if [ -f "android/settings.gradle" ]; then
    sed -i "/background_fetch/d" android/settings.gradle || true
fi
if [ -f "android/app/build.gradle" ]; then
    sed -i "/background_fetch/d" android/app/build.gradle || true
fi
# Fix for .kts (Kotlin DSL) files if they exist
if [ -f "android/app/build.gradle.kts" ]; then
    sed -i "/background_fetch/d" android/app/build.gradle.kts || true
fi

# 2. Force Modern SDK constraints
sed -i 's/sdk: ">=2.7.0 <3.0.0"/sdk: ">=3.0.0 <4.0.0"/g' pubspec.yaml || true

# 3. Inject Dependency Overrides (The Safety Net)
if ! grep -q "dependency_overrides:" pubspec.yaml; then
    printf "\ndependency_overrides:\n  web: ^1.0.0\n  connectivity_plus: ^6.0.3\n  battery_plus: ^6.2.2\n" >> pubspec.yaml
fi

# 4. Fix Android Infrastructure (Gradle 8.13)
mkdir -p android/gradle/wrapper
printf "distributionBase=GRADLE_USER_HOME\ndistributionPath=wrapper/dists\nzipStoreBase=GRADLE_USER_HOME\nzipStorePath=wrapper/dists\ndistributionUrl=https\://services.gradle.org/distributions/gradle-8.13-bin.zip" > android/gradle/wrapper/gradle-wrapper.properties

# 5. Fix Kotlin jvmTarget syntax
if [ -f "android/app/build.gradle.kts" ]; then
    sed -i 's/jvmTarget = JavaVersion.VERSION_11.toString()/kotlinOptions.jvmTarget = "11"/g' android/app/build.gradle.kts || true
fi

# 6. Final Refresh - this will also re-generate generated files
flutter pub get

echo "Environment synced and legacy references removed."
