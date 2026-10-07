class ServiceModel {
  final int id;
  final String name;
  final String description;
  final String image;
  final bool active;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.active,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as int,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      active: json['active'] ?? true,
    );
  }
}
