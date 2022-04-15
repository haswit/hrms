import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hrms_app/services/http_service.dart';
import 'package:hrms_app/widgets/appbar.dart';
import 'package:hrms_app/widgets/drawer.dart';
import 'package:hrms_app/widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Picture extends StatelessWidget {
  const Picture({this.pictureFile, this.session, Key? key}) : super(key: key);
  final String? session;
  final XFile? pictureFile;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final DateFormat formatterTime = DateFormat('Hm');

    final String formatted = formatter.format(now);
    final String _formatterTime = formatterTime.format(now);

    return SafeArea(
      child: Scaffold(
          appBar: headerNav("SUBMIT SESSION"),
          drawer: const MyDrawer(),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: 380,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Image.file(File(pictureFile!.path)),
                ),
                Center(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.22,
                          top: 20,
                          right: MediaQuery.of(context).size.width * 0.22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "SESSION:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 36),
                                child: Text(
                                  session!,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Date:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 70),
                                child: Text(
                                  formatted.toString(),
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Text(
                                "TIME:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 68),
                                child: Text(
                                  _formatterTime.toString(),
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: CustomButton(
                      onclickFunction: () {
                        HttpService.submitSession(context, session!,
                            _formatterTime, formatted, pictureFile);
                      },
                      text: "Submit"),
                )
              ],
            ),
          )),
    );
  }
}
