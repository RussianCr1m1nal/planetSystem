import 'package:flutter/material.dart';
import 'package:planet_system/models/planet.dart';

class PlanetWidget extends StatefulWidget {
  final Planet planet;
  final Function deletePlanetCallBack;
  const PlanetWidget({Key? key, required this.planet, required this.deletePlanetCallBack}) : super(key: key);

  @override
  _PlanetWidgetState createState() => _PlanetWidgetState();
}

class _PlanetWidgetState extends State<PlanetWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: widget.planet.speed.toInt()));

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.translate(
          offset: Offset(0.0, widget.planet.distanceFromSun),
          child: GestureDetector(
            onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      backgroundColor: Colors.grey[700],
                      title: Text('Delete this planet?', style: TextStyle(color: Colors.blueGrey[100])),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel', style: TextStyle(color: Colors.blueGrey[200]))),
                        TextButton(
                            onPressed: () { 
                              widget.deletePlanetCallBack(widget.planet);                                        
                              Navigator.pop(context);             
                            },
                            child: Text('Delete', style: TextStyle(color: Colors.blueGrey[200])))
                      ],
                    )),
            child: Container(
              width: widget.planet.radius * 2,
              height: widget.planet.radius * 2,
              decoration: BoxDecoration(
                  color: widget.planet.color, shape: BoxShape.circle),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
