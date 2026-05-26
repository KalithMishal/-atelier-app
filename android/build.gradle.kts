plugins {
    // Makes Kotlin Gradle types (e.g. KotlinCompile) visible in this script so we can
    // disable incremental compilation for all Flutter plugin subprojects (see subprojects below).
    id("org.jetbrains.kotlin.android") apply false
}

import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

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
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Kotlin incremental compilation + Windows + project on E: + Pub cache on C: triggers
// "IllegalArgumentException: this and base files have different roots" during plugin
// Kotlin compiles. gradle.properties sets kotlin.incremental=false; also force it on
// every KotlinCompile task so Flutter-included plugins always pick it up.
subprojects {
    tasks.withType<KotlinCompile>().configureEach {
        incremental = false
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
