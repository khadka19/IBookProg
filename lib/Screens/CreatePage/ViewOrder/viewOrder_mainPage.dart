import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:petrolpump/API_Services/get_services.dart';
import 'package:petrolpump/API_Services/get_services_sales.dart';
import 'package:petrolpump/API_Services/post_services.dart';
import 'package:petrolpump/API_Services/role_control.dart';
import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/CommonWidgets/custom_button.dart';
import 'package:petrolpump/CommonWidgets/search_bar.dart';
import 'package:petrolpump/Provider/order_provider.dart';
import 'package:petrolpump/Screens/CreatePage/ViewOrder/order_details.dart';
import 'package:petrolpump/Screens/CreatePage/main_page.dart';
import 'package:petrolpump/models/PostModel/orderList_model.dart';
import 'package:petrolpump/models/PostModel/orderResponseList_model.dart';
import 'package:petrolpump/models/customer_model.dart';
import 'package:petrolpump/models/order_details.dart';
import 'package:provider/provider.dart';

class ViewOrder extends StatefulWidget {
  final String title;

  const ViewOrder({super.key, this.title = "Order"});

  @override
  State<ViewOrder> createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder> {
  RoleCheckServices roleControlServices=RoleCheckServices();
  bool isAuthorized=true;
  ValueNotifier<String> searchCusListner = ValueNotifier<String>('');
  OrderServices myServiceOrder = OrderServices();
  List<OrderDetailsModelDetails> orderDetailsList = [];

  late ViewOrderProvider viewOrderProvider;
  TextEditingController searchController = TextEditingController();
  TextEditingController searchControllerCus = TextEditingController();
  String search = '';
  String searchCus = '';

  //for view order
  MyServiceOrderList myServiceOrderList = MyServiceOrderList();
  List<OrderResponseDetails> dataList = [];
  OrderListModel model = OrderListModel(
      userId: null, customerId: null, dateFrom: '', dateTo: '', status: '');

// for getting customer
  MyService myService = MyService();
  List<CustomerModel> _customerList = [];
  CustomerModel _selectedCusModel =
      CustomerModel(id: 0, ledgerName: '', address: '', panNo: '');

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    checkRole();
    fetchData();
    myService.getCustomerName().then((value) async {
      setState(() {
        _customerList = value;
      });
    });
    viewOrderProvider = Provider.of<ViewOrderProvider>(context, listen: false);
  }

  void fetchData() {
    myServiceOrderList.postOrderList(model).then((orderData) {
      setState(() {
        dataList = orderData;
      });
    });
  }


void checkRole()async{
   bool apiResult = await roleControlServices.roleCheckViewOrder();
   if(apiResult==true){
    setState(() {
      isAuthorized=true;
    });
   }
   else {
     setState(() {
     isAuthorized=false;
   });
   }
}
  void apply() {
    final itemProviderCustomerVO =
        Provider.of<CustomerProviderVO>(context, listen: false);
    final itemProviderDateFrom =
        Provider.of<ViewOrderProvider>(context, listen: false);
    final itemProviderDateTo =
        Provider.of<ViewOrderProvider>(context, listen: false);

    // Update the model with selected values
    model.userId = null;
    model.customerId = null;
    if (itemProviderCustomerVO.cusId != null &&
        itemProviderCustomerVO.cusId != 0) {
      model.customerId = itemProviderCustomerVO.cusId;
    }
    model.dateFrom = itemProviderDateFrom.selectedDateFrom != null
        ? DateFormat('yyyy-MM-dd')
            .format(itemProviderDateFrom.selectedDateFrom!)
        : '';
        
    model.dateTo = itemProviderDateTo.selectedDateTo != null
        ? DateFormat('yyyy-MM-dd').format(itemProviderDateTo.selectedDateTo!)
        : '';
    model.status = '';
    if (viewOrderProvider.selectedStatus != "Select a Status") {
      model.status = (viewOrderProvider.selectedStatus ?? "");
    }

    // Filter data based on individual criteria

    fetchData();
  }

  

  @override
  Widget build(BuildContext context) {
    print("Widget is being rebuilt");
    Color _getStatusColor(String status) {
      switch (status) {
        case 'Pending':
          return Colors.orange;
        case 'Approved':
          return Colors.green;
        case 'Rejected':
          return Colors.red;
        default:
          return Colors.grey; // or any default color
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimaryColor,
        elevation: 0,
        title: Text(widget.title),
        centerTitle: true,
        leading: DrawerWidget(),
        actions: [
          Padding(
            padding:  EdgeInsets.only(right: 5.sp),
            child: IconButton(
                onPressed: () {
                  modalButtonSheet();
                },
                icon: const Icon(Feather.filter)),
          )
        ],
      ),
      body:isAuthorized? SizedBox(
        height: double.maxFinite,
        child: dataList.isEmpty
            ? _buildLoadingWidget()
            : ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (BuildContext context, int index) {
                  OrderResponseDetails data = dataList[index];
                  return Padding(
                    padding:  EdgeInsets.all(10.0.sp),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext contex) {
                              return Dialog(
                                child: FractionallySizedBox(
                                  widthFactor: 1,
                                  child: OrderDetails(
                                      dataList: dataList, selectedIndex: index),
                                ),
                              );
                            });
                      },
                      child: Card(
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.alternativeColor,
                            border: Border.all(color: Colors.white, width: 1.5.sp),
                          ),
                          child: Padding(
                            padding:  EdgeInsets.all(8.0.sp),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                         Icon(
                                          Icons.calendar_month,
                                          size: 14.sp,
                                        ),
                                         SizedBox(
                                          width: 4.sp,
                                        ),
                                        Text(
                                          data.orderMiti,
                                          style:  TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.black),
                                        ),
                                         SizedBox(
                                          width: 3.sp,
                                        ),
                                        const Text("||"),
                                         SizedBox(
                                          width: 3.sp,
                                        ),
                                        Text(
                                          data.orderDate,
                                          style:  TextStyle(fontSize: 14.sp),
                                        )
                                      ],
                                    ),
                                    Container(
                                      color: _getStatusColor(data.status),
                                      child: Padding(
                                        padding:  EdgeInsets.all(5.0.sp),
                                        child: Text(
                                          data.status,
                                          style:  TextStyle(
                                              color: const Color.fromRGBO(
                                                  255, 255, 255, 1),
                                              fontSize: 14.sp),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                 SizedBox(
                                  height: 5.sp,
                                ),
                                Row(
                                  children: [
                                     Icon(
                                      MaterialCommunityIcons
                                          .order_bool_descending,
                                      size: 14.sp,
                                    ),
                                     SizedBox(
                                      width: 4.sp,
                                    ),
                                     Text(
                                      "Order :",
                                      style: TextStyle(
                                          color: Colors.black45, fontSize: 14.sp),
                                    ),
                                     SizedBox(
                                      width: 4.sp,
                                    ),
                                    Text(
                                      data.orderNo.toString(),
                                      style:  TextStyle(fontSize: 14.sp),
                                    ),
                                  ],
                                ),
                                 SizedBox(
                                  height: 5.sp,
                                ),
                                Row(
                                  children: [
                                     Icon(
                                      Ionicons.person_outline,
                                      size: 14.sp,
                                    ),
                                     SizedBox(
                                      width: 4.sp,
                                    ),
                                     Text(
                                      "Customer :",
                                      style: TextStyle(
                                          color: Colors.black45, fontSize: 14.sp),
                                    ),
                                     SizedBox(
                                      width: 4.sp,
                                    ),
                                    Expanded(
                                      child: Text(
                                        data.customer,
                                        style:  TextStyle(fontSize: 14.sp),
                                      ),
                                    ),
                                  ],
                                ),
                                 SizedBox(
                                  height: 5.sp,
                                ),
                                Row(
                                  children: [
                                     Icon(
                                      Ionicons.time_outline,
                                      size: 14.sp,
                                    ),
                                     SizedBox(
                                      width: 4.sp,
                                    ),
                                     Text(
                                      "Entered On :",
                                      style: TextStyle(
                                          color: Colors.black45, fontSize: 14.sp),
                                    ),
                                     SizedBox(
                                      width: 4.sp,
                                    ),
                                    Text(
                                      data.enteredOn,
                                      style:  TextStyle(fontSize: 14.sp),
                                    ),
                                  ],
                                ),
                                 SizedBox(
                                  height: 5.sp,
                                ),
                                Visibility(
                                  visible: data.remarks.isNotEmpty,
                                  child: Row(
                                    children: [
                                       Icon(
                                        Ionicons.time_outline,
                                        size: 14.sp,
                                      ),
                                       SizedBox(
                                        width: 4.sp,
                                      ),
                                       Text(
                                        "Remarks :",
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 14.sp),
                                      ),
                                       SizedBox(
                                        width: 4.sp,
                                      ),
                                      Text(
                                        data.remarks,
                                        style:  TextStyle(fontSize: 14.sp),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                     Icon(
                                      Ionicons.md_create_outline,
                                      size: 14.sp,
                                    ),
                                     SizedBox(
                                      width: 4.sp,
                                    ),
                                     Text(
                                      "Entered By :",
                                      style: TextStyle(
                                          color: Colors.black45, fontSize: 14.sp),
                                    ),
                                     SizedBox(
                                      width: 4.sp,
                                    ),
                                    Text(
                                      data.enteredBy,
                                      style:  TextStyle(
                                          fontSize: 14.sp,
                                          color: AppColors.kPrimaryColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
      ):Center(child: Text("Unauthorized User",style: GoogleFonts.aboreto(fontSize: 20.sp,fontWeight: FontWeight.bold),))
    );
  }

  modalButtonSheet() {
    final itemProviderCustomerVO =
        Provider.of<CustomerProviderVO>(context, listen: false);
    List<CustomerModel> filterCustomers(String searchTextCus) {
      return _customerList.where((customer) {
        return customer.ledgerName
            .toLowerCase()
            .contains(searchTextCus.toLowerCase());
      }).toList();
    }

    String selectedButton = 'apply';
    return showModalBottomSheet(
        isScrollControlled: true,
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.sp), topRight: Radius.circular(20.sp))),
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.62,
            child: Padding(
              padding:  EdgeInsets.fromLTRB(10.sp, 10.sp, 10.sp, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(left: 10.sp, right: 10.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text(
                            "Filter Orders",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.sp),
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close))
                        ],
                      ),
                    ),
                     Divider(
                      indent: 10.sp,
                      endIndent: 10.sp,
                      thickness: 1.sp,
                      color: AppColors.kPrimaryColor,
                    ),
                    Padding(
                      padding:  EdgeInsets.fromLTRB(8.sp, 2.sp, 8.sp, 2.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            "Status",
                            style: TextStyle(
                                color: AppColors.kPrimaryColor, fontSize: 15.sp),
                          ),
                          InkWell(
                            onTap: status,
                            child: Padding(
                              padding:  EdgeInsets.all(10.0.sp),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                       Icon(
                                        MaterialCommunityIcons.list_status,
                                        size: 15.sp,
                                      ),
                                       SizedBox(
                                        width: 10.sp,
                                      ),
                                      Consumer<ViewOrderProvider>(builder:
                                          (context, viewOrderProvider, child) {
                                        return Text(
                                          viewOrderProvider.selectedStatus!,
                                          style:  TextStyle(fontSize: 16.sp),
                                        );
                                      })
                                    ],
                                  ),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                            ),
                          ),
                           Divider(
                            thickness: 0.5.sp,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.fromLTRB(8.sp, 2.sp, 8.sp, 2.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Customer",
                            style: TextStyle(
                                color: AppColors.kPrimaryColor, fontSize: 15),
                          ),
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape:  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.sp),
                                          topRight: Radius.circular(20.sp))),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return FractionallySizedBox(
                                      heightFactor: 0.65,
                                      child: Padding(
                                        padding:  EdgeInsets.fromLTRB(
                                            10.sp, 10.sp, 10.sp, 0),
                                        child: Column(
                                          children: [
                                            CustomSearchBar(
                                              controller: searchControllerCus,
                                              onChanged: (String? value) {
                                                searchCusListner.value =
                                                    value ?? "";
                                              },
                                              hintText: 'Select a Customer',
                                            ),
                                            Expanded(
                                              child: ValueListenableBuilder(
                                                valueListenable:
                                                    searchCusListner,
                                                builder:
                                                    (context, value, child) {
                                                  return ListView.builder(
                                                      itemCount:
                                                          filterCustomers(value)
                                                              .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              index) {
                                                        CustomerModel customer =
                                                            filterCustomers(
                                                                value)[index];
                                                        return Padding(
                                                          padding:
                                                               EdgeInsets
                                                                      .only(
                                                                  top: 4.sp,
                                                                  bottom: 4.sp),
                                                          child: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                _selectedCusModel =
                                                                    customer;
                                                              });
                                                              itemProviderCustomerVO.selectCustomer(
                                                                  _selectedCusModel
                                                                      .id
                                                                      .toString(),
                                                                  _selectedCusModel
                                                                      .ledgerName,
                                                                  _selectedCusModel
                                                                      .ledgerName,
                                                                  _selectedCusModel
                                                                      .panNo);

                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  border: Border.all(
                                                                      color: AppColors
                                                                          .borderColor),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          6.sp)),
                                                              child: Padding(
                                                                padding:
                                                                     EdgeInsets
                                                                        .all(10.sp),
                                                                child:
                                                                    Padding(
                                                                  padding:
                                                                       EdgeInsets
                                                                          .all(
                                                                    5.sp,
                                                                  ),
                                                                  child: Text(
                                                                    customer
                                                                        .ledgerName,
                                                                    style:  TextStyle(
                                                                        overflow: TextOverflow
                                                                            .clip,
                                                                        fontSize:
                                                                            17.sp),
                                                                    maxLines:
                                                                        2,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Padding(
                              padding:  EdgeInsets.all(10.0.sp),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                       Icon(
                                        Fontisto.person,
                                        size: 15.sp,
                                      ),
                                       SizedBox(
                                        width: 10.sp,
                                      ),
                                      Consumer<CustomerProviderVO>(
                                        builder: (context, value, child) {
                                          return Text(
                                            value.ledgerName.isNotEmpty
                                                ? value.ledgerName
                                                : "Select a Customer",
                                            style:
                                                 TextStyle(fontSize: 16.sp),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                            ),
                          ),
                           Divider(
                            thickness: 0.5.sp,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.fromLTRB(8.sp, 2.sp, 8.sp, 2.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            "Date From",
                            style: TextStyle(
                                color: AppColors.kPrimaryColor, fontSize: 15.sp),
                          ),
                          Consumer<ViewOrderProvider>(
                            builder: (context, value, child) {
                              return InkWell(
                                onTap: () async {
                                  DateTime? pickedDateFrom = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2100));

                                  if (pickedDateFrom != null) {
                                    setState(() {
                                      value.selectedDateFrom = pickedDateFrom;
                                    });
                                  } else {}
                                },
                                child: Padding(
                                  padding:  EdgeInsets.all(10.0.sp),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                           Icon(
                                            FontAwesome.calendar,
                                            size: 15.sp,
                                          ),
                                           SizedBox(
                                            width: 10.sp,
                                          ),
                                          Text(
                                            value.selectedDateFrom != null
                                                ? DateFormat('yyyy-MM-dd')
                                                    .format(
                                                        value.selectedDateFrom!)
                                                : 'Beginning Date',
                                            style:
                                                 TextStyle(fontSize: 16.sp),
                                          )
                                        ],
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.black,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                           Divider(
                            thickness: 0.5.sp,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.fromLTRB(8.sp, 2.sp, 8.sp, 2.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            "Date To",
                            style: TextStyle(
                                color: AppColors.kPrimaryColor, fontSize: 15.sp),
                          ),
                          Consumer<ViewOrderProvider>(
                            builder: (context, value, child) {
                              return InkWell(
                                onTap: () async {
                                  DateTime? pickedDateTo = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2100));

                                  if (pickedDateTo != null) {
                                    setState(() {
                                      value.selectedDateTo = pickedDateTo;
                                    });
                                  } else {}
                                },
                                child: Padding(
                                  padding:  EdgeInsets.all(10.0.sp),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                           Icon(
                                            FontAwesome.calendar,
                                            size: 15.sp,
                                          ),
                                           SizedBox(
                                            width: 10.sp,
                                          ),
                                          Text(
                                            value.selectedDateTo != null
                                                ? DateFormat('yyyy-MM-dd')
                                                    .format(
                                                        value.selectedDateTo!)
                                                : 'Ending Date',
                                            style: TextStyle(fontSize: 16.sp),
                                          )
                                        ],
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.black,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                           Divider(
                            thickness: 0.5.sp,
                          )
                        ],
                      ),
                    ),
                     SizedBox(
                      height: 10.sp,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: CustomButtom(
                              onPressed: () {
                                setState(() {
                                  selectedButton = 'apply';
                                  // Add your logic for Apply button press
                                  apply();
                                  Navigator.pop(context);
                                  itemProviderCustomerVO.clearSelection();
                                  viewOrderProvider.clearSelectedValues();
                                });
                              },
                              buttonColor: selectedButton == 'apply'
                                  ? AppColors.kPrimaryColor
                                  : Colors.black38,
                              buttonText: "Apply",
                              elevation: 2,
                              context: context),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: CustomButtom(
                              onPressed: () {
                                setState(() {
                                  selectedButton = 'clear';
                                  // Add your logic for Apply button press
                                  itemProviderCustomerVO.clearSelection();
                                  viewOrderProvider.clearSelectedValues();
                                });
                              },
                              buttonColor: selectedButton == 'clear'
                                  ? AppColors.kPrimaryColor
                                  : Colors.black38,
                              buttonText: "Clear",
                              elevation: 2,
                              context: context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  status() {
    TextEditingController _searchController = TextEditingController();
    return showModalBottomSheet(
        isScrollControlled: true,
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.sp), topRight: Radius.circular(20.sp))),
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.35,
            child: Padding(
              padding:  EdgeInsets.fromLTRB(10.sp, 10.sp, 10.sp, 0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomSearchBar(
                        controller: _searchController,
                        onChanged: (String? value) {
                          setState(() {
                            search = value ?? ""; // Update the search variable
                          });
                        },
                        hintText: "Search"),
                     SizedBox(
                      height: 10.sp,
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            viewOrderProvider.selectedStatus = "Pending";
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: AppColors.borderColor,
                                ),
                                borderRadius: BorderRadius.circular(5)),
                            child:  Padding(
                              padding: EdgeInsets.fromLTRB(10.sp, 14.sp, 10.sp, 14.sp),
                              child: Text(
                                "Pending",
                                style: TextStyle(fontSize: 17.sp),
                              ),
                            ),
                          ),
                        ),
                         SizedBox(
                          height: 15.sp,
                        ),
                        InkWell(
                          onTap: () {
                            viewOrderProvider.selectedStatus = "Approved";
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: AppColors.borderColor),
                                borderRadius: BorderRadius.circular(5)),
                            child:  Padding(
                              padding: EdgeInsets.fromLTRB(10.sp, 14.sp, 10.sp, 14.sp),
                              child: Text(
                                "Approved",
                                style: TextStyle(fontSize: 17.sp),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            viewOrderProvider.selectedStatus = "Rejected";
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: AppColors.borderColor),
                                borderRadius: BorderRadius.circular(5)),
                            child:  Padding(
                              padding: EdgeInsets.fromLTRB(10.sp, 14.sp, 10.sp, 14.sp),
                              child: Text(
                                "Rejected",
                                style: TextStyle(fontSize: 17.sp),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _buildLoadingWidget() {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 2)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (dataList.isEmpty) {
          
            return const Center(
              child: Text("Empty Data"),
            );
          } else {
            return const SizedBox.shrink(); // Or any other fallback widget
          }
        }
      },
    );
  }
}
