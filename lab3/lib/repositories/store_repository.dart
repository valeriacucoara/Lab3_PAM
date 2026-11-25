import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/product.dart';

class StoreRepository {
  Future<List<Product>> loadProducts() async {

    // Intarziere pentru a demonstra starea Loading
    await Future.delayed(
      const Duration(seconds: 1),
    );

    // Citim JSON-ul local
    final String jsonString = await rootBundle.loadString(
      'assets/data/lab_v1.json',
    );

    final Map<String, dynamic> data =
    jsonDecode(jsonString);

    // FEATURE PRODUCTS
    final List<dynamic> featureProducts =
    data['homePage']['featureProducts'];

    // RECOMMENDED
    final List<dynamic> recommended =
    data['homePage']['recommended'];

    // SIMILAR PRODUCTS
    final List<dynamic> similarProducts =
    data['productPage']['product']['similarProducts'];

    // Toate produsele simple
    final List<Product> products = [
      ...featureProducts,
      ...recommended,
      ...similarProducts,
    ]
        .map(
          (json) => Product.fromJson(
        json as Map<String, dynamic>,
      ),
    )
        .toList();

    // ==================================================
    // PRODUSUL DETALIAT
    // ==================================================

    final Map<String, dynamic> detailedProductJson =
    data['productPage']['product'];

    final Product detailedProduct =
    Product.fromJson(detailedProductJson);

    // Inlocuim varianta simpla p003
    // cu varianta completa din productPage
    final int index = products.indexWhere(
          (product) => product.id == detailedProduct.id,
    );

    if (index != -1) {
      products[index] = detailedProduct;
    } else {
      products.add(detailedProduct);
    }

    return products;
  }
}