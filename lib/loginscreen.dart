import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class Loginscreen extends StatefulWidget {
   static const String routeName='/Loginscreen';

  

  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  SizedBox textFieldDefault = const SizedBox(height: 15);
  bool passwordVisibility = false;
  XFile? pickedXfile;
  final _fromValidator = GlobalKey<FormState>();
  String userName = " ";
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: const Text(
      //     'Login Screen',
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   centerTitle: true,
      //   backgroundColor: Colors.black,
      // ),

      body: SingleChildScrollView(
        child: Form(
          key: _fromValidator,
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Text(
                'welcome..',
                style: GoogleFonts.italiana(
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 590,
                width: 550,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    color: const Color.fromARGB(255, 167, 168, 165),
                    elevation: 15,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        textFieldDefault,

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
                              top: 90,
                              right: 14,
                              child: InkWell(
                                  onTap: () async {
                                    ImagePicker imagepicker =
                                        ImagePicker(); //user can pic the image from the gallery.
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
                        //name validation for the loginform
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
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () {
                              FocusScope.of(context).nextFocus();
                            },
                            onChanged: (value) {
                              userName = value;
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
                        //phone number validation
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: TextFormField(
                            maxLength: 10,
                            keyboardType:
                                const TextInputType.numberWithOptions(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'please enter number';
                              } else if (value.length < 10) {
                                return 'please enter a valid number';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction
                                .next, //shows the next arrow in the keyboard
                            //The focus changes to the nextline.
                            onEditingComplete: () {
                              FocusScope.of(context).nextFocus();
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
                        //pasword validation for the loginscreen
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: TextFormField(
                            maxLength: 8,
                            obscureText: !passwordVisibility,
                            validator: (value) {
                              //regx expression that allows only upto 8 charectors and atleast one special charecter.
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
                            //done symbol is shown in the keyboard
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              FocusScope.of(context).unfocus();
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
                            //used to unfocus the keyboard after pressing the login.
                            FocusScope.of(context).unfocus();
                            if (_fromValidator.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor:
                                          Color.fromARGB(255, 167, 168, 165),
                                      content: Text('Login successful')));
                              //           //navigate to the homescreen.
                              //            Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => Homescreen(name:userName)),
                              // );
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/homeScreen', (route) => false,arguments:userName);
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
                            'Create an account? signup',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
