# Flutter Animations

| 프로젝트 기간 | 23.05.17                                           |
| ------------- | -------------------------------------------------- |
| 프로젝트 목적 | flutter로 다양한 애니메이션 구현                   |
| Github        | https://github.com/Jinwook-Song/flutter_animations |

[Animation Decision Tree](https://docs.flutter.dev/ui/animations)

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/35e564f0-838c-4cdd-8347-ec6a30181ecf/Untitled.png)

---

1. Implicit Animations

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

2. Explicit Animations

   여러 위젯을 animation 하고싶은 경우,

   animation에 더 많은 통제를 하고싶은 경우(loop, pause, reverse, etc…)

   - SingleTickerProviderStateMixin

   Ticker: call its callback once per animation frame

   SingleTickerProviderStateMixin: only tick while the current tree is enabled

   → 빠른 rebuild를 위해 Ticker를 사용하고, enable 상태에서만 활성화하도록

   ```dart
   class _ExplicitAnimationsScreenState extends State<ExplicitAnimationsScreen>
       with SingleTickerProviderStateMixin {
     late final AnimationController _animationController =
         AnimationController(vsync: this);

     @override
     Widget build(BuildContext context) {
       return Scaffold(
         appBar: AppBar(
           title: const Text('Explicit Animations'),
         ),
       );
     }
   }
   ```
