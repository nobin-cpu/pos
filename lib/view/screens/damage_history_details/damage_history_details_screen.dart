import 'package:flutter/material.dart';
import 'package:flutter_prime/data/controller/damage_history_details/damage_history_details_controller.dart';
import 'package:flutter_prime/view/components/app-bar/custom_appbar.dart';
import 'package:get/get.dart';

class DamageHistoryDetailsScreen extends StatefulWidget {
  const DamageHistoryDetailsScreen({Key? key}) : super(key: key);

  @override
  State<DamageHistoryDetailsScreen> createState() => _DamageHistoryDetailsScreenState();
}

class _DamageHistoryDetailsScreenState extends State<DamageHistoryDetailsScreen> {
  final controller = Get.put(DamageHistoryDetailsController());

  @override
  void initState() {
    super.initState();
    
   int damageID = Get.arguments[0];
    print("thisd si damage id ${damageID}");
    controller.fetchDamageDetails(damageID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Damage history details"),
      body: GetBuilder<DamageHistoryDetailsController>(
        builder: (controller) {
          if (controller.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: controller.damageDetails.length,
              itemBuilder: (context, index) {
                final damageDetail = controller.damageDetails[index];
                return ListTile(
                  title: Text(damageDetail.productName),
                  subtitle: Text('Quantity: ${damageDetail.quantity}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
