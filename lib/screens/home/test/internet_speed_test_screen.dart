import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_speed_test/internet_speed_test.dart';
import 'package:internet_speed_test/callbacks_enum.dart';
import 'package:network_tools/main.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../helper/dialogs.dart';
import '../../../widget/cards/gradient_card.dart';

class InternetSpeedTestScreen extends StatefulWidget {
  const InternetSpeedTestScreen({super.key});

  @override
  State<InternetSpeedTestScreen> createState() =>
      _InternetSpeedTestScreenState();
}

class _InternetSpeedTestScreenState extends State<InternetSpeedTestScreen> {
  final String _downloadServer = 'http://speedtest.tele2.net/1MB.zip',
      _uploadServer = 'http://speedtest.tele2.net/upload.php';

  final InternetSpeedTest _internetSpeedTest = InternetSpeedTest();
  double _downloadRate = 0, _uploadRate = 0, _displayRate = 0, _displayPer = 0;
  String _unitText = 'Mb/s';

  // Using a flag to prevent the user from interrupting running tests
  bool _isTesting = false;

  void protectGauge(double rate) {
    // this function prevents the needle from exceeding the maximum limit of the gauge
    if (rate < 100) _displayRate = rate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: AppBar(title: const Text('Internet Speed Test')),

      //body
      body: DecoratedBox(
        //background image
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.fill)),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //speed meter
            SfRadialGauge(
                title: const GaugeTitle(
                    text: ' ',
                    textStyle:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                axes: <RadialAxis>[
                  RadialAxis(
                      minimum: 0,
                      maximum: 101,
                      axisLabelStyle: const GaugeTextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                      ranges: [
                        GaugeRange(
                            startValue: 0,
                            endValue: 30,
                            gradient: const SweepGradient(
                                colors: [Colors.purple, Colors.blue]),
                            startWidth: 15,
                            endWidth: 15),
                        GaugeRange(
                            startValue: 30,
                            endValue: 70,
                            gradient: const SweepGradient(
                                colors: [Colors.blue, Colors.cyan]),
                            startWidth: 15,
                            endWidth: 15),
                        GaugeRange(
                            startValue: 70,
                            endValue: 101,
                            gradient: const SweepGradient(
                                colors: [Colors.cyan, Colors.green]),
                            startWidth: 15,
                            endWidth: 15),
                      ],
                      pointers: [
                        NeedlePointer(
                            value: _displayRate,
                            enableAnimation: true,
                            knobStyle: const KnobStyle(color: Colors.yellow),
                            gradient: const LinearGradient(
                                colors: [Colors.cyan, Colors.blue]))
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                            widget: Text(
                                '${_displayRate.toStringAsFixed(2)} $_unitText',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                            angle: 90,
                            positionFactor: 0.5)
                      ])
                ]),

            //download & upload speed
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //download card
                GradientCard(
                    title: 'Download',
                    value: '${_downloadRate.toStringAsFixed(1)} $_unitText',
                    icon: const Icon(CupertinoIcons.cloud_download,
                        color: Colors.white),
                    color: Colors.green),

                //for adding some space
                SizedBox(width: mq.width * .04),

                //upload card
                GradientCard(
                    title: 'Upload',
                    value: '${_uploadRate.toStringAsFixed(1)} $_unitText',
                    icon: const Icon(CupertinoIcons.cloud_upload,
                        color: Colors.white),
                    color: Colors.pink),
              ],
            ),

            //start test button
            InkWell(
              onTap: () => _speedTest(),
              child: Container(
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
                child: Text(
                    _isTesting
                        ? '${_displayPer.toStringAsFixed(2)} %'
                        : 'Start Test',
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //speed test function
  void _speedTest() {
    try {
      if (!_isTesting) {
        setState(() => _isTesting = true);

        _internetSpeedTest.startDownloadTesting(
            onDone: (double transferRate, SpeedUnit unit) {
              if (mounted) {
                setState(() {
                  _downloadRate = transferRate;
                  protectGauge(_downloadRate);
                  _unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
                  _displayPer = 100.0;
                });
              }
              _internetSpeedTest.startUploadTesting(
                onDone: (double transferRate, SpeedUnit unit) {
                  if (mounted) {
                    setState(() {
                      _uploadRate = transferRate;
                      _uploadRate = _uploadRate * 10;
                      protectGauge(_uploadRate);
                      _unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
                      _displayPer = 100.0;
                      _isTesting = false;
                    });
                  }
                },
                onProgress:
                    (double percent, double transferRate, SpeedUnit unit) {
                  if (mounted) {
                    setState(() {
                      _uploadRate = transferRate;
                      _uploadRate = _uploadRate * 10;
                      protectGauge(_uploadRate);
                      _unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
                      _displayPer = percent;
                    });
                  }
                },
                onError: (String errorMessage, String speedTestError) {
                  if (mounted) {
                    Dialogs.showSnackbar(
                        context: context,
                        msg:
                            'Upload test failed! Please check your internet connection.');
                    setState(() => _isTesting = false);
                  }
                },
                testServer: _uploadServer,
                fileSize: 20000000,
              );
            },
            onProgress: (double percent, double transferRate, SpeedUnit unit) {
              if (mounted) {
                setState(() {
                  _downloadRate = transferRate;
                  protectGauge(_downloadRate);
                  _unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
                  _displayPer = percent;
                });
              }
            },
            onError: (String errorMessage, String speedTestError) {
              if (mounted) {
                Dialogs.showSnackbar(
                    context: context,
                    msg:
                        'Download test failed! Please check your internet connection.');
                setState(() => _isTesting = false);
              }
            },
            testServer: _downloadServer);
      }
    } catch (e) {
      log('\nspeedTestE: $e');
    }
  }
}
