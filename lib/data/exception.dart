class NoInternetConnectException implements Exception {
  static const String _ERROR = 'User device is not connected to internet';

  const NoInternetConnectException();

  @override
  String toString() => _ERROR;
}