import 'package:flutter/material.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/model/school.dart';
import 'package:schoolman/uitools/custom_button.dart';
import 'package:schoolman/uitools/custom_scaffold.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    School s = GlobalController.instance.school!;
    return CustomScaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text(
          "School Info",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${s.schoolCode} - ${s.schoolName}"),
              Text("${s.regionCode} - ${s.orgName} - ${s.regionName}"),
              Text("Founded at: ${s.foundationDate}"),
              Text("${s.foundationType.name} School"),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text("n30GUI alpha - Under Construction"),
              ),
              Spacer(),
              CustomButton(
                onTap: () {
                  GlobalController.instance.signOut();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Container(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "Sign Out",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),
                borderRadius: BorderRadius.circular(1000),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
