import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class PopupScreen extends StatefulWidget {
  const PopupScreen({super.key});

  @override
  _PopupScreenState createState() => _PopupScreenState();
}

class _PopupScreenState extends State<PopupScreen> with TickerProviderStateMixin {
  List<bool> isSelected = List.generate(9, (index) => index < 3);

  final List<AnimationController> _controllers = [];
  final List<AnimationController> _colorControllers = [];
  final List<AnimationController> _scaleControllers = [];
  final List<Animation<double>> _scaleAnimations = [];
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 9; i++) {
      _controllers.add(AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ));

      _colorControllers.add(AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ));

      final scaleController = AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );

      _scaleControllers.add(scaleController);

      _scaleAnimations.add(
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.375), weight: 20),
          TweenSequenceItem(tween: Tween(begin: 1.375, end: 1.125), weight: 20),
          TweenSequenceItem(tween: Tween(begin: 1.125, end: 1.3125), weight: 20),
          TweenSequenceItem(tween: Tween(begin: 1.3125, end: 1.25), weight: 40),
        ]).animate(CurvedAnimation(
          parent: scaleController,
          curve: Curves.easeInOut,
        )),
      );

      // Reset to default after animation completes
      scaleController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          scaleController.reset(); // Reset back to 1.0
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var controller in _colorControllers) {
      controller.dispose();
    }
    for (var controller in _scaleControllers) {
      controller.dispose();
    }
    _nameController.dispose();
    super.dispose();
  }

  void toggleSelection(int index) {
    HapticFeedback.mediumImpact();

    _controllers[index].repeat(reverse: true);
    Future.delayed(const Duration(milliseconds: 200), () {
      _controllers[index].stop();
    });

    if (isSelected[index]) {
      _colorControllers[index].reverse();
    } else {
      _colorControllers[index].forward();
    }

    _scaleControllers[index].forward(from: 0.0);

    setState(() {
      isSelected[index] = !isSelected[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: 350,
          decoration: BoxDecoration(
            color: const Color(0xFF0C0E12),
            border: Border.all(
              color: const Color(0xFF3A3A3A),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: BorderPainter(),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 50,
                        child: Stack(
                          children: [
                            ClipPath(
                              clipper: HeaderClipper(),
                              child: Container(
                                height: 100,
                                width: 250,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFFD5001C), Color(0xFFD5001C)],
                                  ),
                                ),
                                child: const Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      'SELECT',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.normal,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.0,
                          ),
                          itemCount: 9,
                          itemBuilder: (context, index) {
                            return AnimatedBuilder(
                              animation: _colorControllers[index],
                              builder: (context, child) {
                                return GestureDetector(
                                  onTap: () => toggleSelection(index),
                                  child: ScaleTransition(
                                    scale: _scaleAnimations[index],
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 700),
                                      curve: Curves.easeInOut,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromARGB(255, 104, 104, 104),
                                          width: 0.5,
                                        ),
                                        color: Color.lerp(
                                          Colors.black,
                                          const Color(0xFFCC1430),
                                          _colorControllers[index].value,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Option ${index + 1}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          AnimatedBuilder(
                                            animation: _controllers[index],
                                            builder: (context, child) {
                                              return Transform.translate(
                                                offset: Offset(
                                                  sin(_controllers[index].value * 2 * pi) * 2,
                                                  0,
                                                ),
                                                child: Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.red,
                                                  ),
                                                  child: Center(
                                                    child: AnimatedSwitcher(
                                                      duration: const Duration(milliseconds: 500),
                                                      transitionBuilder: (Widget child,
                                                          Animation<double> animation) {
                                                        return ScaleTransition(
                                                            scale: animation, child: child);
                                                      },
                                                      child: Text(
                                                        isSelected[index] ? '−' : '+',
                                                        key: ValueKey<bool>(isSelected[index]),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3A3A3A)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(35, 0);
    path.lineTo(size.width - 35, 0);
    path.lineTo(size.width, 35);
    path.lineTo(size.width, size.height - 35);
    path.lineTo(size.width - 35, size.height);
    path.lineTo(35, size.height);
    path.lineTo(0, size.height - 35);
    path.lineTo(0, 35);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double reducedHeight = size.height * 0.7;
    double reducedWidth = size.width * 0.8;

    path.moveTo((size.width - reducedWidth) / 2, 0);
    path.lineTo((size.width + reducedWidth) / 2, 0);
    path.lineTo(size.width * 0.85, reducedHeight);
    path.lineTo(size.width * 0.15, reducedHeight);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
