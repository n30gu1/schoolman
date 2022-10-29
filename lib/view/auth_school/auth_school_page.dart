import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:schoolman/apitools/global_controller.dart';
import 'package:schoolman/generated/l10n.dart';
import 'package:schoolman/view/auth_school/auth_school_controller.dart';

class AuthorizeSchoolPage extends StatelessWidget {
  AuthorizeSchoolPage({Key? key}) : super(key: key);

  final c = Get.put(AuthorizeSchoolController());

  Widget _adminView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Admin: " + S.of(context).authorizeSchool,
          style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.5,),
        Text(S.of(context).authorizeSchoolInputNewCode),
        PlatformTextFormField(
          controller: c.adminSchoolCodeEditingController,
          textInputAction: TextInputAction.done,
          onEditingComplete: () {
            c.updateAuthCode();
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(S.of(context).authorizeSchool),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: c.obx(
          (state) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.of(context).authorizeSchool,
                  style: TextStyle(fontWeight: FontWeight.bold),
              textScaleFactor: 1.5,),
              PlatformTextFormField(
                controller: c.schoolCodeEditingController,
                textInputAction: TextInputAction.done,
                onEditingComplete: () {
                  c.authorizeSchool();
                },
              ),
              SizedBox(
                height: 16,
              ),
              FutureBuilder(
                future: Get.find<GlobalController>().validateAdmin(),
                builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data! as bool)
                    return _adminView(context);
                  else
                    return Container();
                } else {
                  return Container();
                }
              })
            ],
          ),
          onLoading: Center(
            child: PlatformCircularProgressIndicator(),
          ),
          onError: (e) => Center(
            child: Text(S.of(context).somethingWentWrong + e.toString()),
          ),
        ),
      ),
    );
  }
}
