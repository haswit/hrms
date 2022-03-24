import 'package:flutter/material.dart';

class Sos extends StatefulWidget {
  const Sos({Key? key}) : super(key: key);

  @override
  State<Sos> createState() => _SosState();
}

class _SosState extends State<Sos> with TickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 3),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.17),
      child: Center(
        child: Column(children: [
          Text(
            "Are you in Emergency?",
            style: TextStyle(
              color: Colors.red,
              fontFamily: 'Calistoga',
              fontSize: 35,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Press the button to report the incident, \nwe'll reach you soon",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 100,
          ),
          Container(
            height: 200,
            width: 200,
            child: Stack(children: [
              Container(
                height: 200,
                width: 200,
                child: AnimatedBuilder(
                  animation: CurvedAnimation(
                      parent: _controller, curve: Curves.easeInCubic),
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        _buildContainer(150 * 1),
                        _buildContainer(200 * _controller.value),
                        _buildContainer(250 * _controller.value),
                        _buildContainer(300 * _controller.value),
                        _buildContainer(350 * _controller.value),
                        Align(
                            child: Text(
                          "",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(35),
                child: ElevatedButton(
                  child: const Text(
                    'HELP ME!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    fixedSize: const Size(200, 200),
                    shape: const CircleBorder(),
                  ),
                ),
              )
            ]),
          )
        ]),
      ),
    );
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            Color.fromARGB(139, 244, 67, 54).withOpacity(1 - _controller.value),
      ),
    );
  }
}
