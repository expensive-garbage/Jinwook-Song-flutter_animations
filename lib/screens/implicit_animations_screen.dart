import 'dart:math';

import 'package:flutter/material.dart';

class ImplicitAnimationsScreen extends StatefulWidget {
  const ImplicitAnimationsScreen({super.key});

  @override
  State<ImplicitAnimationsScreen> createState() =>
      _ImplicitAnimationsScreenState();
}

class _ImplicitAnimationsScreenState extends State<ImplicitAnimationsScreen> {
  bool _visible = true;

  void _toggle() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Implicit Animations',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: size.width * 0.4,
              height: size.width * 0.4,
              transform: Matrix4.rotationZ(_visible ? 1 / 2 * pi : 0),
              transformAlignment: Alignment.center,
              decoration: BoxDecoration(
                color: _visible ? Colors.pink : Colors.amber,
                borderRadius: BorderRadius.circular(_visible ? 10 : 100),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _toggle, child: const Text('Go!'))
          ],
        ),
      ),
    );
  }
}
