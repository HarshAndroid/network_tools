import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../helper/dialogs.dart';
import '../../../main.dart';
import '../../../models/ip_details.dart';
import '../../../widget/cards/ip_card.dart';

class IPTestScreen extends StatefulWidget {
  const IPTestScreen({super.key});

  @override
  State<IPTestScreen> createState() => _IPTestScreenState();
}

class _IPTestScreenState extends State<IPTestScreen> {
  IPDetails _ipDetails = IPDetails();

  @override
  void initState() {
    super.initState();

    _getIPDetails();
  }

  Future<void> _getIPDetails() async {
    try {
      final res = await get(Uri.parse('http://ip-api.com/json'));
      final data = jsonDecode(res.body);
      _ipDetails = IPDetails.fromJson(data);
      setState(() => _ipDetails);

      log('\n_getIPDetails: $data');
    } catch (e) {
      log('\n_getIPDetailsE: $e');
      Dialogs.showSnackbar(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: AppBar(title: const Text('IP Address Test')),

      //body
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        //background image
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.fill)),

        child: SingleChildScrollView(
          child: Column(
            children: [
              //for adding some space
              SizedBox(height: mq.height * .02),

              //ip address
              IPCard(
                  title: 'IP Address',
                  value: _ipDetails.query,
                  icon: const Icon(CupertinoIcons.location_solid,
                      color: Colors.white),
                  color: Colors.blue),

              //for adding some space
              SizedBox(height: mq.height * .015),

              //server
              IPCard(
                  title: 'Server',
                  value: _ipDetails.isp,
                  icon: const Icon(Icons.business, color: Colors.white),
                  color: Colors.yellow),

              //for adding some space
              SizedBox(height: mq.height * .015),

              //location
              IPCard(
                  title: 'Location',
                  value: _ipDetails.city.isEmpty
                      ? 'Fetching ...'
                      : '${_ipDetails.city}, ${_ipDetails.regionName}, ${_ipDetails.country},',
                  icon: const Icon(CupertinoIcons.location_solid,
                      color: Colors.white),
                  color: Colors.pink),

              //for adding some space
              SizedBox(height: mq.height * .015),

              //location
              IPCard(
                  title: 'Pin-code',
                  value: _ipDetails.zip,
                  icon: const Icon(CupertinoIcons.location_solid,
                      color: Colors.white),
                  color: Colors.purple),

              //for adding some space
              SizedBox(height: mq.height * .015),

              //location
              IPCard(
                  title: 'Timezone',
                  value: _ipDetails.timezone,
                  icon: const Icon(CupertinoIcons.location_solid,
                      color: Colors.white),
                  color: Colors.green),

              //get started button
              InkWell(
                onTap: () async {
                  Dialogs.showProgressBar(context);
                  await _getIPDetails().then((value) => Navigator.pop(context));
                },
                child: Container(
                  margin: EdgeInsets.only(top: mq.height * .15),
                  padding: EdgeInsets.symmetric(
                      horizontal: mq.width * .175, vertical: 14),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.cyan.withOpacity(.4),
                        Colors.transparent,
                        Colors.cyan.withOpacity(.4)
                      ]),
                      border: Border.all(color: Colors.cyan, width: 3),
                      borderRadius: BorderRadius.circular(50)),
                  child: const Text('Refresh',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
