import 'package:vibration/vibration.dart';

/// Utility class for haptic feedback
class HapticFeedback {
  HapticFeedback._();

  /// Light haptic feedback for button taps
  static Future<void> light() async {
    try {
      await Vibration.vibrate(duration: 25);
    } catch (e) {
      // Haptic feedback not supported, continue silently
    }
  }

  /// Medium haptic feedback for important actions
  static Future<void> medium() async {
    try {
      await Vibration.vibrate(duration: 50);
    } catch (e) {
      // Haptic feedback not supported, continue silently
    }
  }

  /// Heavy haptic feedback for significant actions
  static Future<void> heavy() async {
    try {
      await Vibration.vibrate(duration: 100);
    } catch (e) {
      // Haptic feedback not supported, continue silently
    }
  }

  /// Success haptic feedback pattern
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
  static Future<void> selection() async {
    try {
      await Vibration.vibrate(duration: 10);
    } catch (e) {
      // Haptic feedback not supported, continue silently
    }
  }

  /// Check if haptic feedback is available
  static Future<bool> isSupported() async {
    try {
      return await Vibration.hasVibrator();
    } catch (e) {
      return false;
    }
  }
}
