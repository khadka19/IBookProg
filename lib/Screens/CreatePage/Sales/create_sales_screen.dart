import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petrolpump/API_Services/get_services_sales.dart';
import 'package:petrolpump/API_Services/role_control.dart';
import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/CommonWidgets/search_bar.dart';
import 'package:petrolpump/Provider/all_provider.dart';
import 'package:petrolpump/Screens/CreatePage/Sales/custom_customer_class.dart';
import 'package:petrolpump/Screens/CreatePage/Sales/custom_productList_class.dart';
import 'package:petrolpump/Screens/CreatePage/Sales/custom_product_class.dart';
import 'package:petrolpump/Screens/CreatePage/main_page.dart';
import 'package:petrolpump/Utilities/utilities.dart';
import 'package:petrolpump/models/customer_model.dart';
import 'package:petrolpump/models/data_table_model.dart';
import 'package:petrolpump/models/product_model.dart';
import 'package:provider/provider.dart';

class CreateSalesScreen extends StatefulWidget {
  final String title;

  const CreateSalesScreen({
    Key? key,
    this.title = "Create Order",
  }) : super(key: key);

  @override
  State<CreateSalesScreen> createState() => _CreateSalesScreenState();
}

class _CreateSalesScreenState extends State<CreateSalesScreen> {
  RoleCheckServices roleCheckServices=RoleCheckServices();
 bool isAuthorized=false;
  late bool _shouldResetState = true;
  bool isLoading = false; // Flag to track loading state

  double totalAmount = 0;
  final TextEditingController _searchControllerCus = TextEditingController();
  final TextEditingController _searchControllerPro = TextEditingController();

  ValueNotifier<String> searchCusListner = ValueNotifier<String>('');
  ValueNotifier<String> searchProListner = ValueNotifier<String>('');

  List<CustomerModel> filterCustomers(String searchTextCus) {
    return _customerList.where((customer) {
      return customer.ledgerName
          .toLowerCase()
          .contains(searchTextCus.toLowerCase());
    }).toList();
  }

  List<ProductModel> filterProducts(String searchText) {
    return _productList.where((product) {
      return product.productName
          .toLowerCase()
          .contains(searchText.toLowerCase());
    }).toList();
  }

  void clear() {
    context.read<ProductProvider>().hideContent();
  }

  void resetSelections() {
    _selectedCustomer = "Select a Customer";
    _selectedProduct = "Select a Product";
    totalAmount = 0;
    context.read<ProductProvider>().hideContent();
    context.read<DataRowProvider>().clearDataRowSelection();
  }

  final CustomerModel itemCustomer =
      CustomerModel(id: 0, address: '', ledgerName: '', panNo: '');

  String _selectedCustomer = "Select a Customer";
  String _selectedProduct = "Select a Product";

  void clearSelectedProduct() {
    _selectedProduct = "";
    _selectedProduct = "Select a Product";
  }

  CustomerModel _selectedCusModel =
      CustomerModel(id: 0, ledgerName: '', address: '', panNo: '');

  ProductModel _selectedProModel =
      ProductModel(id: 0, productName: '', company: '', unit: '', rate: 0);
  MyService myService = MyService();
  List<CustomerModel> _customerList = [];
  List<ProductModel> _productList = [];
  CustomerProvider? itemProviderCustomerS;
  ProductProvider? itemProviderProduct;

  @override
  void initState() {
    super.initState();
    checkRole();
     WidgetsBinding.instance.addPostFrameCallback((_) {
      rePaintWiget();
    });
    myService.getCustomerName().then((customerData) async {
      setState(() {
        _customerList = customerData; // Store the fetched customer data
      });
    });
  }

  rePaintWiget() {
    if (_shouldResetState) {
      itemProviderCustomerS!.clearSelection();
      itemProviderProduct!.clearSelection();
      _shouldResetState = false;
    }
  }

  void checkRole()async{
   bool apiResult = await roleCheckServices.roleCheckSalesBill();
   if(apiResult==true){
    setState(() {
      isAuthorized=true;
    });
   }
   else setState(() {
     isAuthorized=false;
   });
}

  @override
  Widget build(BuildContext context) {
    final dataRowProvider = context.read<DataRowProvider>();
    itemProviderCustomerS = context.watch<CustomerProvider>();
    itemProviderProduct = context.watch<ProductProvider>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.kPrimaryColor,
          elevation: 0,
          title: Text(
            widget.title,
          ),
          centerTitle: true,
          leading: DrawerWidget(),
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         // Navigator.push(context,
          //         //     MaterialPageRoute(builder: (context) => GoogleMapTest()));
          //       },
          //       icon: const Icon(Entypo.location))
          // ],
        ),
        body:isAuthorized? SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding:  EdgeInsets.all(10.0.sp),
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(238, 238, 238, 1),
                  ),
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          shape:  RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.sp),
                                  topRight: Radius.circular(20.sp))),
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: Padding(
                                padding:
                                     EdgeInsets.fromLTRB(10.sp, 10.sp, 10.sp, 0),
                                child: Column(
                                  children: [
                                    CustomSearchBar(
                                      controller: _searchControllerCus,
                                      onChanged: (value) {
                                        searchCusListner.value = value ?? "";
                                        // setState(() {
                                        //   searchCusListner.value = value ?? "";
                                        //   searchCus = value ??
                                        //       ""; // Update the search variable
                                        // });
                                      },
                                      hintText: 'Select a Customer',
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.46,
                                      child: _customerList.isEmpty
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : ValueListenableBuilder(
                                              valueListenable: searchCusListner,
                                              builder: (context, searchvalue,
                                                  child) {
                                                return ListView.builder(
                                                  itemCount: filterCustomers(
                                                          searchvalue)
                                                      .length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    CustomerModel customer =
                                                        filterCustomers(
                                                            searchvalue)[index];
                                                    return Padding(
                                                      padding:  EdgeInsets
                                                              .fromLTRB(
                                                          10.sp, 7.sp, 10.sp, 7.sp),
                                                      child: InkWell(
                                                     onTap: () async {
                                                          setState(() {
                                                            resetSelections();
                                                            _selectedCustomer =
                                                                customer
                                                                    .ledgerName;
                                                            _selectedCusModel =
                                                                customer;
                                                            myService
                                                                .getproductDetails(
                                                                    _selectedCusModel
                                                                        .id);
                                                          });

                                                          final productData =
                                                              await myService
                                                                  .getproductDetails(
                                                                      _selectedCusModel
                                                                          .id);
                                                          setState(() {
                                                            _productList =
                                                                productData;
                                                          });

                                                          itemProviderCustomerS!
                                                              .selectCustomer(
                                                            _selectedCusModel.id
                                                                .toString(),
                                                            _selectedCusModel
                                                                .ledgerName,
                                                            _selectedCusModel
                                                                .address,
                                                            _selectedCusModel
                                                                .panNo,
                                                          );
                                                          // ignore: use_build_context_synchronously
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              customer
                                                                  .ledgerName,
                                                              style: GoogleFonts
                                                                  .adamina(
                                                                fontSize: 18.sp,
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
                                              }),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding:  EdgeInsets.all(10.sp),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.height * 0.3,
                            child: Text(_selectedCustomer,
                                style: GoogleFonts.adamina(fontSize: 18.sp),
                                overflow: TextOverflow.clip),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ),
                 SizedBox(
                  height: 3.sp,
                ),

                SelectedContentCustomer(),
                 SizedBox(
                  height: 3.sp,
                ),

                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: InkWell(
                    onTap: () {
                      clear();
                      showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Padding(
                                  padding:
                                       EdgeInsets.fromLTRB(10.sp, 10.sp, 10.sp, 0),
                                  child: Column(
                                    children: [
                                      CustomSearchBar(
                                          controller: _searchControllerPro,
                                          onChanged: (String? value) {
                                           searchProListner.value = value ?? "";
                                          },
                                          hintText: "Select a Product"),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.46,
                                          child: _customerList.isEmpty
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : ValueListenableBuilder(
                                                  valueListenable:
                                                      searchProListner,
                                                  builder: (context,
                                                      searchValue, child) {
                                                    return ListView.builder(
                                                        itemCount:
                                                            filterProducts(
                                                                    searchValue)
                                                                .length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          ProductModel product =
                                                              filterProducts(
                                                                      searchValue)[
                                                                  index];
                                                          return Padding(
                                                            padding:
                                                                 EdgeInsets
                                                                        .fromLTRB(
                                                                    10.sp,
                                                                    7.sp,
                                                                    10.sp,
                                                                    7.sp),
                                                            child: InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  itemProviderProduct!
                                                                      .showselectProductAgain(); //provider call to get SelectedContentClass after having 1 item added to Add To List
                                                                  _selectedProduct =
                                                                      product
                                                                          .productName;

                                                                  _selectedProModel =
                                                                      ProductModel(
                                                                    id: product
                                                                        .id,
                                                                    productName:
                                                                        product
                                                                            .productName,
                                                                    company: product
                                                                        .company,
                                                                    unit: product
                                                                        .unit,
                                                                    rate: product
                                                                        .rate,
                                                                  );
                                                                });
                                                                itemProviderProduct!.selectProduct(
                                                                    _selectedProModel
                                                                        .id
                                                                        .toString(),
                                                                    _selectedProModel
                                                                        .productName,
                                                                    _selectedProModel
                                                                            .company ??
                                                                        "",
                                                                    _selectedProModel
                                                                        .unit
                                                                        .toString(),
                                                                    _selectedProModel
                                                                            .rate ??
                                                                        0);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    product
                                                                        .productName,
                                                                    style: GoogleFonts.adamina(
                                                                        fontSize:
                                                                            18.sp),
                                                                  ),
                                                                   Divider(
                                                                    thickness:
                                                                        1.sp,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  }))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding:  EdgeInsets.all(
                            10.sp,
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.height * 0.3,
                            child: Text(
                              _selectedProduct,
                              style: GoogleFonts.adamina(fontSize: 18.sp),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ),
                 SizedBox(
                  height: 3.sp,
                ),
                //to add repeatedly SelectedContentProduct class using provider
                Consumer<ProductProvider>(
                  builder: (context, visibilityProvider, child) {
                    return visibilityProvider.showContent
                        ? const SelectedContentProduct()
                        : const SizedBox.shrink();
                  },
                ),
                 SizedBox(
                  height: 3.sp,
                ),

                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: AppColors.kPrimaryColor,
                      ),
                      onPressed: () {
                        if (_selectedCustomer.isEmpty ||
                            _selectedCustomer == "Select a Customer" ||
                            _selectedProduct.isEmpty ||
                            _selectedProduct == "Select a Product") {
                          return Utilities.showSnackBar(
                              context, "Select Customer and Product ", false);
                        } else if (itemProviderProduct!.quantity! == 0 ||
                            itemProviderProduct!.amount! == 0) {
                          return Utilities.showSnackBar(
                              context, "Enter Quantity and Amount", false);
                        } else if (itemProviderProduct!.quantity! <= 0 ||
                            itemProviderProduct!.quantity! <= 0) {
                          return Utilities.showSnackBar(
                              context, "Number must be Positive", false);
                        } else {
                          context.read<ProductProvider>().hideContent();

                          SelectedProductList productModel =
                              SelectedProductList(
                            sn: itemProviderProduct!.sn,
                            id: itemProviderProduct!.proId,
                            quantity: itemProviderProduct!.quantity,
                            name: itemProviderProduct!.productName,
                            unit: itemProviderProduct!.unit!,
                            rate: itemProviderProduct!.rate,
                            amount: itemProviderProduct!.amount,
                          );
                          itemProviderProduct?.selectedItemList(productModel);
                          itemProviderProduct!.sn++;

                          var list = itemProviderProduct!.productList;

                          var newRow;
                          for (int i = 0; i < list.length; i++) {
                            newRow = DataRow(cells: [
                              DataCell(Text(
                                list[i].sn.toString(),
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 13.sp),
                              )),
                              DataCell(Text(
                                list[i].name,
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 13.sp),
                              )),
                              DataCell(Text(
                                list[i].unit,
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.clip,
                                style: TextStyle(fontSize: 13.sp),
                              )),
                              DataCell(Text(
                                list[i].rate!.toStringAsFixed(2),
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.clip,
                                style: TextStyle(fontSize: 13.sp),
                              )),
                              DataCell(Text(
                                list[i].quantity!.toStringAsFixed(2),
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.clip,
                                style: TextStyle(fontSize: 13.sp),
                              )),
                              DataCell(Text(
                                list[i].amount!.toStringAsFixed(2),
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.clip,
                                style: TextStyle(fontSize: 13.sp),
                              )),
                            ]);
                          }
                          clearSelectedProduct();
                          dataRowProvider.addDataRow(newRow);
                          itemProviderProduct!.totalAmountMethod();
                          itemProviderProduct!.quantity = 0;
                          itemProviderProduct!.amount = 0;
                          // context.read<ProductProvider>().totalAmountMethod();
                        }
                      },
                      child: Text(
                        "A d d   T o   L i s t",
                        style: GoogleFonts.acme(fontWeight: FontWeight.bold),
                      ),
                    )),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),

                const SelectedContentProductList(),
              ],
            ),
          ),
        ):Center(child: Text("Unauthorized User",style: GoogleFonts.aboreto(fontSize: 20.sp,fontWeight: FontWeight.bold),))
      ),
    );
  }
}
