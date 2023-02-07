import 'package:flutter/material.dart';

class AvatarImage extends StatelessWidget {

  String? imageUrl;
  double? size;
  Gradient? borderGradient;

  AvatarImage({Key? key, this.imageUrl, this.borderGradient, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  CircleAvatar(
      radius: size,
      backgroundImage:
      NetworkImage(imageUrl!),
      backgroundColor: Colors.transparent,
    );
  }
}
