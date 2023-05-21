import 'package:flutter/material.dart';

class ExplicitAnimationsScreen extends StatefulWidget {
  const ExplicitAnimationsScreen({super.key});

  @override
  State<ExplicitAnimationsScreen> createState() =>
      _ExplicitAnimationsScreenState();
}

class _ExplicitAnimationsScreenState extends State<ExplicitAnimationsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
    reverseDuration: const Duration(seconds: 1),
  );
  late final CurvedAnimation _curvedAnimation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.elasticOut,
    reverseCurve: Curves.elasticIn,
  );

// Connect Tween and AnimationController
  late final Animation<Decoration> _decorationAnimation = DecorationTween(
    begin: BoxDecoration(
      color: Colors.amber,
      borderRadius: BorderRadius.circular(120),
    ),
    end: BoxDecoration(
      color: Colors.purple,
      borderRadius: BorderRadius.circular(20),
    ),
  ).animate(_curvedAnimation);

  late final Animation<double> _rotationAnimation = Tween(
    begin: 0.0,
    end: 1 / 2,
  ).animate(_curvedAnimation);

  late final Animation<double> _scaleAnimation = Tween(
    begin: 1.0,
    end: 0.5,
  ).animate(_curvedAnimation);

  late final Animation<Offset> _offsetAnimation = Tween(
    begin: Offset.zero,
    end: const Offset(0, -1),
  ).animate(_curvedAnimation);

  void _play() {
    _animationController.forward();
  }

  void _pause() {
    _animationController.stop();
  }

  void _rewind() {
    _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explicit Animations'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _offsetAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: RotationTransition(
                  turns: _rotationAnimation,
                  child: DecoratedBoxTransition(
                    decoration: _decorationAnimation,
                    child: const SizedBox(
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _play,
                  child: const Text(
                    'Play',
                  ),
                ),
                ElevatedButton(
                  onPressed: _pause,
                  child: const Text(
                    'Pause',
                  ),
                ),
                ElevatedButton(
                  onPressed: _rewind,
                  child: const Text(
                    'Rewind',
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
