# Keep Razorpay classes
-keep class com.razorpay.** { *; }

# Keep annotations
-keep class proguard.annotation.Keep { *; }
-keep class proguard.annotation.KeepClassMembers { *; }

# Keep Firebase classes
-keep class com.google.firebase.** { *; }

# Keep Kotlin metadata
-keep class kotlin.Metadata { *; }
