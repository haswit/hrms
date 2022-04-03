// // ignore_for_file: deprecated_member_use

// import 'appbar.dart';
// import '../app_theme.dart';
// import 'package:flutter/material.dart';
// import 'home.dart';

// class MyHomePage1 extends StatefulWidget {
//   const MyHomePage1({Key? key}) : super(key: key);

//   @override
//   _MyHomePage1State createState() => _MyHomePage1State();
// }

// class _MyHomePage1State extends State<MyHomePage1>
//     with TickerProviderStateMixin {
//   AnimationController? animationController;
//   bool multiple = true;

//   @override
//   void initState() {
//     animationController = AnimationController(
//         duration: const Duration(milliseconds: 2000), vsync: this);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     animationController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         // You can do some work here.
//         showDialog(
//           context: context,
//           builder: (ctx) => AlertDialog(
//             title: Text("Are you sure"),
//             content: Text("you want to close the app"),
//             actions: <Widget>[
//               FlatButton(
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                 },
//                 child: Text("okay"),
//               ),
//               FlatButton(
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                 },
//                 child: Text("Cancel"),
//               ),
//             ],
//           ),
//         ); // Returning true allows the pop to happen, returning false prevents it.
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: AppTheme.white,
//         body: Padding(
//           padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               appBar(),
//               Expanded(
//                 child: Home(
//                   center_x: 37.4220656,
//                   center_y: 122.0862784,
//                   locationRadius: 200.0,
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
