import 'package:flutter/material.dart';

class ImageTile extends StatelessWidget {
  final String imagepath;
  final Function()? onTap;
  const ImageTile({super.key, required this.imagepath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 4),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Image.asset(
          imagepath,
          height: 25,
          ),
      ),
    );
  }
}