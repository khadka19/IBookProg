import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petrolpump/API_Services/get_services_order.dart';
import 'package:petrolpump/API_Services/get_services_sales.dart';
import 'package:petrolpump/API_Services/role_control.dart';
import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/CommonWidgets/search_bar.dart';
import 'package:petrolpump/Provider/all_provider_order.dart';
import 'package:petrolpump/Screens/CreatePage/Order/custom_customer_screen.dart';
import 'package:petrolpump/Screens/CreatePage/Order/custom_productList_class.dart';
import 'package:petrolpump/Screens/CreatePage/Order/custom_product_class.dart';
import 'package:petrolpump/Screens/CreatePage/main_page.dart';
import 'package:petrolpump/Utilities/utilities.dart';
import 'package:petrolpump/models/customer_model.dart';
import 'package:petrolpump/models/data_table_model.dart';
import 'package:petrolpump/models/product_company_model.dart';
import 'package:petrolpump/models/product_model.dart';
import 'package:provider/provider.dart';

class CreateOrderScreen extends StatefulWidget {
  final String title;

  const CreateOrderScreen({
    Key? key,
    this.title = "Create Order",
  }) : super(key: key);

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  ValueNotifier<String> searchCusListner = ValueNotifier<String>('');
  ValueNotifier<String> searchProListener = ValueNotifier<String>('');
  ValueNotifier<String> searchCompanyListener = ValueNotifier<String>('');

  bool _shouldResetState = true;
  bool isLoading = false; // Flag to track loading state
  double totalAmount = 0;
  final TextEditingController _searchControllerCus = TextEditingController();
  final TextEditingController _searchControllerPro = TextEditingController();
  RoleCheckServices roleControlServices = RoleCheckServices();
  bool isAuthorized = true;
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

  List<ProductCompanyModel> filterProductCompany(String searchProCom) {
    return _productCompanyList.where((productCompany) {
      return productCompany.companyName
          .toLowerCase()
          .contains(searchProCom.toLowerCase());
    }).toList();
  }

  void clear() {
    context.read<ProductProviderO>().hideContent();
  }

  void resetSelections() {
    // Reset selected customer, product, and product list here
    selectedCustomer = "Select a Customer";
    _selectedProduct = "Select a Product";

    // Clear product list and any other necessary data
    totalAmount = 0;
    context.read<ProductProviderO>().hideContent();
    context.read<DataRowProviderO>().clearDataRowSelection();
  }

  final CustomerModel itemCustomer =
      CustomerModel(id: 0, address: '', ledgerName: '', panNo: '');

  static String selectedCustomer = "Select a Customer";
  String _selectedProduct = "Select a Product";
  String _selectedProductCompany = "Select a Company";

  void clearSelectedProduct() {
    _selectedProduct = "";
    _selectedProduct = "Select a Product";
  }

  CustomerModel _selectedCusModel =
      CustomerModel(id: 0, ledgerName: '', address: '', panNo: '');

  ProductCompanyModel _selectProductCompanyModel =
      ProductCompanyModel(id: 0, companyName: '');

  ProductModel _selectedProModel =
      ProductModel(id: 0, productName: '', company: '', unit: '');

  MyService myService = MyService();
  MyServiceOrder myServiceOrder = MyServiceOrder();
  List<CustomerModel> _customerList = [];
  List<ProductModel> _productList = [];
  List<ProductCompanyModel> _productCompanyList = [];
  String text = "Authorized";

  void checkRole() async {
    bool apiResult = await roleControlServices.roleCheckCreateOrder();
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
    super.initState();
    checkRole();
    myService.getCustomerName().then((customerData) async {
      setState(() {
        _customerList = customerData; // Store the fetched customer data
      });
    });

    myServiceOrder.getProductCompanyDetails().then((productCompanyData) async {
      setState(() {
        _productCompanyList =
            productCompanyData; // Store the fetched customer data
      });
    });



    myService.getproductDetails(_selectedCusModel.id).then((product) async {
      setState(() {
        _productList =
            product; // Store the fetched customer data
      });
    });
  
  }

  @override
  Widget build(BuildContext context) {
    final dataRowProvider = context.read<DataRowProviderO>();
    final itemProviderCustomerO = context.watch<CustomerProviderO>();
    final itemProviderProduct = context.watch<ProductProviderO>();
    final itemProviderProductCompany = context.watch<ProductCompanyProviderO>();

    if (_shouldResetState) {
      itemProviderCustomerO.clearSelection();
      itemProviderProduct.clearSelection();
      itemProviderProductCompany.resetSelection();
      _shouldResetState = false;
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AppColors.kPrimaryColor,
            elevation: 0,
            title: Text(widget.title),
            centerTitle: true,
            leading: DrawerWidget(),
          ),
          body: isAuthorized
              ? SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding:  EdgeInsets.all(10.0.sp),
                    child: Column(
                      children: [
                        Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      child: Padding(
                                        padding:  EdgeInsets.fromLTRB(
                                            10.sp, 10.sp, 10.sp, 0),
                                        child: Column(
                                          children: [
                                            CustomSearchBar(
                                              controller: _searchControllerCus,
                                              onChanged: (String? value) {
                                                searchCusListner.value =
                                                    value ?? "";
                                              },
                                              hintText: 'Select a Customer',
                                            ),
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
                                                            searchCusListner,
                                                        builder: (context,
                                                            value, child) {
                                                          return ListView
                                                              .builder(
                                                                  itemCount:
                                                                      filterCustomers(
                                                                              value)
                                                                          .length,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int index) {
                                                                    CustomerModel
                                                                        customer =
                                                                        filterCustomers(
                                                                            value)[index];
                                                                    return Padding(
                                                                      padding:
                                                                           EdgeInsets.fromLTRB(
                                                                              10.sp,
                                                                              7.sp,
                                                                              10.sp,
                                                                              7.sp),
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () async {
                                                                          setState(
                                                                              () {
                                                                            resetSelections();
                                                                            selectedCustomer =
                                                                                customer.ledgerName;
                                                                            _selectedCusModel =
                                                                                customer;
                                                                            myService.getproductDetails(
                                                                                _selectedCusModel
                                                                                    .id!);
                                                                          });

                                                                          itemProviderCustomerO
                                                                              .selectCustomer(
                                                                            _selectedCusModel.id.toString(),
                                                                            _selectedCusModel.ledgerName,
                                                                            _selectedCusModel.address,
                                                                            _selectedCusModel.panNo,
                                                                          );
                                                                          // ignore: use_build_context_synchronously
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Column(
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
                                                      ))
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
                                    width: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: Consumer<CustomerProviderO>(
                                      builder: (context, value, child) {
                                        return Text(
                                          value.ledgerName.isNotEmpty
                                              ? value.ledgerName
                                              : "Select a Customer",
                                          style:
                                              GoogleFonts.adamina(fontSize: 17.sp),
                                          overflow: TextOverflow.clip,
                                        );
                                      },
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

                        SelectedContentCustomerO(),
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Padding(
                                          padding:  EdgeInsets.fromLTRB(
                                              10.sp, 10.sp, 10.sp, 0),
                                          child: Column(
                                            children: [
                                              CustomSearchBar(
                                                  controller:
                                                      _searchControllerCus,
                                                  onChanged: (String? value) {
                                                    searchCompanyListener
                                                        .value = value ?? "";
                                                  },
                                                  hintText: "Select a Company"),
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.46,
                                                  child: _productCompanyList
                                                          .isEmpty
                                                      ? const Center(
                                                          child:
                                                              CircularProgressIndicator())
                                                      : ValueListenableBuilder(
                                                          valueListenable:
                                                              searchCompanyListener,
                                                          builder: (context,
                                                              value, child) {
                                                            return ListView
                                                                .builder(
                                                                    itemCount: filterProductCompany(
                                                                            value)
                                                                        .length,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      ProductCompanyModel
                                                                          productCompany =
                                                                          filterProductCompany(
                                                                              value)[index];
                                                                      return Padding(
                                                                        padding:  EdgeInsets.fromLTRB(
                                                                            10.sp,
                                                                            7.sp,
                                                                            10.sp,
                                                                            7.sp),
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            setState(() {
                                                                              _selectedProductCompany = productCompany.companyName;
                                                                              _selectProductCompanyModel = productCompany;
                                                                              myService.getproductDetails(
                                                                                  _selectedCusModel
                                                                                      .id,
                                                                                  _selectProductCompanyModel
                                                                                      .id);
                                                                            });

                                                                            final productData =
                                                                                await myService.getproductDetails(
                                                                                    _selectedCusModel
                                                                                        .id,
                                                                                    _selectProductCompanyModel
                                                                                        .id);
                                                                            setState(() {
                                                                              _productList =
                                                                                  productData;
                                                                            });

                                                                            itemProviderProductCompany.selectProductCompany(
                                                                              _selectProductCompanyModel.id!,
                                                                              _selectProductCompanyModel.companyName,
                                                                            );
                                                                            // ignore: use_build_context_synchronously
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                productCompany.companyName,
                                                                                style: GoogleFonts.adamina(fontSize: 17.sp),
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
                                                        ))
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
                                    width: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: Consumer<ProductCompanyProviderO>(
                                      builder: (context, value, child) {
                                        return Text(
                                          value.productCompanyName.isNotEmpty
                                              ? value.productCompanyName
                                              : "Select a Company",
                                          style:
                                              GoogleFonts.adamina(fontSize: 17.sp),
                                          overflow: TextOverflow.clip,
                                        );
                                      },
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
                          height: 5.sp,
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
                                  shape:  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.sp),
                                          topRight: Radius.circular(20.sp))),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Padding(
                                          padding:  EdgeInsets.fromLTRB(
                                              10.sp, 10.sp, 10.sp, 0),
                                          child: Column(
                                            children: [
                                              CustomSearchBar(
                                                  controller:
                                                      _searchControllerPro,
                                                  onChanged: (String? value) {
                                                    searchProListener.value =
                                                        value ?? "";
                                                  },
                                                  hintText: "Select a Product"),
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.46,
                                                  child: _productList.isEmpty
                                                      ? const Center(
                                                          child:
                                                              CircularProgressIndicator())
                                                      : ValueListenableBuilder(
                                                          valueListenable:
                                                              searchProListener,
                                                          builder: (context,
                                                              value, child) {
                                                            return ListView
                                                                .builder(
                                                                    itemCount: filterProducts(
                                                                            value)
                                                                        .length,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      ProductModel
                                                                          product =
                                                                          filterProducts(
                                                                              value)[index];
                                                                      return Padding(
                                                                        padding:  EdgeInsets.fromLTRB(
                                                                            10.sp,
                                                                            7.sp,
                                                                            10.sp,
                                                                            7.sp),
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            setState(() {
                                                                              itemProviderProduct.showselectProductAgain(); //provider call to get SelectedContentClass after having 1 item added to Add To List
                                                                              _selectedProduct = product.productName;

                                                                              _selectedProModel = ProductModel(
                                                                                id: product.id,
                                                                                productName: product.productName,
                                                                                company: product.company,
                                                                                unit: product.unit,
                                                                              );
                                                                            });

                                                                            itemProviderProduct.selectProduct(
                                                                                _selectedProModel.id.toString(),
                                                                                _selectedProModel.productName,
                                                                                _selectedProModel.company ?? "",
                                                                                _selectedProModel.unit.toString());
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                product.productName,
                                                                                style: GoogleFonts.adamina(fontSize: 17.sp),
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
                                                        ))
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
                                    width: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: Text(
                                      _selectedProduct,
                                      style: GoogleFonts.adamina(fontSize: 17.sp),
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
                        Consumer<ProductProviderO>(
                          builder: (context, visibilityProvider, child) {
                            return visibilityProvider.showContent
                                ? const SelectedContentProductO()
                                : const SizedBox.shrink();
                          },
                        ),
                        const SizedBox(
                          height: 3,
                        ),

                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 5,
                                backgroundColor: AppColors.kPrimaryColor,
                              ),
                              onPressed: () {
                                if (selectedCustomer.isEmpty ||
                                    selectedCustomer == "Select a Customer" ||
                                    _selectedProduct.isEmpty ||
                                    _selectedProduct == "Select a Product") {
                                  return Utilities.showSnackBar(
                                      context, "Select All Fields ", false);
                                } else if (itemProviderProduct.quantity! == 0) {
                                  return Utilities.showSnackBar(
                                      context, "Enter Quantity", false);
                                } else if (itemProviderProduct.quantity! <= 0 ||
                                    itemProviderProduct.quantity! <= 0) {
                                  return Utilities.showSnackBar(context,
                                      "Number must be Positive", false);
                                } else {
                                  context
                                      .read<ProductProviderO>()
                                      .hideContent();

                                  SelectedProductList productModel =
                                      SelectedProductList(
                                    sn: itemProviderProduct.sn,
                                    id: itemProviderProduct.proId,
                                    quantity: itemProviderProduct.quantity,
                                    name: itemProviderProduct.productName,
                                    unit: itemProviderProduct.unit!,
                                  );
                                  itemProviderProduct
                                      .selectedItemList(productModel);
                                  itemProviderProduct.sn++;

                                  var list = itemProviderProduct.productList;

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
                                        list[i].quantity!.toStringAsFixed(2),
                                        textAlign: TextAlign.right,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(fontSize: 13.sp),
                                      )),
                                    ]);
                                  }
                                  clearSelectedProduct();
                                  dataRowProvider.addDataRow(newRow);
                                  itemProviderProduct.totalQuantityMethod();
                                  itemProviderProduct.quantity = 0;
                                }
                              },
                              child: Text(
                                "A d d   T o   L i s t",
                                style: GoogleFonts.acme(
                                    fontWeight: FontWeight.bold),
                              ),
                            )),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),

                        const SelectedContentProductListO(),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Text(
                  "Unauthorized User",
                  style: GoogleFonts.aboreto(
                      fontSize: 20.sp, fontWeight: FontWeight.bold),
                ))),
    );
  }
}
