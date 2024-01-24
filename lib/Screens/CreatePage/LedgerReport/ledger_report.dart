import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:petrolpump/API_Services/get_services_sales.dart';
import 'package:petrolpump/API_Services/ledger_services.dart';
import 'package:petrolpump/API_Services/role_control.dart';
import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/CommonWidgets/constants_text.dart';
import 'package:petrolpump/CommonWidgets/custom_button.dart';
import 'package:petrolpump/CommonWidgets/search_bar.dart';
import 'package:petrolpump/Preference/preference.dart';
import 'package:petrolpump/Provider/ledger_provider.dart';
import 'package:petrolpump/Screens/CreatePage/main_page.dart';
import 'package:petrolpump/Utilities/english_to_nepaliDateConverter.dart';
import 'package:petrolpump/Utilities/utilities.dart';
import 'package:petrolpump/models/LedgerModel/fiscal_date_model.dart';
import 'package:petrolpump/models/LedgerModel/ledger_report_by_id.dart';
import 'package:petrolpump/models/customer_model.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:pdf/widgets.dart' as pw;

class LedgerReport extends StatefulWidget {
  final String title;
  const LedgerReport({super.key, this.title = "Ledger Report",});

  @override
  State<LedgerReport> createState() => _LedgerReportState();
}

class _LedgerReportState extends State<LedgerReport> {
  bool _shouldResetState = true;

  RoleCheckServices roleCheckServices = RoleCheckServices();
  bool isAuthorized = false;
  final pdf = pw.Document();
  late File? file = null;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  LedgerProvider? ledgerDateProvider;
  pdfWidgets.Font? myFontFamily;
  final ScrollController _scrollController = ScrollController();
  bool hasDataToDisplay = false;

  static const fontFamily = "times new roman";
  LedgerService ledgerService = LedgerService();
  MyService myService = MyService();
  LRFiscalDateService lrFiscalDateService = LRFiscalDateService();
  List<CustomerModel> _customerList = [];
  List<LrFiscalDateModelDetails> _fiscalDateList = [];

  List<LedgerReportModelDetails> _ledgerList = [];
  String ledgerOpeningBalance = '';
  double ledgerOpeningDr = 0;
  double ledgerOpeningCr = 0;
  double totalDrAmount = 0;
  double totalCrAmount = 0;
  double currentBalance = 0;
  String currentBlcnString = '0.00';

  final TextEditingController _searchControllerCus = TextEditingController();
  ValueNotifier<String> searchCusListner = ValueNotifier<String>('');
  CustomerModel _selectedCusModel =
      CustomerModel(id: 0, ledgerName: '', address: '', panNo: '');
  List<CustomerModel> filterCustomers(String searchTextCus) {
    return _customerList.where((customer) {
      return customer.ledgerName
          .toLowerCase()
          .contains(searchTextCus.toLowerCase());
    }).toList();
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
    myService.getCustomerName().then((customerData) async {
      setState(() {
        _customerList = customerData; // Store the fetched customer data
      });
    });

    lrFiscalDateService.getFiscalDate().then((fiscalDate) async {
      _fiscalDateList = fiscalDate; // Store the fetched customer data
    });
  }

  Future<String> getCompanyName() async {
    // Retrieve the companyName from preferences or wherever it's stored
    // For example, using the UserPreference class
    String companyName = await UserPreference.getUserPreference(
        ContstantsText.unEncryptedCompanyName);
    return companyName;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
     final ledgerProvider = Provider.of<LedgerProvider>(context);
    if (_shouldResetState) {
      ledgerProvider.ledgerName="";
      ledgerProvider.selectedDateFrom=null;
      ledgerProvider.selectedDateTo=null;
      _shouldResetState = false;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimaryColor,
        leading: DrawerWidget(),
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () async {
                    totalDrAmount = ledgerOpeningDr;
                    totalCrAmount = ledgerOpeningCr;
                    currentBalance = ledgerOpeningDr - ledgerOpeningCr;

                    if (ledgerProvider != null &&
                        ledgerProvider.ledgerName.isNotEmpty) {
                      _displayPdf();
                    } else {
                      // Show an error message if companyName is null or empty
                      Utilities.showSnackBar(
                          context, "First Select a Customer", false);
                    }
                  },
                  icon: const Icon(Icons.picture_as_pdf)),
              IconButton(
                  onPressed: () {
                    filterWidget();
                  },
                  icon: Icon(Feather.filter))
            ],
          )
        ],
      ),
      body: isAuthorized
          ? Container(
              margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Consumer<LedgerProvider>(
                              builder: (context, value, child) {
                                return hasDataToDisplay
                                    ? Row(
                                        children: [
                                           Text(
                                            "Ledger Name : ",
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                          Text(
                                            value.ledgerName,
                                            style:  TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      )
                                    : SizedBox();
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            
                            Consumer<LedgerProvider>(
                                builder: (context, value, child) {
                              String dateString =
                                  "${value.selectedDateFrom != null ? NepaliDateConverter.convertToNepaliDate(value.selectedDateFrom!) : (_fiscalDateList.isNotEmpty ? NepaliDateConverter.convertToNepaliDate(_fiscalDateList[0].finStartDate) : 'N/A')} || ${value.selectedDateTo != null ? NepaliDateConverter.convertToNepaliDate(value.selectedDateTo!) : (_fiscalDateList.isNotEmpty ? NepaliDateConverter.convertToNepaliDate(_fiscalDateList[0].finEndDate) : 'N/A')}";
                              return hasDataToDisplay
                                  ? Row(
                                      children: [
                                        const Text(
                                          "Date Period : ",
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        Consumer<PDFLedgerProvider>(
                                          builder: (context, pdfValue, child) {
                                            pdfValue.selectedDatePeriod =
                                                dateString;
                                            return Text(
                                              dateString,
                                              style:  TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    )
                                  : SizedBox();
                            }),
                            const SizedBox(
                              height: 7,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                 Text(
                                  "Opening Balance :",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      decoration: TextDecoration.underline),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  ledgerOpeningBalance,
                                  style:  TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
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
                                          return Colors.blue.withOpacity(0.3);
                                        }
                                        return Colors.blue; // Default color
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
                                              child: _fiscalDateList.isNotEmpty
                                                  ? (_fiscalDateList[0]
                                                              .dateMode ==
                                                          "NEP"
                                                      ? Text(
                                                          'Miti',
                                                          style:
                                                              GoogleFonts.acme(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15.sp),
                                                        )
                                                      : Text(
                                                          'Date',
                                                          style:
                                                              GoogleFonts.acme(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15.sp),
                                                        ))
                                                  : SizedBox())),
                                      DataColumn(
                                          label: SizedBox(
                                              child: Text(
                                        'Particulars',
                                        style: GoogleFonts.acme(
                                            color: Colors.white, fontSize: 15.sp),
                                      ))),
                                      DataColumn(
                                          label: SizedBox(
                                              child: Text(
                                            'Dr Amt',
                                            style: GoogleFonts.acme(
                                                color: Colors.white,
                                                fontSize: 15.sp),
                                          )),
                                          numeric: true),
                                      DataColumn(
                                          label: SizedBox(
                                              child: Text(
                                            'Cr Amt',
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
                                    rows: _ledgerList.map((ledger) {
                                      int index =
                                          _ledgerList.indexOf(ledger) + 1;

                                      totalDrAmount += ledger.drAmount;
                                      totalCrAmount += ledger.crAmount;
                                      currentBalance +=
                                          ledger.drAmount - ledger.crAmount;
                                      if (currentBalance >= 0) {
                                        currentBlcnString =
                                            "${currentBalance.toStringAsFixed(2)} Dr";
                                      } else {
                                        var creditConvertedToPositive =
                                            currentBalance * (-1);
                                        currentBlcnString =
                                            "${creditConvertedToPositive.toStringAsFixed(2)} Cr";
                                      }
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
                                                    child: _fiscalDateList
                                                            .isNotEmpty
                                                        ? (_fiscalDateList[0]
                                                                    .dateMode ==
                                                                "NEP"
                                                            ? Text(
                                                                ledger.docMiti,
                                                                style: GoogleFonts
                                                                    .aBeeZee(
                                                                        fontSize:
                                                                            14.sp),
                                                              )
                                                            : Text(
                                                                ledger.docDate,
                                                                style: GoogleFonts
                                                                    .aBeeZee(
                                                                        fontSize:
                                                                            14.sp),
                                                              ))
                                                        : const SizedBox())))),
                                        DataCell(SizedBox(
                                            child: SizedBox(
                                                child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Text(
                                            "${ledger.particulars} (${ledger.docNo}) ",
                                            style: GoogleFonts.aBeeZee(
                                                fontSize: 14.sp),
                                          ),
                                        )))),
                                        DataCell(SizedBox(
                                            child: Text(
                                          ledger.drAmount.toString(),
                                          style:
                                              GoogleFonts.aBeeZee(fontSize: 14.sp),
                                          textAlign: TextAlign.right,
                                        ))),
                                        DataCell(SizedBox(
                                            child: Text(
                                          ledger.crAmount.toDouble().toString(),
                                          style:
                                              GoogleFonts.aBeeZee(fontSize: 14.sp),
                                          textAlign: TextAlign.right,
                                        ))),
                                        DataCell(SizedBox(
                                            child: Text(
                                          currentBlcnString,
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
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeInOut,
                                          );
                                        } else {
                                          // If not at the bottom, scroll to the bottom
                                          _scrollController.animateTo(
                                            _scrollController
                                                .position.maxScrollExtent,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: AppColors.kPrimaryColor
                                              .withOpacity(0.6),
                                          shape: StadiumBorder()),
                                      child: const Center(
                                        child: Icon(Entypo.select_arrows),
                                      )))
                              : SizedBox()
                        ]),
                      ),
                    ),

                    
                    Consumer<PDFLedgerProvider>(
                      builder: (context, value, child) {
                        return Column(children: [
                          Padding(
                            padding:  EdgeInsets.only(left: 5.sp, right: 5.sp),
                            child: Container(
                              color: AppColors.alternativeColor,
                              child: Padding(
                                padding:  EdgeInsets.all(10.0.sp),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                     Text(
                                      "Total Debit (Dr) :",
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
                                      value.selectedPdfDr =
                                          totalDrAmount.toStringAsFixed(2),
                                      style:  TextStyle(
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
                            padding:  EdgeInsets.only(left: 5.sp, right: 5.sp),
                            child: Container(
                              color: AppColors.alternativeColor,
                              child: Padding(
                                padding:  EdgeInsets.all(10.0.sp),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                     Text(
                                      "Total Credit (Cr) :",
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
                                      value.selectedPdfCr =
                                          totalCrAmount.toStringAsFixed(2),
                                      style:  TextStyle(
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
                            padding:  EdgeInsets.only(left: 5.sp, right: 5.sp),
                            child: Container(
                              color: AppColors.alternativeColor,
                              child: Padding(
                                padding:  EdgeInsets.all(10.0.sp),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      currentBlcnString,
                                      style:  TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.sp,
                                          fontFamily: fontFamily),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]);
                      },
                    ),
                  ],
                ),
              ),
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
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.sp), topRight: Radius.circular(20.sp))),
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.only(top: 20.sp, bottom: 10.sp),
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
                    padding:  EdgeInsets.all(10.0.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding:  EdgeInsets.all(10.0.sp),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Date From",
                                style: GoogleFonts.aBeeZee(
                                    color: Colors.black54, fontSize: 16.sp),
                              ),
                               SizedBox(
                                height: 10.sp,
                              ),
                              Consumer<LedgerProvider>(
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
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: AppColors.alternativeColor),
                                      child: Padding(
                                        padding:  EdgeInsets.all(8.0.sp),
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
                                                          .format(value
                                                              .selectedDateFrom!)
                                                      : DateFormat('yyyy-MM-dd')
                                                          .format(
                                                              _fiscalDateList[0]
                                                                  .finStartDate),
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
                          padding:  EdgeInsets.all(8.0.sp),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Date To",
                                style: GoogleFonts.aBeeZee(
                                    color: Colors.black54, fontSize: 16.sp),
                              ),
                               SizedBox(
                                height: 10.sp,
                              ),
                              Consumer<LedgerProvider>(
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
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: AppColors.alternativeColor),
                                      child: Padding(
                                        padding:  EdgeInsets.all(8.0.sp),
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
                                                          .format(value
                                                              .selectedDateTo!)
                                                      : DateFormat('yyyy-MM-dd')
                                                          .format(
                                                              _fiscalDateList[0]
                                                                  .finEndDate),
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
                  InkWell(
                    onTap: () {
                      customerName();
                    },
                    child: Padding(
                      padding:  EdgeInsets.all(20.0.sp),
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        color: AppColors.alternativeColor,
                        child: Padding(
                          padding:  EdgeInsets.all(10.0.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Consumer<LedgerProvider>(
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
                    height: 20,
                  ),
            
                  Padding(
                    padding:  EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.45,
                          child: Padding(
                            padding:  EdgeInsets.all(10.0.sp),
                            child: Consumer<LedgerProvider>(
                              builder: (context, value, child) {
                                return CustomButtom(
                                    onPressed: () async {
                                      if (_selectedCusModel.id == 0) {
                                        // Ledger Name not selected
                                        Utilities.showToastMessage("Select a Ledger Name",
                                            AppColors.warningColor);
                                        return;
                                      }
                                    
                                      String formattedFromDate = value.selectedDateFrom !=
                                              null
                                          ? DateFormat('yyyy-MM-dd')
                                              .format(value.selectedDateFrom!)
                                          : DateFormat('yyyy-MM-dd')
                                              .format(_fiscalDateList[0].finStartDate);
                                    
                                      String formattedToDate =
                                          value.selectedDateTo != null
                                              ? DateFormat('yyyy-MM-dd')
                                                  .format(value.selectedDateTo!)
                                              : DateFormat('yyyy-MM-dd')
                                                  .format(_fiscalDateList[0].finEndDate);
                                    
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          });
                                    
                                      try {
                                        var ledgerData =
                                            await ledgerService.getLedgerById(
                                                _selectedCusModel.id,
                                                formattedFromDate,
                                                formattedToDate);
                                    
                                        setState(() {
                                          _ledgerList = ledgerData
                                              .where((element) =>
                                                  element.particulars != 'Opening')
                                              .toList();
                                          var ledgerOpening = ledgerData
                                              .where((element) =>
                                                  element.particulars == 'Opening')
                                              .firstOrNull;
                                    
                                          hasDataToDisplay = _ledgerList.isNotEmpty;
                                          
                                          ledgerOpeningDr = ledgerOpening!.drAmount;
                                          ledgerOpeningCr = ledgerOpening.crAmount;
                                          var diffAmount = ledgerOpening.drAmount -
                                              ledgerOpening.crAmount;
                                    
                                          totalDrAmount = ledgerOpeningDr;
                                          totalCrAmount = ledgerOpeningCr;
                                          currentBalance =
                                              ledgerOpeningDr - ledgerOpeningCr;
                                    
                                          if (diffAmount > 0) {
                                            ledgerOpeningBalance = "$diffAmount Dr";
                                          } else {
                                            ledgerOpeningBalance = "$diffAmount Cr";
                                          }
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
                          width: MediaQuery.of(context).size.width*0.45,
                          child: Padding(
                            padding:  EdgeInsets.all(10.0.sp),
                            child: Consumer<LedgerProvider>(
                              builder: (context, value, child) {
                                return CustomButtom(
                                    onPressed: () async {
                                     value.ledgerName="";
                                     value.selectedDateFrom=null;
                                    value.selectedDateTo=null;
                                    },
                                    buttonColor: Colors.black38,
                                    buttonText: "Clear",
                                    elevation: 5,
                                    context: context);
                              },
                            ),
                          ),
                        ),
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
        Provider.of<LedgerProvider>(context, listen: false);
    showModalBottomSheet(
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.sp), topRight: Radius.circular(20.sp))),
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Padding(
              padding:  EdgeInsets.fromLTRB(10.sp, 10.sp, 10.sp, 0),
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
                    child: _customerList.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ValueListenableBuilder(
                            valueListenable: searchCusListner,
                            builder: (context, value, child) {
                              return ListView.builder(
                                  itemCount: filterCustomers(value).length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    CustomerModel customer =
                                        filterCustomers(value)[index];
                                    return Padding(
                                      padding:  EdgeInsets.fromLTRB(
                                          10.sp, 7.sp, 10.sp, 7.sp),
                                      child: InkWell(
                                        onTap: () async {
                                          setState(() {
                                            // resetSelections();
                                            _selectedCusModel = customer;
                                            myService.getproductDetails(
                                                _selectedCusModel.id);
                                          });

                                          itemProviderCustomerLR.selectCustomer(
                                            _selectedCusModel.id.toString(),
                                            _selectedCusModel.ledgerName,
                                            _selectedCusModel.address,
                                            _selectedCusModel.panNo,
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

  void _displayPdf() async {
    String companyName = await getCompanyName();
    final doc = pw.Document();
    final pdfLedgerDateProvider =
        Provider.of<PDFLedgerProvider>(context, listen: false);
    double font10sp = ScreenUtil().setSp(10.sp);
    double font8sp = ScreenUtil().setSp(8.sp);
    var screenWidth = MediaQuery.of(context).size.width;
    final ledgerProvider =
        Provider.of<LedgerProvider>(context, listen: false);

    // Function to calculate available space on a page
    double availableSpaceOnPage(pw.Context pdfContext) {
      // Implement the logic to calculate available space based on page size
      // This is just a placeholder; you should replace it with your own implementation
      return 600.0.sp; // Adjust this value based on your needs
    }

    // Split the ledger list into chunks
    List<List<LedgerReportModelDetails>> chunks = [];

    for (int i = 0; i < _ledgerList.length; i += 30) {
      chunks.add(
        _ledgerList.sublist(i, min(i + 30, _ledgerList.length)),
      );
    }

    // Add the title part only once at the beginning
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context pdfContext) {
          List<pw.Widget> ledgerRows = [];

          double availableSpace = availableSpaceOnPage(pdfContext);

          for (var details in _ledgerList) {
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

            currentBalance += details.drAmount - details.crAmount;
            int index = _ledgerList.indexOf(details) + 1;
            String currentBlcnString;
            if (currentBalance >= 0) {
              currentBlcnString = "${currentBalance.toStringAsFixed(2)} Dr";
            } else {
              var creditConvertedToPositive = currentBalance * (-1);
              currentBlcnString =
                  "${creditConvertedToPositive.toStringAsFixed(2)} Cr";
            }

            ledgerRows.add(
              pw.Padding(
                padding:  pw.EdgeInsets.fromLTRB(5.sp, 0, 5.sp, 3.sp),
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
                      width: screenWidth * 0.35,
                      child: pw.Text(
                        "${details.particulars} (${details.docNo})",
                        style: pw.TextStyle(fontSize: font8sp),
                      ),
                    ),
                    pw.SizedBox(
                        width: screenWidth * 0.16,
                        child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Text(
                                details.drAmount.toString(),
                                style: pw.TextStyle(fontSize: font8sp),
                              ),
                            ])),
                    pw.SizedBox(
                        width: screenWidth * 0.16,
                        child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Text(
                                details.crAmount.toString(),
                                style: pw.TextStyle(fontSize: font8sp),
                              ),
                            ])),
                    pw.SizedBox(
                        width: screenWidth * 0.26,
                        child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Text(
                                currentBlcnString,
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
                pw.SizedBox(height: 2.sp),
                pw.Text(
                  ledgerProvider.ledgerName,
                  style: pw.TextStyle(
                    fontSize: 12.sp,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 2.sp),
                pw.Text(
                  "Period (${pdfLedgerDateProvider.pdfDatePeriod})",
                  style: pw.TextStyle(fontSize: 12.sp),
                ),
                pw.SizedBox(height: 4.sp),
                pw.Container(
                  color: PdfColor.fromInt(0xFF000111),
                  child: pw.Padding(
                    padding: pw.EdgeInsets.fromLTRB(5.sp, 3.sp, 5.sp, 3.sp),
                    child: pw.Text(
                      "Opening Balance : ${ledgerOpeningBalance}",
                      style: pw.TextStyle(
                        fontSize: 12.sp,
                        color: PdfColor.fromInt(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
                pw.SizedBox(height: 4.sp),
                pw.Divider(thickness: 1),
              ],
            ),

            // Ledger rows
            pw.Padding(
              padding:  pw.EdgeInsets.fromLTRB(5.sp, 3.sp, 5.sp, 3.sp),
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
                          "Date",
                          style: pw.TextStyle(
                              fontSize: font8sp,
                              fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.SizedBox(
                        width: screenWidth * 0.35,
                        child: pw.Text(
                          "Particulars",
                          style: pw.TextStyle(
                              fontSize: font8sp,
                              fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.SizedBox(
                          width: screenWidth * 0.16,
                          child: pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                pw.Text(
                                  "Debit",
                                  style: pw.TextStyle(
                                      fontSize: font8sp,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              ])),
                      pw.SizedBox(
                          width: screenWidth * 0.16,
                          child: pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                pw.Text(
                                  "Credit",
                                  style: pw.TextStyle(
                                      fontSize: font8sp,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              ])),
                      pw.SizedBox(
                          width: screenWidth * 0.26,
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
                      padding:  pw.EdgeInsets.all(5.sp),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.SizedBox(
                            width: screenWidth * 0.58,
                            child: pw.Text(
                              "Total :",
                              style: pw.TextStyle(fontSize: font10sp),
                            ),
                          ),
                          pw.SizedBox(
                              width: screenWidth * 0.16,
                              child: pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.end,
                                  children: [
                                    pw.Expanded(
                                        child: pw.Align(
                                      alignment: pw.Alignment.bottomRight,
                                      child: pw.Text(
                                          pdfLedgerDateProvider.pdfDrTotal
                                              .toString(),
                                          style: pw.TextStyle(
                                              fontSize: font10sp,
                                              fontWeight: pw.FontWeight.bold),
                                          softWrap: true),
                                    )),
                                  ])),
                          pw.SizedBox(
                              width: screenWidth * 0.16,
                              child: pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.end,
                                  children: [
                                    pw.Expanded(
                                        child: pw.Align(
                                      alignment: pw.Alignment.bottomRight,
                                      child: pw.Text(
                                          pdfLedgerDateProvider.pdfCrTotal
                                              .toString(),
                                          style: pw.TextStyle(
                                              fontSize: font10sp,
                                              fontWeight: pw.FontWeight.bold),
                                          softWrap: true),
                                    )),
                                  ])),
                          pw.SizedBox(
                              width: screenWidth * 0.26,
                              child: pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.end,
                                  children: [
                                    pw.Expanded(
                                        child: pw.Align(
                                      alignment: pw.Alignment.bottomRight,
                                      child: pw.Text(currentBlcnString,
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
        builder: (context) => PreviewScreen(doc: doc),
      ),
    );
  }
}

class PreviewScreen extends StatelessWidget {
  final pw.Document doc;

  const PreviewScreen({
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
