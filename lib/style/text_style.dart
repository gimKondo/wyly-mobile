import 'package:flutter/material.dart';

const _titleFontSize = 60.0;
const _mainFontSize = 20.0;
const _subFontSize = 16.0;

final titleTextStyle = TextStyle(
  fontSize: _titleFontSize,
  fontWeight: FontWeight.w900,
  fontStyle: FontStyle.italic,
  color: Colors.brown,
);

final plainTextStyle = TextStyle(
  fontSize: _mainFontSize,
  fontWeight: FontWeight.w500,
  color: Colors.black,
);

final linkedPlainTextStyle = TextStyle(
  fontSize: _mainFontSize,
  fontWeight: FontWeight.w500,
  color: Colors.blueAccent,
);

final subPlainTextStyle = TextStyle(
  fontSize: _subFontSize,
  fontWeight: FontWeight.w400,
  color: Colors.black54,
);

final buttonTextStyle = TextStyle(
  fontSize: _mainFontSize,
  fontWeight: FontWeight.w800,
  color: Colors.white,
);
