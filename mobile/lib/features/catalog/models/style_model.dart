class StyleModel {
  final int id;
  final String name;
  final String description;
  final String image;
  final String promptInstructions;
  final bool active;

  StyleModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.promptInstructions,
    required this.active,
  });

  factory StyleModel.fromJson(Map<String, dynamic> json) {
    return StyleModel(
      id: json['id'] as int,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      promptInstructions: json['promptInstructions'] ?? '',
      active: json['active'] ?? true,
    );
  }
}
