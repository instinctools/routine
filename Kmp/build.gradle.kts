buildscript {
    repositories {
        google()
        mavenCentral()
        jcenter()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:4.1.1")
        classpath(Deps.SqlDelight.gradle)
        classpath(kotlin("gradle-plugin", Versions.kotlin))
        classpath("com.google.gms:google-services:4.3.4")
        classpath("com.google.firebase:firebase-crashlytics-gradle:2.4.1")
    }
}

allprojects {
    repositories {
        google()
        jcenter()
        maven(url = "https://kotlin.bintray.com/kotlinx") // TODO remove line after kotlinx.datetime migrate to jcenter
    }
}

tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}