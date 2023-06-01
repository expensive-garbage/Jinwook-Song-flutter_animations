import 'dart:math';

import 'package:flutter/material.dart';

class AppleWatchScreen extends StatefulWidget {
  const AppleWatchScreen({super.key});

  @override
  State<AppleWatchScreen> createState() => _AppleWatchScreenState();
}

class _AppleWatchScreenState extends State<AppleWatchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        title: const Text('Apple Watch'),
      ),
      body: Center(
          child: CustomPaint(
        painter: AppleWatchPainter(),
        size: const Size(400, 400),
      )),
    );
  }
}

class AppleWatchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final raidus = size.width / 2;
    final redRadius = raidus * 0.9;
    final greenRadius = raidus * 0.65;
    final blueRadius = raidus * 0.4;
    const double strokeWidth = 45;

    final center = Offset(raidus, raidus);

    // Background Circls
    final redCirclePaint = Paint()
      ..color = Colors.pink.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, redRadius, redCirclePaint);

    final greenCirclePaint = Paint()
      ..color = Colors.lightGreen.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, greenRadius, greenCirclePaint);

    final blueCirclePaint = Paint()
      ..color = Colors.cyan.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, blueRadius, blueCirclePaint);

    // Arc
    final redArcRect = Rect.fromCircle(center: center, radius: redRadius);
    final redArcPaint = Paint()
      ..color = Colors.pink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 45
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(redArcRect, -0.5 * pi, 1.5 * pi, false, redArcPaint);

    final greenArcRect = Rect.fromCircle(center: center, radius: greenRadius);
    final greenArcPaint = Paint()
      ..color = Colors.lightGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 45
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(greenArcRect, -0.5 * pi, 1.2 * pi, false, greenArcPaint);

    final blueArcRect = Rect.fromCircle(center: center, radius: blueRadius);
    final blueArcPaint = Paint()
      ..color = Colors.lightBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 45
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(blueArcRect, -0.5 * pi, 0.8 * pi, false, blueArcPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
