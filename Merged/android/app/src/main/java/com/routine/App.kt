package com.routine

import android.content.Context
import com.facebook.react.PackageList
import com.facebook.react.ReactApplication
import com.facebook.react.ReactNativeHost
import com.facebook.react.ReactPackage
import com.facebook.soloader.SoLoader
import com.routine.common.react.ReactAppPackage
import com.routine.schedulenotification.ScheduleNotification
import com.routine.schedulenotification.react.ScheduleNotificationPackage
import dagger.hilt.android.HiltAndroidApp
import io.flutter.app.FlutterApplication
import timber.log.Timber
import java.lang.reflect.InvocationTargetException

@HiltAndroidApp
class App : FlutterApplication(), ReactApplication {

    companion object {
        @JvmStatic
        lateinit var CONTEXT: Context

        @JvmStatic
        lateinit var scheduleNotification: ScheduleNotification
    }

    override fun onCreate() {
        super.onCreate()
        CONTEXT = this
        scheduleNotification = ScheduleNotification(CONTEXT)

        if (BuildConfig.DEBUG) {
            Timber.plant(Timber.DebugTree())
        }

        SoLoader.init(this,  /* native exopackage */false)
        initializeFlipper(this) // Remove this line if you don't want Flipper enabled
    }

    override fun getReactNativeHost(): ReactNativeHost {
        return object : ReactNativeHost(this) {
            override fun getPackages(): MutableList<ReactPackage> =
                PackageList(this).packages
                    .apply {
                        add(ScheduleNotificationPackage())
                        add(ReactAppPackage())
                    }

            override fun getUseDeveloperSupport(): Boolean = BuildConfig.DEBUG

            override fun getJSMainModuleName(): String = "index"
        }
    }

    /**
     * Loads Flipper in React Native templates.
     *
     * @param context
     */
    private fun initializeFlipper(context: Context) {
        if (BuildConfig.DEBUG) {
            try {
                /*
                    We use reflection here to pick up the class that initializes Flipper,
                    since Flipper library is not available in release mode
                */
                val aClass =
                    Class.forName("com.facebook.flipper.ReactNativeFlipper")
                aClass.getMethod("initializeFlipper", Context::class.java)
                    .invoke(null, context)
            } catch (e: ClassNotFoundException) {
                e.printStackTrace()
            } catch (e: NoSuchMethodException) {
                e.printStackTrace()
            } catch (e: IllegalAccessException) {
                e.printStackTrace()
            } catch (e: InvocationTargetException) {
                e.printStackTrace()
            }
        }
    }
}
