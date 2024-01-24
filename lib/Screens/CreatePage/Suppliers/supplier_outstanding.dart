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
import 'package:petrolpump/API_Services/splrOutstanding_services.dart';
import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/CommonWidgets/constants_text.dart';
import 'package:petrolpump/CommonWidgets/custom_button.dart';
import 'package:petrolpump/CommonWidgets/search_bar.dart';
import 'package:petrolpump/Preference/preference.dart';
import 'package:petrolpump/Provider/splrOutstandingProvider.dart';
import 'package:petrolpump/Screens/CreatePage/about.dart';
import 'package:petrolpump/Utilities/utilities.dart';
import 'package:petrolpump/models/LedgerModel/fiscal_date_model.dart';
import 'package:petrolpump/models/area_model.dart';
import 'package:petrolpump/models/cusOutstandingModel.dart';
import 'package:petrolpump/models/mr_model.dart';
import 'package:petrolpump/models/supplierList_model.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import '../../../models/product_company_model.dart';
import 'package:pdf/widgets.dart' as pw;

class SupplierOutstanding extends StatefulWidget {
  final String title;
  const SupplierOutstanding({super.key, this.title = "Supplier Outstanding"});

  @override
  State<SupplierOutstanding> createState() => _SupplierOutstandingState();
}

class _SupplierOutstandingState extends State<SupplierOutstanding> {
  var totalInvoiceAmount = 0.00;
  var totalBalance = 0.00;
  static const fontFamily = "times new roman";
  bool _shouldResetState = true;
  final TextEditingController _searchControllerCus = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<LrFiscalDateModelDetails> _fiscalDateList = [];
  List<SupplierListModelDetails> _supplierList = [];
  List<CusSplrOutstandingModelDetails> _cusOunstandingList = [];
  List<MrModelDetails> _mrList = [];
  List<AreaModelDetails> _areaList = [];
  List<ProductCompanyModel> _productCompanyList = [];
  MyServiceOrder myServiceOrder = MyServiceOrder();
  LRFiscalDateService lrFiscalDateService = LRFiscalDateService();
  RoleCheckServices roleControlServices = RoleCheckServices();

  String selectedValue = "AB"; // Default selected value

  ValueNotifier<String> searchCusListner = ValueNotifier<String>('');
  SupplierListModelDetails _selectedSupplierModel = SupplierListModelDetails(
      ledgerAddress: '', ledgerId: 0, ledgerName: '', ledgerPan: '');
  List<SupplierListModelDetails> filterSuppliers(String searchTextCus) {
    return _supplierList.where((customer) {
      return customer.ledgerName
          .toLowerCase()
          .contains(searchTextCus.toLowerCase());
    }).toList();
  }

  List<MrModelDetails> filterMR(String searchMR) {
    return _mrList.where((mrData) {
      return mrData.name.toLowerCase().contains(searchMR.toLowerCase());
    }).toList();
  }

  List<AreaModelDetails> filterArea(String searchArea) {
    return _areaList.where((areaData) {
      return areaData.name.toLowerCase().contains(searchArea.toLowerCase());
    }).toList();
  }

  List<ProductCompanyModel> filterProductCompany(String searchProCom) {
    return _productCompanyList.where((productCompany) {
      return productCompany.companyName
          .toLowerCase()
          .contains(searchProCom.toLowerCase());
    }).toList();
  }

  bool hasDataToDisplay = false;
  double totalDrAmount = 0;
  double totalCrAmount = 0;
  double currentBalance = 0;
  String currentBlcnString = '0.00';
  MyService myService = MyService();
  SplrOutstandingServices cusOutstandingServices = SplrOutstandingServices();
  bool isAuthorized = true;

  String dropdownvalue = 'Bill Date';
  var items = [
    'Bill Date',
    'Dispatch Date',
    'Due Date',
  ];

  void checkRole() async {
    bool apiResult = await roleControlServices.roleCheckSupplierOutstanding();
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

  Future<String> getCompanyName() async {
    // Retrieve the companyName from preferences or wherever it's stored
    // For example, using the UserPreference class
    String companyName = await UserPreference.getUserPreference(
        ContstantsText.unEncryptedCompanyName);
    return companyName;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkRole();
    cusOutstandingServices.getSupplierList().then((customerData) async {
      setState(() {
        _supplierList = customerData; // Store the fetched customer data
      });
    });

    cusOutstandingServices.getMR().then((mrData) async {
      setState(() {
        _mrList = mrData; // Store the fetched customer data
      });
    });

    cusOutstandingServices.getAreaList().then((areaData) async {
      setState(() {
        _areaList = areaData; // Store the fetched customer data
      });
    });

    myServiceOrder.getProductCompanyDetails().then((productCompanyData) async {
      setState(() {
        _productCompanyList =
            productCompanyData; // Store the fetched customer data
      });
    });

    lrFiscalDateService.getFiscalDate().then((fiscalDate) async {
      _fiscalDateList = fiscalDate; // Store the fetched customer data
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final supplierOutstandingProvider =
        Provider.of<SupplierOutstandingProvider>(context);

    if (_shouldResetState) {
      supplierOutstandingProvider.clearSelection();
      supplierOutstandingProvider.selectedMR = '';
      supplierOutstandingProvider.selectedMRID = 0;
      supplierOutstandingProvider.selectedProductCompany = '';
      supplierOutstandingProvider.selectedProductCompanyID = 0;
      supplierOutstandingProvider.selectedArea = '';
      supplierOutstandingProvider.selectedAreaID = 0;
      supplierOutstandingProvider.clearSelectionDate();
      supplierOutstandingProvider.selectedAgeingOn = '';
      _shouldResetState = false;
    }
    double totalInvoiceAmount = 0.00;

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
                      if (supplierOutstandingProvider.ledgerName.isNotEmpty) {
                        _displayPdf();
                      } else {
                        // Show an error message if companyName is null or empty
                        Utilities.showSnackBar(
                            context, "First Select a Ledger", false);
                      }
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
                  hasDataToDisplay
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                          child: Consumer<SupplierOutstandingProvider>(
                            builder: (context, value, child) {
                              var date = DateFormat('yyyy-MM-dd')
                                  .format(value.selectedAsOnDate!);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Ledger Name : ",
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          value.ledgerName,
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
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
                                      Text(
                                        "Date : ",
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                      Text(
                                        date,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              );
                            },
                          ),
                        )
                      : SizedBox(),
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
                                  headingRowColor:
                                      MaterialStateColor.resolveWith(
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
                                            child: _cusOunstandingList
                                                    .isNotEmpty
                                                ? (_fiscalDateList[0]
                                                            .dateMode ==
                                                        "NEP"
                                                    ? Text(
                                                        'Miti',
                                                        style: GoogleFonts.acme(
                                                            color: Colors.white,
                                                            fontSize: 15.sp),
                                                      )
                                                    : Text(
                                                        'Date',
                                                        style: GoogleFonts.acme(
                                                            color: Colors.white,
                                                            fontSize: 15.sp),
                                                      ))
                                                : const SizedBox())),
                                    DataColumn(
                                        label: SizedBox(
                                            child: Text(
                                      'Voucher No.',
                                      style: GoogleFonts.acme(
                                          color: Colors.white, fontSize: 15.sp),
                                    ))),
                                    DataColumn(
                                        label: SizedBox(
                                            child: Text(
                                          'Days',
                                          style: GoogleFonts.acme(
                                              color: Colors.white,
                                              fontSize: 15.sp),
                                        )),
                                        numeric: true),
                                    DataColumn(
                                        label: SizedBox(
                                            child: Text(
                                          'Invoice Amount',
                                          style: GoogleFonts.acme(
                                              color: Colors.white,
                                              fontSize: 15.sp),
                                        )),
                                        numeric: true),
                                    DataColumn(
                                        label: SizedBox(
                                            child: Text(
                                          'Receipt Amount',
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
                                  rows: _cusOunstandingList
                                      .map((outstandingData) {
                                    int index = _cusOunstandingList
                                            .indexOf(outstandingData) +
                                        1;
                                    var a = outstandingData.invoiceAmount;
                                    var b = outstandingData.balance;
                                    var receiptAmount = (a - b);
                                    totalInvoiceAmount = totalInvoiceAmount +
                                        outstandingData.invoiceAmount;
                                    totalBalance = outstandingData.balance;

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
                                              child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  child: _cusOunstandingList
                                                          .isNotEmpty
                                                      ? (_fiscalDateList[0]
                                                                  .dateMode ==
                                                              "NEP"
                                                          ? Text(
                                                              outstandingData
                                                                  .docMiti,
                                                              style: GoogleFonts
                                                                  .aBeeZee(
                                                                      fontSize:
                                                                          14.sp),
                                                            )
                                                          : Text(
                                                              outstandingData
                                                                  .docDate,
                                                              style: GoogleFonts
                                                                  .aBeeZee(
                                                                      fontSize:
                                                                          14.sp),
                                                            ))
                                                      : const SizedBox())))),
                                      DataCell(SizedBox(
                                          child: SizedBox(
                                              child: Text(
                                        outstandingData.docNo,
                                        style: GoogleFonts.aBeeZee(
                                            fontSize: 14.sp),
                                      )))),
                                      DataCell(SizedBox(
                                          child: Text(
                                        outstandingData.docDays.toString(),
                                        style: GoogleFonts.aBeeZee(
                                            fontSize: 14.sp),
                                        textAlign: TextAlign.right,
                                      ))),
                                      DataCell(SizedBox(
                                          child: Text(
                                        outstandingData.invoiceAmount
                                            .toString(),
                                        style: GoogleFonts.aBeeZee(
                                            fontSize: 14.sp),
                                        textAlign: TextAlign.right,
                                      ))),
                                      DataCell(SizedBox(
                                          child: Text(
                                        index == 1 &&
                                                outstandingData
                                                        .ledgerBillPayment ==
                                                    0
                                            ? receiptAmount.toStringAsFixed(2)
                                            : "0.00",
                                        style: GoogleFonts.aBeeZee(
                                            fontSize: 14.sp),
                                        textAlign: TextAlign.right,
                                      ))),
                                      DataCell(SizedBox(
                                          child: Text(
                                        outstandingData.balance.toString(),
                                        style: GoogleFonts.aBeeZee(
                                            fontSize: 14.sp),
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
                                right: 10,
                                bottom: 2,
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Total Invoice Amount :",
                                style: TextStyle(
                                    color: AppColors.kPrimaryColor,
                                    fontFamily: fontFamily,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: 5.sp,
                              ),
                              Text(
                                totalInvoiceAmount.toStringAsFixed(2),
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
                    SizedBox(
                      height: 3.sp,
                    ),
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
              )));
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
          return FractionallySizedBox(
            heightFactor: 0.78,
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
                    padding: EdgeInsets.all(10.0.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0.sp),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "As On",
                                style: GoogleFonts.aBeeZee(
                                    color: Colors.black54, fontSize: 16.sp),
                              ),
                              SizedBox(
                                height: 10.sp,
                              ),
                              Consumer<SupplierOutstandingProvider>(
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
                                          value.selectedAsOnDate =
                                              pickedDateFrom;
                                        });
                                      } else {}
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: AppColors.alternativeColor),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0.sp),
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
                                                  value.selectedAsOnDate != null
                                                      ? DateFormat('yyyy-MM-dd')
                                                          .format(value
                                                              .selectedAsOnDate!)
                                                      : "${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
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
                          padding: EdgeInsets.all(8.0.sp),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Ageing On",
                                style: GoogleFonts.aBeeZee(
                                    color: Colors.black54, fontSize: 16.sp),
                              ),
                              SizedBox(
                                height: 10.sp,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    color: AppColors.alternativeColor),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Consumer<SupplierOutstandingProvider>(
                                        builder: (context, value, child) {
                                          return DropdownButton(
                                            // Initial Value
                                            value: dropdownvalue,
                                            // Down Arrow Icon
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down),

                                            // Array list of items
                                            items: items.map((String items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(items),
                                              );
                                            }).toList(),
                                            // After selecting the desired option,it will
                                            // change button value to selected value
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                dropdownvalue = newValue!;
                                              });
                                            },
                                          );
                                        },
                                      ),
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
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      customerName();
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        color: AppColors.alternativeColor,
                        child: Padding(
                          padding: EdgeInsets.all(10.0.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Consumer<SupplierOutstandingProvider>(
                                key: UniqueKey(),
                                builder: (context, value, child) {
                                  var name = value.ledgerName;
                                  return SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Text(
                                      name.isNotEmpty
                                          ? name
                                          : "Select a Ledger Name",
                                      style: GoogleFonts.adamina(
                                          color: Colors.black, fontSize: 16.sp),
                                    ),
                                  );
                                },
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
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          "MR",
                          style: GoogleFonts.aBeeZee(
                              color: Colors.black54, fontSize: 16.sp),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      InkWell(
                        onTap: () {
                          mr();
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                                  Consumer<SupplierOutstandingProvider>(
                                    key: UniqueKey(),
                                    builder: (context, value, child) {
                                      var name = value.selectedMR;
                                      return SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Text(
                                          name.isNotEmpty ? name : "Select  MR",
                                          style: GoogleFonts.adamina(
                                              color: Colors.black,
                                              fontSize: 16.sp),
                                        ),
                                      );
                                    },
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
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          "Area",
                          style: GoogleFonts.aBeeZee(
                              color: Colors.black54, fontSize: 16.sp),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      InkWell(
                        onTap: () {
                          areaList();
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                                  Consumer<SupplierOutstandingProvider>(
                                    key: UniqueKey(),
                                    builder: (context, value, child) {
                                      var name = value.selectedArea;
                                      return SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Text(
                                          name.isNotEmpty
                                              ? name
                                              : "Select a Area",
                                          style: GoogleFonts.adamina(
                                              color: Colors.black,
                                              fontSize: 16.sp),
                                        ),
                                      );
                                    },
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
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          "Company",
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
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                                  Consumer<SupplierOutstandingProvider>(
                                    key: UniqueKey(),
                                    builder: (context, value, child) {
                                      var name = value.selectedProductCompany;
                                      return SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Text(
                                          name.isNotEmpty
                                              ? name
                                              : "Select a Company",
                                          style: GoogleFonts.adamina(
                                              color: Colors.black,
                                              fontSize: 16.sp),
                                        ),
                                      );
                                    },
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
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: EdgeInsets.all(10.0.sp),
                            child: Consumer<SupplierOutstandingProvider>(
                              builder: (context, value, child) {
                                return CustomButtom(
                                    onPressed: () async {
                                      if (_selectedSupplierModel.ledgerId == 0) {
                                        // Ledger Name not selected
                                        Utilities.showToastMessage(
                                            "Select Supplier", AppColors.warningColor);
                                        return;
                                      }
                  
                                      var selectedDate = value.selectedAsOnDate;
                                      int selectedMR = value.selectedMRID;
                                      int selectedArea = value.selectedAreaID;
                                      int selectedProductCompany =
                                          value.selectedProductCompanyID;
                  
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          });
                                      await Future.delayed(Duration(seconds: 1));
                                      try {
                                        cusOutstandingServices
                                            .getSplrOutstanding(
                                                selectedDate.toString(),
                                                dropdownvalue,
                                                _selectedSupplierModel.ledgerId,
                                                selectedMR,
                                                selectedArea,
                                                selectedProductCompany)
                                            .then((cusOutstandingData) async {
                                          setState(() {
                                            _cusOunstandingList =
                                                cusOutstandingData; // Store the fetched customer data
                                            hasDataToDisplay =
                                                _cusOunstandingList.isNotEmpty;
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
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Padding(
                            padding: EdgeInsets.all(10.0.sp),
                            child: Consumer<SupplierOutstandingProvider>(
                              builder: (context, value, child) {
                                return CustomButtom(
                                    onPressed: () async {
                                       value.clearSelection();
                                       value.selectedMR = '';
                                      value.selectedMRID = 0;
                                      value.selectedProductCompany = '';
                                      value.selectedProductCompanyID = 0;
                                      value.selectedArea = '';
                                      value.selectedAreaID = 0;
                                      value.clearSelectionDate();
                                     value.selectedAgeingOn = '';
   
                                    },
                                    buttonColor: Colors.black38,
                                    buttonText: "Clear",
                                    elevation: 5,
                                    context: context);
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  customerName() {
    var itemProviderCustomerLR =
        Provider.of<SupplierOutstandingProvider>(context, listen: false);
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
                    hintText: 'Select a Customer',
                  ),
                  Expanded(
                    child: _supplierList.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ValueListenableBuilder(
                            valueListenable: searchCusListner,
                            builder: (context, value, child) {
                              return ListView.builder(
                                  itemCount: filterSuppliers(value).length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    SupplierListModelDetails customer =
                                        filterSuppliers(value)[index];
                                    return Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          10.sp, 7.sp, 10.sp, 7.sp),
                                      child: InkWell(
                                        onTap: () async {
                                          setState(() {
                                            // resetSelections();
                                            _selectedSupplierModel = customer;
                                            myService.getproductDetails(
                                                _selectedSupplierModel
                                                    .ledgerId);
                                          });

                                          itemProviderCustomerLR.selectCustomer(
                                            _selectedSupplierModel.ledgerId
                                                .toString(),
                                            _selectedSupplierModel.ledgerName,
                                            _selectedSupplierModel
                                                .ledgerAddress,
                                            _selectedSupplierModel.ledgerPan,
                                          );
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              customer.ledgerName,
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

  mr() {
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
                    hintText: 'Select MR',
                  ),
                  Expanded(
                    child: _supplierList.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ValueListenableBuilder(
                            valueListenable: searchCusListner,
                            builder: (context, value, child) {
                              return ListView.builder(
                                  itemCount: filterMR(value).length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    MrModelDetails mR = filterMR(value)[index];
                                    return Consumer<
                                        SupplierOutstandingProvider>(
                                      builder: (context, value, child) {
                                        return Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10.sp, 7.sp, 10.sp, 7.sp),
                                          child: InkWell(
                                            onTap: () async {
                                              // resetSelections();
                                              value.selectedMR = mR.name;
                                              value.selectedMRID = mR.id;
                                              // ignore: use_build_context_synchronously
                                              Navigator.pop(context);
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  mR.name,
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

  areaList() {
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
                    hintText: 'Select Area',
                  ),
                  Expanded(
                    child: _areaList.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ValueListenableBuilder(
                            valueListenable: searchCusListner,
                            builder: (context, value, child) {
                              return ListView.builder(
                                  itemCount: filterArea(value).length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    AreaModelDetails area =
                                        filterArea(value)[index];
                                    return Consumer<
                                        SupplierOutstandingProvider>(
                                      builder: (context, value, child) {
                                        return Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10.sp, 7.sp, 10.sp, 7.sp),
                                          child: InkWell(
                                            onTap: () async {
                                              // resetSelections();
                                              value.selectedArea = area.name;
                                              value.selectedAreaID = area.id;

                                              // ignore: use_build_context_synchronously
                                              Navigator.pop(context);
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  area.name,
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
                    child: _areaList.isEmpty
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
                                    return Consumer<
                                        SupplierOutstandingProvider>(
                                      builder: (context, value, child) {
                                        return Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10.sp, 7.sp, 10.sp, 7.sp),
                                          child: InkWell(
                                            onTap: () async {
                                              // resetSelections();
                                              value.selectedProductCompany =
                                                  productCompany.companyName;
                                              value.selectedProductCompanyID =
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

  void _displayPdf() async {
    double totalReceiptAmount = 0.00;
    double totalInvoiceAmount = 0.00;

    String companyName = await getCompanyName();
    final doc = pw.Document();

    double font10sp = ScreenUtil().setSp(10.sp);
    double font8sp = ScreenUtil().setSp(8.sp);
    var screenWidth = MediaQuery.of(context).size.width;
    final supplierOutstandingProvider =
        Provider.of<SupplierOutstandingProvider>(context, listen: false);
    var date = DateFormat('yyyy-MM-dd')
        .format(supplierOutstandingProvider.selectedAsOnDate!);
    double availableSpaceOnPage(pw.Context pdfContext) {
      return 600.0.sp;
    }

    // Split the ledger list into chunks
    List<List<CusSplrOutstandingModelDetails>> chunks = [];

    for (int i = 0; i < _cusOunstandingList.length; i += 30) {
      chunks.add(
        _cusOunstandingList.sublist(i, min(i + 30, _cusOunstandingList.length)),
      );
    }

    // Add the title part only once at the beginning
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context pdfContext) {
          List<pw.Widget> ledgerRows = [];

          double availableSpace = availableSpaceOnPage(pdfContext);

          for (var details in _cusOunstandingList) {
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

            int index = _cusOunstandingList.indexOf(details) + 1;
            var a = details.invoiceAmount;
            var b = details.balance;
            var receiptAmount = (a - b);
            var ab = index == 1 && details.ledgerBillPayment == 0
                ? receiptAmount
                : 0.00;
            totalReceiptAmount += ab; // Accumulate the value here
            totalInvoiceAmount = totalInvoiceAmount + details.invoiceAmount;

            ledgerRows.add(
              pw.Padding(
                padding: pw.EdgeInsets.fromLTRB(5.sp, 0, 5.sp, 3.sp),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.SizedBox(
                      width: screenWidth * 0.05,
                      child: pw.Text(
                        index.toString(),
                        style: pw.TextStyle(fontSize: font8sp),
                      ),
                    ),
                    pw.SizedBox(
                      width: screenWidth * 0.18,
                      child: pw.Text(
                        details.docDate,
                        style: pw.TextStyle(fontSize: font8sp),
                      ),
                    ),
                    pw.SizedBox(
                      width: screenWidth * 0.23,
                      child: pw.Text(
                        details.docNo,
                        style: pw.TextStyle(fontSize: font8sp),
                      ),
                    ),
                    pw.SizedBox(
                        width: screenWidth * 0.08,
                        child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Text(
                                details.docDays.toString(),
                                style: pw.TextStyle(fontSize: font8sp),
                              ),
                            ])),
                    pw.SizedBox(
                        width: screenWidth * 0.21,
                        child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Text(
                                details.invoiceAmount.toString(),
                                style: pw.TextStyle(fontSize: font8sp),
                              ),
                            ])),
                    pw.SizedBox(
                        width: screenWidth * 0.22,
                        child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Text(
                                index == 1 && details.ledgerBillPayment == 0
                                    ? receiptAmount.toStringAsFixed(2)
                                    : "0.00",
                                style: pw.TextStyle(fontSize: font8sp),
                              ),
                            ])),
                    pw.SizedBox(
                        width: screenWidth * 0.22,
                        child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Text(
                                details.balance.toString(),
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
                  "Supplier Outstanding Report",
                  style: pw.TextStyle(
                      fontSize: 12.sp, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 2.sp),
                pw.Text(
                  supplierOutstandingProvider.ledgerName,
                  style: pw.TextStyle(
                    fontSize: 12.sp,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 2.sp),
                pw.Text(
                  date,
                  style: pw.TextStyle(
                    fontSize: 12.sp,
                  ),
                ),
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
                        width: screenWidth * 0.05,
                        child: pw.Text(
                          "S.N",
                          style: pw.TextStyle(
                              fontSize: font8sp,
                              fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.SizedBox(
                        width: screenWidth * 0.18,
                        child: pw.Text(
                          "Date/Miti",
                          style: pw.TextStyle(
                              fontSize: font8sp,
                              fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.SizedBox(
                        width: screenWidth * 0.23,
                        child: pw.Text(
                          "Voucher No.",
                          style: pw.TextStyle(
                              fontSize: font8sp,
                              fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.SizedBox(
                          width: screenWidth * 0.08,
                          child: pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                pw.Text(
                                  "Days",
                                  style: pw.TextStyle(
                                      fontSize: font8sp,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              ])),
                      pw.SizedBox(
                          width: screenWidth * 0.21,
                          child: pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                pw.Text(
                                  "Invoice Amount",
                                  style: pw.TextStyle(
                                      fontSize: font8sp,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              ])),
                      pw.SizedBox(
                          width: screenWidth * 0.22,
                          child: pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                pw.Text(
                                  "Receipt Amount",
                                  style: pw.TextStyle(
                                      fontSize: font8sp,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              ])),
                      pw.SizedBox(
                          width: screenWidth * 0.22,
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
                              width: screenWidth * 0.21,
                              child: pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.end,
                                  children: [
                                    pw.Expanded(
                                        child: pw.Align(
                                      alignment: pw.Alignment.bottomRight,
                                      child: pw.Text(
                                          totalInvoiceAmount.toStringAsFixed(2),
                                          style: pw.TextStyle(
                                              fontSize: font10sp,
                                              fontWeight: pw.FontWeight.bold),
                                          softWrap: true),
                                    )),
                                  ])),
                          pw.SizedBox(
                              width: screenWidth * 0.22,
                              child: pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.end,
                                  children: [
                                    pw.Expanded(
                                        child: pw.Align(
                                      alignment: pw.Alignment.bottomRight,
                                      child: pw.Text(
                                          totalReceiptAmount.toStringAsFixed(2),
                                          style: pw.TextStyle(
                                              fontSize: font10sp,
                                              fontWeight: pw.FontWeight.bold),
                                          softWrap: true),
                                    )),
                                  ])),
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
        builder: (context) => PreviewScreenSplrOutstanding(doc: doc),
      ),
    );
  }
}

class PreviewScreenSplrOutstanding extends StatelessWidget {
  final pw.Document doc;

  const PreviewScreenSplrOutstanding({
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
