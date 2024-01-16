import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petrolpump/API_Services/get_services.dart';
import 'package:petrolpump/API_Services/post_services.dart';
import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/CommonWidgets/custom_button.dart';
import 'package:petrolpump/Screens/CreatePage/main_page.dart';
import 'package:petrolpump/Utilities/utilities.dart';
import 'package:petrolpump/models/PostModel/orderResponseList_model.dart';
import 'package:petrolpump/models/order_details.dart';

// ignore: must_be_immutable
class OrderDetails extends StatefulWidget {
  final List<OrderResponseDetails> dataList;

  final int selectedIndex;

  OrderDetails(
      {super.key, required this.dataList, required this.selectedIndex});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  static const fontFamily = "times new roman";
  OrderServices myServiceOrder = OrderServices();
  MyServiceDeleteOrder myServiceDeleteOrder = MyServiceDeleteOrder();
  late OrderResponseDetails data;
  List<OrderDetailsModelDetails> orderDetailsList = [];
  // ignore: prefer_typing_uninitialized_variables
  var svgImage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = widget.dataList[widget.selectedIndex];
    fetchData();
  }

  fetchData() {
    myServiceOrder.getOrderDetails(data.id).then((value) {
      setState(() {
        orderDetailsList = value;
      });
    });
  }

  checkImageStatus() {
    String? defaultValue;
    if (data.status == "Approved") {
      return svgImage = "assets/images/approved.svg";
    } else if (data.status == "Pending") {
      return svgImage = "assets/images/pending.svg";
    } else if (data.status == "Rejected") {
      return svgImage = "assets/images/rejected.svg";
    }
    return defaultValue ?? "";
  }

  checkElevatedButton() {
    String? nothing;
    if (data.status == "Pending") {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: CustomButtom(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: const Text("Delete"),
                    content: const Text(
                        "Are You sure you want to delete this item ?"),
                    actions: [
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("No"),
                      ),
                      MaterialButton(
                        onPressed: () async {
                          await FutureBuilder(
                            future: fetchDeleteOrder(),
                            builder: (BuildContext context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return Text("Error : ${snapshot.error}");
                              }
                              return Container();
                            },
                          );
                        
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainPage(
                                        initialIndex: 3,
                                      )));
                          // ignore: use_build_context_synchronously
                          Utilities.showSnackBar(
                              context, "SuccessFully Deleted !!!", true);
                        },
                        child: const Text("Yes"),
                      )
                    ],
                  );
                });
          },
          buttonColor: AppColors.warningColor,
          buttonText: 'Delete',
          context: context,
          elevation: 5,
        ),
      );
    } else {
      Container();
    }
    return nothing ?? Container();
  }

  fetchDeleteOrder() {
    myServiceDeleteOrder.postDeleteOrder(data.id).then((value) {
      setState(() {
        orderDetailsList = value as List<OrderDetailsModelDetails>;
      });
    });
  }

  getTotalQuantity() {
    double totalQuantity = 0;
    for (var orderDetails in orderDetailsList) {
      totalQuantity = totalQuantity + orderDetails.qty;
    }
    return totalQuantity;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(AntDesign.closecircle)),
          ],
          backgroundColor: AppColors.kPrimaryColor,
          elevation: 0,
          title: const Text(
            "Order Details",
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 15, 5, 5),
                  child: Card(
                    borderOnForeground: true,
                    elevation: 5,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset(
                            checkImageStatus(),
                            height: 60,
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    FontAwesome.calendar,
                                    size: 14,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    "Date :",
                                    style: TextStyle(
                                        fontFamily: fontFamily, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "${data.orderMiti}  ||  ${data.orderDate}",
                                    style: const TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    FontAwesome.reorder,
                                    size: 14,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    "Order :",
                                    style: TextStyle(
                                        fontFamily: fontFamily, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    data.orderNo.toString(),
                                    style: const TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    MaterialCommunityIcons.list_status,
                                    size: 14,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    "Status :",
                                    style: TextStyle(
                                        fontFamily: fontFamily, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    data.status.toString(),
                                    style: const TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Fontisto.person,
                                    size: 14,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    "Customer :",
                                    style: TextStyle(
                                        fontFamily: fontFamily, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: Text(
                                      data.customer.toString(),
                                      maxLines: 2,
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: fontFamily,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Feather.clock,
                                    size: 14,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    "Entered On :",
                                    style: TextStyle(
                                        fontFamily: fontFamily, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    data.enteredOn.toString(),
                                    style: const TextStyle(
                                        fontFamily: fontFamily,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Visibility(
                                visible: data.remarks.isNotEmpty,
                                child: const SizedBox(
                                  height: 10,
                                ),
                              ),
                              Visibility(
                                visible: data.remarks.isNotEmpty,
                                child: Row(
                                  children: [
                                    const Icon(
                                      MaterialCommunityIcons.email_newsletter,
                                      size: 14,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text(
                                      "Remarks :",
                                      style: TextStyle(
                                          fontFamily: fontFamily, fontSize: 14),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      data.remarks.toString(),
                                      style: const TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    MaterialCommunityIcons
                                        .arrow_right_bottom_bold,
                                    size: 14,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    "Entered By :",
                                    style: TextStyle(
                                        fontFamily: fontFamily, fontSize: 14),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    data.enteredBy.toString(),
                                    style: const TextStyle(
                                        color: AppColors.kPrimaryColor,
                                        fontFamily: fontFamily,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: orderDetailsList.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Text(
                          "Product  List",
                          style: GoogleFonts.akshar(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                            child: SizedBox(
                              width: double.maxFinite,
                              child: Column(
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      headingRowColor:
                                          MaterialStateColor.resolveWith(
                                        (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.hovered)) {
                                            // Color when the heading row is hovered
                                            return Colors.blue.withOpacity(0.3);
                                          }
                                          return Colors.blue; // Default color
                                        },
                                      ),
                                      dataRowHeight: 40.sp,
                                      headingRowHeight: 30.sp,
                                      dividerThickness: 1,
                                      columnSpacing: 10.sp,
                                      showCheckboxColumn: true,
                                      sortAscending: true,
                                      sortColumnIndex: 0,
                                      columns: [
                                        DataColumn(
                                            label: SizedBox(
                                                width: screenWidth * 0.08,
                                                child: Text(
                                                  'S.N',
                                                  style: GoogleFonts.acme(
                                                      color: Colors.white,
                                                      fontSize: 15),
                                                ))),
                                        DataColumn(
                                            label: SizedBox(
                                                width: screenWidth * 0.21,
                                                child: Text(
                                                  'Product',
                                                  style: GoogleFonts.acme(
                                                      color: Colors.white,
                                                      fontSize: 15),
                                                ))),
                                        DataColumn(
                                            label: SizedBox(
                                                width: screenWidth * 0.1,
                                                child: Text(
                                                  'Unit',
                                                  style: GoogleFonts.acme(
                                                      color: Colors.white,
                                                      fontSize: 15),
                                                  textAlign: TextAlign.right,
                                                ))),
                                        DataColumn(
                                            label: SizedBox(
                                                width: screenWidth * 0.14,
                                                child: Text(
                                                  'Quantity',
                                                  style: GoogleFonts.acme(
                                                      color: Colors.white,
                                                      fontSize: 15),
                                                  textAlign: TextAlign.right,
                                                ))),
                                      ],
                                      rows:
                                          orderDetailsList.map((orderDetails) {
                                        int index = orderDetailsList
                                                .indexOf(orderDetails) +
                                            1;
                                        return DataRow(cells: [
                                          DataCell(SizedBox(
                                              width: screenWidth * 0.08,
                                              child: Text(
                                                index.toString(),
                                                style: GoogleFonts.acme(
                                                    fontSize: 15),
                                              ))),
                                          DataCell(SizedBox(
                                              width: screenWidth * 0.21,
                                              child: SizedBox(
                                                  child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Text(
                                                  orderDetails.product,
                                                  style: GoogleFonts.acme(
                                                      fontSize: 15),
                                                ),
                                              )))),
                                          DataCell(SizedBox(
                                              width: screenWidth * 0.1,
                                              child: Text(
                                                orderDetails.unit,
                                                style: GoogleFonts.acme(
                                                    fontSize: 15),
                                                textAlign: TextAlign.right,
                                              ))),
                                          DataCell(SizedBox(
                                              width: screenWidth * 0.14,
                                              child: Text(
                                                orderDetails.qty
                                                    .toDouble()
                                                    .toString(),
                                                style: GoogleFonts.acme(
                                                    fontSize: 15),
                                                textAlign: TextAlign.right,
                                              ))),
                                        ]);
                                      }).toList(),
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 2,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    color: AppColors.alternativeColor,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 15, 0, 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Total Quantitty :",
                                            style: TextStyle(
                                                color: AppColors.kPrimaryColor,
                                                fontFamily: fontFamily,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            getTotalQuantity().toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                                fontFamily: fontFamily),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                checkElevatedButton()
              ],
            ),
          ),
        ));
  }
}
