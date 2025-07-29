// Top-level build file

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        //  Google Services Plugin for Firebase
        classpath("com.google.gms:google-services:4.4.2")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

//  Optional: Custom build directory structure
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

//  Clean Task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
