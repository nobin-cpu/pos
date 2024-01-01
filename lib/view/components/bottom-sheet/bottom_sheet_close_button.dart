import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';

class BottomSheetCloseButton extends StatelessWidget {
  const BottomSheetCloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 30, width: 30,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(Dimensions.space5),
        decoration:  BoxDecoration(color: MyColor.colorGrey.withOpacity(.1), shape: BoxShape.circle),
        child:const Center(child: Icon(Icons.clear, color: MyColor.colorBlack, size: 12)),
      ),
    );
  }
}
