import 'package:flutter/material.dart';

import '../../main.dart';

//a single home card used in home screen
class HomeCard extends StatelessWidget {
  const HomeCard(
      {Key? key,
      required this.title,
      required this.icon,
      required this.onPressed,
      required this.color})
      : super(key: key);

  final String title;
  final Icon icon;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: mq.width * .4,
        height: mq.width * .4,
        decoration: BoxDecoration(
            gradient: RadialGradient(
                colors: [Colors.transparent, color.withOpacity(.45)]),
            border: Border.all(color: color, width: 3),
            borderRadius: BorderRadius.circular(30)),
        child: InkWell(
          onTap: () => onPressed(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //icon
              icon,

              //for adding some space
              SizedBox(height: mq.height * .01),

              //title
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500))
            ],
          ),
        ));
  }
}
