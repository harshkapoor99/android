class CommonResponse<T> {
  CommonResponse({
    required this.isSuccess,
    required this.message,
    this.response,
  });
  final bool isSuccess;
  final String message;
  T? response;

  @override
  String toString() {
    return "isSuccess: $isSuccess, message: $message,response: ${response.toString()}";
  }
}
