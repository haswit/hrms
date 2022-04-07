import 'package:flutter/material.dart';
import 'package:hrms_app/main.dart';
import 'package:hrms_app/widgets/appbar.dart';
import 'package:hrms_app/widgets/custom_button.dart';
import 'package:hrms_app/widgets/drawer.dart';

class SosTrackingPage extends StatefulWidget {
  const SosTrackingPage({Key? key}) : super(key: key);

  @override
  _SosTrackingPageState createState() => _SosTrackingPageState();
}

class _SosTrackingPageState extends State<SosTrackingPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: headerNav(),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            width: double.infinity,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    "Emergency",
                    style: TextStyle(
                        color: Color.fromARGB(230, 255, 255, 255),
                        fontSize: 30,
                        fontFamily: 'Calistoga'),
                  ),
                  Text("Request sent!",
                      style: TextStyle(
                          color: Color.fromARGB(211, 255, 255, 255),
                          fontSize: 30,
                          fontFamily: 'Calistoga')),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Please stay calm!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Help will reachout to you soon",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                ]),
            height: 220,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromARGB(242, 248, 104, 37),
                Color.fromARGB(255, 248, 71, 59),
              ],
            )),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Timeline(
                  children: <Widget>[
                    ListTile(
                      subtitle: const Text("12:30 PM"),
                      title: Container(
                          child: const Text(
                              "You will receive a call from control room."),
                          color: Colors.transparent),
                    ),
                    ListTile(
                      subtitle: const Text("12:32 PM"),
                      title: Container(
                          child: const Text(
                              "Responder will reached you location shortly."),
                          color: Colors.transparent),
                    ),
                    ListTile(
                      subtitle: const Text("12:40 PM"),
                      title: Container(
                        color: Colors.transparent,
                        child: const Text("Alright!!"),
                      ),
                    ),
                    ListTile(
                      subtitle: const Text("12:42 PM"),
                      title: Container(
                        alignment: Alignment.bottomLeft,
                        color: Colors.transparent,
                        child: const Icon(
                          Icons.photo,
                          size: 150,
                        ),
                      ),
                    ),
                    ListTile(
                      subtitle: const Text("12:45 PM"),
                      title: Container(
                        color: Colors.transparent,
                        child: const ListTile(
                          leading: Icon(
                            Icons.mic,
                            color: Colors.black,
                          ),
                          trailing: Icon(Icons.play_arrow_rounded),
                          subtitle: Text("0:15 min"),
                          title: Text("Voice message sent"),
                        ),
                      ),
                    ),
                  ],
                  indicators: const <Widget>[
                    Icon(Icons.access_alarm),
                    Icon(Icons.accessibility_new),
                    Icon(Icons.chat),
                    Icon(Icons.photo),
                    Icon(Icons.mic),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  width: 60,
                  height: 60,
                  child: const Icon(
                    Icons.message,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  width: 60,
                  height: 60,
                  child: const Icon(
                    Icons.camera,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  width: 60,
                  height: 60,
                  child: const Icon(
                    Icons.mic,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  width: 60,
                  height: 60,
                  child: const Icon(
                    Icons.location_pin,
                    size: 30,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: CustomButton(
                  onclickFunction: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const MyHomePage()));
                  },
                  text: "Mark as Resolved"))
        ],
      ),
    ));
  }
}

class Timeline extends StatelessWidget {
  const Timeline({
    Key? key,
    required this.children,
    this.indicators,
    this.isLeftAligned = true,
    this.itemGap = 12.0,
    this.gutterSpacing = 4.0,
    this.padding = const EdgeInsets.all(8),
    this.controller,
    this.lineColor = Colors.grey,
    this.physics,
    this.shrinkWrap = true,
    this.primary = false,
    this.reverse = false,
    this.indicatorSize = 30.0,
    this.lineGap = 4.0,
    this.indicatorColor = Colors.blue,
    this.indicatorStyle = PaintingStyle.fill,
    this.strokeCap = StrokeCap.butt,
    this.strokeWidth = 2.0,
    this.style = PaintingStyle.stroke,
  })  : itemCount = children.length,
        assert(itemGap >= 0),
        assert(lineGap >= 0),
        assert(indicators == null || children.length == indicators.length),
        super(key: key);

  final List<Widget> children;
  final double itemGap;
  final double gutterSpacing;
  final List<Widget>? indicators;
  final bool isLeftAligned;
  final EdgeInsets padding;
  final ScrollController? controller;
  final int itemCount;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final bool primary;
  final bool reverse;

  final Color lineColor;
  final double lineGap;
  final double indicatorSize;
  final Color indicatorColor;
  final PaintingStyle indicatorStyle;
  final StrokeCap strokeCap;
  final double strokeWidth;
  final PaintingStyle style;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      separatorBuilder: (_, __) => SizedBox(height: itemGap),
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      controller: controller,
      reverse: reverse,
      primary: primary,
      itemBuilder: (context, index) {
        final child = children[index];
        final _indicators = indicators;

        Widget? indicator;
        if (_indicators != null) {
          indicator = _indicators[index];
        }

        final isFirst = index == 0;
        final isLast = index == itemCount - 1;

        final timelineTile = <Widget>[
          CustomPaint(
            foregroundPainter: _TimelinePainter(
              hideDefaultIndicator: indicator != null,
              lineColor: lineColor,
              indicatorColor: indicatorColor,
              indicatorSize: indicatorSize,
              indicatorStyle: indicatorStyle,
              isFirst: isFirst,
              isLast: isLast,
              lineGap: lineGap,
              strokeCap: strokeCap,
              strokeWidth: strokeWidth,
              style: style,
              itemGap: itemGap,
            ),
            child: SizedBox(
              height: double.infinity,
              width: indicatorSize,
              child: indicator,
            ),
          ),
          SizedBox(width: gutterSpacing),
          Expanded(child: child),
        ];

        return IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:
                isLeftAligned ? timelineTile : timelineTile.reversed.toList(),
          ),
        );
      },
    );
  }
}

class _TimelinePainter extends CustomPainter {
  _TimelinePainter({
    required this.hideDefaultIndicator,
    required this.indicatorColor,
    required this.indicatorStyle,
    required this.indicatorSize,
    required this.lineGap,
    required this.strokeCap,
    required this.strokeWidth,
    required this.style,
    required this.lineColor,
    required this.isFirst,
    required this.isLast,
    required this.itemGap,
  })  : linePaint = Paint()
          ..color = lineColor
          ..strokeCap = strokeCap
          ..strokeWidth = strokeWidth
          ..style = style,
        circlePaint = Paint()
          ..color = indicatorColor
          ..style = indicatorStyle;

  final bool hideDefaultIndicator;
  final Color indicatorColor;
  final PaintingStyle indicatorStyle;
  final double indicatorSize;
  final double lineGap;
  final StrokeCap strokeCap;
  final double strokeWidth;
  final PaintingStyle style;
  final Color lineColor;
  final Paint linePaint;
  final Paint circlePaint;
  final bool isFirst;
  final bool isLast;
  final double itemGap;

  @override
  void paint(Canvas canvas, Size size) {
    final indicatorRadius = indicatorSize / 2;
    final halfItemGap = itemGap / 2;
    final indicatorMargin = indicatorRadius + lineGap;

    final top = size.topLeft(Offset(indicatorRadius, 0.0 - halfItemGap));
    final centerTop = size.centerLeft(
      Offset(indicatorRadius, -indicatorMargin),
    );

    final bottom = size.bottomLeft(Offset(indicatorRadius, 0.0 + halfItemGap));
    final centerBottom = size.centerLeft(
      Offset(indicatorRadius, indicatorMargin),
    );

    if (!isFirst) canvas.drawLine(top, centerTop, linePaint);
    if (!isLast) canvas.drawLine(centerBottom, bottom, linePaint);

    if (!hideDefaultIndicator) {
      final Offset offsetCenter = size.centerLeft(Offset(indicatorRadius, 0));

      canvas.drawCircle(offsetCenter, indicatorRadius, circlePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
