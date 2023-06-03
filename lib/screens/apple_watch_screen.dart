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

  late final CurvedAnimation _curvedAnimation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.elasticOut,
  );

  List<double> _getRandomValueList({int count = 3}) {
    return List.generate(count, (_) => Random().nextDouble() * 2.0 * pi);
  }

  late final List<double> _initProgressPoints = _getRandomValueList();

  late final List<Animation<double>> _progressList = List.generate(
    3,
    (index) => Tween(
      begin: 0 * pi,
      end: _initProgressPoints[index],
    ).animate(_curvedAnimation),
  );

  void _animateValues() {
    final newBeginPoints = _progressList //
        .map((e) => e.value)
        .toList();
    final newEndPoints = _getRandomValueList();

    _progressList.asMap().forEach((idx, _) {
      _progressList[idx] = Tween(
        begin: newBeginPoints[idx],
        end: newEndPoints[idx],
      ).animate(_curvedAnimation);
    });

    setState(() {
      _animationController.forward(from: 0);
    });
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
          animation: _progressList[0],
          builder: (context, child) {
            return CustomPaint(
              painter: AppleWatchPainter(
                progressList: _progressList.map((e) => e.value).toList(),
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
  final List<double> progressList;

  AppleWatchPainter({required this.progressList});
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
      progressList[0],
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
      progressList[1],
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
      progressList[2],
      false,
      blueArcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant AppleWatchPainter oldDelegate) {
    return oldDelegate.progressList[0] != progressList[0] ||
        oldDelegate.progressList[1] != progressList[1] ||
        oldDelegate.progressList[2] != progressList[2];
  }
}
