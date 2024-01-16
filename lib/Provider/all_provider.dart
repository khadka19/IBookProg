import 'package:flutter/material.dart';
import 'package:petrolpump/API_Services/post_services.dart';
import 'package:petrolpump/Screens/CreatePage/Sales/create_sales_screen.dart';
import 'package:petrolpump/models/PostModel/invoice_model.dart';
import 'package:petrolpump/models/PostModel/productSales_post_model.dart';
import 'package:petrolpump/models/customer_model.dart';
import 'package:petrolpump/models/data_table_model.dart';
import 'package:petrolpump/models/product_model.dart';

class CustomerProvider extends ChangeNotifier {
  List<CustomerModel> _customers = [];
  List<CustomerModel> get customers => _customers;
  int cusId = 0;
  String ledgerName = "";
  String address = "";
  String panNo = "";

  void selectCustomer(
      String id, String ledgerName, String address, String panNo) {
    cusId = int.parse(id);
    this.ledgerName = ledgerName.toString();
    this.address = address.toString();
    this.panNo = panNo.toString();
    notifyListeners();
  }


void resetState() {
  _customers=[];
    // Implement code to reset the state of the provider
    // For example, clear selected customer and product.
    // You can also clear other relevant data.
  notifyListeners();
}
  void clearSelection() {
    cusId = 0;
    ledgerName = "";
    address = "";
    panNo = "";
    ProductProvider productProvider = ProductProvider();
    productProvider.productList = [];
    notifyListeners();
  }
}

class ProductProvider extends ChangeNotifier {
  double? _quantity=0.0; // Private variable to store the quantity
   double? _amount=0.0;

  double? get quantity => _quantity; // Getter

  set quantity(double? value) {
    _quantity = value; // Setter
  }

  double? get amount => _amount; // Getter

  set amount(double? value) {
    _amount = value; // Setter
  }

void resetState(){
  _products=[];
}

  List<SelectedProductList> productList = [];
  DataRowProvider getDataRowProvider() {
    return DataRowProvider(this); // Pass 'this' to the constructor
  }
  bool _showContent = true;
  bool get showContent => _showContent;
  List<ProductModel> _products = []; // Your list of products
  List<ProductModel> get products => _products;
  int sn = 1;
  int proId = 0;
  String productName = "";
  String? company = "";
  String? unit = "";
  double? rate = 0;

  void selectProduct(
      String id, String productName, String company, String unit, double rate) {
    proId = int.parse(id);
    this.productName = productName.toString();
    this.company = company.toString();
    this.unit = unit.toString();
    this.rate = rate;
    notifyListeners();
  }

  void resetProductListSN(){
    sn = 1;
  }

  void updateProducts(List<ProductModel> newProducts) {
    _products = newProducts;
    notifyListeners();
  }

  void showselectProductAgain() {
    _showContent = true;
    notifyListeners();
  }

  void hideContent() {
    _showContent = false;
    notifyListeners();
  }

  void removeProductList() {
    _products = [];
    notifyListeners();
  }
  
  void clearSelection() {
    proId = 0;
    productList.clear();
    notifyListeners();
  }


  void updateQuantity(double newQuantity) {
    _quantity = newQuantity;
    _amount = newQuantity * rate!;
    notifyListeners();
  }

  void updateAmount(double newAmount) {
    _amount = newAmount;
    _quantity = newAmount / rate!;
    notifyListeners();
  }

  double totalAmount = 0;
  void totalAmountMethod() {
    totalAmount = 0;
    for (var i = 0; i < productList.length; i++) {
      totalAmount += productList[i].amount!;
    }
    notifyListeners();
  }

  void selectedItemList(SelectedProductList productObject) {
    int sn = productObject.sn;
    int id = productObject.id;
    double? quantity=productObject.quantity;
    String name = productObject.name;
    String unit = productObject.unit;
    double? rate = productObject.rate;
    double? amount = productObject.amount;

    SelectedProductList selectedProduct = SelectedProductList(
      sn: sn,
      id: id,
      quantity: quantity,
      name: name,
      unit: unit,
      rate: rate,
      amount: amount,
    );
    productList.add(selectedProduct);
  }
}

class ProductListProvider extends ChangeNotifier {
  CreateSalesScreen createSalesScreen = const CreateSalesScreen();
  void clearSelection() {
    createSalesScreen;
    notifyListeners();
  }
}

class DataRowProvider extends ChangeNotifier {
  final List<DataRow> _dataRows = [];
  final ProductProvider productProvider;
  DataRowProvider(this.productProvider);
  List<DataRow> get dataRows => _dataRows;

  void addDataRow(DataRow dataRow) {
    _dataRows.add(dataRow);
    notifyListeners();
  }

  void clearDataRowSelection() {
    productProvider.resetProductListSN();
    _dataRows.clear();
    productProvider.clearSelection();
    notifyListeners();
  }

  void removeDataRow(BuildContext context, DataRow dataRow, int index) {
    productProvider.productList.removeAt(index);
    _dataRows.remove(dataRow);
    productProvider.totalAmountMethod();
    notifyListeners();
  }
}

///post suru vayo haiii
class SalesProvider extends ChangeNotifier {
  MyServiceSalesPost myServicePost = MyServiceSalesPost();
  final ProductProvider productProvider;
  // final CompanyProvider companyProvider;
  final CustomerProvider customerProvider;

  SalesProvider(this.productProvider, this.customerProvider);
  Future<Invoice> postSalesData(int customerId, String remarks) async {
    List<SelectedProductList> productList = productProvider.productList;
    List<ProductSalesDetailsModel> productDetailList = [];
    for (int i = 0; i < productList.length; i++) {
      SelectedProductList selectedProduct = productList[i];
      ProductSalesDetailsModel productDetails = ProductSalesDetailsModel(
        productId: selectedProduct.id,
        quantity: selectedProduct.quantity,
        rate: selectedProduct.rate!,
        amount: selectedProduct.amount!,
        discount: 0.0,
      );
      productDetailList.add(productDetails);
    }

    Map<String, dynamic> posSalestModel = {
      "CustomerId": customerId,
      "Remarks": remarks,
      "Details": productDetailList,
    };

    ProductSalesPostModel productPostModel = ProductSalesPostModel(
      customerId: posSalestModel["CustomerId"],
      remarks: posSalestModel["Remarks"],
      details: posSalestModel["Details"],
    );

    return await myServicePost.postSalesProductModel(productPostModel);
  }
}