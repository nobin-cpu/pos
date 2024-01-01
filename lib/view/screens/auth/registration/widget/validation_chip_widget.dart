import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/core/utils/style.dart';


class ChipWidget extends StatelessWidget {

  final String name;
  final bool hasError;

  const ChipWidget({
       Key? key,
       required this.name,
       required this.hasError
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Chip(
          avatar: Icon(hasError?Icons.cancel:Icons.check_circle,color: hasError?Colors.red:Colors.green,size: 15,),
          shape: StadiumBorder(side: BorderSide(color: hasError?Colors.red:Colors.green,width: 1)),
          label: Text(
            name.tr,
            style: regularSmall.copyWith(
              fontSize: Dimensions.fontExtraSmall,
              color: hasError?Colors.red:Colors.green,
            ),
          ),
          backgroundColor: MyColor.getCardBgColor(),
        ),
        const SizedBox(width: 5,),
      ],
    );
  }
}