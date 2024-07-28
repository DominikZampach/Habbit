import 'package:fluttertoast/fluttertoast.dart';
import 'package:habbit_app/const.dart';

void toastAuth(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.SNACKBAR,
    fontSize: 20.0,
    textColor: secondary,
  );
}
