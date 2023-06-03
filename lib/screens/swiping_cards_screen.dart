import 'dart:math';

import 'package:flutter/material.dart';

class SwipingCardsScreen extends StatefulWidget {
  const SwipingCardsScreen({super.key});

  @override
  State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
}

class _SwipingCardsScreenState extends State<SwipingCardsScreen>
    with SingleTickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;

  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
    lowerBound: -size.width,
    upperBound: size.width,
    value: 0,
  );

  late final Tween<double> _rotation = Tween(
    begin: -15,
    end: 15,
  );

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _animationController.value += details.delta.dx;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    _animationController.animateTo(
      0,
      curve: Curves.elasticOut,
    );
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
        title: const Text(
          'Swiping Cards',
        ),
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final angle = _rotation.transform(
                  (_animationController.value + size.width / 2) / size.width) *
              pi /
              180; // convert to radians
          return Stack(children: [
            Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onHorizontalDragUpdate: _onHorizontalDragUpdate,
                onHorizontalDragEnd: _onHorizontalDragEnd,
                child: Transform.translate(
                  offset: Offset(_animationController.value, 30),
                  child: Transform.rotate(
                    angle: angle,
                    child: Material(
                      elevation: 20,
                      color: Colors.red.shade100,
                      child: SizedBox(
                        width: size.width * 0.8,
                        height: size.height * 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ]);
        },
      ),
    );
  }
}
