# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Kotlin metadata
-keep class kotlin.Metadata { *; }

# Prevent stripping of Flutter JNI
-keep class * extends io.flutter.embedding.engine.FlutterEngine
