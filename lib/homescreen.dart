import 'package:finlitapp/chatscreen.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});
  
  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  final String _text = 'Your AI-powered Financial Guide';
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: _text.length * 100),
      vsync: this,
    );
    
    _animation = IntTween(begin: 0, end: _text.length).animate(_controller);
    
    
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      appBar:AppBar(
        title:const Center(child: Text('FinLit AI',style:TextStyle(fontSize:30,fontWeight:FontWeight.bold),)),
        backgroundColor:Colors.white,
      ),
      body: Column(
        
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Text(
                  _text.substring(0, _animation.value),
                  style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
          const SizedBox(height:30,),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatScreen()),
                  );
                },
                label: const Text(
                  'Chat',
                  style: TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: const Icon(Icons.chat),
                iconAlignment: IconAlignment.end,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 34, 34, 34),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadowColor: const Color(0xFF1565C0),
                  elevation: 5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}