# Flutter Animations

| 프로젝트 기간 | 23.05.17                                           |
| ------------- | -------------------------------------------------- |
| 프로젝트 목적 | flutter로 다양한 애니메이션 구현                   |
| Github        | https://github.com/Jinwook-Song/flutter_animations |

---

1. Implicit Animations

   애니메이션에 대해서 코드를 작성할 필요가 없다. 플러터가 알아서 다 해준다.

   `Animated`로 시작하는 위젯이 이에 해당된다. ([dcos](https://docs.flutter.dev/ui/widgets/animation))

   AnimatedContainer: 어떤것이든 transition 효과를 준다

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
