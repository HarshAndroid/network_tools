import 'package:flutter/material.dart';

import '../../main.dart';

//a special gradient card for showing ip, location
class IPCard extends StatelessWidget {
  const IPCard(
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
        width: double.maxFinite,
        height: mq.width * .2,
        margin: EdgeInsets.symmetric(horizontal: mq.width * .04),
        padding: EdgeInsets.only(left: mq.width * .04),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              color.withOpacity(.45),
              Colors.transparent,
              color.withOpacity(.45)
            ]),
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
                  Text(title, style: const TextStyle(color: Colors.white70)),

                  //for adding some space
                  const SizedBox(height: 4),

                  //value
                  Flexible(
                    child: Text(value,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
