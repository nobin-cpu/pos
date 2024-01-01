import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/my_color.dart';

class BottomSheetBar extends StatelessWidget {
  const BottomSheetBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 5, width: 50,
        decoration: BoxDecoration(
            color: MyColor.colorGrey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15)
        ),
      ),
    );
  }
}
