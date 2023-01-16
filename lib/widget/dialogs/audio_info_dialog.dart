import 'package:flutter/material.dart';

import '../../main.dart';

class AudioInfoDialog extends StatelessWidget {
  const AudioInfoDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: myColor.withOpacity(.8),
        contentPadding:
            const EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actionsAlignment: MainAxisAlignment.center,
        title:
            const Text('Instructions', style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: mq.width * .8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _richText(
                  title: '0dB', subTitle: 'Most people just hear a low noise'),
              _richText(title: '30~40dB', subTitle: 'It\'s the ideal calm'),
              _richText(title: '50~70dB', subTitle: 'Affects rest and sleep'),
              _richText(
                  title: '70~90dB', subTitle: 'Can affect learning and work'),
              _richText(
                  title: '90dB or More', subTitle: 'Very irritating & loud'),
              _richText(
                  title: '150dB',
                  subTitle:
                      'A sudden exposure to a sound environment of 150dB will break the eardrums. The audition will be completely lost.'),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.only(bottom: 16),

        // button
        actions: [
          MaterialButton(
            shape: const StadiumBorder(),
            color: Colors.blue,
            child: const Text('OK',
                style: TextStyle(color: Colors.white, fontSize: 16)),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ]);
  }

  Widget _richText({required String title, required String subTitle}) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: '$title : ',
          style: const TextStyle(fontWeight: FontWeight.w500)),
      TextSpan(text: '$subTitle\n'),
    ]));
  }
}
