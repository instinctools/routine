import org.jetbrains.kotlin.config.KotlinCompilerVersion

plugins {
    id("com.android.application")
    kotlin("android")
}

android {
    compileSdkVersion(Versions.compileSdk)
    buildToolsVersion = Versions.buildToolsVersion
    defaultConfig {
        applicationId = "com.instinctools.routine_kmp"
        minSdkVersion(Versions.minSdk)
        targetSdkVersion(Versions.targetSdk)
        versionCode = 1
        versionName = "1.0"
    }

    packagingOptions {
        exclude("META-INF/*.kotlin_module")
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8.toString()
    }

    viewBinding.isEnabled = true
}

dependencies {
    implementation(kotlin("stdlib-jdk7", KotlinCompilerVersion.VERSION))
    implementation(project(":shared"))

    /* Android X */
    implementation(Deps.AndroidX.appCompat)
    implementation(Deps.AndroidX.coreKtx)
    implementation(Deps.AndroidX.activity)
    implementation(Deps.AndroidX.activityKtx)
    implementation(Deps.AndroidX.fragment)
    implementation(Deps.AndroidX.fragmentKtx)
    implementation(Deps.AndroidX.lifecycle)

    implementation(Deps.AndroidX.recyclerView)
    implementation(Deps.AndroidX.constraintLayout)
    /* Android X */

    /* Views */
    implementation(Deps.AndroidView.material)
    implementation(Deps.AndroidView.wheelPicker)
    /* Views */

    implementation(Deps.Coroutines.android)

    implementation(Deps.threeTenAbp)
}