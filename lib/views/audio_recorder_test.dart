// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:hrms_app/widgets/audio_player.dart';
// import 'package:hrms_app/widgets/audio_recorder.dart';
// import 'package:just_audio/just_audio.dart' as ap;
// import 'package:record/record.dart';

// class RecorderWidget extends StatefulWidget {
//   @override
//   _RecorderWidgetState createState() => _RecorderWidgetState();
// }

// class _RecorderWidgetState extends State<RecorderWidget> {
//   bool showPlayer = false;
//   ap.AudioSource? audioSource;

//   @override
//   void initState() {
//     showPlayer = false;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: showPlayer
//             ? Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 25),
//                 child: AudioPlayer(
//                   source: audioSource!,
//                   onDelete: () {
//                     setState(() => showPlayer = false);
//                   },
//                 ),
//               )
//             : AudioRecorder(
//                 onStop: (path) {
//                   setState(() {
//                     audioSource = ap.AudioSource.uri(Uri.parse(path));
//                     showPlayer = true;
//                   });
//                 },
//               ),
//       ),
//     );
//   }
// }
