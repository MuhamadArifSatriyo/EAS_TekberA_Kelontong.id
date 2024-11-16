class Item {
  final String id; // ID unik untuk setiap barang
  final String name;
  final String category;
  final String description;
  final double price;
  final int stock;

  Item({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.stock,
  });

  // Fungsi untuk membuat salinan objek dengan properti yang diperbarui
  Item copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    double? price,
    int? stock,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
    );
  }
}
