import org.jetbrains.kotlin.gradle.plugin.mpp.KotlinNativeTarget

plugins {
    kotlin("multiplatform")
    kotlin("native.cocoapods")
    id("com.squareup.sqldelight")
    id("com.android.library")
}

android {
    compileSdkVersion(Versions.compileSdk)
    defaultConfig {
        minSdkVersion(Versions.minSdk)
        targetSdkVersion(Versions.targetSdk)
    }
}

// cocoapods requirement
version = "1.0"

kotlin {
    //select iOS target platform depending on the Xcode environment variables
    val onPhone = System.getenv("SDK_NAME")?.startsWith("iphoneos") ?: false
    if (onPhone) {
        iosArm64("ios")
    } else {
        iosX64("ios")
    }
    android()

    targets.getByName<KotlinNativeTarget>("ios").compilations["main"].kotlinOptions.freeCompilerArgs +=
        listOf("-Xobjc-generics", "-Xg0")

    sourceSets {
        all {
            languageSettings.apply {
                useExperimentalAnnotation("kotlin.RequiresOptIn")
                useExperimentalAnnotation("kotlinx.coroutines.ExperimentalCoroutinesApi")
            }
        }
    }

    sourceSets["commonMain"].dependencies {
        implementation(Deps.SqlDelight.runtime)
        implementation(Deps.SqlDelight.coroutinesKtx)
        implementation(Deps.Coroutines.common) {
            version {
                strictly(Versions.coroutines)
            }
        }
        implementation(Deps.Stately.concurrency)
        implementation(Deps.Stately.common)
        implementation(Deps.DayTime.common)
    }

    sourceSets["androidMain"].dependencies {
        implementation(Deps.SqlDelight.driverAndroid)
        implementation(Deps.Coroutines.android)
        implementation(Deps.Coroutines.playServices)
        implementation(Deps.Firebase.auth)
        implementation(Deps.Firebase.firestore)
    }

    sourceSets["iosMain"].dependencies {
        implementation(Deps.SqlDelight.driverIos)
    }

    cocoapods {
        summary = "Shared module for Routine project"
        homepage = "https://github.com/instinctools/routine"
        frameworkName = "RoutineShared"
    }
}

sqldelight {
    database("TodoDatabase") {
        packageName = "com.instinctools.routine_kmp"
    }
}