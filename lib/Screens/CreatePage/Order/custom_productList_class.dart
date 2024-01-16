// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/Provider/all_provider_order.dart';
import 'package:petrolpump/Screens/CreatePage/Order/remarks_pdf.dart';
import 'package:provider/provider.dart';

class SelectedContentProductListO extends StatefulWidget {
  const SelectedContentProductListO({super.key});

  @override
  State<SelectedContentProductListO> createState() =>
      _SelectedContentProductListOState();
}

class _SelectedContentProductListOState
    extends State<SelectedContentProductListO> {
  List<DataRow> dataRows = []; // List to hold the data rows
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    final itemProvider = context.watch<ProductProviderO>();
    // final selectedItem = itemProvider3.selectedItemPro;
    final dataRowProvider = context.watch<DataRowProviderO>();
    final dataRows = dataRowProvider.dataRows;
    return itemProvider.productList.isNotEmpty
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
                  child: Column(
                    children: [
                      Container(
                        decoration:  BoxDecoration(
                            color: AppColors.kPrimaryColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.sp),
                                topRight: Radius.circular(5.sp))),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: screenWidth * 0.02,
                              horizontal: screenWidth * 0.02),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width: screenWidth * 0.07,
                                  child: Text(
                                    "S.N",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  )),
                              SizedBox(
                                  width: screenWidth * 0.3,
                                  child: Text(
                                    "Product Name",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  )),
                              SizedBox(
                                  width: screenWidth * 0.13,
                                  child: Text(
                                    "Unit",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right,
                                  )),
                             
                              SizedBox(
                                  width: screenWidth * 0.2,
                                  child: Text(
                                    "Quantity",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right,
                                  )),
                            
                            ],
                          ),
                        ),
                      ),
                      LimitedBox(
                        maxHeight: MediaQuery.of(context).size.height * 0.2,
                        child: ListView.builder(
                            padding: const EdgeInsets.all(0),
                            shrinkWrap: true,
                            itemCount: dataRows.length,
                            // itemExtent: 60,
                            itemBuilder: (context, index) {
                              final DataRow dataRow = dataRows[index];
                              final cells = dataRow.cells.toList();

                              return Column(
                                children: [
                                  Dismissible(
                                    key: Key(cells[0]
                                        .child
                                        .toString()), // Use a unique key for each item
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      color: Colors.red,
                                      alignment: Alignment.centerRight,
                                      padding:
                                           EdgeInsets.only(right: 16.sp),
                                      child:  Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 20.sp),
                                            child: const Text("Alert"),
                                          ),
                                          const Icon(Icons.delete,
                                              color: Colors.white),
                                        ],
                                      ),
                                    ),
                                    onDismissed: (direction) {
                                      // Remove the item from your dataRows and data source here
                                      setState(() {
                                        dataRowProvider.removeDataRow(
                                            context, dataRow, index);
                                      });
                                    },
                                    confirmDismiss: (direction) async {
                                      // Show a confirmation dialog before deleting
                                      return await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Delete Item"),
                                            content: const Text(
                                                "Are you sure you want to delete this item?"),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(true),
                                                child: const Text("Delete"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0.02),
                                          child: ListTile(
                                              contentPadding:
                                                  const EdgeInsets.all(0),
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        screenWidth * 0.07,
                                                    child: cells[0].child,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        screenWidth * 0.3,
                                                    child: cells[1].child,
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          screenWidth * 0.13,
                                                      child:
                                                          cells[2].child),
                                                 
                                                  SizedBox(
                                                      width: screenWidth *
                                                          0.2,
                                                      child:
                                                          cells[3].child),
                                                 
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                   Divider(
                                    indent: 10.sp,
                                    endIndent: 10.sp,
                                    thickness: 0.2.sp,
                                    color: Colors.black,
                                    height: 0, // You can customize the color
                                  ),
                                ],
                              );
                            }),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding:  EdgeInsets.fromLTRB(10.sp, 10.sp, 10.sp, 10.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Amount",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(itemProvider.totalQuantity.toStringAsFixed(2),
                                style: const TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                 SizedBox(
                  height: 10.sp,
                ),
                 Divider(
                  thickness: 2.sp,
                  color: Colors.black45,
                  indent: 160.sp,
                  endIndent: 160.sp,
                ),
                 SizedBox(
                  height: 5.sp,
                ),
                const RemarksForm()
              ],
            ),
          )
        : const SizedBox.shrink(); // Hide if no item is selected
  }
}
