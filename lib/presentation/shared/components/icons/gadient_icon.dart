import 'package:flutter/material.dart';

class GradientIcon extends StatelessWidget {
  Gradient? gradient;
  IconData? icon;
  double? size;
  GradientIcon({Key? key, this.gradient,this.icon,this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) => gradient!.createShader(bounds),
      child: Icon(
        icon!,
        size: size,
      ),
    );

  }
}
