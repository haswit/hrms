import 'package:flutter/material.dart';
import 'package:hrms_app/widgets/drawer.dart';
import '../widgets/appbar.dart';

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
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const MyDrawer(),
        appBar: headerNav(),
        body: Container(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.17),
          child: Center(
            child: Column(children: [
              const Text(
                "Are you in Emergency?",
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Calistoga',
                  fontSize: 35,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Press the button to report the incident, \nwe'll reach you soon",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 100,
              ),
              SizedBox(
                height: 200,
                width: 200,
                child: Stack(children: [
                  SizedBox(
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
                            const Align(
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
                    padding: const EdgeInsets.all(35),
                    child: ElevatedButton(
                      child: const Text(
                        'HELP ME!',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
        ),
      ),
    );
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color.fromARGB(139, 244, 67, 54)
            .withOpacity(1 - _controller.value),
      ),
    );
  }
}
