#!/bin/bash
# 1. Force Modern SDK constraints (The root of most Null Safety issues)
sed -i 's/sdk: ">=2.7.0 <3.0.0"/sdk: ">=3.0.0 <4.0.0"/g' pubspec.yaml || true

# 2. Inject Dependency Overrides to stop the "Dependency Hell"
# This forces compatible versions even if the packages disagree
if ! grep -q "dependency_overrides:" pubspec.yaml; then
    printf "\ndependency_overrides:\n" >> pubspec.yaml
    printf "  web: ^1.0.0\n" >> pubspec.yaml
    printf "  connectivity_plus: ^6.0.3\n" >> pubspec.yaml
    printf "  battery_plus: ^6.2.2\n" >> pubspec.yaml
fi

# 3. Fix Android/Kotlin Infrastructure
mkdir -p android/gradle/wrapper
printf "distributionBase=GRADLE_USER_HOME\ndistributionPath=wrapper/dists\nzipStoreBase=GRADLE_USER_HOME\nzipStorePath=wrapper/dists\ndistributionUrl=https\://services.gradle.org/distributions/gradle-8.13-bin.zip" > android/gradle/wrapper/gradle-wrapper.properties
sed -i 's/jvmTarget = JavaVersion.VERSION_11.toString()/kotlinOptions.jvmTarget = "11"/g' android/app/build.gradle.kts || true

# 4. Final Refresh
flutter pub get
