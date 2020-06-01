object Versions {
    const val minSdk = 21
    const val targetSdk = 29
    const val compileSdk = 29

    const val kotlin = "1.3.72"
    const val buildToolsVersion = "29.0.0"

    const val sqlDelight = "1.3.0"
    const val coroutines = "1.3.5-native-mt"
    const val stately = "1.0.2"

    const val activityX = "1.2.0-alpha04"
    const val fragmentX = "1.3.0-alpha04"
    const val lifecycle = "2.3.0-alpha02"
}

object Deps {

    const val threeTenAbp = "com.jakewharton.threetenabp:threetenabp:1.2.4"

    object AndroidX {
        const val appCompat = "androidx.appcompat:appcompat:1.2.0-rc01"
        const val coreKtx = "androidx.core:core-ktx:1.3.0-rc01"
        const val activity = "androidx.activity:activity:${Versions.activityX}}"
        const val activityKtx = "androidx.activity:activity-ktx:${Versions.activityX}"
        const val fragment = "androidx.fragment:fragment:${Versions.fragmentX}"
        const val fragmentKtx = "androidx.fragment:fragment-ktx:${Versions.fragmentX}"

        const val lifecycle = "androidx.lifecycle:lifecycle-common-java8:${Versions.lifecycle}"

        const val recyclerView = "androidx.recyclerview:recyclerview:1.1.0"
        const val constraintLayout = "androidx.constraintlayout:constraintlayout:2.0.0-beta6"
    }

    object AndroidView {
        const val material = "com.google.android.material:material:1.2.0-alpha06"
        const val wheelPicker = "cn.aigestudio.wheelpicker:WheelPicker:1.1.3"
    }

    object Coroutines {
        const val common = "org.jetbrains.kotlinx:kotlinx-coroutines-core-common:${Versions.coroutines}"
        const val native = "org.jetbrains.kotlinx:kotlinx-coroutines-core-native:${Versions.coroutines}"
        const val android = "org.jetbrains.kotlinx:kotlinx-coroutines-android:${Versions.coroutines}"
    }

    object SqlDelight {
        const val gradle = "com.squareup.sqldelight:gradle-plugin:${Versions.sqlDelight}"
        const val runtime = "com.squareup.sqldelight:runtime:${Versions.sqlDelight}"
        const val driverIos = "com.squareup.sqldelight:native-driver:${Versions.sqlDelight}"
        const val driverAndroid = "com.squareup.sqldelight:android-driver:${Versions.sqlDelight}"
        const val coroutinesKtx = "com.squareup.sqldelight:coroutines-extensions:${Versions.sqlDelight}"
    }

    object Stately {
        const val common = "co.touchlab:stately-common:${Versions.stately}"
        const val concurrency = "co.touchlab:stately-concurrency:${Versions.stately}"
    }
}