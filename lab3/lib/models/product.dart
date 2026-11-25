class ProductColor {
  final String id;
  final String name;
  final String value;

  const ProductColor({
    required this.id,
    required this.name,
    required this.value,
  });

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return ProductColor(
      id: json['id'] as String,
      name: json['name'] as String,
      value: json['value'] as String,
    );
  }
}

class ProductReview {
  final String id;
  final String author;
  final String avatarUrl;
  final double rating;
  final String createdAtLabel;
  final String text;

  const ProductReview({
    required this.id,
    required this.author,
    required this.avatarUrl,
    required this.rating,
    required this.createdAtLabel,
    required this.text,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      id: json['id'] as String,
      author: json['author'] as String,
      avatarUrl: json['avatarUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      createdAtLabel: json['createdAtLabel'] as String,
      text: json['text'] as String,
    );
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  final String currency;
  final String imageUrl;

  // DATE DETALIATE
  final double? rating;
  final int? ratingCount;
  final String? description;

  final List<ProductColor> availableColors;
  final List<String> availableSizes;

  final String? selectedColor;
  final String? selectedSize;

  final List<ProductReview> reviews;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.imageUrl,

    this.rating,
    this.ratingCount,
    this.description,

    this.availableColors = const [],
    this.availableSizes = const [],

    this.selectedColor,
    this.selectedSize,

    this.reviews = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,

      name: json['name'] as String,

      price: (json['price'] as num).toDouble(),

      currency: json['currency'] as String,

      // Produsele simple au imageUrl,
      // produsul detaliat are mainImageUrl.
      imageUrl:
      (json['imageUrl'] ?? json['mainImageUrl'] ?? '') as String,

      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,

      ratingCount: json['ratingCount'] as int?,

      description: json['description'] as String?,

      availableColors:
      (json['availableColors'] as List<dynamic>?)
          ?.map(
            (color) => ProductColor.fromJson(
          color as Map<String, dynamic>,
        ),
      )
          .toList() ??
          [],

      availableSizes:
      (json['availableSizes'] as List<dynamic>?)
          ?.map(
            (size) => size.toString(),
      )
          .toList() ??
          [],

      selectedColor:
      json['selectedColor'] as String?,

      selectedSize:
      json['selectedSize'] as String?,

      reviews:
      (json['reviews'] as List<dynamic>?)
          ?.map(
            (review) => ProductReview.fromJson(
          review as Map<String, dynamic>,
        ),
      )
          .toList() ??
          [],
    );
  }
}