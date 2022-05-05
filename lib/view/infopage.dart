import 'package:flutter/material.dart';
import 'package:schoolman/controller/global_controller.dart';
import 'package:schoolman/model/school.dart';
import 'package:schoolman/uitools/custom_button.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    School s = GlobalController.instance.school!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text(
          "School Info",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${s.schoolCode} - ${s.schoolName}"),
              Text("${s.regionCode} - ${s.orgName} - ${s.regionName}"),
              Text("Founded at: ${s.foundationDate}"),
              Text("${s.foundationType.name} School"),
              CustomButton(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Sign Out",
                      style: TextStyle(color: Colors.red),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
