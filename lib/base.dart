// import 'package:flutter/material.dart';
// import 'app_theme.dart';
// import 'appbar.dart';

// class Base extends StatefulWidget {
//   final childWidget;

//   const Base({Key? key, this.childWidget}) : super(key: key);

//   @override
//   State<Base> createState() => _BaseState(this.childWidget);
// }

// class _BaseState extends State<Base> with TickerProviderStateMixin {
//   final _widget;

//   _BaseState(this._widget);

//   AnimationController? animationController;
//   bool multiple = true;

//   @override
//   void initState() {
//     animationController = AnimationController(
//         duration: const Duration(milliseconds: 2000), vsync: this);

//     @override
//     dispose() {
//       animationController?.dispose();

//       super.dispose();
//     }

//     @override
//     Widget build(BuildContext context) {
//       return WillPopScope(
//           onWillPop: () async {
//             // You can do some work here.
//             showDialog(
//               context: context,
//               builder: (ctx) => AlertDialog(
//                 title: Text("Are you sure"),
//                 content: Text("you want to close the app"),
//                 actions: <Widget>[
//                   FlatButton(
//                     onPressed: () {
//                       Navigator.of(ctx).pop();
//                     },
//                     child: Text("okay"),
//                   ),
//                   FlatButton(
//                     onPressed: () {
//                       Navigator.of(ctx).pop();
//                     },
//                     child: Text("Cancel"),
//                   ),
//                 ],
//               ),
//             ); // Returning true allows the pop to happen, returning false prevents it.
//             return true;
//           },
//           child: Scaffold(
//               backgroundColor: AppTheme.white,
//               body: Padding(
//                   padding:
//                       EdgeInsets.only(top: MediaQuery.of(context).padding.top),
//                   child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[appBar(), _widget]))));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
// }
