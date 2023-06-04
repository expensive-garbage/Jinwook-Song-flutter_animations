import 'package:flutter/material.dart';

class MusicPlaterScreen extends StatefulWidget {
  const MusicPlaterScreen({super.key});

  @override
  State<MusicPlaterScreen> createState() => _MusicPlaterScreenState();
}

class _MusicPlaterScreenState extends State<MusicPlaterScreen> {
  final PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 0.8,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 350,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          'assets/images/covers/yeonjae0$index.jpeg',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'yeonjae',
                    style: TextStyle(
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'home',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
