import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool centerTitle;
  final TextStyle? titleStyle;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;

  const CommonAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.centerTitle = true,
    this.titleStyle,
    this.onBackPressed,
    this.showBackButton = true,
    this.flexibleSpace,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null ? Text(
        title!,
        style: titleStyle ?? const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ) : null,
      actions: actions,
      leading: leading ?? (showBackButton ? _buildBackButton(context) : null),
      automaticallyImplyLeading: automaticallyImplyLeading && !showBackButton,
      backgroundColor: backgroundColor ?? Colors.white,
      foregroundColor: foregroundColor ?? Colors.black87,
      elevation: elevation ?? 0,
      centerTitle: centerTitle,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
      ),
      onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0),
  );
}

class TransparentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final Widget? leading;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;

  const TransparentAppBar({
    super.key,
    this.actions,
    this.leading,
    this.onBackPressed,
    this.showBackButton = true,
    this.flexibleSpace,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return CommonAppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      leading: leading ?? (showBackButton ? _buildTransparentBackButton(context) : null),
      actions: actions,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
    );
  }

  Widget _buildTransparentBackButton(BuildContext context) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
      ),
      onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0),
  );
}

class SearchAppBar extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onBack;
  final Widget? trailing;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const SearchAppBar({
    super.key,
    this.hintText,
    this.controller,
    this.onChanged,
    this.onClear,
    this.onBack,
    this.trailing,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
    _hasText = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
    widget.onChanged?.call(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return CommonAppBar(
      backgroundColor: widget.backgroundColor ?? Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: widget.onBack ?? () => Navigator.of(context).pop(),
      ),
      title: null,
      flexibleSpace: Container(
        padding: const EdgeInsets.fromLTRB(60, 16, 16, 16),
        alignment: Alignment.center,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: widget.hintText ?? 'Search...',
              hintStyle: TextStyle(color: Colors.grey[500]),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: _hasText
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _controller.clear();
                        widget.onClear?.call();
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ),
      ),
      actions: widget.trailing != null ? [widget.trailing!] : null,
    );
  }
}
