// import 'package:flutter/material.dart';
// import 'dart:math' as math;

// class GlowingSnakeButton extends StatefulWidget {
//   final String text;
//   final double width;
//   final VoidCallback onPressed;

//   const GlowingSnakeButton({
//     super.key,
//     required this.text,
//     required this.width,
//     required this.onPressed,
//   });

//   @override
//   State<GlowingSnakeButton> createState() => _GlowingSnakeButtonState();
// }

// class _GlowingSnakeButtonState extends State<GlowingSnakeButton>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 3),
//       vsync: this,
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     const double height = 50;
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         // Snake‑line painter behind the button
//         SizedBox(
//           width: widget.width,
//           height: height,
//           child: AnimatedBuilder(
//             animation: _controller,
//             builder: (_, __) => CustomPaint(
//               painter: _GlowingSnakePainter(
//                 progress: _controller.value,
//                 color: Colors.orangeAccent,
//                 strokeWidth: 3,
//                 borderRadius: 25,
//               ),
//             ),
//           ),
//         ),

//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.orange,
//             minimumSize: Size(widget.width, height),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(25),
//             ),
//             elevation: 7,
//             shadowColor: Colors.orangeAccent,
//           ),
//           onPressed: widget.onPressed,
//           child: Text(widget.text,
//               style: const TextStyle(fontSize: 16, color: Colors.white)),
//         ),
//       ],
//     );
//   }
// }

// class _GlowingSnakePainter extends CustomPainter {
//   final double progress;
//   final double strokeWidth;
//   final double borderRadius;
//   final Color color;

//   _GlowingSnakePainter({
//     required this.progress,
//     required this.color,
//     this.strokeWidth = 2,
//     this.borderRadius = 20,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     //  full rounded‐rect path
//     final rrect = RRect.fromRectAndRadius(
//       Offset.zero & size,
//       Radius.circular(borderRadius),
//     );
//     final path = Path()..addRRect(rrect);

//     final metric = path.computeMetrics().first;
//     final totalLen = metric.length;
//     const segLen = 350.0;

//     double start = progress * totalLen;
//     double end = (start + segLen) % totalLen;

//     //Extract the glowing segment
//     Path segment;
//     if (end > start) {
//       segment = metric.extractPath(start, end);
//     } else {
//       segment = Path()
//         ..addPath(metric.extractPath(start, totalLen), Offset.zero)
//         ..addPath(metric.extractPath(0, end), Offset.zero);
//     }

//     //halo (blur)
//     // final blurPaint = Paint()
//     //   ..color = color.withOpacity(0.9)
//     //   ..style = PaintingStyle.stroke
//     //   ..strokeWidth = strokeWidth * 2
//     //   ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12); //snake blur
//     // canvas.drawPath(segment, blurPaint);
//     final blurPaint = Paint()
//       ..color = color.withOpacity(0.9)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth * 2
//       ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);

//     //bright core line
//     // final corePaint = Paint()
//     //   ..color = color
//     //   ..style = PaintingStyle.stroke
//     //   ..strokeWidth = strokeWidth
//     //   ..strokeCap = StrokeCap.round;
//     // canvas.drawPath(segment, corePaint);
//     // final shader = SweepGradient(
//     //   colors: [Colors.orange, Colors.deepOrangeAccent, Colors.yellow],
//     //   stops: [0.0, 0.5, 1.0],
//     //   transform: GradientRotation(progress * 2 * math.pi),
//     // ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

//     // final corePaint = Paint()
//     //   ..shader = shader
//     //   ..style = PaintingStyle.stroke
//     //   ..strokeWidth = strokeWidth
//     //   ..strokeCap = StrokeCap.round;
//     final shader = SweepGradient(
//       colors: [Colors.orange, Colors.deepOrangeAccent, Colors.yellow],
//       stops: [0.0, 0.5, 1.0],
//       transform: GradientRotation(progress * 2 * math.pi),
//     ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

//     final corePaint = Paint()
//       ..shader = shader
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth
//       ..strokeCap = StrokeCap.round;
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter old) => true;
// }
//---------------------------------------------------------------
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class GlowingSnakeButton extends StatefulWidget {
  final String text;
  final double width;
  final VoidCallback onPressed;

  const GlowingSnakeButton({
    Key? key,
    required this.text,
    required this.width,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<GlowingSnakeButton> createState() => _GlowingSnakeButtonState();
}

class _GlowingSnakeButtonState extends State<GlowingSnakeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double height = 50;
    return Stack(
      alignment: Alignment.center,
      children: [
        // Snake‑line
        SizedBox(
          width: widget.width,
          height: height,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => CustomPaint(
              painter: _GlowingSnakePainter(
                progress: _controller.value,
                color: Colors.orangeAccent,
                strokeWidth: 3,
                borderRadius: 25,
              ),
            ),
          ),
        ),

        //   button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            minimumSize: Size(widget.width, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 7,
            shadowColor: Colors.orangeAccent,
          ),
          onPressed: widget.onPressed,
          child: Text(
            widget.text,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _GlowingSnakePainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final double borderRadius;
  final Color color;

  _GlowingSnakePainter({
    required this.progress,
    required this.color,
    this.strokeWidth = 2,
    this.borderRadius = 20,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // rounded‑rect path
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(borderRadius),
    );
    final path = Path()..addRRect(rrect);

    // segment length
    final metric = path.computeMetrics().first;
    final totalLen = metric.length;
    const segLen = 60.0;

    // 3) Compute start & end points
    final start = progress * totalLen;
    final end = (start + segLen) % totalLen;

    Path segment;
    if (end > start) {
      segment = metric.extractPath(start, end);
    } else {
      segment = Path()
        ..addPath(metric.extractPath(start, totalLen), Offset.zero)
        ..addPath(metric.extractPath(0, end), Offset.zero);
    }

    // glowing blur (halo)
    final blurPaint = Paint()
      ..color = color.withOpacity(0.8) // stronger glow
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    canvas.drawPath(segment, blurPaint);

    //bright core with rotating gradient
    final shader = SweepGradient(
      colors: [
        color,
        color.withOpacity(0.0),
      ],
      stops: const [0.0, 1.0],
      transform: GradientRotation(progress * 2 * math.pi),
    ).createShader(Offset.zero & size);

    final corePaint = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(segment, corePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
