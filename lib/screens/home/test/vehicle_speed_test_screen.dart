import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../main.dart';
import '../../../widget/cards/ip_card.dart';

class VehicleSpeedTestScreen extends StatefulWidget {
  const VehicleSpeedTestScreen({super.key});

  @override
  State<VehicleSpeedTestScreen> createState() => _VehicleSpeedTestScreenState();
}

class _VehicleSpeedTestScreenState extends State<VehicleSpeedTestScreen> {
  // StreamSubscription<Position>? _locationStream;

  // double _speed = 0.0;

  // @override
  // void initState() {
  //   super.initState();
  //   _getVehicleSpeed();
  // }

  double _speed = 0, _maxSpeed = 0.0;

  @override
  void initState() {
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      _onAccelerate(event);
    });
    super.initState();
  }

  void _onAccelerate(UserAccelerometerEvent event) {
    double newVelocity =
        sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

    if ((newVelocity - _speed).abs() < 1) return;

    if (mounted) {
      setState(() {
        _speed = newVelocity;

        if (_speed > _maxSpeed) {
          _maxSpeed = _speed;
        }
      });
    }
  }

  //for getting current speed of user (handles permission related stuff's too)
  // _getVehicleSpeed() async {
  //   try {
  //     //requesting to enable gps service & Requesting location permission
  //     await Geolocator.requestPermission().then((permission) async {
  //       switch (permission) {
  //         case LocationPermission.deniedForever:
  //         case LocationPermission.denied:
  //           SchedulerBinding.instance.addPostFrameCallback(
  //               (timeStamp) => _showLocationRequestDialog());
  //           break;

  //         default:
  //           const LocationSettings locationSettings =
  //               LocationSettings(accuracy: LocationAccuracy.bestForNavigation);
  //           _locationStream =
  //               Geolocator.getPositionStream(locationSettings: locationSettings)
  //                   .listen((Position? position) {
  //             if (position != null) {
  //               // log('\nLatitude: ${position.latitude}, Longitude: ${position.speed * 3.6} km/hr');

  //               setState(() {
  //                 _speed = position.speed * 3.6;
  //               });
  //             }
  //           });
  //       }
  //     });
  //   } catch (e) {
  //     // log('\n_getVehicleSpeedE: $e');
  //   }
  // }

  // _showLocationRequestDialog() {
  //   // set up the buttons
  //   Widget okButton = MaterialButton(
  //       color: Colors.blue,
  //       textColor: Colors.white,
  //       shape: const StadiumBorder(),
  //       onPressed: () async {
  //         Navigator.of(context).pop();
  //         Geolocator.openAppSettings();
  //       },
  //       child: const Text('OK', style: TextStyle(fontSize: 18)));

  //   // show the dialog
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           backgroundColor: myColor.withOpacity(.9),
  //           shape: const RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(15))),
  //           title: Row(
  //             children: const [
  //               Icon(Icons.location_history, color: Colors.redAccent, size: 30),
  //               Text("  GPS Permission\nRequired!",
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.w500, color: Colors.white))
  //             ],
  //           ),
  //           actionsAlignment: MainAxisAlignment.center,
  //           actions: [okButton],
  //         );
  //       });
  // }

  @override
  dispose() {
    //for disposing location stream resources
    // _locationStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: AppBar(title: const Text('Vehicle Speed Test')),

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
                      maximum: 181,
                      axisLabelStyle: const GaugeTextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                      ranges: [
                        GaugeRange(
                            startValue: 0,
                            endValue: 55,
                            gradient: const SweepGradient(
                                colors: [Colors.cyan, Colors.green]),
                            startWidth: 15,
                            endWidth: 15),
                        GaugeRange(
                            startValue: 50,
                            endValue: 125,
                            gradient: const SweepGradient(
                                colors: [Colors.green, Colors.yellow]),
                            startWidth: 15,
                            endWidth: 15),
                        GaugeRange(
                            startValue: 125,
                            endValue: 181,
                            gradient: const SweepGradient(
                                colors: [Colors.yellow, Colors.red]),
                            startWidth: 15,
                            endWidth: 15),
                      ],
                      pointers: [
                        NeedlePointer(
                            value: _speed,
                            enableAnimation: true,
                            knobStyle: const KnobStyle(color: Colors.yellow),
                            gradient: const LinearGradient(
                                colors: [Colors.cyan, Colors.blue]))
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                            widget: Text('${_speed.toStringAsFixed(1)} Km/hr',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                            angle: 90,
                            positionFactor: 0.5)
                      ])
                ]),

            //for adding some space
            SizedBox(height: mq.height * .015),

            //max
            IPCard(
                title: 'Max. Speed',
                value: '${_maxSpeed.toStringAsFixed(1)} Km/hr',
                icon: const Icon(Icons.speed, color: Colors.white),
                color: Colors.green),
          ],
        ),
      ),
    );
  }
}
