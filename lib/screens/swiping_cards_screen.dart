import 'package:flutter/material.dart';

class SwipingCardsScreen extends StatefulWidget {
  const SwipingCardsScreen({super.key});

  @override
  State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
}

class _SwipingCardsScreenState extends State<SwipingCardsScreen> {
  double _posX = 0;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _posX += details.delta.dx;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    setState(() {
      _posX = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Swiping Cards',
        ),
      ),
      body: Stack(children: [
        Align(
          alignment: Alignment.topCenter,
          child: GestureDetector(
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            onHorizontalDragEnd: _onHorizontalDragEnd,
            child: Transform.translate(
              offset: Offset(_posX, 0),
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
        )
      ]),
    );
  }
}
