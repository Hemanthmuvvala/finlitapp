import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessagesScreen extends StatelessWidget {
  final Color redGradientStart = const Color(0xFFE50914);
  final Color redGradientEnd = const Color(0xFF8B0000);

  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Center(
                child: Text(
                  'MESSAGES',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      width: 368,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                            color: const Color.fromARGB(255, 32, 31, 31)),
                        // borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Search for Groups',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    width: 45,
                    height: 45,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD51933),
                      // borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      messageTile(time: '9:03 PM', unreadCount: 0),
                      dividerLine(),
                      messageTile(time: '9:30 PM', unreadCount: 0),
                      dividerLine(),
                      messageTile(time: '9:03 PM', unreadCount: 5),
                      dividerLine(),
                      messageTile(time: '9:03 PM', unreadCount: 5),
                      dividerLine(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget messageTile({required int unreadCount, required String time}) {
    return Container(
      // width:430,
      // height:80,

      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 0, 0),
        borderRadius: BorderRadius.circular(4),
        // border: Border.all(color:const Color.fromARGB(255, 32, 31, 31)),
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 54,
            padding: const EdgeInsets.all(1), // space between image and border
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 0, 0),
              border: Border.all(color: Colors.white), // border color
            ),
            child: Padding(
              padding: const EdgeInsets.all(0.5),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 152, 152, 152)), //
                ),
                child: SizedBox(
                  width: 50,
                  height: 48,
                  child: Image.asset(
                    'assets/images/gamers_logo.png',
                    fit: BoxFit.fill, // or BoxFit.fill if needed
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TOURNAMET NAME FULL NAME FULL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 81,
                  height: 17,
                  decoration: BoxDecoration(
                    gradient: const RadialGradient(
                      colors: [
                        Color.fromARGB(40, 117, 26, 26),
                        Color.fromARGB(153, 255, 6, 6),
                      ],
                      radius: 2.8,
                      stops: [0, 0.83],
                      center: Alignment.center,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'GTGSD52354',
                    style: GoogleFonts.jost(
                        fontSize: 8,
                        color: Colors.white,
                        fontWeight: FontWeight.w100),
                    // TextStyle(
                    //   color: Color(0xFFEEEEEE),
                    //   fontSize: 8,
                    //   fontWeight: FontWeight.w100,

                    // ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              if (unreadCount > 0)
                Material(
                  elevation: 20,
                  shadowColor: Colors.redAccent.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6), // Smaller radius
                  color: Colors.transparent,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: ClipPath(
                      clipper: SkewedClipper(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4.5, // Reduced from 8
                          vertical: 4, // Reduced from 4
                        ),
                        color: const Color(0xFFC80D31),
                        child: Text(
                          unreadCount.toString().padLeft(2, '0'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8, // Reduced from 10
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EyeShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.height / 2);

    // Flatter top curve
    path.quadraticBezierTo(
      size.width / 2,
      -size.height * 0.5, // was -0.5, reduced to -0.25
      size.width,
      size.height / 2,
    );

    // Flatter bottom curve
    path.quadraticBezierTo(
      size.width / 2,
      size.height * 1.5, // was 1.5, reduced to 1.25
      0,
      size.height / 2,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Widget dividerLine() {
  return Divider(
    color: Colors.grey[800], // subtle line on black background
    thickness: 0.5,
    height: 16, // space around the divider
  );
}

// Custom Clipper for slanted badge
class SkewedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0); // top-left
    path.lineTo(size.width, 0); // top-right
    path.lineTo(size.width, size.height * 0.75); // bottom-right
    path.lineTo(0, size.height); // bottom-left
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
