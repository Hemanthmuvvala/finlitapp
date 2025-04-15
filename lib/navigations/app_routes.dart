import 'package:finlitapp/errorscreen.dart';
import 'package:finlitapp/homescreen.dart';
import 'package:finlitapp/loginscreen.dart';
import 'package:finlitapp/splashscreen.dart';
import 'package:flutter/material.dart';

var onGenerate = (RouteSettings settings) {
  if (settings.name == '/') {
    return MaterialPageRoute(builder: (builder) => const Splashscreen());
  } else if (settings.name == Loginscreen.routeName) {
    return MaterialPageRoute(builder: (builder) => const Loginscreen());
  } else if (settings.name == Homescreen.routeName) {
    return MaterialPageRoute(
        builder: (builder) => Homescreen(name: settings.arguments.toString()));
  } else {
    return MaterialPageRoute(builder: (builder) => const ErrorScreen());
  }
};
