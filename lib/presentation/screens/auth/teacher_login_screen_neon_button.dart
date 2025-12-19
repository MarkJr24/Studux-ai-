// Neon Button with Success Animation
class _NeonButton extends StatefulWidget {
  final VoidCallback? onTap;
  final bool isLoading;
  final bool showSuccess;

  const _NeonButton({
    required this.onTap,
    required this.isLoading,
    required this.showSuccess,
  });

  @override
  State<_NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<_NeonButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _successController;
  late Animation<double> _successAnimation;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _successAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.8),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.8, end: 1.2),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 25,
      ),
    ]).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(_NeonButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showSuccess && !oldWidget.showSuccess) {
      _successController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _successController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = _isPressed ? 1.03 : 1.0;

    return AnimatedBuilder(
      animation: _successAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.showSuccess ? _successAnimation.value : scale,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFFF7B54), // Orange
                  Color(0xFFFFB84D), // Yellow-Orange
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF7B54).withOpacity(_isPressed ? 0.5 : 0.3),
                  blurRadius: _isPressed ? 20 : 15,
                  offset: const Offset(0, 8),
                  spreadRadius: _isPressed ? 2 : 0,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                onTapDown: (_) => setState(() => _isPressed = true),
                onTapUp: (_) => setState(() => _isPressed = false),
                onTapCancel: () => setState(() => _isPressed = false),
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: widget.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : widget.showSuccess
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 28,
                            )
                          : Text(
                              'Sign In as Teacher',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
