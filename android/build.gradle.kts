plugins {
    id("com.google.gms.google-services") version "4.4.4" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: File = rootProject.projectDir.resolve("../build")
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    // Only redirect build dir for subprojects on the same drive as the root project
    val subprojectRoot = project.projectDir.toString().substringBefore(":")
    val rootProjectRoot = rootProject.projectDir.toString().substringBefore(":")
    if (subprojectRoot.equals(rootProjectRoot, ignoreCase = true)) {
        project.layout.buildDirectory.set(File(newBuildDir, project.name))
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
