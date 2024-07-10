import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Kralicek extends StatelessWidget {
  final double height;
  final double padding;
  const Kralicek({super.key, required this.height, required this.padding});

  final String kralicekPath = 'assets/kralicek.svg';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      child: SvgPicture.asset(
        kralicekPath,
        height: height,
        semanticsLabel: 'Habbit\'s logo',
      ),
    );
  }
}
