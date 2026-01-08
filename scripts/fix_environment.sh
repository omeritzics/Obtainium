#!/bin/bash
# This script synchronizes dependencies and infrastructure settings

echo "Starting environment synchronization..."

# 1. Sync Gradle
mkdir -p android/gradle/wrapper
printf "distributionBase=GRADLE_USER_HOME\ndistributionPath=wrapper/dists\nzipStoreBase=GRADLE_USER_HOME\nzipStorePath=wrapper/dists\ndistributionUrl=https\://services.gradle.org/distributions/gradle-8.13-bin.zip" > android/gradle/wrapper/gradle-wrapper.properties

# 2. Sync Kotlin syntax
sed -i 's/jvmTarget = JavaVersion.VERSION_11.toString()/kotlinOptions.jvmTarget = "11"/g' android/app/build.gradle.kts || true

# 3. Sync Flutter dependencies
sed -i 's/sdk: ">=2.7.0 <3.0.0"/sdk: ">=3.0.0 <4.0.0"/g' pubspec.yaml || true

if ! flutter pub get; then
    echo "Sync failed. Forcing dependency overrides..."
    if ! grep -q "dependency_overrides:" pubspec.yaml; then
        printf "\ndependency_overrides:\n" >> pubspec.yaml
    fi
    # Add overrides only if missing
    grep -q "connectivity_plus:" pubspec.yaml || printf "  connectivity_plus: 6.0.3\n" >> pubspec.yaml
    grep -q "battery_plus:" pubspec.yaml || printf "  battery_plus: 6.2.2\n" >> pubspec.yaml
    grep -q "web:" pubspec.yaml || printf "  web: ^1.0.0\n" >> pubspec.yaml
    flutter pub get
fi

echo "Environment is synchronized!"
