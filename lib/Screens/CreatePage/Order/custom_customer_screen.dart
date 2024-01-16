import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/API_Services/get_services_sales.dart';
import 'package:petrolpump/Provider/all_provider_order.dart';
import 'package:provider/provider.dart';

class SelectedContentCustomerO extends StatefulWidget {
  @override
  State<SelectedContentCustomerO> createState() =>
      _SelectedContentCustomerOState();
}

class _SelectedContentCustomerOState extends State<SelectedContentCustomerO> {
  MyService myService = MyService();
  @override
  Widget build(BuildContext context) {
    final customerProvider = context.watch<CustomerProviderO>();
    final id = customerProvider.cusId;

    return id != 0
        ? Padding(
            padding:  EdgeInsets.only(top: 10.sp),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      // side: BorderSide(color: AppColors.kPrimaryColor),
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
                              "Address",
                              style: TextStyle(
                                  fontSize: 15.sp, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Pan No :",
                              style: TextStyle(
                                  fontSize: 15.sp, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                         SizedBox(
                          height: 5.sp,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              customerProvider.address,
                              style: const TextStyle(color: Colors.black),
                            ),
                            Text(
                              customerProvider.panNo,
                              style: const TextStyle(color: Colors.black),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                 SizedBox(
                  height: 5.sp,
                ),
                 Divider(
                  thickness: 2.sp,
                  color: Colors.black45,
                  indent: 160.sp,
                  endIndent: 160.sp,
                ),
                 SizedBox(
                  height: 5.sp,
                )
              ],
            ),
          )
        : const SizedBox.shrink(); // Hide if no item is selected
  }
}
