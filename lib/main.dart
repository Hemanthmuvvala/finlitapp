import 'package:finlitapp/navigations/app_routes.dart';
import 'package:finlitapp/navigations/task2.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true,),
     
      home:  MessagesScreen(),
      initialRoute:'/',
      onGenerateRoute:onGenerate,
    );
    
  }
}

