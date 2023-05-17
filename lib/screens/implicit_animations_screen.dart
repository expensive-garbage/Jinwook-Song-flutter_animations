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
            AnimatedAlign(
              duration: const Duration(milliseconds: 150),
              alignment:
                  _visible ? Alignment.centerRight : Alignment.centerLeft,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: _visible ? 1 : 0,
                child: Container(
                  width: size.width * 0.8,
                  height: size.width * 0.8,
                  color: Colors.amber,
                ),
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
