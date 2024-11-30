import 'package:fluttertoast/fluttertoast.dart';
import 'package:habbit_app/const.dart';

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.SNACKBAR,
    fontSize: 20.0,
    backgroundColor: tertiary.withOpacity(0.6),
    textColor: primary,
  );
}
