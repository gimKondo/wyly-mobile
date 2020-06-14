import 'package:flutter/material.dart';

import 'package:wyly/style/color.dart';

const _titleFontSize = 60.0;
const _mainFontSize = 20.0;
const _subFontSize = 16.0;

final titleTextStyle = TextStyle(
  fontSize: _titleFontSize,
  fontWeight: FontWeight.w900,
  fontStyle: FontStyle.italic,
  color: primaryColor,
);

final plainTextStyle = TextStyle(
  fontSize: _mainFontSize,
  fontWeight: FontWeight.w500,
  color: plainTextColor,
);

final linkedPlainTextStyle = TextStyle(
  fontSize: _mainFontSize,
  fontWeight: FontWeight.w500,
  color: linkedTextColor,
);

final subPlainTextStyle = TextStyle(
  fontSize: _subFontSize,
  fontWeight: FontWeight.w400,
  color: subTextColor,
);

final buttonTextStyle = TextStyle(
  fontSize: _mainFontSize,
  fontWeight: FontWeight.w800,
  color: buttonTextColor,
);
