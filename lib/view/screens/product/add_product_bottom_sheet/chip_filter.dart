import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_color.dart';
import 'package:flutter_prime/data/model/category/category_model.dart';

class ChipFilter extends StatelessWidget {
  final List<CategoryModel> categories;
  final Function(CategoryModel) onChipSelected;
  final String selectedCategory;

  ChipFilter({required this.categories, required this.onChipSelected, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(Dimensions.space5),
      child: Row(
        children: categories.skip(1).map((category) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.space5),
            child: FilterChip(
              backgroundColor: MyColor.greyColor,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: MyColor.colorWhite, style: BorderStyle.none,),
                borderRadius: BorderRadius.circular(Dimensions.space30),
              ),
              label: Text(category.title!),
              selected: category.title == selectedCategory,
              onSelected: (selected) {
                onChipSelected(selected ? category : CategoryModel(title: ''));
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
