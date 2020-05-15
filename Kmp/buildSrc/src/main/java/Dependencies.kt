object Versions {
    const val minSdk = 21
    const val targetSdk = 29
    const val compileSdk = 29

    const val kotlin = "1.3.72"
    const val buildToolsVersion = "29.0.0"
    const val sqlDelight = "1.3.0"
    const val coroutines = "1.3.5-native-mt"
}

object Deps {
    const val app_compat_x = "androidx.appcompat:appcompat:1.1.0"
    const val core_ktx = "androidx.core:core-ktx:1.2.0"

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
}