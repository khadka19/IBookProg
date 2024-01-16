import 'package:nepali_utils/nepali_utils.dart';

class NepaliDateConverter {
  static String convertToNepaliDate(DateTime englishDate) {
    // ignore: deprecated_member_use
    NepaliDateTime nepaliDate = NepaliDateTime.fromDateTime(englishDate);
    return NepaliDateFormat('yyyy-MM-dd').format(nepaliDate);
  }
}
