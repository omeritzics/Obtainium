allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
    
    val applySdkOverride = {
        project.extensions.findByName("android")?.let { android ->
            if (android is com.android.build.gradle.BaseExtension) {
                val minCompileSdk = (rootProject.findProperty("updatium.minCompileSdk") as? String)?.toIntOrNull() ?: 34
                val currentSdk = android.compileSdkVersion?.substringAfter("-")?.toIntOrNull() ?: 0
                if (currentSdk < minCompileSdk) {
                    android.compileSdkVersion(minCompileSdk)
                }
            }
        }
    }

    if (project.state.executed) {
        applySdkOverride()
    } else {
        project.afterEvaluate {
            applySdkOverride()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
