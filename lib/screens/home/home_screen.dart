import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helper/dialogs.dart';
import '../../helper/pref.dart';
import '../../main.dart';
import '../../widget/cards/home_card.dart';
import 'drawer/privacy_policy_screen.dart';
import 'drawer/terms_conditions_screen.dart';
import 'test/internet_speed_test_screen.dart';
import 'test/ip_test_screen.dart';
import 'test/sound_test_screen.dart';
import 'test/vehicle_speed_test_screen.dart';
import 'test/weather_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Pref.autoLogin = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      //app bar
      appBar: AppBar(
        toolbarHeight: mq.height * .1,
        title: const Text('   Network Tool'),
        actions: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            icon: const Icon(Icons.grid_view_rounded),
          )
        ],
      ),

      endDrawer: const _NavigationDrawer(),

      //body
      body: Container(
        alignment: Alignment.center,

        //background image
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.fill)),

        child: Wrap(
            spacing: mq.width * .05,
            runSpacing: mq.width * .04,
            children: [
              //internet speed test
              HomeCard(
                title: 'Internet\nSpeed Test',
                icon: const Icon(Icons.network_check_outlined,
                    color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const InternetSpeedTestScreen()));
                },
                color: Colors.green,
              ),

              //ip address test
              HomeCard(
                title: 'IP Address\nTest',
                icon: const Icon(Icons.network_locked_rounded,
                    color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const IPTestScreen()));
                },
                color: Colors.pink,
              ),

              //sound test
              HomeCard(
                title: 'Sound\nTest',
                icon: const Icon(Icons.headphones_rounded,
                    color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SoundTestScreen()));
                },
                color: Colors.purple,
              ),

              //vehicle speed test
              HomeCard(
                title: 'Vehicle\nSpeed Test',
                icon: const Icon(CupertinoIcons.speedometer,
                    color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const VehicleSpeedTestScreen()));
                },
                color: Colors.red,
              ),

              //map navigation
              HomeCard(
                title: 'Map\nNavigation',
                icon: const Icon(CupertinoIcons.location_fill,
                    color: Colors.white, size: 30),
                onPressed: () {
                  launch("geo:");
                },
                color: Colors.blue,
              ),

              //weather report
              HomeCard(
                title: 'Weather\nReport',
                icon: const Icon(Icons.cloud_rounded,
                    color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const WeatherScreen()));
                },
                color: Colors.yellow,
              ),
            ]),
      ),
    );
  }
}

//custom navigation drawer
class _NavigationDrawer extends StatefulWidget {
  const _NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<_NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<_NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: myColor.withOpacity(.8),
      child: ListView(padding: const EdgeInsets.only(top: 0), children: [
        //navigation header with company name & circular label
        DrawerHeader(
            // decoration: const BoxDecoration(
            //     gradient: LinearGradient(colors: [Colors.purple, Colors.blue])),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
              SizedBox(height: mq.height * .01),
              //profile image
              SizedBox(
                  height: mq.height * .09,
                  width: mq.height * .09,
                  child: Image.asset('assets/images/network.png')),

              //name
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text('Welcome to Network Tools',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              )
            ])),

        //horizontal line separator
        Divider(
            indent: mq.width * .04,
            endIndent: mq.width * .04,
            color: Colors.grey),

        //Member ship plans
        _NavItem(
            title: 'More Apps',
            icon: const Icon(Icons.local_grocery_store_rounded,
                color: Colors.pinkAccent, size: 26),
            onPressed: () {
              Dialogs.showSnackbar(context: context, msg: 'To be implemented');
            }),

        //Rate us
        _NavItem(
            title: 'Rate Us',
            icon: const Icon(CupertinoIcons.star_circle_fill,
                color: Colors.green, size: 26),
            onPressed: () {
              if (Platform.isAndroid || Platform.isIOS) {
                final appId =
                    Platform.isAndroid ? 'com.whatsapp' : 'YOUR_IOS_APP_ID';
                final url = Uri.parse(
                  Platform.isAndroid
                      ? "market://details?id=$appId"
                      : "https://apps.apple.com/app/id$appId",
                );
                launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                );
              }
            }),

        //Privacy Policy
        _NavItem(
            title: 'Privacy Policy',
            icon: Icon(CupertinoIcons.doc_person_fill,
                color: Colors.yellow.shade800, size: 26),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const PrivacyPolicyScreen()));
            }),

        //Terms & Conditions
        _NavItem(
            title: 'Terms & Conditions',
            icon: const Icon(CupertinoIcons.doc_plaintext,
                color: Colors.blue, size: 26),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const TermsConditionsScreen()));
            }),
      ]),
    );
  }
}

//single item used in navigation drawer item
class _NavItem extends StatelessWidget {
  const _NavItem(
      {Key? key,
      required this.title,
      required this.icon,
      required this.onPressed})
      : super(key: key);

  final String title;
  final Icon icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(),
      child: Padding(
        padding: EdgeInsets.only(
            left: mq.width * .04,
            top: mq.height * .01,
            bottom: mq.width * .025),
        child: Row(
          children: [
            icon,
            Expanded(
              child: Text('    $title',
                  style: const TextStyle(
                      fontSize: 15, letterSpacing: 0.1, color: Colors.white)),
            ),
            const Icon(CupertinoIcons.forward, color: Colors.white),
            const SizedBox(width: 16)
          ],
        ),
      ),
    );
  }
}
