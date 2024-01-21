import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/Screens/CreatePage/Sales/remarks.dart';
import 'package:petrolpump/Provider/all_provider.dart';
import 'package:provider/provider.dart';

class SelectedContentProductList extends StatefulWidget {
  const SelectedContentProductList({super.key});

  @override
  State<SelectedContentProductList> createState() =>
      _SelectedContentProductListState();
}

class _SelectedContentProductListState
    extends State<SelectedContentProductList> {
  List<DataRow> dataRows = []; // List to hold the data rows
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    final itemProvider = context.watch<ProductProvider>();
    final dataRowProvider = context.watch<DataRowProvider>();
    final dataRows = dataRowProvider.dataRows;
    return itemProvider.productList.isNotEmpty
        ? Padding(
            padding:  EdgeInsets.only(top: 10.sp),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  width: screenWidth * 0.26,
                                  child: Text(
                                    "Product Name",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  )),
                              SizedBox(
                                  width: screenWidth * 0.1,
                                  child: Text(
                                    "Unit",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right,
                                  )),
                              SizedBox(
                                  width: screenWidth * 0.13,
                                  child: Text(
                                    "Rate",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right,
                                  )),
                              SizedBox(
                                  width: screenWidth * 0.13,
                                  child: Text(
                                    "Qty",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right,
                                  )),
                              SizedBox(
                                  width: screenWidth * 0.18,
                                  child: Text(
                                    "Amount",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right,
                                  ))
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
                                   key: Key("${itemProvider.productList[index].sn}_$index"),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      color: Colors.red,
                                      alignment: Alignment.centerRight,
                                      padding:  EdgeInsets.only(right: 16.sp),
                                      child:  Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 20.sp),
                                            child: const Text("Alert"),
                                          ),
                                          const Icon(Icons.delete,
                                              color: Colors.white),
                                        ],
                                      ),
                                    ),
                                    onDismissed: (direction) {
                                      setState(() {
                                        dataRowProvider.removeDataRow(
                                            context, dataRow, index);
                                      });
                                    },
                                    confirmDismiss: (direction) async {
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
                                                    width: screenWidth * 0.07,
                                                    child: cells[0].child,
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth * 0.26,
                                                    child: cells[1].child,
                                                  ),
                                                  SizedBox(
                                                      width: screenWidth * 0.1,
                                                      child: cells[2].child),
                                                  SizedBox(
                                                      width: screenWidth * 0.13,
                                                      child: cells[3].child),
                                                  SizedBox(
                                                      width: screenWidth * 0.13,
                                                      child: cells[4].child),
                                                  SizedBox(
                                                      width: screenWidth * 0.18,
                                                      child: cells[5].child),
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                Divider(
                                  
                                  thickness: 1,
                               color: Color.fromRGBO(238, 238, 238, 1),
                                )
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
                            Text(itemProvider.totalAmount.toStringAsFixed(2),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))
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
