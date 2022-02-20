import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:planet_system/main.dart';
import 'package:planet_system/models/planet.dart';
import 'package:flutter/services.dart';

class NewPlanetView extends StatefulWidget {
  final List<Planet> planets;

  const NewPlanetView({Key? key, required this.planets}) : super(key: key);

  @override
  State<NewPlanetView> createState() => _NewPlanetViewState();
}

class _NewPlanetViewState extends State<NewPlanetView> {
  final _radiusController = TextEditingController();
  final _distanceController = TextEditingController();
  final _speedController = TextEditingController();
  Color _color = Colors.red;

  final _textColor = Colors.blueGrey[200];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(backgroundColor: Colors.grey[900]),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _radiusTextField(),
          _distanceTextField(),
          _speedTextField(),
          _colorSelect(),
          ..._preview()
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _onSavePlanet,
          backgroundColor: Colors.grey[900],
          child: const Text('Save')),
    );
  }

  Widget _radiusTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextField(
        controller: _radiusController,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(color: _textColor),
        onChanged: (value) {
          setState(() {
            if ((double.tryParse(value) ?? 0) > sunRadius) {
              _radiusController.clear();
              _showSnackBar('Planet\'s radius can\'t be greater then Sun\'s');
            }
          });
        },
        decoration: InputDecoration(
          labelText: 'Radius',
          labelStyle: TextStyle(color: _textColor),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: (_textColor)!, width: 1.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: (_textColor)!, width: 1.0),
          ),
        ),
      ),
    );
  }

  Widget _distanceTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextField(
        controller: _distanceController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(color: _textColor),
        decoration: InputDecoration(
          labelText: 'Distance from the Sun',
          labelStyle: TextStyle(color: _textColor),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: (_textColor)!, width: 1.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: (_textColor)!, width: 1.0),
          ),
        ),
      ),
    );
  }

  Widget _speedTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextField(
        controller: _speedController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(color: _textColor),
        decoration: InputDecoration(
          labelText: 'Speed (sec per orbit)',
          labelStyle: TextStyle(color: _textColor),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: (_textColor)!, width: 1.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: (_textColor)!, width: 1.0),
          ),
        ),
      ),
    );
  }

  Widget _colorSelect() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextButton(
        child: Text(
          'Select color',
          style: TextStyle(color: Colors.blueGrey[100]),
        ),
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            backgroundColor: Colors.grey[700],
            content: ColorPicker(
                pickerColor: _color,
                onColorChanged: (color) {
                  setState(() {
                    _color = color;
                  });
                }),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'OK');
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.blueGrey[100]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _preview() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Text(
          'Prewiew: ',
          style: TextStyle(color: _textColor),
        ),
      ),
      Center(
        child: Container(
          width: _radiusController.text == ''
              ? 0
              : (double.tryParse(_radiusController.text) ?? 0) * 2,
          height: _radiusController.text == ''
              ? 0
              : (double.tryParse(_radiusController.text) ?? 0) * 2,
          decoration: BoxDecoration(
            color: _color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    ];
  }

  void _onSavePlanet() {

    final radius = double.tryParse(_radiusController.text);
    final distance = double.tryParse(_distanceController.text);
    final speed = double.tryParse(_speedController.text);

    if (radius == null || distance == null || speed == null) {
      _showSnackBar('All the fields need to be field');
      return;
    }

    if (_isCollidingWithSun(distance, radius)) {
      _showSnackBar(
          'Oops... Looks like your planet is going to collide with the Sun. Try adjusting the radius or distance from the Sun');
      return;
    }

    if (_isCollidingWithAnotherPlanet(distance, radius)) {
      _showSnackBar(
          'Oops... Looks like your planet is going to collide with another one. Try adjusting the radius or distance from the Sun');
      return;
    }

    Navigator.pop(context, Planet(radius, distance, speed, _color));
  }

  void _showSnackBar(String message) {
    SnackBar snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool _isCollidingWithSun(double distance, double radius) {
    return distance < sunRadius + radius;
  }

  bool _isCollidingWithAnotherPlanet(double distance, double radius) {
    for (Planet planet in widget.planets) {
      if ((distance - radius >= planet.distanceFromSun - planet.radius &&
              distance - radius <= planet.distanceFromSun + planet.radius) ||
          (distance + radius >= planet.distanceFromSun - planet.radius &&
              distance + radius <= planet.distanceFromSun + planet.radius)) {
        return true;
      }
    }

    return false;
  }
}
