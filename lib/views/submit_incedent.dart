import 'package:flutter/material.dart';
import 'package:hrms_app/widgets/appbar.dart';
import 'package:hrms_app/widgets/custom_button.dart';
import 'package:hrms_app/widgets/drawer.dart';

class SubmitIncedent extends StatefulWidget {
  const SubmitIncedent({Key? key}) : super(key: key);

  @override
  _SubmitIncedentState createState() => _SubmitIncedentState();
}

class _SubmitIncedentState extends State<SubmitIncedent> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: headerNav("Submit Incedent"),
      drawer: MyDrawer(),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Form(
            child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                  decoration: const InputDecoration(
                prefix: Icon(Icons.question_mark),
                hintText: "Enter Subject",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              )),
              SizedBox(
                height: 30,
              ),
              TextField(
                  minLines: 5,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    focusedBorder: InputBorder.none, 
                    hintText: "Enter Message",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  )),
              SizedBox(
                height: 30,
              ),
              CustomButton(onclickFunction: () {}, text: "Submit")
            ],
          ),
        )),
      ),
    ));
  }
}
