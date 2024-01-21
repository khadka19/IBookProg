import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:petrolpump/API_Services/get_services_order.dart';
import 'package:petrolpump/API_Services/get_services_sales.dart';
import 'package:petrolpump/API_Services/ledger_services.dart';
import 'package:petrolpump/API_Services/role_control.dart';
import 'package:petrolpump/API_Services/trial_stock_services.dart';
import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/CommonWidgets/constants_text.dart';
import 'package:petrolpump/CommonWidgets/custom_button.dart';
import 'package:petrolpump/CommonWidgets/search_bar.dart';
import 'package:petrolpump/Preference/preference.dart';
import 'package:petrolpump/Provider/trial_stock_provider.dart';
import 'package:petrolpump/Screens/CreatePage/main_page.dart';
import 'package:petrolpump/Utilities/utilities.dart';
import 'package:petrolpump/models/LedgerModel/fiscal_date_model.dart';
import 'package:petrolpump/models/product_company_model.dart';
import 'package:petrolpump/models/product_model.dart';
import 'package:petrolpump/models/trailStock_brach_model.dart';
import 'package:petrolpump/models/trialStock_productGroup_model.dart';
import 'package:petrolpump/models/trial_stock_model.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class TrialStock extends StatefulWidget {
  final String title;
  const TrialStock({super.key, required this.title});

  @override
  State<TrialStock> createState() => _TrialStockState();
}

class _TrialStockState extends State<TrialStock> {
  bool _shouldResetState = true;
  bool hasPressed = false;
  bool hasDataToDisplay = false;
  final ScrollController _scrollController = ScrollController();
  static const fontFamily = "times new roman";
  List<TrialStockModelDetails> _trialStockList = [];
  List<LrFiscalDateModelDetails> _fiscalDateList = [];

  List<ProductCompanyModel> _productCompanyList = [];
  List<TsProductGroupModelDetails> _productGroupList = [];
  List<ProductModel> _productList = [];

  List<TrialStockBranchDetails> _trialStockBranchList = [];
  LRFiscalDateService lrFiscalDateService = LRFiscalDateService();
  MyServiceOrder myServiceOrder = MyServiceOrder();
  final TextEditingController _searchControllerCus = TextEditingController();
  ValueNotifier<String> searchCusListner = ValueNotifier<String>('');
  TrialStockServices trialStockService = TrialStockServices();
  List<String> balnceTypeItems = ['Positive', 'Negative', 'Zero', 'All'];
  double totalBalance = 0.0;
  RoleCheckServices roleCheckServices = RoleCheckServices();
  bool isAuthorized = false;
  MyService myService = MyService();

  List<ProductCompanyModel> filterProductCompany(String searchProCom) {
    return _productCompanyList.where((productCompany) {
      return productCompany.companyName
          .toLowerCase()
          .contains(searchProCom.toLowerCase());
    }).toList();
  }

  List<TsProductGroupModelDetails> filterProductGroup(String search) {
    return _productGroupList.where((productGroup) {
      return productGroup.name.toLowerCase().contains(search.toLowerCase());
    }).toList();
  }

  List<ProductModel> filterProduct(String search) {
    return _productList.where((data) {
      return data.productName.toLowerCase().contains(search.toLowerCase());
    }).toList();
  }

  List<TrialStockBranchDetails> filterTrialStockBranch(String searchBranch) {
    return _trialStockBranchList.where((branch) {
      return branch.name.toLowerCase().contains(searchBranch.toLowerCase());
    }).toList();
  }

  Future<String> getCompanyName() async {
    // Retrieve the companyName from preferences or wherever it's stored
    // For example, using the UserPreference class
    String companyName = await UserPreference.getUserPreference(
        ContstantsText.unEncryptedCompanyName);
    return companyName;
  }

  void checkRole() async {
    bool apiResult = await roleCheckServices.roleCheckLedgerReport();
    if (apiResult == true) {
      setState(() {
        isAuthorized = true;
      });
    } else {
      setState(() {
        isAuthorized = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkRole();
    lrFiscalDateService.getFiscalDate().then((fiscalDate) async {
      _fiscalDateList = fiscalDate;
    });

    trialStockService.getTrialStockBranch().then((branchList) async {
      _trialStockBranchList = branchList; // Store the fetched customer data
    });

    myServiceOrder.getProductCompanyDetails().then((productCompanyData) async {
      setState(() {
        _productCompanyList =
            productCompanyData; // Store the fetched customer data
      });
    });
    trialStockService.getProductGroup().then((data) async {
      setState(() {
        _productGroupList = data; // Store the fetched customer data
      });
    });

    myService.getproductDetails(0).then((data) async {
      setState(() {
        _productList = data; // Store the fetched customer data
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final trialStockProvider = Provider.of<TrialStockProvider>(context);

    if (_shouldResetState) {
      trialStockProvider.selectedProductCompany = '';
      trialStockProvider.selectedProductCompanyId = 0;
      trialStockProvider.selectedBranch = '';
      trialStockProvider.selectedBranchId = 0;
      trialStockProvider.selectedBalanceType = 'Positive';
      trialStockProvider.selectedProductGroup = '';
      trialStockProvider.selectedProductGroupId = 0;
      trialStockProvider.selectedProductName = '';
      trialStockProvider.selectedProductNameId = 0;
      _shouldResetState = false;
      trialStockProvider.selectedDateFrom = null;
      trialStockProvider.selectedDateTo = null;
    }
    double totalBalance = 0.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimaryColor,
        title: Text(widget.title),
        centerTitle: true,
        leading: DrawerWidget(),
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    hasPressed
                        ? _displayPdf()
                        : Utilities.showSnackBar(
                            context, "Select Field", false);
                  },
                  icon: Icon(Icons.picture_as_pdf)),
              IconButton(
                  onPressed: () {
                    filterWidget();
                  },
                  icon: Icon(Feather.filter)),
            ],
          )
        ],
      ),
      body: isAuthorized
          ? Column(
              children: [
                SizedBox(
                  height: 10.sp,
                ),
               
                Card(
                  elevation: 5,
                  child: LimitedBox(
                    maxHeight: screenHeight * 0.608,
                    child: Stack(children: [
                      SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                border: TableBorder.all(
                                  width: 1,
                                  color: Colors.black12,
                                ),
                                headingRowColor: MaterialStateColor.resolveWith(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.hovered)) {
                                      // Color when the heading row is hovered
                                      return AppColors.kPrimaryColor
                                          .withOpacity(0.3);
                                    }
                                    return AppColors
                                        .kPrimaryColor; // Default color
                                  },
                                ),
                                dataRowHeight: 35.sp,
                                headingRowHeight: 30.sp,
                                dividerThickness: 1,
                                columnSpacing: 10.sp,
                                showCheckboxColumn: true,
                                sortAscending: true,
                                sortColumnIndex: 0,
                                columns: [
                                  DataColumn(
                                      label: SizedBox(
                                          child: Text(
                                    'S.N',
                                    style: GoogleFonts.acme(
                                        color: Colors.white, fontSize: 15.sp),
                                  ))),
                                  DataColumn(
                                      label: SizedBox(
                                          child: Text(
                                    'Product Name',
                                    style: GoogleFonts.acme(
                                        color: Colors.white, fontSize: 15.sp),
                                  ))),
                                  DataColumn(
                                      label: SizedBox(
                                          child: Text(
                                    'OP Qty',
                                    style: GoogleFonts.acme(
                                        color: Colors.white, fontSize: 15.sp),
                                  )),
                                  
                                  numeric: true),
                                  DataColumn(
                                      label: SizedBox(
                                          child: Text(
                                        'In Qty',
                                        style: GoogleFonts.acme(
                                            color: Colors.white,
                                            fontSize: 15.sp),
                                      )),
                                      numeric: true),
                                  DataColumn(
                                      label: SizedBox(
                                          child: Text(
                                        'Out Qty',
                                        style: GoogleFonts.acme(
                                            color: Colors.white,
                                            fontSize: 15.sp),
                                      )),
                                      numeric: true),
                                  DataColumn(
                                      label: SizedBox(
                                          child: Text(
                                        'Balance',
                                        style: GoogleFonts.acme(
                                            color: Colors.white,
                                            fontSize: 15.sp),
                                      )),
                                      numeric: true),
                                ],
                                rows: _trialStockList.map((data) {
                                  int index = _trialStockList.indexOf(data) + 1;

                                  totalBalance += data.balance;
                                  return DataRow(cells: [
                                    DataCell(SizedBox(
                                      child: Text(
                                        index.toString(),
                                        style: GoogleFonts.aBeeZee(
                                            fontSize: 14.sp),
                                      ),
                                    )),
                                    DataCell(SizedBox(
                                        child: SizedBox(
                                            child: Text(
                                      data.productName,
                                      style:
                                          GoogleFonts.aBeeZee(fontSize: 14.sp),
                                    )))),
                                    DataCell(SizedBox(
                                        child: SizedBox(
                                            child: Text(
                                      data.openingQuantity.toString(),
                                      style:
                                          GoogleFonts.aBeeZee(fontSize: 14.sp),
                                          textAlign: TextAlign.right,
                                    )))),
                                    DataCell(SizedBox(
                                        child: Text(
                                      data.inQuantity.toString(),
                                      style:
                                          GoogleFonts.aBeeZee(fontSize: 14.sp),
                                      textAlign: TextAlign.right,
                                    ))),
                                    DataCell(SizedBox(
                                        child: Text(
                                      data.outQuantity.toString(),
                                      style:
                                          GoogleFonts.aBeeZee(fontSize: 14.sp),
                                      textAlign: TextAlign.right,
                                    ))),
                                    DataCell(SizedBox(
                                        child: Text(
                                      data.balance.toString(),
                                      style:
                                          GoogleFonts.aBeeZee(fontSize: 14.sp),
                                      textAlign: TextAlign.right,
                                    ))),
                                  ]);
                                }).toList(),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              child: Center(
                                  child: hasDataToDisplay
                                      ? null
                                      : Text(
                                          "- Empty -",
                                          style: GoogleFonts.aBeeZee(
                                            fontSize: 14.sp,
                                          ),
                                        )),
                            ),
                          ],
                        ),
                      ),
                      hasDataToDisplay
                          ? Positioned(
                              right: 10.sp,
                              bottom: 2.sp,
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (_scrollController.position.pixels ==
                                        _scrollController
                                            .position.maxScrollExtent) {
                                      // If already at the bottom, scroll to the top
                                      _scrollController.animateTo(
                                        _scrollController
                                            .position.minScrollExtent,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    } else {
                                      // If not at the bottom, scroll to the bottom
                                      _scrollController.animateTo(
                                        _scrollController
                                            .position.maxScrollExtent,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.kPrimaryColor
                                          .withOpacity(0.6),
                                      shape: StadiumBorder()),
                                  child: const Center(
                                    child: Icon(Entypo.select_arrows),
                                  )))
                          : const SizedBox()
                    ]),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Column(children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5.sp, right: 5.sp),
                    child: Container(
                      color: AppColors.alternativeColor,
                      child: Padding(
                        padding: EdgeInsets.all(10.0.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Balance :",
                              style: TextStyle(
                                  color: AppColors.kPrimaryColor,
                                  fontFamily: fontFamily,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              totalBalance.toStringAsFixed(2),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.sp,
                                  fontFamily: fontFamily),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
              ],
            )
          : Center(
              child: Text(
              "Unauthorized User",
              style: GoogleFonts.aboreto(
                  fontSize: 20.sp, fontWeight: FontWeight.bold),
            )),
    );
  }

  filterWidget() {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.sp),
                topRight: Radius.circular(20.sp))),
        context: context,
        builder: (BuildContext context) {
          return Consumer<TrialStockProvider>(
            builder: (context, value, child) {
              var selectedBranch = value.selectedBranch;
              var name = value.selectedProductCompany;
              var productGroupName = value.selectedProductGroup;
              var productName = value.selectedProductName;
              return FractionallySizedBox(
                heightFactor: 0.8,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.sp, bottom: 10.sp),
                        child: Text(
                          "Configuration",
                          style: GoogleFonts.aboreto(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(
                        thickness: 1.sp,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.0.sp),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.only(left: 10.sp),
                                    child: Text(
                                      "Date From",
                                      style: GoogleFonts.aBeeZee(
                                          color: Colors.black54,
                                          fontSize: 16.sp),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.sp,
                                  ),
                                  Consumer<TrialStockProvider>(
                                    builder: (context, value, child) {
                                      return InkWell(
                                        onTap: () async {
                                          DateTime? pickedDateFrom =
                                              await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1950),
                                                  //DateTime.now() - not to allow to choose before today.
                                                  lastDate: DateTime(2100));

                                          if (pickedDateFrom != null) {
                                            setState(() {
                                              value.selectedDateFrom =
                                                  pickedDateFrom;
                                            });
                                          } else {}
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              color:
                                                  AppColors.alternativeColor),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0.sp),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                      value.selectedDateFrom !=
                                                              null
                                                          ? DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(value
                                                                  .selectedDateFrom!)
                                                          : DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(_fiscalDateList[
                                                                      0]
                                                                  .finStartDate),
                                                      style: TextStyle(
                                                          fontSize: 16.sp),
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
                              padding: EdgeInsets.all(10.0.sp),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.only(right: 10.sp),
                                    child: Text(
                                      "Date To",
                                      style: GoogleFonts.aBeeZee(
                                          color: Colors.black54,
                                          fontSize: 16.sp),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.sp,
                                  ),
                                  Consumer<TrialStockProvider>(
                                    builder: (context, value, child) {
                                      return InkWell(
                                        onTap: () async {
                                          DateTime? pickedDateTo =
                                              await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1950),
                                                  //DateTime.now() - not to allow to choose before today.
                                                  lastDate: DateTime(2100));

                                          if (pickedDateTo != null) {
                                            setState(() {
                                              value.selectedDateTo =
                                                  pickedDateTo;
                                            });
                                          } else {}
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              color:
                                                  AppColors.alternativeColor),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0.sp),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                      value.selectedDateTo !=
                                                              null
                                                          ? DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(value
                                                                  .selectedDateTo!)
                                                          : DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(
                                                                  _fiscalDateList[
                                                                          0]
                                                                      .finEndDate),
                                                      style: TextStyle(
                                                          fontSize: 16.sp),
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
                                      );
                                    },
                                  ),
                                  Divider(
                                    thickness: 0.5.sp,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 10.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.only(left: 10.sp),
                                    child: Text(
                                      "Branch",
                                      style: GoogleFonts.aBeeZee(
                                          color: Colors.black54,
                                          fontSize: 16.sp),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.sp,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      branchName();
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      color: AppColors.alternativeColor,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0.sp),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              child: Text(
                                                selectedBranch.isNotEmpty
                                                    ? selectedBranch
                                                    : "Select Branch",
                                                style: GoogleFonts.adamina(
                                                    color: Colors.black,
                                                    fontSize: 16.sp),
                                              ),
                                            ),
                                            const Icon(
                                              Icons.arrow_drop_down,
                                            )
                                          ],
                                        ),
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
                              padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.only(right: 10.sp),
                                    child: Text(
                                      "Blnc Type",
                                      style: GoogleFonts.aBeeZee(
                                          color: Colors.black54,
                                          fontSize: 16.sp),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.sp,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      balanceType();
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      color: AppColors.alternativeColor,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0.sp),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              child: Text(
                                                value.selectedBalanceType
                                                        .isNotEmpty
                                                    ? value.selectedBalanceType
                                                    : balnceTypeItems[0],
                                                style: GoogleFonts.adamina(
                                                    color: Colors.black,
                                                    fontSize: 16.sp),
                                              ),
                                            ),
                                            const Icon(
                                              Icons.arrow_drop_down,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0.5.sp,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(left: 30.sp),
                            child: Text(
                              "Product Company",
                              style: GoogleFonts.aBeeZee(
                                  color: Colors.black54, fontSize: 16.sp),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          InkWell(
                            onTap: () {
                              productCompany();
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(20.sp, 0, 20.sp, 0),
                              child: Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                color: AppColors.alternativeColor,
                                child: Padding(
                                  padding: EdgeInsets.all(10.0.sp),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Text(
                                          name.isNotEmpty
                                              ? name
                                              : "Select a Product Company",
                                          style: GoogleFonts.adamina(
                                              color: Colors.black,
                                              fontSize: 16.sp),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(left: 30.sp),
                            child: Text(
                              "Product Group",
                              style: GoogleFonts.aBeeZee(
                                  color: Colors.black54, fontSize: 16.sp),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          InkWell(
                            onTap: () {
                              productGroup();
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(20.sp, 0, 20.sp, 0),
                              child: Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                color: AppColors.alternativeColor,
                                child: Padding(
                                  padding: EdgeInsets.all(10.0.sp),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Text(
                                          productGroupName.isNotEmpty
                                              ? productGroupName
                                              : "Select a Product Group",
                                          style: GoogleFonts.adamina(
                                              color: Colors.black,
                                              fontSize: 16.sp),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(left: 30.sp),
                            child: Text(
                              "Product",
                              style: GoogleFonts.aBeeZee(
                                  color: Colors.black54, fontSize: 16.sp),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          InkWell(
                            onTap: () {
                              productDetails();
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(20.sp, 0, 20.sp, 0),
                              child: Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                color: AppColors.alternativeColor,
                                child: Padding(
                                  padding: EdgeInsets.all(10.0.sp),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Text(
                                          productName.isNotEmpty
                                              ? productName
                                              : "Select a Product",
                                          style: GoogleFonts.adamina(
                                              color: Colors.black,
                                              fontSize: 16.sp),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0.sp),
                        child: Consumer<TrialStockProvider>(
                          builder: (context, value, child) {
                            return CustomButtom(
                                onPressed: () async {
                                  hasPressed = true;
                                  String balanceType =
                                      value.selectedBalanceType.toString();
                                  int selectedBranchId = value.selectedBranchId;
                                  int selectedProductCompanyId =
                                      value.selectedProductCompanyId;
                                  int selectedProductGroupId =
                                      value.selectedProductGroupId;
                                  int selectedProductId =
                                      value.selectedProductNameId;
                                  String formattedFromDate =
                                      value.selectedDateFrom != null
                                          ? DateFormat('yyyy-MM-dd')
                                              .format(value.selectedDateFrom!)
                                          : DateFormat('yyyy-MM-dd').format(
                                              _fiscalDateList[0].finStartDate);

                                  String formattedToDate =
                                      value.selectedDateTo != null
                                          ? DateFormat('yyyy-MM-dd')
                                              .format(value.selectedDateTo!)
                                          : DateFormat('yyyy-MM-dd').format(
                                              _fiscalDateList[0].finEndDate);

                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      });
                                  await Future.delayed(Duration(seconds: 1));
                                  try {
                                    trialStockService
                                        .getTrialStockList(
                                      formattedFromDate,
                                      formattedToDate,
                                      balanceType,
                                      selectedBranchId,
                                      selectedProductCompanyId,
                                      selectedProductGroupId,
                                      selectedProductId,
                                    )
                                        .then((data) async {
                                      setState(() {
                                        _trialStockList =
                                            data; // Store the fetched customer data
                                        hasDataToDisplay =
                                            _trialStockList.isNotEmpty;
                                      });
                                    });
                                  } finally {
                                    Navigator.pop(context);
                                  }
                                },
                                buttonColor: AppColors.kPrimaryColor,
                                buttonText: "Apply",
                                elevation: 5,
                                context: context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  productCompany() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.sp),
                topRight: Radius.circular(20.sp))),
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 10.sp, 10.sp, 0),
              child: Column(
                children: [
                  CustomSearchBar(
                    controller: _searchControllerCus,
                    onChanged: (String? value) {
                      searchCusListner.value = value ?? "";
                    },
                    hintText: 'Select Company',
                  ),
                  Expanded(
                    child: _productCompanyList.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ValueListenableBuilder(
                            valueListenable: searchCusListner,
                            builder: (context, value, child) {
                              return ListView.builder(
                                  itemCount: filterProductCompany(value).length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    ProductCompanyModel productCompany =
                                        filterProductCompany(value)[index];
                                    return Consumer<TrialStockProvider>(
                                      builder: (context, value, child) {
                                        return Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10.sp, 7.sp, 10.sp, 7.sp),
                                          child: InkWell(
                                            onTap: () async {
                                              // resetSelections();
                                              value.selectedProductCompany =
                                                  productCompany.companyName;
                                              value.selectedProductCompanyId =
                                                  productCompany.id!;
                                              // ignore: use_build_context_synchronously
                                              Navigator.pop(context);
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  productCompany.companyName,
                                                  style: GoogleFonts.adamina(
                                                    fontSize: 17.sp,
                                                  ),
                                                ),
                                                Divider(
                                                  thickness: 1.sp,
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
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
  }

  productGroup() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.sp),
                topRight: Radius.circular(20.sp))),
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 10.sp, 10.sp, 0),
              child: Column(
                children: [
                  CustomSearchBar(
                    controller: _searchControllerCus,
                    onChanged: (String? value) {
                      searchCusListner.value = value ?? "";
                    },
                    hintText: 'Select Company',
                  ),
                  Expanded(
                    child: _productGroupList.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ValueListenableBuilder(
                            valueListenable: searchCusListner,
                            builder: (context, value, child) {
                              return ListView.builder(
                                  itemCount: filterProductGroup(value).length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    TsProductGroupModelDetails data =
                                        filterProductGroup(value)[index];
                                    return Consumer<TrialStockProvider>(
                                      builder: (context, value, child) {
                                        return Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10.sp, 7.sp, 10.sp, 7.sp),
                                          child: InkWell(
                                            onTap: () async {
                                              // resetSelections();
                                              value.selectedProductGroup =
                                                  data.name;
                                              value.selectedProductGroupId =
                                                  data.id!;
                                              // ignore: use_build_context_synchronously
                                              Navigator.pop(context);
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data.name,
                                                  style: GoogleFonts.adamina(
                                                    fontSize: 17.sp,
                                                  ),
                                                ),
                                                Divider(
                                                  thickness: 1.sp,
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
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
  }

  productDetails() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.sp),
                topRight: Radius.circular(20.sp))),
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 10.sp, 10.sp, 0),
              child: Column(
                children: [
                  CustomSearchBar(
                    controller: _searchControllerCus,
                    onChanged: (String? value) {
                      searchCusListner.value = value ?? "";
                    },
                    hintText: 'Select Company',
                  ),
                  Expanded(
                    child: _productList.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ValueListenableBuilder(
                            valueListenable: searchCusListner,
                            builder: (context, value, child) {
                              return ListView.builder(
                                  itemCount: filterProduct(value).length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    ProductModel data =
                                        filterProduct(value)[index];
                                    return Consumer<TrialStockProvider>(
                                      builder: (context, value, child) {
                                        return Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10.sp, 7.sp, 10.sp, 7.sp),
                                          child: InkWell(
                                            onTap: () async {
                                              // resetSelections();
                                              value.selectedProductName =
                                                  data.productName;
                                              value.selectedProductNameId =
                                                  data.id!;
                                              // ignore: use_build_context_synchronously
                                              Navigator.pop(context);
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data.productName,
                                                  style: GoogleFonts.adamina(
                                                    fontSize: 17.sp,
                                                  ),
                                                ),
                                                Divider(
                                                  thickness: 1.sp,
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
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
  }

  branchName() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.sp),
                topRight: Radius.circular(20.sp))),
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.sp, 10.sp, 10.sp, 0),
              child: Column(
                children: [
                  CustomSearchBar(
                    controller: _searchControllerCus,
                    onChanged: (String? value) {
                      searchCusListner.value = value ?? "";
                    },
                    hintText: 'Branch',
                  ),
                  Expanded(
                    child: _trialStockBranchList.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ValueListenableBuilder(
                            valueListenable: searchCusListner,
                            builder: (context, value, child) {
                              return ListView.builder(
                                  itemCount:
                                      filterTrialStockBranch(value).length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var trialStockBranch =
                                        filterTrialStockBranch(value)[index];
                                    return Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          10.sp, 7.sp, 10.sp, 7.sp),
                                      child: Consumer<TrialStockProvider>(
                                        builder: (context, value, child) {
                                          return InkWell(
                                            onTap: () async {
                                              value.selectedBranch =
                                                  trialStockBranch.name;
                                              value.selectedBranchId =
                                                  trialStockBranch.id;
                                              // ignore: use_build_context_synchronously
                                              Navigator.pop(context);
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  trialStockBranch.name,
                                                  style: GoogleFonts.adamina(
                                                    fontSize: 17.sp,
                                                  ),
                                                ),
                                                Divider(
                                                  thickness: 1.sp,
                                                )
                                              ],
                                            ),
                                          );
                                        },
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
  }

  balanceType() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.sp),
                topRight: Radius.circular(20.sp))),
        context: context,
        builder: (BuildContext context) {
          return Consumer<TrialStockProvider>(
            builder: (context, value, child) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10.sp, 10.sp, 10.sp, 0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: balnceTypeItems.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(
                                    10.sp, 7.sp, 10.sp, 7.sp),
                                child: InkWell(
                                    onTap: () async {
                                      value.selectedBalanceType =
                                          balnceTypeItems[index];

                                      // ignore: use_build_context_synchronously
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            balnceTypeItems[index],
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          Divider(
                                            thickness: 1,
                                          )
                                        ],
                                      ),
                                    )),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  void _displayPdf() async {
    String companyName = await getCompanyName();
    final doc = pw.Document();

    double font10sp = ScreenUtil().setSp(10.sp);
    double font8sp = ScreenUtil().setSp(8.sp);
    var screenWidth = MediaQuery.of(context).size.width;
    final trialStockProvider =
        Provider.of<TrialStockProvider>(context, listen: false);
    double totalBalance = 0.0;

    double availableSpaceOnPage(pw.Context pdfContext) {
      return 600.0.sp;
    }

    // Split the ledger list into chunks
    List<List<TrialStockModelDetails>> chunks = [];

    for (int i = 0; i < _trialStockList.length; i += 30) {
      chunks.add(
        _trialStockList.sublist(i, min(i + 30, _trialStockList.length)),
      );
    }

    // Add the title part only once at the beginning
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context pdfContext) {
          List<pw.Widget> ledgerRows = [];

          double availableSpace = availableSpaceOnPage(pdfContext);

          for (var details in _trialStockList) {
            double rowHeight = 15.0.sp; // Adjust this based on your row height

            if (availableSpace < rowHeight) {
              // If adding the current row exceeds the available space, start a new page
              doc.addPage(
                pw.MultiPage(
                  pageFormat: PdfPageFormat.a4,
                  build: (pw.Context pdfContext) {
                    // Add title and other content for the new page if needed
                    availableSpace = availableSpaceOnPage(pdfContext);
                    return [];
                  },
                ),
              );
            }

            int index = _trialStockList.indexOf(details) + 1;
            // var a = details.invoiceAmount;
            // var b = details.balance;
            // var receiptAmount = (a - b);
            // var ab = index == 1 && details.ledgerBillPayment == 0
            //     ? receiptAmount
            //     : 0.00;
            // totalReceiptAmount += ab; // Accumulate the value here
            totalBalance += details.balance;

            ledgerRows.add(
              pw.Padding(
                padding: pw.EdgeInsets.fromLTRB(5.sp, 0, 5.sp, 3.sp),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.SizedBox(
                      width: screenWidth * 0.07,
                      child: pw.Text(
                        index.toString(),
                        style: pw.TextStyle(fontSize: font8sp),
                      ),
                    ),
                    pw.SizedBox(
                      width: screenWidth * 0.33,
                      child: pw.Text(
                        details.productName,
                        style: pw.TextStyle(fontSize: font8sp),
                      ),
                    ),
                    pw.SizedBox(
                      width: screenWidth * 0.18,
                      child: pw.Text(
                        details.openingQuantity.toStringAsFixed(2),
                        style: pw.TextStyle(fontSize: font8sp),
                      ),
                    ),
                    pw.SizedBox(
                      width: screenWidth * 0.18,
                      child: pw.Text(
                        details.inQuantity.toStringAsFixed(2),
                        style: pw.TextStyle(fontSize: font8sp),
                      ),
                    ),
                    pw.SizedBox(
                      width: screenWidth * 0.18,
                      child: pw.Text(
                        details.outQuantity.toStringAsFixed(2),
                        style: pw.TextStyle(fontSize: font8sp),
                      ),
                    ),
                    pw.SizedBox(
                        width: screenWidth * 0.2,
                        child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Text(
                                details.balance.toStringAsFixed(2),
                                style: pw.TextStyle(fontSize: font8sp),
                              ),
                            ])),
                  ],
                ),
              ),
            );

            availableSpace -= rowHeight;
          }

          return [
            // Title part
            pw.Column(
              children: [
                pw.Text(
                  companyName,
                  style: pw.TextStyle(
                    fontSize: 13.sp,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 3.sp),
                pw.Text(
                  "Trial Stock Report",
                  style: pw.TextStyle(
                      fontSize: 12.sp, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 2.sp),
                pw.Text(
                  trialStockProvider.selectedProductCompany,
                  style: pw.TextStyle(
                    fontSize: 12.sp,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 2.sp),
                pw.SizedBox(height: 4.sp),
                pw.Divider(thickness: 1),
              ],
            ),

            // Ledger rows
            pw.Padding(
              padding: pw.EdgeInsets.fromLTRB(5.sp, 3.sp, 5.sp, 3.sp),
              child: pw.Column(
                children: [
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.SizedBox(
                        width: screenWidth * 0.07,
                        child: pw.Text(
                          "S.N",
                          style: pw.TextStyle(
                              fontSize: font8sp,
                              fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.SizedBox(
                        width: screenWidth * 0.33,
                        child: pw.Text(
                          "Product",
                          style: pw.TextStyle(
                              fontSize: font8sp,
                              fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.SizedBox(
                        width: screenWidth * 0.18,
                        child: pw.Text(
                          "OP Qty",
                          style: pw.TextStyle(
                              fontSize: font8sp,
                              fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.SizedBox(
                        width: screenWidth * 0.18,
                        child: pw.Text(
                          "In Qty",
                          style: pw.TextStyle(
                              fontSize: font8sp,
                              fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.SizedBox(
                        width: screenWidth * 0.18,
                        child: pw.Text(
                          "Out Qty",
                          style: pw.TextStyle(
                              fontSize: font8sp,
                              fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.SizedBox(
                          width: screenWidth * 0.2,
                          child: pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                pw.Text(
                                  "Balance",
                                  style: pw.TextStyle(
                                      fontSize: font8sp,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              ])),
                    ],
                  ),
                  pw.Divider(thickness: 2.sp),
                  pw.SizedBox(
                    height: 3.sp,
                  ),

                  ...ledgerRows,
                  pw.SizedBox(height: 5.sp),
                  // Other total and footer widgets
                  pw.Container(
                    width: double.maxFinite,
                    decoration:
                        pw.BoxDecoration(color: PdfColor.fromInt(0xFFCCCCCC)),
                    child: pw.Padding(
                      padding: pw.EdgeInsets.all(5.sp),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.SizedBox(
                            width: screenWidth * 0.54,
                            child: pw.Text(
                              "Total :",
                              style: pw.TextStyle(fontSize: font10sp),
                            ),
                          ),
                          pw.SizedBox(
                              width: screenWidth * 0.22,
                              child: pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.end,
                                  children: [
                                    pw.Expanded(
                                        child: pw.Align(
                                      alignment: pw.Alignment.bottomRight,
                                      child: pw.Text(
                                          totalBalance.toStringAsFixed(2),
                                          style: pw.TextStyle(
                                              fontSize: font10sp,
                                              fontWeight: pw.FontWeight.bold),
                                          softWrap: true),
                                    )),
                                  ])),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    // Open Preview Screen
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreenTrialStock(doc: doc),
      ),
    );
  }
}

class PreviewScreenTrialStock extends StatelessWidget {
  final pw.Document doc;

  const PreviewScreenTrialStock({
    Key? key,
    required this.doc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        centerTitle: true,
        title: const Text("Ledger Report"),
      ),
      body: PdfPreview(
        build: (format) => doc.save(),
        allowSharing: true,
        allowPrinting: true,
        initialPageFormat: PdfPageFormat.a4,
        pdfFileName: "mydoc.pdf",
      ),
    );
  }
}
