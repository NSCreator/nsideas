// ignore_for_file: unnecessary_import, non_constant_identifier_names, prefer_const_constructors, sort_child_properties_last, must_be_immutable, file_names, use_build_context_synchronously

import 'dart:async';
import 'dart:math';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'raspberrypi.dart';
import 'textField.dart';
import 'functions.dart';
import 'homepage.dart';

import 'notification.dart';
double size(BuildContext context) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenHeight = ((mediaQuery.size.height/900)+(mediaQuery.size.width/400))/2;
  return screenHeight;
}

class createNewUser extends StatefulWidget {
  const createNewUser({super.key});



  @override
  State<createNewUser> createState() => _createNewUserState();
}

class _createNewUserState extends State<createNewUser> {
  bool isTrue = false;
  bool isSend = false;
  String otp = "";

  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController_X = TextEditingController();

  String generateCode() {
    final Random random = Random();
    const characters = '123456789abcdefghijklmnpqrstuvwxyz';
    String code = '';

    for (int i = 0; i < 6; i++) {
      code += characters[random.nextInt(characters.length)];
    }

    return code;
  }

  @override
  Widget build(BuildContext context) {
    double Size = size(context);
    return backGroundImage(
      text: "Enter Gmail ID",
      child: Column(
        children: [


          TextFieldContainer(
              child: TextFormField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                style: textFieldStyle(Size),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Gmail ID',
                    hintStyle: textFieldHintStyle(Size)),
                validator: (email) =>
                email != null && !EmailValidator.validate(email)
                    ? "Enter a valid Email"
                    : null,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isSend)
                Flexible(
                  child: TextFieldContainer(
                      child: TextFormField(
                        controller: otpController,
                        textInputAction: TextInputAction.next,
                        style: textFieldStyle(Size),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter OPT',
                            hintStyle: textFieldHintStyle(Size)),
                      )),
                ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: Size * 10),
                child: InkWell(
                  child: Container(
                    padding:  EdgeInsets.symmetric(
                        vertical:Size *  5, horizontal:Size *  10),
                    decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(Size * 30)),
                    child: Text(
                      isSend ? "Verity" : "Send OTP",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Size * 25,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  onTap: () async {


                    if (isSend) {
                      if (otp == otpController.text.trim()) {
                        isTrue = true;
                        FirebaseFirestore.instance
                            .collection("tempRegisters")
                            .doc(emailController.text)
                            .delete();
                      } else {
                        showToastText("Please Enter Correct OTP");
                      }
                    }
                    else {
                      otp = generateCode();
                          showToastText("OTP is Sent to our Email");
                          FirebaseFirestore.instance
                              .collection("tempRegisters")
                              .doc(emailController.text)
                              .set({"email": emailController.text, "opt": otp});
                          sendEmail(emailController.text, otp);
                        isSend = true;
                    }



                    setState(() {
                      isSend;
                      otp;
                      isTrue;
                    });
                  },
                ),
              ),
            ],
          ),

          if (isTrue)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                   EdgeInsets.symmetric(vertical: Size * 15, horizontal: Size * 15),
                  child: Text(
                    "Fill the Details",
                    style: creatorHeadingTextStyle,
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: TextFieldContainer(
                          child: TextFormField(
                            controller: firstNameController,
                            textInputAction: TextInputAction.next,
                            style: textFieldStyle(Size),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'First Name',
                                hintStyle: textFieldHintStyle(Size)),
                          )),
                    ),
                    Flexible(
                      child: TextFieldContainer(
                          child: TextFormField(
                            controller: lastNameController,
                            textInputAction: TextInputAction.next,
                            style: textFieldStyle(Size),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Last Name',
                              hintStyle: textFieldHintStyle(Size),
                            ),
                          )),
                    ),
                  ],
                ),

                TextFieldContainer(
                    child: TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      textInputAction: TextInputAction.next,
                      style: textFieldStyle(Size),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: textFieldHintStyle(Size)),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value != null && value.length < 6
                          ? "Enter min. 6 characters"
                          : null,
                    )),
                TextFieldContainer(
                    child: TextFormField(
                      obscureText: true,
                      controller: passwordController_X,
                      textInputAction: TextInputAction.next,
                      style: textFieldStyle(Size),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Conform Password',
                        hintStyle: textFieldHintStyle(Size),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value != null && value.length < 6
                          ? "Enter min. 6 characters"
                          : null,
                    )),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: Size * 15),
                    child:
                    Text('cancel ', style: TextStyle(fontSize: Size * 20)),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (passwordController.text.trim() ==
                        passwordController_X.text.trim()) {
                      if (firstNameController.text.isNotEmpty &&
                          lastNameController.text.isNotEmpty) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => Center(
                              child: CircularProgressIndicator(),
                            ));
                        try {
                          await FirebaseFirestore.instance
                              .collection("user")
                              .doc(emailController.text)
                              .set({
                            "id": emailController.text,
                            "name": "${firstNameController.text};${lastNameController.text}",

                          });
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                              email:
                              emailController.text.trim().toLowerCase(),
                              password: passwordController.text.trim());

                          NotificationService().showNotification(
                              title: "Welcome to eSRKR app!",
                              body: "Your Successfully Registered!");
                          // updateToken();
                          // newUser(emailController.text.trim().toLowerCase());
                        } on FirebaseException catch (e) {
                          print(e);
                          // Utils.showSnackBar(e.message);
                        }
                        Navigator.pop(context);
                        Navigator.pop(context);
                      } else {
                        showToastText("Fill All Details");
                      }
                    } else {
                      showToastText("Enter Same Password");
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: Size * 15),
                    child: Text(
                      'Sign up ',
                      style: TextStyle(fontSize: Size * 20),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> sendEmail(String mail, String otp) async {
    final smtpServer = gmail('esrkr.app@gmail.com', 'wndwwhhpifpgnanu');
    final message = Message()
      ..from = Address('esrkr.app@gmail.com')
      ..recipients.add(mail)
      ..subject = 'OTP for eSRKR App'
      ..text = 'Your Otp : $otp';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
    } catch (e) {
      print('Error sending email: $e');
    }
  }
}

