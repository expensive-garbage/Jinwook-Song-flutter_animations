# Flutter Animations

| 프로젝트 기간 | 23.05.17                                           |
| ------------- | -------------------------------------------------- |
| 프로젝트 목적 | flutter로 다양한 애니메이션 구현                   |
| Github        | https://github.com/Jinwook-Song/flutter_animations |

[Animation Decision Tree](https://docs.flutter.dev/ui/animations)

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/35e564f0-838c-4cdd-8347-ec6a30181ecf/Untitled.png)

---

- Implicit Animations
  애니메이션에 대해서 코드를 작성할 필요가 없다. 플러터가 알아서 다 해준다.
  `Animated`로 시작하는 위젯이 이에 해당된다. ([dcos](https://docs.flutter.dev/ui/widgets/animation))
  - AnimatedContainer: 어떤것이든 transition 효과를 준다
  ```dart
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
  ```
  - Curves ([docs](https://api.flutter.dev/flutter/animation/Curves-class.html))
  - TweenAnimationBuilder
    나만의 implicit animation 위젯을 만들 수 있다
    내장된 AnimatedWidget이 없는 경우 사용할 수 있다
    tween: from ~ to 사이의 값으로 transition 효과를 줌
    value: currently animated value
    ```dart
    TweenAnimationBuilder(
                  tween: ColorTween(
                    begin: Colors.amber,
                    end: Colors.purple,
                  ),
                  curve: Curves.bounceInOut,
                  duration: const Duration(seconds: 5),
                  builder: (context, value, child) {
                    return Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/4/4f/Dash%2C_the_mascot_of_the_Dart_programming_language.png',
                      color: value,
                      colorBlendMode: BlendMode.hue,
                    );
                  },
                ),
    ```
- Explicit Animations
  여러 위젯을 animation 하고싶은 경우,
  animation에 더 많은 통제를 하고싶은 경우(loop, pause, reverse, etc…)
  - SingleTickerProviderStateMixin
  Ticker: call its callback once per animation frame
  SingleTickerProviderStateMixin: only tick while the current tree is enabled
  → 빠른 rebuild를 위해 Ticker를 사용하고, enable 상태에서만 활성화하도록
  ```dart
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
         duration: const Duration(
           seconds: 10,
         ),
         lowerBound: 50.0,
         upperBound: 100.0,
       )
         // Called when the animation value changes
         // 하지만 전체를 rebuild하기 때문에 매우 부적합하다
         ..addListener(() {
           setState(() {});
         });

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
       void initState() {
         super.initState();
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
                 Text(
                   _animationController.value.toStringAsFixed(3),
                   style: const TextStyle(fontSize: 40),
                 ),
                 const SizedBox(
                   height: 20,
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
  ```
  - AnimatedBuilder
    animation이 바뀌는 부분만 새롭게 render
    ```dart
    AnimatedBuilder(
                       animation: _animationController,
                       builder: (context, child) {
                         return Text(
                           _animationController.value.toStringAsFixed(3),
                           style: const TextStyle(fontSize: 40),
                         );
                       },
                     ),
    ```
  - Explicit Animations
    ```dart
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
         ).animate(_animationController);

         late final Animation<double> _rotationAnimation = Tween(
           begin: 0.0,
           end: 1 / 8,
         ).animate(_animationController);

         late final Animation<double> _scaleAnimation = Tween(
           begin: 1.0,
           end: 0.5,
         ).animate(_animationController);

         late final Animation<Offset> _offsetAnimation = Tween(
           begin: Offset.zero,
           end: const Offset(0, -1),
         ).animate(_animationController);

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
    ```
  - Curve
    ```dart
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
    ```
  - ValueNotifier & ValueListenableBuilder
    animation 진행 상황을 render할때, setState를 이용하지 않고,
    ValueNotifier의 값을 변경하고, 이 변화된 값을 렌더해주는 ValueListenableBuilder를 이용하여 최적화 할 수 있다
    ```dart
    late final AnimationController _animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
        reverseDuration: const Duration(seconds: 1),
      )..addListener(() {
          _progress.value = _animationController.value;
        });

    final ValueNotifier<double> _progress = ValueNotifier(0.0);

      void _onChanged(double value) {
        _progress.value = value;
        _animationController.value = value;
      }

    ValueListenableBuilder(
                  valueListenable: _progress,
                  builder: (context, value, child) {
                    return Slider(
                      value: value,
                      onChanged: _onChanged,
                    );
                  },
                )
    ```
  - AnimationStatus
    `foward`, `completed`, `reverse`, `dismissed` 에 따라 animation을 컨트롤 할 수 있다
    ```dart
    late final AnimationController _animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
        reverseDuration: const Duration(seconds: 1),
      )
        ..addListener(() {
          _progress.value = _animationController.value;
        })
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _rewind();
          } else if (status == AnimationStatus.dismissed) {
            _play();
          }
        });

    bool _looping = false;

      void _toggleLooping() {
        if (_looping) {
          _animationController.stop();
        } else {
          _animationController.repeat(reverse: true);
        }
        setState(() {
          _looping = !_looping;
        });
      }
    ```
  여러 위젯을 animation 하고싶은 경우,
  animation에 더 많은 통제를 하고싶은 경우(loop, pause, reverse, etc…)
  - SingleTickerProviderStateMixin
  Ticker: call its callback once per animation frame
  SingleTickerProviderStateMixin: only tick while the current tree is enabled
  → 빠른 rebuild를 위해 Ticker를 사용하고, enable 상태에서만 활성화하도록
  ```dart
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
         duration: const Duration(
           seconds: 10,
         ),
         lowerBound: 50.0,
         upperBound: 100.0,
       )
         // Called when the animation value changes
         // 하지만 전체를 rebuild하기 때문에 매우 부적합하다
         ..addListener(() {
           setState(() {});
         });

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
       void initState() {
         super.initState();
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
                 Text(
                   _animationController.value.toStringAsFixed(3),
                   style: const TextStyle(fontSize: 40),
                 ),
                 const SizedBox(
                   height: 20,
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
  ```
  - AnimatedBuilder
    animation이 바뀌는 부분만 새롭게 render
    ```dart
    AnimatedBuilder(
                       animation: _animationController,
                       builder: (context, child) {
                         return Text(
                           _animationController.value.toStringAsFixed(3),
                           style: const TextStyle(fontSize: 40),
                         );
                       },
                     ),
    ```
  - Explicit Animations
    ```dart
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
         ).animate(_animationController);

         late final Animation<double> _rotationAnimation = Tween(
           begin: 0.0,
           end: 1 / 8,
         ).animate(_animationController);

         late final Animation<double> _scaleAnimation = Tween(
           begin: 1.0,
           end: 0.5,
         ).animate(_animationController);

         late final Animation<Offset> _offsetAnimation = Tween(
           begin: Offset.zero,
           end: const Offset(0, -1),
         ).animate(_animationController);

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
    ```
  - Curve
    ```dart
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
    ```
  - ValueNotifier & ValueListenableBuilder
    animation 진행 상황을 render할때, setState를 이용하지 않고,
    ValueNotifier의 값을 변경하고, 이 변화된 값을 렌더해주는 ValueListenableBuilder를 이용하여 최적화 할 수 있다
    ```dart
    late final AnimationController _animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
        reverseDuration: const Duration(seconds: 1),
      )..addListener(() {
          _progress.value = _animationController.value;
        });

    final ValueNotifier<double> _progress = ValueNotifier(0.0);

      void _onChanged(double value) {
        _progress.value = value;
        _animationController.value = value;
      }

    ValueListenableBuilder(
                  valueListenable: _progress,
                  builder: (context, value, child) {
                    return Slider(
                      value: value,
                      onChanged: _onChanged,
                    );
                  },
                )
    ```
  - AnimationStatus
    `foward`, `completed`, `reverse`, `dismissed` 에 따라 animation을 컨트롤 할 수 있다
    ```dart
    late final AnimationController _animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
        reverseDuration: const Duration(seconds: 1),
      )
        ..addListener(() {
          _progress.value = _animationController.value;
        })
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _rewind();
          } else if (status == AnimationStatus.dismissed) {
            _play();
          }
        });

    bool _looping = false;

      void _toggleLooping() {
        if (_looping) {
          _animationController.stop();
        } else {
          _animationController.repeat(reverse: true);
        }
        setState(() {
          _looping = !_looping;
        });
      }
    ```
