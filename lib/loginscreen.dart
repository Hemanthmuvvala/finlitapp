import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  SizedBox textFieldDefault = const SizedBox(height: 15);
  bool passwordVisibility = false;
  XFile? pickedXfile;
  final _fromValidator = GlobalKey<FormState>();
  // bool validCheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Login Screen',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _fromValidator,
          child: SizedBox(
            height: 590,
            width: 550,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                color: const Color.fromARGB(255, 167, 168, 165),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  // mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    textFieldDefault,
                    const Text(
                      'Welcome to finlit :)',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Stack(children: [
                      pickedXfile != null
                          ? CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  FileImage(File(pickedXfile!.path)),
                            )
                          : const CircleAvatar(
                              radius: 60,
                            ),
                      Positioned(
                          bottom: 0,
                          right: 20,
                          child: InkWell(
                              onTap: () async {
                                ImagePicker imagepicker = ImagePicker();
                                pickedXfile = await imagepicker.pickImage(
                                  source: ImageSource.gallery,
                                  // preferredCameraDevice:CameraDevice.front
                                );
                                if (pickedXfile != null) {
                                  setState(() {});
                                }
                              },
                              child: const Icon(
                                Icons.photo_camera,
                                size: 30,
                              )))
                    ]),
                    textFieldDefault,
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: TextFormField(
                        maxLength: 24,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter Name",
                          label: const Text('Name'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          prefixIcon: const Icon(Icons.person),
                          counterText: "",
                          focusColor: Colors.black,
                        ),
                      ),
                    ),
                    textFieldDefault,
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: TextFormField(
                        maxLength: 10,
                        keyboardType: const TextInputType.numberWithOptions(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter number';
                          } else if (value.length < 10) {
                            return 'please enter a valid number';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Phone",
                          label: const Text('Phone'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          prefixIcon: const Icon(Icons.phone_callback),
                          counterText: "",
                          focusColor: Colors.black,
                        ),
                      ),
                    ),
                    textFieldDefault,
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: TextFormField(
                        maxLength: 8,
                        obscureText: !passwordVisibility,
                        validator: (value) {
                          final bool validPassword = RegExp(
                                  r'^(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$')
                              .hasMatch(value ?? '');

                          if (value == null || value.isEmpty) {
                            return 'please enter password';
                          } else if (!validPassword) {
                            return 'password contains 8 charecters and  atleast one \nspecial charecter';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Password",
                          label: const Text('Password'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          prefixIcon: const Icon(Icons.key),
                          counterText: "",
                          focusColor: Colors.black,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                passwordVisibility = !passwordVisibility;
                              });
                            },
                            child: Icon(
                              passwordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    textFieldDefault,
                    ElevatedButton(
                      onPressed: () {
                        if (_fromValidator.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            
                              const SnackBar(backgroundColor:Color.fromARGB(255, 167, 168, 165),
                                  content: Text('Login successful')));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      child: const Text('Login'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
