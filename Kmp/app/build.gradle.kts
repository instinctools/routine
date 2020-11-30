import org.jetbrains.kotlin.config.KotlinCompilerVersion

plugins {
    id("com.android.application")
    kotlin("android")
    kotlin("kapt")
}
apply(plugin = "com.google.gms.google-services")
apply(plugin = "com.google.firebase.crashlytics")


android {
    compileSdkVersion(Versions.compileSdk)
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

    buildFeatures {
        viewBinding = true
    }
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
    /* Android X */

    /* Android X Views*/
    implementation(Deps.AndroidX.recyclerView)
    implementation(Deps.AndroidX.constraintLayout)
    implementation(Deps.AndroidX.swipeRefresh)
    /* Android X Views*/

    /* Views */
    implementation(Deps.AndroidView.material)
    implementation(Deps.AndroidView.wheelPicker)
    /* Views */

    /* Dagger */
    implementation(Deps.Dagger.library)
    kapt(Deps.Dagger.compiler)
    /* Dagger */

    implementation(Deps.Coroutines.android)
    implementation(Deps.timber)
}