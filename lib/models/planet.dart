
import 'dart:convert';

import 'package:flutter/material.dart';

class Planet {
  late final double _radius;
  late final double _distanceFromSun;
  late final double _speed;
  late final Color _color;

  Planet(this._radius, this._distanceFromSun, this._speed, this._color);

  Planet.fromJson(String jsonString) {
    final planetData = jsonDecode(jsonString);

    _radius = planetData['radius'];
    _distanceFromSun = planetData['distanceFromSun'];
    _speed = planetData['speed'];
    _color = Color(planetData['color']);
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