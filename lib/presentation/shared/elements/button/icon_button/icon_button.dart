import 'package:flutter/material.dart';
import 'package:oc_coding_challange/presentation/shared/style/colors.dart';

class CustomIconButton extends StatelessWidget {

  Widget? icon;
  double? size;

  CustomIconButton({Key? key, this.icon,this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: CustomColors.white,
        backgroundColor: CustomColors.darkBlue,
        shadowColor: CustomColors.lightBlue,
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0)),
        minimumSize: Size(size!,20),
      ),
      onPressed: () {},
      child: icon,
    );
  }
}
