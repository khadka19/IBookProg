
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/CommonWidgets/custom_button.dart';
import 'package:petrolpump/Provider/all_provider_order.dart';
import 'package:petrolpump/Screens/CreatePage/attendence.dart';
import 'package:petrolpump/Utilities/utilities.dart';
import 'package:petrolpump/models/customer_model.dart';
import 'package:provider/provider.dart';

class RemarksForm extends StatefulWidget {
  const RemarksForm({super.key});
  @override
  State<RemarksForm> createState() => _RemarksFormState();
}

class _RemarksFormState extends State<RemarksForm> {
  double font10 = ScreenUtil().setSp(10);
  double font12 = ScreenUtil().setSp(12);
  double font13 = ScreenUtil().setSp(13);
  double font14 = ScreenUtil().setSp(14);
  double font15 = ScreenUtil().setSp(15);
  double font16 = ScreenUtil().setSp(16);
  double font17 = ScreenUtil().setSp(17);
  double paddingVerySmall = ScreenUtil().screenWidth * 0.025;
  double paddingSmall = ScreenUtil().screenWidth * 0.05;
  double paddingBig = ScreenUtil().screenWidth * 0.1;

  resetSelections() {
    // Reset selected customer, product, and product list here
    // Clear product list and any other necessary data
    context.read<ProductProviderO>().removeProductList();
    context.read<ProductProviderO>().clearSelection();
    context.read<DataRowProviderO>().clearDataRowSelection();
    context.read<CustomerProviderO>().clearSelection();
    context.read<ProductCompanyProviderO>().resetSelection();
  }

  //  GlobalKey<FormState> formkey=SelectedContentProduct()._formKey;
  final CustomerModel itemCustomer =
      CustomerModel(id: 0, address: '', ledgerName: '', panNo: '');

  void clearSelectedProduct() {}



  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final customerProvider = context.watch<CustomerProviderO>();
    // final companyProvider = context.watch<CompanyProvider>();

    return Padding(
        padding: EdgeInsets.all(paddingSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _feedbackController,
              maxLines: 4,
              decoration: const InputDecoration(
                  labelText: 'Enter your remarks or feedback...',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.kPrimaryColor))),
            ),
             SizedBox(height: 16.sp),
            CustomButtom(
                buttonColor: AppColors.kPrimaryColor,
                buttonText: 'Submit',
                elevation: 5,
                context: context,
                onPressed: () async {
                  try {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(child: CircularProgressIndicator());
                      },
                    );
                    var position =
                        LocationUtilitiies.currentPosition(context);
                  
                    position.then((value) async {
                      var response = await orderProvider.postOrderData(
                          customerProvider.cusId,
                          _feedbackController.text,
                          0,
                          value.latitude,
                          value.longitude);

                      Navigator.pop(context);

                      // ignore: use_build_context_synchronously
              
                      resetSelections();
                       
                    });
                  } catch (e) {
                    Utilities.showToastMessage(e.toString(), Colors.black);
                  }
                })
          ],
        ));
  }

  final TextEditingController _feedbackController = TextEditingController();

  
  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

 
}
