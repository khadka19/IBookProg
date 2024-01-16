import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/Provider/all_provider_order.dart';
import 'package:provider/provider.dart';

class SelectedContentProductO extends StatefulWidget {
  const SelectedContentProductO({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectedContentProductO> createState() => _SelectedContentProductOState();
}
class _SelectedContentProductOState extends State<SelectedContentProductO> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  double? rate = 0.0;
  
  @override
  void dispose() {
    _quantityController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void updateAmount(String quantityInput) {
    try {
      double? quantity = double.parse(quantityInput);
      double? amount = quantity * rate!;
      _amountController.text = amount.toStringAsFixed(2);
    } catch (e) {
      _amountController.text = "";
    }
  }

  void updateQuantity(String amountInput) {
    try {
      double? amount = double.parse(amountInput);
      double? quantity = amount / rate!;
      _quantityController.text = quantity.toStringAsFixed(2);
    } catch (e) {
      _quantityController.text = "";
    }
  }

  void clearFields(BuildContext context) {
    _formKey.currentState!.reset(); // Reset the form
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProviderO>();
    final id = productProvider.proId;

    return id != 0
        ? Padding(
            padding:  EdgeInsets.only(top: 10.sp),
            child: Form(
              key: _formKey,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.sp)),
                shadowColor: AppColors.kPrimaryColor,
                elevation: 2,
                child: Padding(
                  padding:  EdgeInsets.all(10.0.sp),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text(
                            "Unit :",
                            style: TextStyle(
                                fontSize: 15.sp, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            productProvider.unit.toString(),
                            style:  TextStyle(fontSize: 15.sp),
                          )
                        ],
                      ),
                       SizedBox(
                        height: 7.sp,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          
                        
                        ],
                      ),
                       SizedBox(
                        height: 7.sp,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Quantity :",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: TextFormField(
                              textAlign: TextAlign.end,
                              controller: _quantityController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Enter Quantity',
                                  hintTextDirection: TextDirection.ltr),
                              onChanged: (value) {
                                double newQuantity = double.parse(value);
                                productProvider.updateQuantity(newQuantity);
                                _amountController.text =
                                    (newQuantity * rate!).toStringAsFixed(2);
                              },
                            ),
                          ),
                        ],
                      ),
                       SizedBox(
                        height: 7.sp,
                      ),
                     
                    ],
                  ),
                ),
              ),
            ),
          )
        : const SizedBox.shrink(); // Hide if no item is selected
  }
}