import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PopupScreen extends StatefulWidget {
  const PopupScreen({super.key});

  @override
  _PopupScreenState createState() => _PopupScreenState();
}

class _PopupScreenState extends State<PopupScreen>
    with TickerProviderStateMixin {
  List<bool> isSelected =
      List.generate(9, (index) => index < 3); // First 3 are selected by default
  final List<AnimationController> _controllers = [];
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
   
    for (int i = 0; i < 9; i++) {
      _controllers.add(AnimationController(
        duration: const Duration(milliseconds: 150),
        vsync: this,
      ));
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _nameController.dispose();
    super.dispose();
  }

  void toggleSelection(int index) {
    HapticFeedback.mediumImpact();

    // Animate button press
    _controllers[index].forward().then((_) {
      _controllers[index].reverse();
    });

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
              // Outer frame for the entire popup with angled corners
              Stack(
                children: [
                  // Entire popup outline with angled corners
                  Positioned.fill(
                    child: CustomPaint(
                      painter: BorderPainter(),
                    ),
                  ),

                  Column(
                    children: [
                      // Header with custom shape - updated to match reference
                      Container(
                        height: 50,
                        margin: const EdgeInsets.only(top: 0),
                        child: Stack(
                          children: [
                            // Red SELECT header with correct shape
                            ClipPath(
                              clipper: HeaderClipper(),
                              child: Container(
                                height: 100,
                                width:250,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFD5001C),
                                      Color(0xFFD5001C),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0,0,0,10),
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

                            // Metal accent at top-left of header
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: 25,
                                height: 12,
                                color: Colors.grey.withOpacity(0.7),
                              ),
                            ),

                            // Metal accent at top-right of header
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 25,
                                height: 12,
                                color: Colors.grey.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Options Grid
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
                              animation: _controllers[index],
                              builder: (context, child) {
                                // Create scale effect on press
                                return Transform.scale(
                                  scale:
                                      1.0 - (_controllers[index].value * 0.05),
                                  child: GestureDetector(
                                    onTap: () => toggleSelection(index),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromARGB(255, 104, 104, 104),
                                          width:  0.5, 
                                            
                                        ),
                                        color: isSelected[index]
                                            ? const Color(0xFFCC1430)
                                            : const Color.fromARGB(255, 1, 1, 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Option ${index + 1}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          // Black ball with plus/minus
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  const Color.fromARGB(255, 15, 15, 15)!,
                                                  const Color.fromARGB(255, 27, 26, 26)!,
                                                ],
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  blurRadius: 3,
                                                  spreadRadius: 0,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                isSelected[index] ? '−' : '+',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
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

                      // Custom name input
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "CUSTOM NAME",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _nameController,
                              style: const TextStyle(color: Colors.white70),
                              decoration: InputDecoration(
                                hintText: 'Enter your custom name',
                                hintStyle: TextStyle(color: Colors.grey[600]),
                                filled: true,
                                fillColor: const Color(0xFF0C0E12),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[800]!),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[600]!),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Create Button
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.heavyImpact();
                          },
                          child: Container(
                            width: 700,
                            height: 40,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFD5001C),
                                  Color(0xFFD5001C),
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "CREATE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
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

// Custom painter for the angled borders of the entire popup
class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3A3A3A)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Top border with angled corners
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

// Custom clipper for the header shape
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double reducedHeight = size.height * 0.7; // Reduced height
    double reducedWidth = size.width * 0.8;  // Reduced width

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


