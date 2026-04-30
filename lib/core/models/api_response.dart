class ApiResponse {
  final dynamic _data;
  final String? _error;
  final int? _statusCode;
  final String? _code;
  
  ApiResponse({
    dynamic data,
    String? error,
    int? statusCode,
    String? code,
  }) : _data = data, _error = error, _statusCode = statusCode, _code = code;

  bool get isSuccessful => _error == null;
  dynamic get data => _data;
  String get error => _error!;
  int? get statusCode => _statusCode;
  String? get code => _code;

  @override
  String toString() {
    return 'ApiResponse{'
              'data: ${_data.toString()}, '
              'error: $_error, '
              'statusCode: $_statusCode, '
              'code: $_code '
            '}';
  }

}