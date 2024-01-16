class DataTableRow {
  final String product;
  final String unit;
  final double rate;
  final int qty;
  final double amount;

  DataTableRow({
    required this.product,
    required this.unit,
    required this.rate,
    required this.qty,
    required this.amount,
  });
}
class SelectedProductList {
  late final int sn;
  final int id;
  final double? quantity;
  final String name;
  final String unit;
  final double? rate;
  final double? amount;
  
  SelectedProductList({
    required this.sn,
    required this.id,
    required this.quantity,
    required this.name,
    required this.unit,
     this.rate,
     this.amount,
  });
}
