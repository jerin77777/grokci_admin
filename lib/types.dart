import 'dart:async';

import 'package:flutter/material.dart';

StreamController<String> router = StreamController<String>.broadcast();
StreamSink<String> get routerSink => router.sink;
Stream<String> get routerStream => router.stream;

StreamController<String> refresh = StreamController<String>.broadcast();
StreamSink<String> get refreshSink => refresh.sink;
Stream<String> get refreshStream => refresh.stream;

class Pallet {
  static Color primary = Color(0xFF30E287);
  static Color primary2 = Color(0xFF006D3C);
  // static Color background = Colors.white;
  static const Color background = Color(0xFFe3eaf2);
  static Color font1 = Colors.black;
  static Color font2 = Color(0xFF414942);
  static Color font3 = Color(0xFF999999);

  static Color inner1 = Color(0xFFeaefe9);
  static Color shadow = Color(0xFFeaefe9);
}
