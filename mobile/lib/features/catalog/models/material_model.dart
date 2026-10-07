class MaterialModel {
  final int id;
  final String name;
  final String category; // 'wall' or 'floor'
  final String? description;
  final String? image;
  final String? color;
  final String? priceRange;
  final bool active;

  MaterialModel({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    this.image,
    this.color,
    this.priceRange,
    required this.active,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'] as int,
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] as String?,
      image: json['image'] as String?,
      color: json['color'] as String?,
      priceRange: json['priceRange'] as String?,
      active: json['active'] ?? true,
    );
  }
}
