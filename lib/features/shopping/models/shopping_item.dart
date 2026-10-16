class ShoppingItem {
  final String id;
  final String name;
  final String category;
  final bool checked;

  const ShoppingItem({
    required this.id,
    required this.name,
    required this.category,
    required this.checked,
  });

  ShoppingItem copyWith({String? name, String? category, bool? checked}) {
    return ShoppingItem(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      checked: checked ?? this.checked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'checked': checked,
    };
  }

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? 'Autre',
      checked: json['checked'] as bool? ?? false,
    );
  }
}
