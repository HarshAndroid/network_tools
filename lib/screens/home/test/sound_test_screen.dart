import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../main.dart';
import '../../../widget/dialogs/audio_info_dialog.dart';
import '../../../widget/cards/gradient_card.dart';

class SoundTestScreen extends StatefulWidget {
  const SoundTestScreen({super.key});

  @override
  State<SoundTestScreen> createState() => _SoundTestScreenState();
}

class _SoundTestScreenState extends State<SoundTestScreen> {
  bool _isRecording = false;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  late NoiseMeter _noiseMeter;
  double maxDB = 0, meanDB = 0, maxVal = 0;
  List<_ChartData> chartData = <_ChartData>[];
  late int previousMillis;

  @override
  void initState() {
    super.initState();
    _noiseMeter = NoiseMeter(_onError);
  }

  void _onData(NoiseReading noiseReading) {
    if (mounted) {
      setState(() {
        if (!_isRecording) _isRecording = true;
      });
    }

    if (noiseReading.maxDecibel > maxVal) maxVal = noiseReading.maxDecibel;
    maxDB = noiseReading.maxDecibel;
    meanDB = noiseReading.meanDecibel;

    chartData.add(_ChartData(
        maxDB,
        meanDB,
        ((DateTime.now().millisecondsSinceEpoch - previousMillis) / 1000)
            .toDouble()));
  }

  void _onError(Object e) {
    log(e.toString());
    _isRecording = false;
  }

  void start() async {
    previousMillis = DateTime.now().millisecondsSinceEpoch;
    try {
      _noiseSubscription = _noiseMeter.noiseStream.listen(_onData);
    } catch (e) {
      log(e.toString());
    }
  }

  void _stop() async {
    try {
      _noiseSubscription!.cancel();
      _noiseSubscription = null;

      setState(() => _isRecording = false);
    } catch (e) {
      log('stopRecorder error: $e');
    }
    previousMillis = 0;
    chartData.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (chartData.length >= 25) {
      chartData.removeAt(0);
    }
    return Scaffold(
      //app bar
      appBar: AppBar(title: const Text('Sound Test'), actions: [
        IconButton(
            padding: const EdgeInsets.only(right: 16),
            onPressed: () {
              showDialog(
                  context: context, builder: (_) => const AudioInfoDialog());
            },
            icon: const Icon(Icons.info_outline, color: Colors.white, size: 26))
      ]),

      //body
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,

        //background image
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.fill)),

        child: Column(
          children: [
            //for adding some space
            SizedBox(height: mq.height * .05),

            //graph or chart
            SfCartesianChart(
              primaryXAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  labelStyle: const TextStyle(fontSize: 0)),
              primaryYAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  labelStyle: const TextStyle(fontSize: 0)),
              margin: EdgeInsets.symmetric(horizontal: mq.width * .04),

              //line
              series: <LineSeries<_ChartData, double>>[
                LineSeries<_ChartData, double>(
                    dataSource: chartData,
                    width: 3,
                    xValueMapper: (_ChartData value, _) => value.frames,
                    yValueMapper: (_ChartData value, _) => value.maxDB,
                    animationDuration: 0),
              ],
            ),

            //for adding some space
            SizedBox(height: mq.height * .05),

            //Max & mean dB
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //max dB
                GradientCard(
                    title: 'Max.',
                    value: '${maxVal.toStringAsFixed(1)} dB',
                    icon: const Icon(Icons.volume_up_rounded,
                        color: Colors.white),
                    color: Colors.red),

                //for adding some space
                SizedBox(width: mq.width * .04),

                //mean dB
                GradientCard(
                    title: 'Mean',
                    value: '${meanDB.toStringAsFixed(1)} dB',
                    icon: const Icon(Icons.volume_down, color: Colors.white),
                    color: Colors.green),
              ],
            ),

            //start test button
            InkWell(
              onTap: _isRecording ? _stop : start,
              child: Container(
                margin: EdgeInsets.only(top: mq.height * .1),
                padding: EdgeInsets.symmetric(
                    horizontal: mq.width * .175, vertical: 14),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      _isRecording
                          ? Colors.red.withOpacity(.4)
                          : Colors.blue.withOpacity(.4),
                      Colors.transparent,
                      _isRecording
                          ? Colors.red.withOpacity(.4)
                          : Colors.blue.withOpacity(.4),
                    ]),
                    border: Border.all(
                        color: _isRecording ? Colors.red : Colors.blue,
                        width: 2),
                    borderRadius: BorderRadius.circular(50)),
                child: Text(_isRecording ? 'Stop Test' : 'Start Test',
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  final double? maxDB;
  final double? meanDB;
  final double frames;

  _ChartData(this.maxDB, this.meanDB, this.frames);
}
