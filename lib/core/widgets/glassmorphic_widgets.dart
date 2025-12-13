import 'dart:ui';
import 'package:flutter/material.dart';

/// Glassmorphic container widget matching Admin UI style
class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;
  final List<Color>? gradientColors;
  final Border? border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final List<BoxShadow>? boxShadow;

  const GlassmorphicContainer({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.opacity = 0.1,
    this.borderRadius,
    this.gradientColors,
    this.border,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: border,
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            decoration: BoxDecoration(
              gradient: gradientColors != null
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradientColors!,
                    )
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(opacity),
                        Colors.white.withOpacity(opacity * 0.5),
                      ],
                    ),
              borderRadius: borderRadius ?? BorderRadius.circular(16),
            ),
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Neon glow button with ripple and scale animations
class NeonGlowButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final List<Color> gradientColors;
  final IconData? icon;
  final double? width;
  final double? height;
  final bool enabled;
  final bool isLocked;

  const NeonGlowButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.gradientColors,
    this.icon,
    this.width,
    this.height,
    this.enabled = true,
    this.isLocked = false,
  });

  @override
  State<NeonGlowButton> createState() => _NeonGlowButtonState();
}

class _NeonGlowButtonState extends State<NeonGlowButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLocked) {
      return Container(
        width: widget.width ?? double.infinity,
        height: widget.height ?? 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.grey.shade600,
              Colors.grey.shade800,
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock, color: Colors.white70, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'LOCKED',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: widget.width ?? double.infinity,
        height: widget.height ?? 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: widget.enabled
                ? widget.gradientColors
                : [Colors.grey.shade400, Colors.grey.shade600],
          ),
          boxShadow: widget.enabled
              ? [
                  BoxShadow(
                    color: widget.gradientColors[0].withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.enabled
                ? () async {
                    await _controller.forward();
                    await _controller.reverse();
                    widget.onTap();
                  }
                : null,
            onTapDown: widget.enabled ? (_) => _controller.forward() : null,
            onTapUp: widget.enabled ? (_) => _controller.reverse() : null,
            onTapCancel: widget.enabled ? () => _controller.reverse() : null,
            borderRadius: BorderRadius.circular(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                ],
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Floating card animation mixin
mixin FloatingCardAnimation<T extends StatefulWidget>
    on SingleTickerProviderStateMixin<T> {
  late AnimationController floatingController;
  late Animation<double> floatingAnimation;

  void initFloatingAnimation() {
    floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    );
    floatingAnimation = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(parent: floatingController, curve: Curves.easeInOut),
    );
    floatingController.repeat(reverse: true);
  }

  void disposeFloatingAnimation() {
    floatingController.dispose();
  }

  Widget buildFloatingCard({required Widget child}) {
    return AnimatedBuilder(
      animation: floatingAnimation,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, floatingAnimation.value),
          child: child,
        );
      },
    );
  }
}

/// Animated tab selector with neon underline
class AnimatedTabSelector extends StatefulWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTabSelected;
  final List<Color>? activeGradient;

  const AnimatedTabSelector({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.activeGradient,
  });

  @override
  State<AnimatedTabSelector> createState() => _AnimatedTabSelectorState();
}

class _AnimatedTabSelectorState extends State<AnimatedTabSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(widget.tabs.length, (index) {
          final isSelected = index == widget.selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => widget.onTabSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: widget.activeGradient ??
                              [
                                const Color(0xFF9333EA),
                                const Color(0xFF60D5F4),
                              ],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.tabs[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : Colors.black.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 2,
                      width: isSelected ? 40 : 0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: widget.activeGradient ??
                              [
                                const Color(0xFF9333EA),
                                const Color(0xFF60D5F4),
                              ],
                        ),
                        borderRadius: BorderRadius.circular(1),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF9333EA).withOpacity(0.5),
                                  blurRadius: 4,
                                ),
                              ]
                            : [],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
