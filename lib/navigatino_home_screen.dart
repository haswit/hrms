// import 'package:hrms_app/app_theme.dart';
// import 'package:hrms_app/base.dart';
// import 'package:hrms_app/custom_drawer/drawer_user_controller.dart';
// import 'package:hrms_app/custom_drawer/home_drawer.dart';
// import 'package:hrms_app/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:hrms_app/settings.dart';
// import 'package:hrms_app/sos.dart';

// class NavigationHomeScreen extends StatefulWidget {
//   const NavigationHomeScreen({Key? key}) : super(key: key);

//   @override
//   _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
// }

// class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
//   Widget? screenView;
//   DrawerIndex? drawerIndex;

//   @override
//   void initState() {
//     drawerIndex = DrawerIndex.HOME;
//     screenView = const MyHomePage1();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppTheme.nearlyWhite,
//       child: SafeArea(
//         top: false,
//         bottom: false,
//         child: Scaffold(
//           backgroundColor: AppTheme.nearlyWhite,
//           body: DrawerUserController(
//             screenIndex: drawerIndex,
//             drawerWidth: MediaQuery.of(context).size.width * 0.75,
//             onDrawerCall: (DrawerIndex drawerIndexdata) {
//               changeIndex(drawerIndexdata);
//               //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
//             },
//             screenView: screenView,
//             //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
//           ),
//         ),
//       ),
//     );
//   }

//   void changeIndex(DrawerIndex drawerIndexdata) {
//     if (drawerIndex != drawerIndexdata) {
//       drawerIndex = drawerIndexdata;
//       switch (drawerIndex) {
//         case DrawerIndex.HOME:
//           setState(() {
//             screenView = MyHomePage1();
//           });
//           break;
//         case DrawerIndex.SOS:
//           setState(() {
//             screenView = Base(childWidget: Sos());
//           });
//           break;
//         case DrawerIndex.SETTINGS:
//           setState(() {
//             screenView = Base(childWidget: Settings());
//           });
//           break;

//         default:
//           break;
//       }
//     }
//   }
// }
