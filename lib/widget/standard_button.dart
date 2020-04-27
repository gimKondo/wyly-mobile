import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class StandardButton extends StatelessWidget {
  final Function() onTap;
  final String text;
  final Color color;

  StandardButton({
    @required this.onTap,
    @required this.text,
    @required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 200,
      height: 50,
      child: RaisedButton(
        onPressed: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
        ),
        color: color,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
