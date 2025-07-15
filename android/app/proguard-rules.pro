# Flutter
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# TensorFlow Lite + GPU
-keep class org.tensorflow.** { *; }
-dontwarn org.tensorflow.**
#-keep class org.tensorflow.lite.gpu.GpuDelegateFactory$Options { *; }
#-keep class org.tensorflow.lite.gpu.GpuDelegate { *; }

# ML Kit
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Play Core / Deferred Components
-keep class com.google.android.play.** { *; }
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.**

# Umum
-dontwarn kotlin.**
-dontwarn androidx.annotation.**
-dontwarn androidx.lifecycle.**
