import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart';
import '../helper/pref.dart';
import 'home/home_screen.dart';
import 'home/intro_screen.dart';

//splash screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    //open hive connection
    Pref.openBox();

    Future.delayed(const Duration(seconds: 2), () {
      //exit full-screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

      if (Pref.autoLogin) {
        //navigate to home screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        //navigate to intro screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const IntroScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    mq = MediaQuery.of(context).size;

    return Scaffold(
      //body
      body: Stack(children: [
        Positioned.fill(
            child:
                Image.asset('assets/images/background.png', fit: BoxFit.fill)),
        Positioned(
            top: mq.height * .3,
            right: mq.width * .25,
            width: mq.width * .5,
            child: Column(
              children: [
                //app logo
                Image.asset('assets/images/network.png',
                    height: mq.height * .15),

                //label
                const Text('\nNetwork Tools',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        letterSpacing: .5,
                        fontWeight: FontWeight.w500))
              ],
            )),
      ]),
    );
  }
}
