import 'package:flutter/material.dart';

class SwipingCardsScreen extends StatefulWidget {
  const SwipingCardsScreen({super.key});

  @override
  State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
}

class _SwipingCardsScreenState extends State<SwipingCardsScreen> {
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
          child: Material(
            elevation: 20,
            color: Colors.red.shade100,
            child: SizedBox(
              width: size.width * 0.8,
              height: size.height * 0.5,
            ),
          ),
        )
      ]),
    );
  }
}
