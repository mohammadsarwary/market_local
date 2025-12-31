import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../utils/haptic_feedback.dart';

/// Floating scroll-to-top button
class ScrollToTopButton extends StatefulWidget {
  final ScrollController scrollController;
  final double threshold;
  final Duration animationDuration;
  final VoidCallback? onPressed;

  const ScrollToTopButton({
    super.key,
    required this.scrollController,
    this.threshold = 200.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.onPressed,
  });

  @override
  State<ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<ScrollToTopButton>
    with SingleTickerProviderStateMixin {
  bool _isVisible = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    _animationController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final shouldShow = widget.scrollController.offset > widget.threshold;
    if (shouldShow != _isVisible) {
      setState(() {
        _isVisible = shouldShow;
      });
      if (_isVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  void _scrollToTop() async {
    // Haptic feedback
    await HapticFeedback.light();
    
    // Custom callback
    widget.onPressed?.call();
    
    // Scroll to top with animation
    await widget.scrollController.animateTo(
      0,
      duration: widget.animationDuration,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: FloatingActionButton(
        mini: true,
        onPressed: _scrollToTop,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        child: const Icon(Icons.keyboard_arrow_up),
      ),
    );
  }
}

/// Scroll-to-top button for nested scroll views (CustomScrollView)
class NestedScrollToTopButton extends StatefulWidget {
  final ScrollController scrollController;
  final double threshold;
  final Duration animationDuration;
  final VoidCallback? onPressed;

  const NestedScrollToTopButton({
    super.key,
    required this.scrollController,
    this.threshold = 200.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.onPressed,
  });

  @override
  State<NestedScrollToTopButton> createState() => _NestedScrollToTopButtonState();
}

class _NestedScrollToTopButtonState extends State<NestedScrollToTopButton>
    with SingleTickerProviderStateMixin {
  bool _isVisible = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 2), // Start from bottom
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    _animationController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final shouldShow = widget.scrollController.offset > widget.threshold;
    if (shouldShow != _isVisible) {
      setState(() {
        _isVisible = shouldShow;
      });
      if (_isVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  void _scrollToTop() async {
    // Haptic feedback
    await HapticFeedback.light();
    
    // Custom callback
    widget.onPressed?.call();
    
    // Scroll to top with animation
    await widget.scrollController.animateTo(
      0,
      duration: widget.animationDuration,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 80, // Above bottom navigation
      right: AppSizes.paddingM,
      child: SlideTransition(
        position: _slideAnimation,
        child: FloatingActionButton(
          mini: true,
          onPressed: _scrollToTop,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          child: const Icon(Icons.keyboard_arrow_up),
        ),
      ),
    );
  }
}

/// Scroll-to-top button for list views
class ListScrollToTopButton extends StatefulWidget {
  final ScrollController scrollController;
  final double threshold;
  final Duration animationDuration;
  final VoidCallback? onPressed;

  const ListScrollToTopButton({
    super.key,
    required this.scrollController,
    this.threshold = 200.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.onPressed,
  });

  @override
  State<ListScrollToTopButton> createState() => _ListScrollToTopButtonState();
}

class _ListScrollToTopButtonState extends State<ListScrollToTopButton>
    with SingleTickerProviderStateMixin {
  bool _isVisible = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    _animationController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final shouldShow = widget.scrollController.offset > widget.threshold;
    if (shouldShow != _isVisible) {
      setState(() {
        _isVisible = shouldShow;
      });
      if (_isVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  void _scrollToTop() async {
    // Haptic feedback
    await HapticFeedback.light();
    
    // Custom callback
    widget.onPressed?.call();
    
    // Scroll to top with animation
    await widget.scrollController.animateTo(
      0,
      duration: widget.animationDuration,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Positioned(
        bottom: 80, // Above bottom navigation
        right: AppSizes.paddingM,
        child: FloatingActionButton(
          mini: true,
          onPressed: _scrollToTop,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          child: const Icon(Icons.keyboard_arrow_up),
        ),
      ),
    );
  }
}
