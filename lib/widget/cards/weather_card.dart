import 'package:flutter/material.dart';

import '../../helper/my_date_util.dart';
import '../../main.dart';
import '../../models/weather_data.dart';

//a special weather card for showing weather details
class WeatherCard extends StatelessWidget {
  final WeatherData data;

  const WeatherCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF372986),
      elevation: 5,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.symmetric(
          horizontal: mq.width * .04, vertical: mq.height * .015),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: mq.width * .06, vertical: mq.height * .025),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                //city name
                Text(data.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),

                //for adding some space
                const SizedBox(height: 4),

                //date
                Text(
                    MyDateUtil.getFormattedDate(
                        context: context, date: DateTime.now()),
                    style: const TextStyle(color: Colors.white70)),

                //for adding some space
                const SizedBox(height: 20),

                //date
                Text('${data.main.temp.toStringAsFixed(0)} °C',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w500)),

                //for adding some space
                if (data.weather.isNotEmpty) const SizedBox(height: 20),

                //date
                if (data.weather.isNotEmpty)
                  Text(data.weather.first.main,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
              ],
            ),

            //for adding some space
            SizedBox(width: mq.width * .1),

            if (data.weather.isNotEmpty)
              Expanded(
                child: Image.asset(
                    'assets/images/${_getImageName(data.weather.first.main)}.png',
                    height: mq.height * .15),
              )
          ],
        ),
      ),
    );
  }

  String _getImageName(String weather) {
    switch (weather.toLowerCase()) {
      case 'clear':
        return 'sun';

      case 'thunderstorm':
        return 'storm';

      case 'drizzle':
        return 'drizzle';

      case 'rain':
        return 'rain';

      case 'snow':
        return 'snow';

      case 'clouds':
        return 'cloudy';

      default:
        return 'smoke';
    }
  }


  // String getMessage(int temp) {
  //   if (temp > 25) {
  //     return 'It\'s 🍦 time';
  //   } else if (temp > 20) {
  //     return 'Time for shorts and 👕';
  //   } else if (temp < 10) {
  //     return 'You\'ll need 🧣 and 🧤';
  //   } else {
  //     return 'Bring a 🧥 just in case';
  //   }
  // }
}
