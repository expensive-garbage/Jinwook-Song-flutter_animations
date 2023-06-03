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
  int _cardIndex = 1;

  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
    lowerBound: -(size.width + 100),
    upperBound: size.width + 100,
    value: 0,
  );

  late final Tween<double> _rotation = Tween(
    begin: -15,
    end: 15,
  );

  late final Tween<double> _scale = Tween(
    begin: 0.8,
    end: 1.0,
  );
  late final Tween<double> _buttonScale = Tween(
    begin: 1.0,
    end: 0.9,
  );

  late final ColorTween _buttonColor = ColorTween(
    begin: Colors.amber,
    end: Colors.pink,
  );

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _animationController.value += details.delta.dx;
  }

  void _dismissCard({required bool forward, int duration = 300}) {
    final factor = forward ? 1 : -1;
    _animationController
        .animateTo((size.width + 100) * factor,
            duration: Duration(milliseconds: duration))
        .whenComplete(() {
      _animationController.value = 0;
      _cardIndex += 1;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = size.width / 2;
    if (_animationController.value >= bound ||
        _animationController.value <= -bound) {
      _animationController.value.isNegative
          ? _dismissCard(forward: false)
          : _dismissCard(forward: true);
    } else {
      _animationController.animateTo(
        0,
        curve: Curves.elasticOut,
      );
    }
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

          final scale = _scale
              .transform(_animationController.value.abs() / (size.width + 100));
          final buttonScale = _buttonScale
              .transform(_animationController.value.abs() / (size.width + 100));
          final buttonColor = _buttonColor
              .transform(_animationController.value.abs() / (size.width + 100));

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 100,
                child: Transform.scale(
                    scale: scale,
                    child: Card(
                      index: (_cardIndex + 1) % 10,
                    )),
              ),
              Positioned(
                top: 100,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: Transform.translate(
                    offset: Offset(_animationController.value, 0),
                    child: Transform.rotate(
                      angle: angle,
                      child: Card(
                        index: _cardIndex % 10,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                  bottom: 100,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            _dismissCard(forward: false, duration: 300),
                        child: Transform.scale(
                          scale: _animationController.value.isNegative
                              ? buttonScale
                              : 1.0,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: _animationController.value.isNegative
                                  ? buttonColor
                                  : Colors.amber,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.7),
                                  blurRadius: 5.0,
                                  spreadRadius: 0.0,
                                  offset: const Offset(0, 7),
                                )
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_sharp,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 80,
                      ),
                      GestureDetector(
                        onTap: () => _dismissCard(forward: true, duration: 300),
                        child: Transform.scale(
                          scale: _animationController.value.isNegative
                              ? 1.0
                              : buttonScale,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: _animationController.value.isNegative
                                  ? Colors.amber
                                  : buttonColor,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.7),
                                  blurRadius: 5.0,
                                  spreadRadius: 0.0,
                                  offset: const Offset(0, 7),
                                )
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios_sharp,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          );
        },
      ),
    );
  }
}

class Card extends StatelessWidget {
  final int index;
  const Card({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      elevation: 20,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.5,
        child: Image.asset(
          'assets/images/covers/yeonjae0$index.jpeg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
