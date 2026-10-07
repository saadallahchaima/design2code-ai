class ProjectModel {
  final int id;
  final String title;
  final String description;
  final String? location;
  final String? roomType;
  final String? style;
  final String coverImage;
  final String? beforeImage;
  final String? afterImage;
  final DateTime? createdAt;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    this.location,
    this.roomType,
    this.style,
    required this.coverImage,
    this.beforeImage,
    this.afterImage,
    this.createdAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as int,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] as String?,
      roomType: json['roomType'] as String?,
      style: json['style'] as String?,
      coverImage: json['coverImage'] ?? '',
      beforeImage: json['beforeImage'] as String?,
      afterImage: json['afterImage'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}
