import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../../../helper/dialogs.dart';
import '../../../helper/my_date_util.dart';
import '../../../helper/pref.dart';
import '../../../main.dart';
import '../../../models/forecast.dart';
import '../../../models/weather_data.dart';
import '../../../widget/cards/gradient_card.dart';
import '../../../widget/cards/ip_card.dart';
import '../../../widget/cards/weather_card.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  WeatherData _data = WeatherData(weather: [], main: Main(), wind: Wind());
  List<Forecast> _forecast = [];
  final _apiKey = '1c4291462f695ed4a355203bd3efa431';

  bool _isAllDataFetched = false;

  @override
  void initState() {
    super.initState();

    if (Pref.lat != 0 && Pref.long != 0) {
      _fetchWeatherData(Pref.lat, Pref.long)
          .then((value) => _getLocationWeather(false));
    } else {
      _getLocationWeather(true);
    }
  }

  //get url for image
  // String _getIcon(String name) => 'https://openweathermap.org/img/w/$name.png';

  //get url with lat & long name
  Uri _getLatLongUrl(double lat, double long) => Uri.parse(
      'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=$_apiKey');

  Uri _get7DayData(double lat, double long) => Uri.parse(
      'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$long&exclude=hourly,minutely,current,alerts&appid=$_apiKey');

  //get url with city name
  // Uri _getCityUrl(String city) => Uri.parse(
  //     'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey');

  Future<void> _fetchWeatherData(double lat, double long) async {
    try {
      _isAllDataFetched = false;
      var res = await http.get(_getLatLongUrl(lat, long));
      var res1 = await http.get(_get7DayData(lat, long));
      // var response = await http.get(_getCityUrl('Mumbai'));
      var data = jsonDecode(res.body);
      var data1 = jsonDecode(res1.body);
      log('_fetchWeatherData: ${res.body}');
      log('\n_7DayData: ${res1.body}');
      setState(() {
        _data = WeatherData.fromJson(data);
        try {
          _forecast = List.from(data1['daily'])
              .map((e) => Forecast.fromJson(e))
              .toList();
        } catch (e) {
          log(e.toString());
        }

        _isAllDataFetched = true;
      });
    } catch (e) {
      log(e.toString());
      if (mounted) {
        setState(() {
          _isAllDataFetched = true;
        });
        Dialogs.showSnackbar(context: context);
      }
    }
  }

  //for getting current speed of user (handles permission related stuff's too)
  Future<void> _getLocationWeather(bool fetchData) async {
    try {
      //requesting to enable gps service & Requesting location permission
      await Geolocator.requestPermission().then((permission) async {
        switch (permission) {
          case LocationPermission.deniedForever:
          case LocationPermission.denied:
            SchedulerBinding.instance.addPostFrameCallback(
                (timeStamp) => _showLocationRequestDialog());
            break;

          default:
            await Geolocator.getCurrentPosition().then((position) async {
              log('\nLatitude: ${position.latitude}, Longitude: ${position.longitude}');
              Pref.lat = position.latitude;
              Pref.long = position.longitude;
              if (fetchData) {
                await _fetchWeatherData(position.latitude, position.longitude);
              }
            });
        }
      });
    } catch (e) {
      log('\n_getLocation: $e');
    }
  }

  _showLocationRequestDialog() {
    // set up the buttons
    Widget okButton = MaterialButton(
        color: Colors.blue,
        textColor: Colors.white,
        shape: const StadiumBorder(),
        onPressed: () async {
          Navigator.of(context).pop();
          Geolocator.openAppSettings();
        },
        child: const Text('OK', style: TextStyle(fontSize: 18)));

    // show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: myColor.withOpacity(.9),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            title: Row(
              children: const [
                Icon(Icons.location_history, color: Colors.redAccent, size: 30),
                Text("  GPS Permission\nRequired!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.white))
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [okButton],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: AppBar(title: const Text('Weather Report'), actions: [
        IconButton(
            padding: const EdgeInsets.only(right: 16),
            onPressed: () async {
              Dialogs.showProgressBar(context);
              await _getLocationWeather(true).then((value) {
                if (mounted) Navigator.pop(context);
              });
            },
            icon: const Icon(CupertinoIcons.refresh,
                color: Colors.white, size: 26))
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
          child: _data.weather.isEmpty

              //progress dialog
              ? _isAllDataFetched
                  ? const Center(
                      child: Text('Data Not Found!',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                    )
                  : const Center(
                      child: CircularProgressIndicator(strokeWidth: 2))

              //weather info
              : SingleChildScrollView(
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WeatherCard(data: _data),

                      //for adding some space
                      SizedBox(height: mq.height * .01),

                      //pressure & humidity
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //pressure
                          GradientCard(
                              title: 'Pressure',
                              value: '${_data.main.pressure} hPa',
                              icon: const Icon(Icons.air, color: Colors.white),
                              color: Colors.cyan),

                          //for adding some space
                          SizedBox(width: mq.width * .08),

                          //humidity
                          GradientCard(
                              title: 'Humidity',
                              value: '${_data.main.humidity} %',
                              icon: const Icon(Icons.dry_outlined,
                                  color: Colors.white),
                              color: Colors.green),
                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.only(
                            bottom: mq.height * .01, top: mq.height * .04),
                        child: const Text(
                          'Weather Forecast',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),

                      for (var i in _forecast)

                        //ip address
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: mq.height * .01),
                          child: IPCard(
                              title: MyDateUtil.getFormattedDate(
                                  context: context,
                                  date: DateTime.fromMillisecondsSinceEpoch(
                                      i.dt * 1000)),
                              value:
                                  'Min. ${i.temp.min.toStringAsFixed(0)}°C  -  Max. ${i.temp.max.toStringAsFixed(0)}°C',
                              icon: const Icon(CupertinoIcons.location_solid,
                                  color: Colors.white),
                              color: Colors.blue),
                        ),
                    ],
                  ),
                )),
    );
  }
}
