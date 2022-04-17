import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hrms_app/main.dart';
import 'package:hrms_app/services/http_service.dart';
import 'package:hrms_app/widgets/appbar.dart';
import 'package:hrms_app/widgets/audio_player.dart';
import 'package:hrms_app/widgets/audio_recorder.dart';
import 'package:hrms_app/widgets/custom_button.dart';
import 'package:hrms_app/widgets/drawer.dart';
import 'package:hrms_app/widgets/timeline.dart';
import 'package:just_audio/just_audio.dart' as ap;

class SosTrackingPage extends StatefulWidget {
  var cameras;
  SosTrackingPage({Key? key, this.cameras}) : super(key: key);

  @override
  _SosTrackingPageState createState() => _SosTrackingPageState();
}

class _SosTrackingPageState extends State<SosTrackingPage> {
  bool showPlayer = false;
  ap.AudioSource? audioSource;
  late CameraController controller;
  XFile? pictureFile;
  late String _message;
  // ignore: prefer_typing_uninitialized_variables
  var filepath;
  // ignore: prefer_typing_uninitialized_variables
  var path;

  late List<Widget> timelineItems = [];
  late List<Widget> indicatorIcons = [];

  Future<void> updatedShowPlayyer(StateSetter updateState, value) async {
    updateState(() {
      showPlayer = value;
    });
  }

  Future<void> updateMessageState(StateSetter updateState, value) async {
    updateState(() {
      _message = value;
    });
  }

  Future<void> updatedPath(StateSetter updateState, value) async {
    updateState(() {
      path = value;
    });
  }

  // ignore: non_constant_identifier_names
  var sos_data = [
    {"id": 1, "type": "message", "content": "Hi", "date_time": "20-11-2022"},
    {
      "id": 1,
      "type": "message",
      "content": "I need",
      "date_time": "20-11-2022"
    },
    {"id": 1, "type": "message", "content": "help", "date_time": "20-11-2022"}
  ];

  @override
  void initState() {
    super.initState();
    showPlayer = false;
    List<Widget> temptimelineItems = [];
    List<Widget> tempindicatorIcons = [];

// Icon(Icons.access_alarm),
// Icon(Icons.accessibility_new),
// Icon(Icons.chat),
// Icon(Icons.photo),
// Icon(Icons.mic),

    for (var item in sos_data) {
      if (item['type'] == "message") {
        tempindicatorIcons.add(const Icon(Icons.photo));
        temptimelineItems.add(messageWidget(item['content'].toString()));
      }
    }

    setState(() {
      timelineItems = temptimelineItems;
      indicatorIcons = tempindicatorIcons;
    });

    controller = CameraController(
      widget.cameras![0],
      ResolutionPreset.max,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: headerNav("HELP"),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          emergencyHeader(),
          TimelineView(),
          inputButtons(context),
          markAsResolved(context)
        ],
      ),
    ));
  }

  SizedBox markAsResolved(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: CustomButton(
            onclickFunction: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyHomePage()));
            },
            text: "Mark as Resolved"));
  }

  Padding inputButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          chatButton(context),
          photoButton(context),
          audioButton(context),
          locationButton(context)
        ],
      ),
    );
  }

  Expanded TimelineView() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Timeline(
            children: timelineItems,
            indicators: indicatorIcons,
          ),
        ),
      ),
    );
  }

  Container emergencyHeader() {
    return Container(
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
    );
  }

  GestureDetector locationButton(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (context, state) {
                    return Container(height: 300, child: const Text("three"));
                  },
                );
              });
        },
        child: Container(
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
        ));
  }

  GestureDetector audioButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, state) {
                  return Container(
                    height: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: showPlayer
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: AudioPlayer(
                                    source: audioSource!,
                                    onDelete: () {
                                      updatedShowPlayyer(state, false);
                                    },
                                  ),
                                )
                              : AudioRecorder(
                                  onStop: (path) {
                                    print(
                                        "source ===============================");
                                    print(path);
                                    updatedPath(state, path);
                                    setState(() {
                                      audioSource =
                                          ap.AudioSource.uri(Uri.parse(path));
                                      showPlayer = true;
                                      filepath = path;
                                    });
                                    updatedShowPlayyer(state, true);
                                  },
                                ),
                        ),
                        Center(
                            child: showPlayer
                                ? ElevatedButton(
                                    onPressed: () {
                                      HttpService.submitAudio(
                                          context, filepath);
                                    },
                                    child: const Text("Send"))
                                : null)
                      ],
                    ),
                  );
                },
              );
            });
      },
      child: Container(
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
    );
  }

  photoButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return SafeArea(
                child: StatefulBuilder(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Container(
                          height: MediaQuery.of(context).size.height * 1,
                          child: Column(
                            children: [
                              Expanded(child: CameraPreview(controller)),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 120,
                                width: double.infinity,
                                child: IconButton(
                                    onPressed: () async {
                                      pictureFile =
                                          await controller.takePicture();

                                      HttpService.submitImage(
                                          context, pictureFile);
                                    },
                                    icon: const Icon(Icons.camera, size: 55)),
                              )
                            ],
                          )),
                    );
                  },
                ),
              );
            });
      },
      child: Container(
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
    );
  }

  GestureDetector chatButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, state) {
                  return Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Form(
                        child: Column(
                          children: [
                            const Center(
                                child: const Text("one",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: 'Calistoga'))),
                            TextFormField(
                              onChanged: (value) {
                                updateMessageState(state, value);
                              },
                            )
                          ],
                        ),
                      ));
                },
              );
            });
      },
      child: Container(
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
    );
  }

  ListTile voiceMessageWidget() {
    return ListTile(
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
    );
  }

  ListTile photoWidget() {
    return ListTile(
      subtitle: const Text("12:42 PM"),
      title: Container(
        alignment: Alignment.bottomLeft,
        color: Colors.transparent,
        child: const Icon(
          Icons.photo,
          size: 150,
        ),
      ),
    );
  }

  ListTile messageWidget(String message) {
    return ListTile(
      subtitle: const Text("12:40 PM"),
      title: Container(
        color: Colors.transparent,
        child: Text(message),
      ),
    );
  }
}
