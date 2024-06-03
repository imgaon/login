class ResponseModel<T> {
  final T? body;
  final int statusCode;
  final String statusMessage;
  final bool success;

  ResponseModel({
    required this.body,
    required this.statusCode,
    required this.statusMessage,
    required this.success,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json, String? bodyName, T Function(dynamic)? convertBody) {
    return ResponseModel(
      body: convertBody != null ? convertBody(json[bodyName ?? 'body']) : null,
      statusCode: json['status_cd'],
      statusMessage: json['status_msg'],
      success: json['success'],
    );
  }
}
