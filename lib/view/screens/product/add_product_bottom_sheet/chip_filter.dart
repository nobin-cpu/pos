import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
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
      padding:const EdgeInsets.all(Dimensions.space8),
      child: Row(
        children: categories.skip(1).map((category) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal:Dimensions.space8),
            child: FilterChip(
              shape:RoundedRectangleBorder(
    side: BorderSide.none, 
    borderRadius: BorderRadius.circular(8.0),
  ) ,
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
