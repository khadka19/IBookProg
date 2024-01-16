import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/CommonWidgets/custom_button.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:petrolpump/Provider/all_provider.dart';
import 'package:petrolpump/Utilities/utilities.dart';
import 'package:petrolpump/models/PostModel/invoice_model.dart';
import 'package:petrolpump/models/customer_model.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


class RemarksForm extends StatefulWidget {
  const RemarksForm({super.key});
  @override
  State<RemarksForm> createState() => _RemarksFormState();
}

class _RemarksFormState extends State<RemarksForm> {
  pdfWidgets.Font? myFontFamily; 
  
  Future<void> loadFont() async {
    final ByteData fontData = await rootBundle.load("assets/fonts/times new roman.ttf");
    myFontFamily = pdfWidgets.Font.ttf(fontData.buffer.asByteData());
    // Once the font is loaded, trigger a rebuild
    if (mounted) {
      setState(() {});
    }
  }
  double font10=ScreenUtil().setSp(10);
   double font12=ScreenUtil().setSp(12);
    double font13=ScreenUtil().setSp(13);
    double font14=ScreenUtil().setSp(14);
    double font15=ScreenUtil().setSp(15);
    double font16=ScreenUtil().setSp(16);
    double font17=ScreenUtil().setSp(17);
    double paddingVerySmall=ScreenUtil().screenWidth*0.025;
    double paddingSmall=ScreenUtil().screenWidth*0.05;
    double paddingBig=ScreenUtil().screenWidth*0.1;



  void resetSelections() {
    context.read<ProductProvider>().removeProductList();
    context.read<ProductProvider>().clearSelection();
    context.read<DataRowProvider>().clearDataRowSelection();
  }
  final CustomerModel itemCustomer =
      CustomerModel(id: 0, address: '', ledgerName: '', panNo: '');

  void clearSelectedProduct() {}

  @override
  Widget build(BuildContext context) {
    final salesProvider = context.watch<SalesProvider>();
    final customerProvider = context.watch<CustomerProvider>();

    return Padding(
        padding:  EdgeInsets.all(10.0.sp),
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
                  await loadFont();
                  var response = await salesProvider.postSalesData(
                      customerProvider.cusId, _feedbackController.text);
                  if (!response.success) {
                    Utilities.showToastMessage(response.message, Colors.red);
                  } else {
                    Utilities.showToastMessage(response.message, Colors.green);
                    final pdf = _generateAndSavePDF(response.data);

                    await Printing.layoutPdf(onLayout: (_) => pdf.save());
                    resetSelections();
                  }
                } catch (e) {
                  Utilities.showToastMessage(e.toString(), Colors.green);
                }
              },
            ),
          ],
        ));
  }

  final TextEditingController _feedbackController = TextEditingController();

  pdfWidgets.Document _generateAndSavePDF(InvoiceData invoiceData) {
     double customWidthInMM = 58.0.sp; // Replace with your desired width
 double customHeightInMM = 150.0.sp; // Replace with your desired height

// Convert millimeters to points
 double customWidthInPoints = customWidthInMM * (1 / 25.4) * 72.0;
 double customHeightInPoints = customHeightInMM * (1 / 25.4) * 72.0;
    final pdf = pdfWidgets.Document();

    pdf.addPage(
      pdfWidgets.Page(
       pageTheme: const pdfWidgets.PageTheme(),
        build: (pdfWidgets.Context context) {
          return pdfWidgets.Column(
            children: [
              bodyContent(
                invoiceData,
              ),
            ],
          );
        },
      ),
    );
    return pdf;
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  // Use pdfWidgets to build the content for the PDF
  pdfWidgets.Widget bodyContent(InvoiceData invoiceData) {
    // Get the current date
    DateTime currentDate = DateTime.now();
    DateTime currentTime = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    String formattedTime = DateFormat('h:mm a').format(currentTime);

    // final companyProvider = Provider.of<CompanyProvider>(context, listen: false);
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);
    return pdfWidgets.Container(
      decoration: pdfWidgets.BoxDecoration(border: pdfWidgets.Border.all()),
      child: pdfWidgets.Padding(
        padding:  pdfWidgets.EdgeInsets.all(20.sp),
        child: pdfWidgets.Column(
          mainAxisAlignment: pdfWidgets.MainAxisAlignment.start,
          crossAxisAlignment: pdfWidgets.CrossAxisAlignment.start,
          children: [
            pdfWidgets.Column(
              mainAxisAlignment: pdfWidgets.MainAxisAlignment.start,
              children: [
                pdfWidgets.Text("Tax Invoice",
                style:  pdfWidgets.TextStyle(fontSize: font16,font: myFontFamily,
                decoration: pdfWidgets.TextDecoration.underline)),
                pdfWidgets.SizedBox(height: 10.sp),
                pdfWidgets.Text(
                  invoiceData.companyName,
                  style:  pdfWidgets.TextStyle(
                    fontSize: font14,font: myFontFamily,
                  ),
                ),
                pdfWidgets.SizedBox(
                  height: 5.sp,
                ),
                pdfWidgets.Text(
                  customerProvider.address,
                  style:  pdfWidgets.TextStyle(fontSize: font13,font: myFontFamily,),
                ),
                pdfWidgets.SizedBox(
                  height: 4.sp,
                ),
               
                pdfWidgets.Text(
                  customerProvider.panNo,
                  style:  pdfWidgets.TextStyle(fontSize: font12,font: myFontFamily,),
                ),
                pdfWidgets.SizedBox(
                  height: 4.sp,
                ),
                pdfWidgets.Divider(
                  thickness: 1.sp,
                )
              ],
            ),
            pdfWidgets.Column(
              children: [
                pdfWidgets.Row(
                  mainAxisAlignment: pdfWidgets.MainAxisAlignment.spaceBetween,
                  children: [
                    pdfWidgets.Text(
                      "Invoice No: ${invoiceData.invoiceNo}",
                      style:  pdfWidgets.TextStyle(fontSize: font12,font: myFontFamily,),
                    ),
                    pdfWidgets.Text(
                      "Invoice Date : ${invoiceData.invoiceDate}",
                      style:  pdfWidgets.TextStyle(fontSize: font12,font: myFontFamily,),
                    ),
                  ],
                ),
                pdfWidgets.SizedBox(
                  height: 4.sp,
                ),
                pdfWidgets.Row(
                  mainAxisAlignment: pdfWidgets.MainAxisAlignment.spaceBetween,
                  children: [
                    pdfWidgets.Text(
                      "Customer Name : ${invoiceData.customerName}",
                      style:  pdfWidgets.TextStyle(fontSize: font12,font: myFontFamily,),
                    ),
                    pdfWidgets.Text(
                      "Invoice Miti : ${invoiceData.invoiceMiti}",
                      style:  pdfWidgets.TextStyle(fontSize: font12,font: myFontFamily,),
                    ),
                  ],
                ),
                pdfWidgets.SizedBox(
                  height: 4.sp,
                ),
                pdfWidgets.Row(
                  mainAxisAlignment: pdfWidgets.MainAxisAlignment.spaceBetween,
                  children: [
                    pdfWidgets.Text(
                      "Customer Address : ${invoiceData.customerAddress}",
                      style:  pdfWidgets.TextStyle(fontSize: font12,font: myFontFamily,),
                    ),
                    pdfWidgets.Text(
                      "",
                    ),
                  ],
                ),
                pdfWidgets.SizedBox(
                  height: 4.sp,
                ),
                pdfWidgets.Row(
                  mainAxisAlignment: pdfWidgets.MainAxisAlignment.spaceBetween,
                  children: [
                    pdfWidgets.Text(
                      "Customer PAN : ${invoiceData.customerPan}",
                      style:  pdfWidgets.TextStyle(fontSize: font12,font: myFontFamily,),
                    ),
                    pdfWidgets.Text(
                      "",
                    ),
                  ],
                ),
                pdfWidgets.SizedBox(
                  height: 4.sp,
                ),
                pdfWidgets.Row(
                  mainAxisAlignment: pdfWidgets.MainAxisAlignment.spaceBetween,
                  children: [
                    pdfWidgets.Text(
                      "Payment Mode : ${invoiceData.paymode}",
                      style:  pdfWidgets.TextStyle(fontSize: font12,font: myFontFamily,),
                    ),
                    pdfWidgets.Text(
                      "",
                    ),
                  ],
                ),
              ],
            ),
            pdfWidgets.SizedBox(
              height: 10.sp,
            ),
            table(invoiceData.details, invoiceData),
            pdfWidgets.Padding(
              padding:  pdfWidgets.EdgeInsets.all(10.0.sp),
              child:
              
               pdfWidgets.Text("Remarks : ${invoiceData.remarks}",
                  style:  pdfWidgets.TextStyle(fontSize: font13,
                  font: myFontFamily,
                  ),
                  textAlign: pdfWidgets.TextAlign.start,
                  maxLines: 2,
                  
                  ),
            ),
            pdfWidgets.SizedBox(
              height: 10.sp,
            ),
            pdfWidgets.Column(
              mainAxisAlignment: pdfWidgets.MainAxisAlignment.start,
              crossAxisAlignment: pdfWidgets.CrossAxisAlignment.start,
              children: [
                pdfWidgets.Padding(
                  padding:  pdfWidgets.EdgeInsets.all(10.0.sp),
                  child: pdfWidgets.Row(
                    mainAxisAlignment:
                        pdfWidgets.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pdfWidgets.CrossAxisAlignment.start,
                    children: [
                      pdfWidgets.Expanded(
                          child: pdfWidgets.Divider(
                        thickness: 1.sp,
                      )),
                      pdfWidgets.SizedBox(
                        width: 50.sp,
                      ),
                      pdfWidgets.Expanded(
                          child: pdfWidgets.Divider(
                        thickness: 1.sp,
                      ))
                    ],
                  ),
                ),
                pdfWidgets.Padding(
                  padding:  pdfWidgets.EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 10.sp),
                  child: pdfWidgets.Row(
                    mainAxisAlignment:
                        pdfWidgets.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pdfWidgets.CrossAxisAlignment.start,
                    children: [
                      pdfWidgets.Expanded(
                          child: pdfWidgets.Text(
                        "Received by :",
                        style:  pdfWidgets.TextStyle(fontSize: font13,font: myFontFamily,),
                      )),
                      pdfWidgets.SizedBox(
                        width: 50.sp,
                      ),
                      pdfWidgets.Expanded(
                          child: pdfWidgets.Text(
                        invoiceData.companyName,
                        textAlign: pdfWidgets.TextAlign.right,
                        style:  pdfWidgets.TextStyle(fontSize: font13,font: myFontFamily,),
                      ))
                    ],
                  ),
                )
              ],
            ),
            pdfWidgets.Padding(
              padding:  pdfWidgets.EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 0),
              child: pdfWidgets.Row(
                mainAxisAlignment: pdfWidgets.MainAxisAlignment.spaceBetween,
                children: [
                  pdfWidgets.Text(
                    "Print Date : $formattedDate $formattedTime",
                    style:  pdfWidgets.TextStyle(fontSize: font13,font: myFontFamily,),
                  ),
                  pdfWidgets.Text("")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  pdfWidgets.Widget table(
      List<InvoiceDetail> invoiceDetails, InvoiceData invoiceData) {
    var cellStyle = pdfWidgets.TextStyle(fontSize: font13,font: myFontFamily,);
    var columnHeaderStyle = pdfWidgets.TextStyle(
      fontSize: font13,font: myFontFamily,
    );

    return pdfWidgets.Container(
      decoration: pdfWidgets.BoxDecoration(border: pdfWidgets.Border.all()),
      child: pdfWidgets.Padding(
        padding:  pdfWidgets.EdgeInsets.fromLTRB(10.sp, 5.sp, 10.sp, 5.sp),
        child: pdfWidgets.Column(children: [
          pdfWidgets.Row(
            crossAxisAlignment: pdfWidgets.CrossAxisAlignment.end,
            mainAxisAlignment: pdfWidgets.MainAxisAlignment.spaceBetween,
            children: [
              pdfWidgets.SizedBox(
                  width: 130.sp,
                  child: pdfWidgets.Text(
                    "Particulars",
                    style:  pdfWidgets.TextStyle(fontSize: font13,font: myFontFamily,)
                  )),
              pdfWidgets.SizedBox(width: 5.sp),
              _buildColumnHeader("Unit", columnHeaderStyle),
              _buildColumnHeader("Quantity", columnHeaderStyle),
              _buildColumnHeader("Rate", columnHeaderStyle),
              _buildColumnHeader(
                "Amount",
                columnHeaderStyle,
              ),
            ],
          ),
          pdfWidgets.Divider(thickness: 2.sp),
          pdfWidgets.SizedBox(
            height: 7.sp,
          ),
          for (var details in invoiceDetails)
            pdfWidgets.Padding(
              padding:  pdfWidgets.EdgeInsets.only(bottom: 5.sp),
              child: pdfWidgets.Row(
                mainAxisAlignment: pdfWidgets.MainAxisAlignment.spaceBetween,
                children: [
                  pdfWidgets.SizedBox(
                    width: 130.sp,
                    child: pdfWidgets.Text(
                      details.particulars,
                      style:  pdfWidgets.TextStyle(fontSize: 13.sp,font: myFontFamily,)
                    ),
                  ),
                  pdfWidgets.SizedBox(width: 5.sp),
                  _buildCell(details.unit, cellStyle),
                  _buildCell(details.quantity.toStringAsFixed(2), cellStyle),
                  _buildCell(details.rate.toStringAsFixed(2), cellStyle),
                  _buildCell(details.amount.toStringAsFixed(2), cellStyle),
                ],
              ),
            ),


            
          pdfWidgets.Divider(thickness: 1.sp),
          pdfWidgets.SizedBox(height: 5.sp),
          pdfWidgets.Row(
              mainAxisAlignment: pdfWidgets.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pdfWidgets.CrossAxisAlignment.start,
              children: [
                pdfWidgets.Text(""),
                pdfWidgets.Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: pdfWidgets.Column(
                      children: [
                        pdfWidgets.Row(
                          mainAxisAlignment:
                              pdfWidgets.MainAxisAlignment.spaceBetween,
                          children: [
                            _buildRowHeader(
                                "Gross Amount  ", columnHeaderStyle),
                            pdfWidgets.Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: pdfWidgets.Row(
                                  mainAxisAlignment: pdfWidgets.MainAxisAlignment.spaceBetween,
                                  children: [
                                  pdfWidgets.Text(":",style: pdfWidgets.TextStyle(font: myFontFamily,fontSize: font13)),
                                  pdfWidgets.Text(
                                      invoiceData.grossAmount
                                          .toStringAsFixed(2),
                                          style: pdfWidgets.TextStyle(font: myFontFamily),
                                      textAlign: pdfWidgets.TextAlign.right),
                                ]))
                          ],
                        ),
                        pdfWidgets.SizedBox(
                          height: 5.sp,
                        ),
                        pdfWidgets.Row(
                          mainAxisAlignment:
                              pdfWidgets.MainAxisAlignment.spaceBetween,
                          children: [
                            _buildRowHeader("Discount  ", columnHeaderStyle),
                            pdfWidgets.Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: pdfWidgets.Row(
                                  mainAxisAlignment: pdfWidgets.MainAxisAlignment.spaceBetween,
                                  
                                  children: [
                                  pdfWidgets.Text(":",style: pdfWidgets.TextStyle(font: myFontFamily,fontSize: font13)),
                                  pdfWidgets.Text(
                                     0
                                          .toStringAsFixed(2), style: pdfWidgets.TextStyle(font: myFontFamily),
                                      textAlign: pdfWidgets.TextAlign.right),
                                ]))
                          ],
                        ),
                        pdfWidgets.SizedBox(height: 5.sp),
                        pdfWidgets.Row(
                            mainAxisAlignment:
                                pdfWidgets.MainAxisAlignment.spaceBetween,
                            children: [
                              _buildRowHeader(
                                  "Taxable Amount  ", columnHeaderStyle),
                              pdfWidgets.Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: pdfWidgets.Row(
                                  mainAxisAlignment: pdfWidgets.MainAxisAlignment.spaceBetween,
                                  children: [
                                  pdfWidgets.Text(":",style: pdfWidgets.TextStyle(font: myFontFamily,fontSize: font13)),
                                  pdfWidgets.Text(
                                      invoiceData.taxableAmount
                                          .toStringAsFixed(2), style: pdfWidgets.TextStyle(font: myFontFamily),
                                      textAlign: pdfWidgets.TextAlign.right),
                                ]))
                            ]),
                        pdfWidgets.SizedBox(height: 5.sp),
                        pdfWidgets.Row(
                            mainAxisAlignment:
                                pdfWidgets.MainAxisAlignment.spaceBetween,
                            children: [
                              _buildRowHeader("VAT 13%  ", columnHeaderStyle),
                             pdfWidgets.Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: pdfWidgets.Row(
                                  mainAxisAlignment: pdfWidgets.MainAxisAlignment.spaceBetween,
                                  
                                  children: [
                                  pdfWidgets.Text(":",style: pdfWidgets.TextStyle(font: myFontFamily,fontSize: font13)),
                                  pdfWidgets.Text(
                                      invoiceData.vatAmount
                                          .toStringAsFixed(2), style: pdfWidgets.TextStyle(font: myFontFamily),
                                      textAlign: pdfWidgets.TextAlign.right),
                                ]))
                            ]),
                        pdfWidgets.SizedBox(height: 5.sp),
                        pdfWidgets.Row(
                            mainAxisAlignment:
                                pdfWidgets.MainAxisAlignment.spaceBetween,
                            children: [
                              _buildRowHeader("Grand Total", columnHeaderStyle),
                              pdfWidgets.Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: pdfWidgets.Row(
                                  mainAxisAlignment: pdfWidgets.MainAxisAlignment.spaceBetween,
                                  
                                  children: [
                                  pdfWidgets.Text(":",style: pdfWidgets.TextStyle(font: myFontFamily,fontSize: font13)),
                                  pdfWidgets.Text(
                                      invoiceData.grandTotal
                                          .toStringAsFixed(2), style: pdfWidgets.TextStyle(font: myFontFamily),
                                      textAlign: pdfWidgets.TextAlign.right),
                                ]))
                            ]),
                        pdfWidgets.SizedBox(height: 5.sp),
                      ],
                    ))
              ])
        ]),
      ),
    );
  }

  pdfWidgets.Widget _buildColumnHeader(String text, pdfWidgets.TextStyle style,
      {double width = 150}) {
    return pdfWidgets.Container(
      width: MediaQuery.of(context).size.width *
          0.17, // Specify your desired width here
      child: pdfWidgets.Text(text,
           style: pdfWidgets.TextStyle(font: myFontFamily), textAlign: pdfWidgets.TextAlign.right),
    );
  }

  pdfWidgets.Widget _buildCell(String text, pdfWidgets.TextStyle style,
      {double width = 150}) {
    return pdfWidgets.Container(
      width: MediaQuery.of(context).size.width *
          0.17, // Specify your desired width here
      child: pdfWidgets.Text(text,
          style: pdfWidgets.TextStyle(font: myFontFamily), textAlign: pdfWidgets.TextAlign.right,),
    );
  }

  pdfWidgets.Widget _buildRowHeader(
    String text,
    pdfWidgets.TextStyle style,
  ) {
    return pdfWidgets.Container(
      width: MediaQuery.of(context).size.width *
          0.25, // Specify your desired width here
      child: pdfWidgets.Text(text, style: pdfWidgets.TextStyle(font: myFontFamily)),
    );
  }

}