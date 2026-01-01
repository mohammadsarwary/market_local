import 'package:vibration/vibration.dart';

/// Utility class for haptic feedback
class HapticFeedback {
  HapticFeedback._();

  /// Light haptic feedback for button taps
  /// 
  /// Provides a subtle vibration for UI interactions like button presses.
  /// Duration: 25ms. Silently fails if haptic feedback is not supported.
  static Future<void> light() async {
    try {
      await Vibration.vibrate(duration: 25);
    } catch (e) {
      // Haptic feedback not supported, continue silently
    }
  }

  /// Medium haptic feedback for important actions
  /// 
  /// Provides a moderate vibration for significant UI interactions
  /// like confirming actions or toggling switches.
  /// Duration: 50ms. Silently fails if haptic feedback is not supported.
  static Future<void> medium() async {
    try {
      await Vibration.vibrate(duration: 50);
    } catch (e) {
      // Haptic feedback not supported, continue silently
    }
  }

  /// Heavy haptic feedback for significant actions
  /// 
  /// Provides a strong vibration for major actions like deleting items
  /// or completing important tasks.
  /// Duration: 100ms. Silently fails if haptic feedback is not supported.
  static Future<void> heavy() async {
    try {
      await Vibration.vibrate(duration: 100);
    } catch (e) {
      // Haptic feedback not supported, continue silently
    }
  }

  /// Success haptic feedback pattern
  /// 
  /// Provides a two-part vibration pattern (50ms, pause, 25ms) to
  /// indicate successful completion of an operation.
  /// Silently fails if haptic feedback is not supported.
  static Future<void> success() async {
    try {
      await Vibration.vibrate(duration: 50);
      await Future.delayed(const Duration(milliseconds: 100));
      await Vibration.vibrate(duration: 25);
    } catch (e) {
      // Haptic feedback not supported, continue silently
    }
  }

  /// Error haptic feedback pattern
  /// 
  /// Provides a two-part vibration pattern (100ms, pause, 50ms) to
  /// indicate an error or failed operation.
  /// Silently fails if haptic feedback is not supported.
  static Future<void> error() async {
    try {
      await Vibration.vibrate(duration: 100);
        await Future.delayed(const Duration(milliseconds: 50));
      await Vibration.vibrate(duration: 50);
    } catch (e) {
      // Haptic feedback not supported, continue silently
    }
  }

  /// Selection haptic feedback (for UI selections)
  /// 
  /// Provides a very short vibration for selection UI interactions
  /// like selecting list items or tabs.
  /// Duration: 10ms. Silently fails if haptic feedback is not supported.
  static Future<void> selection() async {
    try {
      await Vibration.vibrate(duration: 10);
    } catch (e) {
      // Haptic feedback not supported, continue silently
    }
  }

  /// Check if haptic feedback is available
  /// 
  /// Determines whether the device supports haptic feedback.
  /// 
  /// Returns:
  /// true if the device has a vibrator, false otherwise
  static Future<bool> isSupported() async {
    try {
      return await Vibration.hasVibrator();
    } catch (e) {
      return false;
    }
  }
}
