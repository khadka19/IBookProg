import 'package:flutter/material.dart';
import 'package:petrolpump/API_Services/post_services.dart';
import 'package:petrolpump/Screens/CreatePage/Sales/create_sales_screen.dart';
import 'package:petrolpump/models/PostModel/productOrder_post_model.dart';
import 'package:petrolpump/models/customer_model.dart';
import 'package:petrolpump/models/data_table_model.dart';
import 'package:petrolpump/models/product_company_model.dart';
import 'package:petrolpump/models/product_model.dart';

class CustomerProviderO extends ChangeNotifier {
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

  void clearSelection() {
    cusId = 0;
    ledgerName = "";
    address = "";
    panNo = "";
    ProductProviderO productProvider = ProductProviderO();
    productProvider.productList = [];
    notifyListeners();
  }
}

class ProductProviderO extends ChangeNotifier {
  double? _quantity = 0.0; // Private variable to store the quantity
  double? _amount = 0.0;

  double? get quantity => _quantity; // Getter

  set quantity(double? value) {
    _quantity = value; // Setter
  }

  double? get amount => _amount; // Getter

  set amount(double? value) {
    _amount = value; // Setter
  }

  List<SelectedProductList> productList = [];
  DataRowProviderO getDataRowProvider() {
    return DataRowProviderO(this); // Pass 'this' to the constructor
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

  void selectProduct(
      String id, String productName, String company, String unit,) {
    proId = int.parse(id);
    this.productName = productName.toString();
    this.company = company.toString();
    this.unit = unit.toString();
    notifyListeners();
  }

  void resetProductListSN() {
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
    notifyListeners();
  }

  void updateAmount(double newAmount) {
    _amount = newAmount;
    notifyListeners();
  }

  double totalQuantity = 0;
  void totalQuantityMethod() {
    totalQuantity = 0;
    for (var i = 0; i < productList.length; i++) {
      totalQuantity += productList[i].quantity!;
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

class ProductListProviderO extends ChangeNotifier {
  CreateSalesScreen createSalesScreen = const CreateSalesScreen();
  void clearSelection() {
    createSalesScreen;
    notifyListeners();
  }
}

class DataRowProviderO extends ChangeNotifier {
  final List<DataRow> _dataRows = [];
  final ProductProviderO productProvider;
  DataRowProviderO(this.productProvider);
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
    productProvider.totalQuantityMethod();
    notifyListeners();
  }
}

/// post suru vayo haiii
class OrderProvider extends ChangeNotifier {
  MyServiceOrderPost myServiceOrderPost = MyServiceOrderPost();
   final ProductProviderO productProviderO;
  // final CompanyProvider companyProvider;
   final CustomerProviderO customerProviderO;
   


//API Services part
  OrderProvider(this.productProviderO, this.customerProviderO,);
  Future postOrderData(int customerId,String remarks,int userId,double latitude,double longitude) async {
    List<SelectedProductList> productList = productProviderO.productList;
    List<ProductOrderDetailsModel> productDetailList = [];
    for (int i = 0; i < productList.length; i++) {
      SelectedProductList selectedProduct = productList[i];
      ProductOrderDetailsModel productDetails = ProductOrderDetailsModel(
        productId: selectedProduct.id,
        quantity: selectedProduct.quantity,
      );
      productDetailList.add(productDetails);
    }

    Map<String, dynamic> postOrderModel = {
      "CustomerId": customerId,
      "UserId": userId,
      "Latitude":latitude,
      "Longitude":longitude,
      "Remarks": remarks,
      "Details": productDetailList,
    };

    ProductOrderPostModel productOrderPostModel = ProductOrderPostModel(
      customerId: postOrderModel["CustomerId"],
      userId: postOrderModel["UserId"],
      latitude: postOrderModel["Latitude"],
      longitude: postOrderModel["Longitude"],
      remarks: postOrderModel["Remarks"],
      details: postOrderModel["Details"],
       
         
    );
     await myServiceOrderPost.postOrderProductModel(productOrderPostModel);
  }


  
}

class ProductCompanyProviderO extends ChangeNotifier{
   final List<ProductCompanyModel> _productCompanyList= [];
  List<ProductCompanyModel> get proComp => _productCompanyList;
  int id = 0;
  String productCompanyName = "";


  void selectProductCompany(
      int id, String productCompanyName, ) {
    this.productCompanyName = productCompanyName.toString();
    notifyListeners();
  }
  void resetSelection(){
    id=0;
    productCompanyName="";
   notifyListeners();
  }
}
