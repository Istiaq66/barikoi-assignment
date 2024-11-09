import 'package:barikoi/comon/widgets/custom_snackbar.dart';
import 'package:get/get.dart';

class ApiChecker {
  static void checkApi(Response response, {bool getXSnackBar = false}) {
      showCustomSnackBar(response.statusText, getXSnackBar: getXSnackBar);
  }
}
