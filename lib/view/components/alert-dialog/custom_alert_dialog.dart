import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';

class CustomAlertDialog {
  bool isHorizontalPadding;
  final Widget child;
  final List<TextButton> actions;

  CustomAlertDialog({
    this.isHorizontalPadding = false,
    required this.child,
    required this.actions,
  });

  void customAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.space40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            padding: isHorizontalPadding
                ? const EdgeInsets.symmetric(
                    horizontal: Dimensions.space15,
                    vertical: Dimensions.space12,
                  )
                : const EdgeInsets.symmetric(vertical: Dimensions.space15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: MyColor.colorWhite,
              borderRadius: BorderRadius.circular(Dimensions.space5),
            ),
            child: Column(
              children: [
                child,
                const SizedBox(height: Dimensions.space15), 
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
