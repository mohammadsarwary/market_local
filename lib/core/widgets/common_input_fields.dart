import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// A customizable text field widget with consistent styling
/// 
/// This widget provides a standardized text field that can be used throughout
/// the application. It includes common styling options and sensible defaults
/// while allowing for extensive customization.
/// 
/// Example usage:
/// ```dart
/// AppTextField(
///   controller: _nameController,
///   hintText: 'Enter your name',
///   prefixIcon: Icons.person,
///   validator: (value) => value!.isEmpty ? 'Required' : null,
/// )
/// ```
class AppTextField extends StatelessWidget {
  /// Controller for managing the text field's value
  final TextEditingController? controller;
  
  /// Text displayed when the field is empty
  final String? hintText;
  
  /// Label text displayed above the field
  final String? labelText;
  
  /// Icon displayed before the input text
  final IconData? prefixIcon;
  
  /// Icon displayed after the input text
  final IconData? suffixIcon;
  
  /// Whether to obscure the text (for passwords)
  final bool obscureText;
  
  /// Type of keyboard to show
  final TextInputType? keyboardType;
  
  /// Action to perform when user submits
  final TextInputAction? textInputAction;
  
  /// Maximum number of lines for multi-line input
  final int? maxLines;
  
  /// Function to validate the input
  final String? Function(String?)? validator;
  
  /// Callback when text changes
  final void Function(String)? onChanged;
  
  /// Callback when field is tapped
  final void Function()? onTap;
  
  /// Whether the field is read-only
  final bool readOnly;
  
  /// Whether the field is enabled
  final bool enabled;
  
  /// Focus node for managing focus state
  final FocusNode? focusNode;
  
  /// Padding inside the text field
  final EdgeInsets? contentPadding;
  
  /// Border styling
  final InputBorder? border;
  
  /// Border styling when enabled
  final InputBorder? enabledBorder;
  
  /// Border styling when focused
  final InputBorder? focusedBorder;
  
  /// Text styling
  final TextStyle? textStyle;
  
  /// Hint text styling
  final TextStyle? hintStyle;
  
  /// Background color
  final Color? fillColor;
  
  /// Border radius for rounded corners
  final double? borderRadius;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.enabled = true,
    this.focusNode,
    this.contentPadding,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.textStyle,
    this.hintStyle,
    this.fillColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      enabled: enabled,
      focusNode: focusNode,
      style: textStyle ?? const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        hintStyle: hintStyle ?? TextStyle(color: Colors.grey[400]),
        fillColor: fillColor ?? Colors.white,
        filled: true,
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: border ?? OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: enabledBorder ?? OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: focusedBorder ?? OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}

class AppSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool readOnly;
  final bool enabled;

  const AppSearchField({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: hintText,
      prefixIcon: Icons.search,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      enabled: enabled,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}

class AppPriceField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const AppPriceField({
    super.key,
    this.controller,
    this.hintText = '0.00',
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: hintText,
      keyboardType: TextInputType.number,
      prefixIcon: Icons.attach_money,
      validator: validator,
      onChanged: onChanged,
    );
  }
}

class AppTextArea extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final int maxLines;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final EdgeInsets? contentPadding;

  const AppTextArea({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.maxLines = 5,
    this.validator,
    this.onChanged,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
      contentPadding: contentPadding ?? const EdgeInsets.all(16),
    );
  }
}
