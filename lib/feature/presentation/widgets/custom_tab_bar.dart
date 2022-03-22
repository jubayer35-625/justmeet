
import 'package:flutter/material.dart';
import 'package:justmeet/feature/presentation/widgets/theme/style.dart';

class CustomTabBar extends StatelessWidget {
  final int index;

  const CustomTabBar({required Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(color: primaryColor),
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            child: const Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
          ),
          const Expanded(

            child: CustomTabBarButton(
             // index == 1 ? textIconColor : textIconColorGray
              text: "CHATS",
              textColor: Colors.grey,
             // index == 1 ? textIconColor : Colors.transparent
              borderColor: Colors.transparent, key: null,
            ),
          ),
          const Expanded(
            child: CustomTabBarButton(
              text: "STATUS",
              textColor: Colors.grey,
              borderColor: Colors.transparent, key: null,
            ),
          ),
          const Expanded(
            child: CustomTabBarButton(
              text: "CALLS",
              textColor: Colors.grey,
              borderColor: Colors.transparent, key: null,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTabBarButton extends StatelessWidget {
  final String text;
  final Color borderColor;
  final Color textColor;
  final double borderWidth;

  const CustomTabBarButton({
    required Key? key,
    required this.text,
    required this.borderColor,
    required this.textColor,
    this.borderWidth=3.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: borderColor, width: borderWidth),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}