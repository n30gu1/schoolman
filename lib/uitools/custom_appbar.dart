import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final Widget? subView;
  const CustomAppBar({
    required this.title,
    this.trailing,
    required this.subView,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).viewPadding.top + 87,
          color: Colors.white,
        ),
        Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewPadding.top + 8,
              left: 16,
              right: 16),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  subView ?? Container(),
                  Text(
                    title,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Spacer(),
              () {
                if (trailing != null) {
                  return trailing!;
                } else {
                  return Container();
                }
              }()
            ],
          ),
        ),
      ],
    );
  }
}
