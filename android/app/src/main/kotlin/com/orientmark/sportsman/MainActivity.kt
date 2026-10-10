package com.orientmark.sportsman

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Build
import android.os.Bundle
import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import android.animation.ValueAnimator
import android.view.SurfaceView
import android.view.animation.AccelerateDecelerateInterpolator

class MainActivity: FlutterActivity() {
    private var splashFinished = Build.VERSION.SDK_INT < 31
    private val splashWaiters = mutableListOf<MethodChannel.Result>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.VERSION.SDK_INT >= 31) {
            // A recreated activity may not receive a starting-window callback.
            if (savedInstanceState != null) splashFinished = true
            splashScreen.setOnExitAnimationListener { view ->
                val start = view.iconAnimationStart?.toEpochMilli()
                val duration = view.iconAnimationDuration?.toMillis() ?: 0L
                val remaining = if (start == null) 0L else
                    (start + duration - System.currentTimeMillis()).coerceIn(0L, 1000L)
                view.postDelayed({
                    // ViewPropertyAnimator bypasses SplashScreenView.setAlpha,
                    // leaving the animated icon's independent surface opaque.
                    ValueAnimator.ofFloat(1f, 0f).apply {
                        this.duration = 320L
                        interpolator = AccelerateDecelerateInterpolator()
                        addUpdateListener { animation ->
                            val alpha = animation.animatedValue as Float
                            view.alpha = alpha
                            // Some Android versions multiply the surface alpha
                            // in setAlpha. Set the absolute value afterwards so
                            // the icon and background follow the same curve.
                            (view.iconView as? SurfaceView)?.alpha = alpha
                        }
                        addListener(object : AnimatorListenerAdapter() {
                            override fun onAnimationEnd(animation: Animator) {
                                view.alpha = 0f
                                (view.iconView as? SurfaceView)?.alpha = 0f
                                view.remove()
                                finishSplash()
                            }
                        })
                        start()
                    }
                }, remaining)
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.orientmark/startup")
            .setMethodCallHandler { call, result ->
                if (call.method != "waitForSplashExit") result.notImplemented()
                else if (splashFinished) result.success(null)
                else splashWaiters.add(result)
            }
    }

    private fun finishSplash() {
        splashFinished = true
        splashWaiters.forEach { it.success(null) }
        splashWaiters.clear()
    }

    override fun onDestroy() {
        finishSplash()
        super.onDestroy()
    }
}
