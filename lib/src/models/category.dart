class Category {
  final String id;
  final String name;
  final String image;

  Category.fromJson(Map<String, dynamic> parsedJson)
      : this.id = parsedJson['_id'],
        this.name = parsedJson['name'] ?? '',
        this.image = parsedJson['image'] ?? '';

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'image': image,
      };

  @override
  String toString() => name;
}
