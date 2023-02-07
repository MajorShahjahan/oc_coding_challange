import 'package:flutter/material.dart';
import 'package:oc_coding_challange/presentation/shared/style/colors.dart';

class Gradients{

  static const blueGradient = LinearGradient(
      colors: [
        CustomColors.darkBlue,
        CustomColors.lightBlue,
        CustomColors.blueAccent,
        CustomColors.white
      ],
    begin: Alignment(-0.7,12),
    end: Alignment(1,-2),
  );
}