import 'package:flutter/material.dart';
import 'package:oc_coding_challange/presentation/shared/components/avatar/avatar_image.dart';
import 'package:oc_coding_challange/presentation/shared/components/icons/gadient_icon.dart';
import 'package:oc_coding_challange/presentation/shared/elements/button/icon_button/icon_button.dart';
import 'package:oc_coding_challange/presentation/shared/style/colors.dart';
import 'package:oc_coding_challange/presentation/shared/style/gradients.dart';
import 'package:oc_coding_challange/presentation/shared/style/spacing.dart';

class HorizontalListLayout extends StatelessWidget {
  const HorizontalListLayout({
    Key? key,
    required this.tiles,
    this.leading,
    this.headerArgs,
  }) : super(key: key);

  final List<MediaTileM> tiles;
  final CharacterTile? leading;

  final HorizontalListLayoutHeaderArguments? headerArgs;

  static const double _headerHeight = 70;
  static const double _height = 255;

  @override
  Widget build(BuildContext context) {
    if (headerArgs != null) {
      return SizedBox(
        height: _height + _headerHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  const EdgeInsets.only(
                left: CustomSpaces.space2x,
              ),
              child: HorizontalListLayoutHeader(
                args: headerArgs!,
              ),
            ),
            const SizedBox(
              height: CustomSpaces.space2x,
            ),
            _generateHorizontalList(),
          ],
        ),
      );
    } else {
      return _generateHorizontalList();
    }
  }

  Widget _generateHorizontalList() {
    final List items = leading != null ? [leading!, ...tiles] : tiles;
    return SizedBox(
      height: _height,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(
            right: CustomSpaces.halfSpace,
            left: CustomSpaces.space2x,
          ),
          child: items[index],
        ),
      ),
    );
  }
}

class HorizontalListLayoutHeader extends StatelessWidget {
  const HorizontalListLayoutHeader({
    Key? key,
    required this.args,
  }) : super(key: key);

  final HorizontalListLayoutHeaderArguments args;

  static const double _buttonSize = 48;
  static const double _iconSize = 22;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (args.icon != null || args.imageUrl != null) _leading,
        if (args.icon != null || args.imageUrl != null)
          const SizedBox(
            width: CustomSpaces.space,
          ),
        CustomText.h3(
          args.text,
          color: args.light ? CustomColors.white : CustomColors.darkBlue,
        ),
      ],
    );
  }

  Widget get _leading => (args.icon != null)
      ? CustomIconButton(
          size: _buttonSize,
          icon: GradientIcon(
            gradient: Gradients.blueGradient,
            icon: args.icon!,
            size: _iconSize,
          ),
        )
      : AvatarImage(
          imageUrl: args.imageUrl!,
          size: _buttonSize,
          borderGradient: args.light ? null : Gradients.blueGradient,
        );
}



class HorizontalListLayoutHeaderArguments {
  HorizontalListLayoutHeaderArguments({
    required this.text,
    this.icon,
    this.imageUrl,
    this.light = false,
  });

  final IconData? icon;
  final String? imageUrl;
  final String text;
  final bool light;
}
