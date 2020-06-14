import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:wyly/style/text_style.dart';

class ListHeaderDatetime extends StatelessWidget {
  final DateTime datetime;
  final double position;

  ListHeaderDatetime({
    @required this.datetime,
    @required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).cardColor.withOpacity(1 - position),
      ),
      height: 70,
      width: 70,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            DateFormat.Hm().format(datetime),
            style: subPlainTextStyle,
          ),
          Text(
            '${datetime.day} ${DateFormat.MMM().format(datetime)}',
            style: subPlainTextStyle,
          )
        ],
      ),
    );
  }
}
