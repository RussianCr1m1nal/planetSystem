
import 'dart:convert';

import 'package:flutter/material.dart';

class Planet {
  final double _radius;
  final double _distanceFromSun;
  final double _speed;
  final Color _color;

  Planet(this._radius, this._distanceFromSun, this._speed, this._color);

  Planet fromJson(String jsonString) {
    final planetData = jsonDecode(jsonString);

    return Planet(planetData['radius'], planetData['distanceFromSun'], planetData['speed'], Color(planetData['color']));
  }

  String toJson() {
    return jsonEncode(this, toEncodable: (Object? nonEncodable) {
      return nonEncodable is Color ? nonEncodable.value : UnsupportedError('Cannot convert to JSON: $nonEncodable');
    });
  }

  double get radius => _radius;
  double get distanceFromSun => _distanceFromSun;
  double get speed => _speed;
  Color get color => _color;
}