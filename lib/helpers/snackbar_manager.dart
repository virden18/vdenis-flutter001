class SnackBarManager {
  static final SnackBarManager _instance = SnackBarManager._internal();

  factory SnackBarManager() {
    return _instance;
  }

  SnackBarManager._internal();

  bool _isConnectivitySnackBarShowing = false;

  bool get isConnectivitySnackBarShowing => _isConnectivitySnackBarShowing;

  void setConnectivitySnackBarShowing(bool value) {
    _isConnectivitySnackBarShowing = value;
  }

  bool canShowSnackBar() {
    return !_isConnectivitySnackBarShowing;
  }
}
