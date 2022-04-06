// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:hrms_app/services/http_service.dart';

// class MapScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           CustomGoogleMap(),
//           CustomHeader(),
//           DraggableScrollableSheet(
//             initialChildSize: 0.30,
//             minChildSize: 0.15,
//             builder: (BuildContext context, ScrollController scrollController) {
//               return SingleChildScrollView(
//                 controller: scrollController,
//                 child: CustomScrollViewContent(),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// Google Map in the background
// class CustomGoogleMap extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.blue[50],
//       child: Center(child: Text("Google Map here")),
//     );
//   }
// }

// /// Search text field plus the horizontally scrolling categories below the text field
// class CustomHeader extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         OutofRadiusMessage(
//           inLoginZone: false,
//         ),
//         CustomSearchContainer(),
//         CustomSearchCategories(),
//       ],
//     );
//   }
// }

// class OutofRadiusMessage extends StatelessWidget {
//   final bool inLoginZone;
//   OutofRadiusMessage({required this.inLoginZone});

//   @override
//   Widget build(BuildContext context) {
//     return Visibility(
//       visible: inLoginZone ? false : true,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 10),
//         padding: const EdgeInsets.all(5),
//         color: const Color.fromARGB(82, 244, 132, 3),
//         child: SingleChildScrollView(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Padding(
//                 padding: EdgeInsets.only(right: 8.0),
//                 child: Icon(Icons.info),
//               ),
//               Text(
//                 "warning".tr().toString(),
//                 style: const TextStyle(
//                   color: Color.fromARGB(255, 7, 7, 7),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CustomSearchContainer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(
//           16, 40, 16, 8), //adjust "40" according to the status bar size
//       child: Container(
//         height: 50,
//         decoration: BoxDecoration(
//             color: Colors.white, borderRadius: BorderRadius.circular(6)),
//         child: Row(
//           children: <Widget>[
//             CustomTextField(),
//             Icon(Icons.mic),
//             SizedBox(width: 16),
//             CustomUserAvatar(),
//             SizedBox(width: 16),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CustomTextField extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: TextFormField(
//         maxLines: 1,
//         decoration: InputDecoration(
//           contentPadding: const EdgeInsets.all(16),
//           hintText: "Search here",
//           border: InputBorder.none,
//         ),
//       ),
//     );
//   }
// }

// class CustomUserAvatar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 32,
//       width: 32,
//       decoration: BoxDecoration(
//           color: Colors.grey[500], borderRadius: BorderRadius.circular(16)),
//     );
//   }
// }

// class CustomSearchCategories extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: <Widget>[
//           SizedBox(width: 16),
//           CustomCategoryChip(Icons.fastfood, "Takeout"),
//           SizedBox(width: 12),
//           CustomCategoryChip(Icons.directions_bike, "Delivery"),
//           SizedBox(width: 12),
//           CustomCategoryChip(Icons.local_gas_station, "Gas"),
//           SizedBox(width: 12),
//           CustomCategoryChip(Icons.shopping_cart, "Groceries"),
//           SizedBox(width: 12),
//           CustomCategoryChip(Icons.local_pharmacy, "Pharmacies"),
//           SizedBox(width: 12),
//         ],
//       ),
//     );
//   }
// }

// class CustomCategoryChip extends StatelessWidget {
//   final IconData iconData;
//   final String title;

//   CustomCategoryChip(this.iconData, this.title);

//   @override
//   Widget build(BuildContext context) {
//     return Chip(
//       label: Row(
//         children: <Widget>[
//           Icon(iconData, size: 16),
//           SizedBox(width: 8),
//           Text(title)
//         ],
//       ),
//       backgroundColor: Colors.grey[50],
//     );
//   }
// }

// /// Content of the DraggableBottomSheet's child SingleChildScrollView
// class CustomScrollViewContent extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 12.0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//       margin: const EdgeInsets.all(0),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(24),
//         ),
//         child: CustomInnerContent(),
//       ),
//     );
//   }
// }

// class CustomInnerContent extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         SizedBox(height: 12),
//         CustomDraggingHandle(),
//         SizedBox(height: 16),
//         MySitesTitle(),
//         SizedBox(height: 16),
//         MySites(),
//         SizedBox(height: 24),
//         SessionList(),
//         SizedBox(height: 16),
//         TodaysSessionsListView(),
//         SizedBox(height: 24),
//       ],
//     );
//   }
// }

// class CustomDraggingHandle extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 5,
//       width: 30,
//       decoration: BoxDecoration(
//           color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
//     );
//   }
// }

// class MySitesTitle extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Text("My Sites", style: TextStyle(fontSize: 22, color: Colors.black45)),
//         SizedBox(width: 8),
//         Container(
//           height: 30,
//           width: 30,
//           child: Icon(Icons.map, size: 12, color: Colors.black54),
//           decoration: BoxDecoration(
//               color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
//         ),
//       ],
//     );
//   }
// }

// class MySites extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             CustomSiteChip(
//               title: "Site A",
//             ),
//             SizedBox(width: 12),
//             CustomSiteChip(
//               title: "Site B",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SessionList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16),
//       //only to left align the text
//       child: Row(
//         children: <Widget>[
//           Text("Today's sessions", style: TextStyle(fontSize: 14))
//         ],
//       ),
//     );
//   }
// }

// class TodaysSessionsListView extends StatefulWidget {
//   @override
//   State<TodaysSessionsListView> createState() => _TodaysSessionsListViewState();
// }

// class _TodaysSessionsListViewState extends State<TodaysSessionsListView> {
//   late List<Set<String>> SessionListData;
//   fetchData() {
//     var data = HttpService().getSessions();
//     setState(() {
//       SessionListData = data;
//     });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     fetchData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 500,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: ListView.builder(
//           scrollDirection: Axis.vertical,
//           itemCount: SessionListData.length,
//           itemBuilder: (context, index) {
//             return Container(
//               decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                       color: Color.fromARGB(96, 210, 217, 230),
//                       blurRadius: 2,
//                       spreadRadius: 2,
//                       offset: Offset.zero,
//                       blurStyle: BlurStyle.normal)
//                 ],
//                 border: Border(
//                   bottom:
//                       BorderSide(width: .2, color: Colors.lightBlue.shade900),
//                 ),
//               ),
//               child: ListTile(
//                 trailing: Icon(
//                   Icons.photo,
//                   color: Colors.blue,
//                 ),
//                 title: Text(SessionListData[index]["session"]),
//                 subtitle: Text(SessionListData[index]["date_time"]),
//                 leading: Container(
//                   margin: EdgeInsets.only(top: 5),
//                   decoration: BoxDecoration(
//                       color: SessionListData[index]['session'] == "IN"
//                           ? Colors.green
//                           : Colors.red,
//                       borderRadius: BorderRadius.circular(50)),
//                   width: 20,
//                   height: 20,
//                 ),
//               ),
//             );

//             {
//               return Center(child: CircularProgressIndicator());
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

// class CustomSiteChip extends StatelessWidget {
//   final String title;

//   CustomSiteChip({required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         height: 50,
//         width: 100,
//         decoration: BoxDecoration(
//           color: Colors.blue,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           children: [
//             IconButton(
//               color: Colors.white,
//               icon: Icon(Icons.pin_drop),
//               onPressed: () {},
//             ),
//             Text(
//               title,
//               style: TextStyle(color: Colors.white),
//             )
//           ],
//         ));
//   }
// }

// class CustomFeaturedItem extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text("Test"),
//     );
//   }
// }
