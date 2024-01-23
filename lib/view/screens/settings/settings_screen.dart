import 'package:flutter/material.dart';
import 'package:flutter_prime/core/utils/dimensions.dart';
import 'package:flutter_prime/core/utils/my_strings.dart';
import 'package:flutter_prime/data/controller/settings/settings_controller.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:flutter_prime/view/components/card/custom_card.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    final controller = Get.put(SettingsController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
    controller.getVatActivationValue();
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: MyStrings.setting,
      ),
      body: GetBuilder<SettingsController>(
        builder: (controller) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.space5),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(Dimensions.space5),
                  child: CustomCard(
                    width: double.infinity,
                    onPressed: () {
                      if (controller.percentDiscount) {
                        controller.showVatCustomizeAleartDialogue(context);
                      }
                    },
                    isPress: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: Dimensions.space10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(MyStrings.vat + controller.cheakAmount),
                            Switch(
                              value: controller.vatSwitch,
                              onChanged: (value) {
                                controller.changevatCheckBox();
                                if (value) {
                                  controller.showVatCustomizeAleartDialogue(context);
                                }
                               // controller.saveVatDataToSharedPreference();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
