class QuoteModel {
  final int id;
  final int? userId;
  final int? transformationId;
  final String fullName;
  final String phone;
  final String email;
  final String? city;
  final String? roomType;
  final double? surfaceArea;
  final String? message;
  final String status;
  final DateTime? createdAt;

  QuoteModel({
    required this.id,
    this.userId,
    this.transformationId,
    required this.fullName,
    required this.phone,
    required this.email,
    this.city,
    this.roomType,
    this.surfaceArea,
    this.message,
    required this.status,
    this.createdAt,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['id'] as int,
      userId: json['userId'] as int?,
      transformationId: json['transformationId'] as int?,
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      city: json['city'] as String?,
      roomType: json['roomType'] as String?,
      surfaceArea: json['surfaceArea'] != null
          ? (json['surfaceArea'] as num).toDouble()
          : null,
      message: json['message'] as String?,
      status: json['status'] ?? 'PENDING',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}
