import 'package:flutter/material.dart';

import '../../helper/dialogs.dart';
import '../../main.dart';
import 'home_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body
      body: Stack(children: [
        Positioned.fill(
            child:
                Image.asset('assets/images/background.png', fit: BoxFit.fill)),
        Positioned(
            top: mq.height * .15,
            right: mq.width * .1,
            width: mq.width * .8,
            child: Column(
              children: [
                //app logo
                Image.asset('assets/images/home_logo.png'),

                //for adding some space
                SizedBox(height: mq.height * .03),

                //welcome to label
                const Text('Welcome to',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500)),

                //for adding some space
                SizedBox(height: mq.height * .015),

                //network tools label
                const Text('CypherTools\nNetwork Analyzer',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w500)),
              ],
            )),

        //button
        Positioned(
            bottom: 0,
            width: mq.width * .8,
            left: mq.width * .1,
            child: Column(
              children: [
                Row(
                  children: [
                    //check box
                    SizedBox(
                      width: 35,
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(unselectedWidgetColor: Colors.blue),
                        child: Checkbox(
                          activeColor: Colors.white,
                          checkColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3)),
                          value: _isChecked,
                          onChanged: (value) {
                            setState(() => _isChecked = value ?? false);
                          },
                        ),
                      ),
                    ),

                    //agree text
                    Flexible(
                      child: RichText(
                          // textAlign: TextAlign.center,
                          text: const TextSpan(
                              style: TextStyle(
                                  letterSpacing: .5,
                                  fontWeight: FontWeight.w500),
                              children: [
                            TextSpan(text: 'By clicking you are Agreeing to'),
                            TextSpan(
                                text: ' Privacy Policy ',
                                style: TextStyle(color: Colors.blue)),
                            TextSpan(text: 'and'),
                            TextSpan(
                                text: ' Terms & Conditions',
                                style: TextStyle(color: Colors.blue))
                          ])),
                    ),
                  ],
                ),

                //get started button
                InkWell(
                  onTap: () {
                    if (_isChecked) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HomeScreen()));
                    } else {
                      Dialogs.showSnackbar(
                          context: context,
                          msg: 'Agree Privacy Policy and Terms & Conditions');
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: mq.height * .1, top: mq.height * .03),
                    padding: EdgeInsets.symmetric(
                        horizontal: mq.width * .175, vertical: 14),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.blue.withOpacity(.4),
                          Colors.transparent,
                          Colors.blue.withOpacity(.4)
                        ]),
                        border: Border.all(color: Colors.blue, width: 3),
                        borderRadius: BorderRadius.circular(50)),
                    child: const Text('Get Started',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ))
      ]),
    );
  }
}
