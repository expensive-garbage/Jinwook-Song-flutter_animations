import 'dart:math';

import 'package:flutter/material.dart';

class AppleWatchScreen extends StatefulWidget {
  const AppleWatchScreen({super.key});

  @override
  State<AppleWatchScreen> createState() => _AppleWatchScreenState();
}

class _AppleWatchScreenState extends State<AppleWatchScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  )..forward();

  late final CurvedAnimation _curvedAnimation =
      CurvedAnimation(parent: _animationController, curve: Curves.bounceOut);

  late Animation<double> _progress = Tween(
    begin: 0 * pi,
    end: 3 / 2 * pi,
  ).animate(_curvedAnimation);

  void _animateValues() {
    final newBegin = _progress.value;
    final random = Random();
    final newEnd = random.nextDouble() * 2 * pi;
    _progress = Tween(
      begin: newBegin,
      end: newEnd,
    ).animate(_curvedAnimation);
    setState(() {});
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
        child: AnimatedBuilder(
          animation: _progress,
          builder: (context, child) {
            return CustomPaint(
              painter: AppleWatchPainter(
                progress: _progress.value,
              ),
              size: const Size(400, 400),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _animateValues,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class AppleWatchPainter extends CustomPainter {
  final double progress;

  AppleWatchPainter({required this.progress});
  @override
  void paint(Canvas canvas, Size size) {
    final raidus = size.width / 2;
    final redRadius = raidus * 0.9;
    final greenRadius = raidus * 0.65;
    final blueRadius = raidus * 0.4;
    const double strokeWidth = 45;
    const startingAngle = -1 / 2 * pi;

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
    canvas.drawArc(
      redArcRect,
      startingAngle,
      progress,
      false,
      redArcPaint,
    );

    final greenArcRect = Rect.fromCircle(center: center, radius: greenRadius);
    final greenArcPaint = Paint()
      ..color = Colors.lightGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 45
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      greenArcRect,
      startingAngle,
      progress,
      false,
      greenArcPaint,
    );

    final blueArcRect = Rect.fromCircle(center: center, radius: blueRadius);
    final blueArcPaint = Paint()
      ..color = Colors.lightBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 45
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      blueArcRect,
      startingAngle,
      progress,
      false,
      blueArcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant AppleWatchPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
