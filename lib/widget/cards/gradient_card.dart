import 'package:flutter/material.dart';

import '../../main.dart';

//a special gradient card (used in internet speed screen, vehicle speed screen)
class GradientCard extends StatelessWidget {
  const GradientCard(
      {Key? key,
      required this.title,
      required this.value,
      required this.icon,
      required this.color})
      : super(key: key);

  final String title, value;
  final Icon icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: mq.width * .4,
        height: mq.width * .2,
        padding: EdgeInsets.only(left: mq.width * .04),
        decoration: BoxDecoration(
            gradient: RadialGradient(
                colors: [Colors.transparent, color.withOpacity(.45)]),
            border: Border.all(color: color, width: 3),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //icon
            icon,

            //for adding some space
            SizedBox(width: mq.width * .04),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //title
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.w500)),

                  //value
                  Flexible(
                    child: Text(value,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
