import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final Widget? prefixIcon;
  final String label;
  final VoidCallback onTap;
  final double borderRadius;
  final bool isLoading;
  final Color? borderColor;
  final double blurStrength;
  final double? width;
  final double height;

  const CustomButton({
    super.key,
    required this.label,
    required this.onTap,
    this.prefixIcon,
    this.borderRadius = 30.0,
    this.isLoading = false,
    this.borderColor,
    this.blurStrength = 10.0,
    this.width,
    this.height = 60.0,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: _isPressed
            ? Matrix4.translationValues(0, 2, 0)
            : Matrix4.identity(),
        width: widget.width ?? MediaQuery.of(context).size.width * 0.9,
        height: widget.height,
        decoration: BoxDecoration(
          color: const Color(0xFF31473A),
          // color: const Color(0XFF202224),

          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: widget.borderColor != null
              ? Border.all(color: widget.borderColor!, width: 1.5)
              : null,
        ),
        child: Center(
          child: Container(
            width: double.infinity,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.isLoading
                  ? [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                    ]
                  : [
                      if (widget.prefixIcon != null) ...[
                        widget.prefixIcon!,
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.label,
                        style: const TextStyle(
                          color: Color(0xFFEDF4F2),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
