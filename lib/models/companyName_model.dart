import 'dart:convert';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));
class PostModel {
  bool success;
  String message;
  List<CompanyModel> data;

  PostModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        success: json["success"],
        message: json["message"],
        data: List<CompanyModel>.from(
            json["data"].map((x) => CompanyModel.fromJson(x))),
      );
}

class CompanyModel {
  String companyCode;
  String companyName;
  DateTime fyStartMiti;
  DateTime fyEndMiti;

  CompanyModel({
    required this.companyCode,
    required this.companyName,
    required this.fyStartMiti,
    required this.fyEndMiti,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
        companyCode: json["companyCode"],
        companyName: json["companyName"],
        fyStartMiti: DateTime.parse(json["fyStartMiti"]),
        fyEndMiti: DateTime.parse(json["fyEndMiti"]),
      );
}

enum FyEndMitiEnum { THE_20780332, THE_20790332, THE_20810332 }

final fyEndMitiEnumValues = EnumValues({
  "2078-03-32": FyEndMitiEnum.THE_20780332,
  "2079-03-32": FyEndMitiEnum.THE_20790332,
  "2081-03-32": FyEndMitiEnum.THE_20810332
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
