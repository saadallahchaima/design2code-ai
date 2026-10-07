class TransformationModel {
  final int id;
  final int? userId;
  final String originalImageUrl;
  final String? generatedImageUrl;
  final String roomType;
  final String style;
  final String? wallMaterial;
  final String? floorMaterial;
  final String? lighting;
  final String? customPrompt;
  final String status; // PENDING, PROCESSING, COMPLETED, FAILED
  final String? errorMessage;
  final DateTime? createdAt;

  TransformationModel({
    required this.id,
    this.userId,
    required this.originalImageUrl,
    this.generatedImageUrl,
    required this.roomType,
    required this.style,
    this.wallMaterial,
    this.floorMaterial,
    this.lighting,
    this.customPrompt,
    required this.status,
    this.errorMessage,
    this.createdAt,
  });

  bool get isCompleted => status == 'COMPLETED' && generatedImageUrl != null;
  bool get isProcessing => status == 'PROCESSING' || status == 'PENDING';
  bool get isFailed => status == 'FAILED';

  factory TransformationModel.fromJson(Map<String, dynamic> json) {
    return TransformationModel(
      id: int.parse(json['id'].toString()),
      userId: json['userId'] != null ? int.parse(json['userId'].toString()) : null,
      originalImageUrl: json['originalImageUrl'] ?? '',
      generatedImageUrl: json['generatedImageUrl'] as String?,
      roomType: json['roomType'] ?? '',
      style: json['style'] ?? '',
      wallMaterial: json['wallMaterial'] as String?,
      floorMaterial: json['floorMaterial'] as String?,
      lighting: json['lighting'] as String?,
      customPrompt: json['customPrompt'] as String?,
      status: json['status'] ?? 'PENDING',
      errorMessage: json['errorMessage'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}
