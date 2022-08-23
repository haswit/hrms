import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hrms_app/services/http_service.dart';
import 'package:hrms_app/widgets/appbar.dart';
import 'package:hrms_app/widgets/custom_button.dart';
import 'package:hrms_app/widgets/drawer.dart';

class SubmitIncedent extends StatefulWidget {
  const SubmitIncedent({Key? key}) : super(key: key);

  @override
  _SubmitIncedentState createState() => _SubmitIncedentState();
}

class _SubmitIncedentState extends State<SubmitIncedent> {
  TextEditingController messageController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  late CameraController controller;
  XFile? pictureFile;
  bool captured = false;

  Future<void> updatedPath(StateSetter updateState, value, context) async {
    updateState(() {
      setState(() {
        captured = value;
      });
      print(value);
    });

    Navigator.pop(context);
  }

  captureImage() {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SafeArea(
            child: StatefulBuilder(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: SizedBox(
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
                                  pictureFile = await controller.takePicture();

                                  updatedPath(state, true, context);
                                  //HttpService.submitImage(context, pictureFile);
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
  }

  initCamera() async {
    await availableCameras().then(
      (value) {
        setState(() {
          controller = CameraController(
            value[0],
            ResolutionPreset.max,
          );
        });
        controller.initialize().then((_) {
          print("Controller  initializing");
          if (!mounted) {
            print("Controller not initialized");
            return;
          }
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40),
      child: Form(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: subjectController,
                    decoration: const InputDecoration(
                      prefix: null,
                      hintText: "Enter Subject",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    )),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: messageController,
                    minLines: 5,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      focusedBorder: InputBorder.none,
                      hintText: "Enter Message",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    )),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              child: captured == false
                  ? GestureDetector(
                      onTap: () {
                        captureImage();
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.camera,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text("Capture Image")
                            ],
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Image.file(File(pictureFile!.path)),
                        ),
                        FittedBox(
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  pictureFile = null;
                                  captured = false;
                                });
                                captureImage();
                              },
                              child: Row(
                                children: [
                                  const Icon(Icons.replay_outlined),
                                  const Text("Retake"),
                                ],
                              )),
                        )
                      ],
                    ),
            ),
            const SizedBox(
              height: 30,
            ),
            CustomButton(
                onclickFunction: () {
                  HttpService.submitIncedent(context, subjectController.text,
                      messageController.text, pictureFile);
                },
                text: "Submit")
          ],
        ),
      )),
    );
  }
}
