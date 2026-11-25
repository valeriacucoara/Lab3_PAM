import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/product.dart';
import '../repositories/store_repository.dart';
import 'store_state.dart';

enum PriceFilter {
  all,
  under40,
  between40And60,
  over60,
}

enum SortOption {
  defaultOrder,
  priceLowToHigh,
  priceHighToLow,
  nameAZ,
}

class StoreCubit extends Cubit<StoreState> {
  final StoreRepository repository;

  StoreCubit(this.repository) : super(StoreLoading());

  List<Product> _allProducts = [];

  String _searchQuery = '';

  PriceFilter _priceFilter = PriceFilter.all;

  SortOption _sortOption = SortOption.defaultOrder;

  final Set<String> _favorites = {};

  // GETTERS
  String get searchQuery => _searchQuery;

  PriceFilter get priceFilter => _priceFilter;

  SortOption get sortOption => _sortOption;

  // INCARCA PRODUSELE DIN JSON
  Future<void> loadProducts() async {
    emit(StoreLoading());

    try {
      _allProducts = await repository.loadProducts();

      _applyFilters();
    } catch (e) {
      emit(
        StoreError(
          'Nu s-au putut încărca produsele.',
        ),
      );
    }
  }

  // CAUTARE
  void searchProducts(String query) {
    _searchQuery = query;

    _applyFilters();
  }

  // FILTRARE DUPA PRET
  void filterByPrice(PriceFilter filter) {
    _priceFilter = filter;

    _applyFilters();
  }

  // SORTARE
  void sortProducts(SortOption option) {
    _sortOption = option;

    _applyFilters();
  }

  // ADAUGARE / ELIMINARE FAVORITE
  void toggleFavorite(String productId) {
    if (_favorites.contains(productId)) {
      _favorites.remove(productId);
    } else {
      _favorites.add(productId);
    }

    _applyFilters();
  }

  bool isFavorite(String productId) {
    return _favorites.contains(productId);
  }

  // APLICA TOATE REGULILE
  void _applyFilters() {
    List<Product> result =
    List<Product>.from(_allProducts);

    // 1. CAUTARE
    if (_searchQuery.isNotEmpty) {
      result = result.where((product) {
        return product.name
            .toLowerCase()
            .contains(
          _searchQuery.toLowerCase(),
        );
      }).toList();
    }

    // 2. FILTRARE DUPA PRET
    switch (_priceFilter) {
      case PriceFilter.all:
        break;

      case PriceFilter.under40:
        result = result.where((product) {
          return product.price < 40;
        }).toList();
        break;

      case PriceFilter.between40And60:
        result = result.where((product) {
          return product.price >= 40 &&
              product.price <= 60;
        }).toList();
        break;

      case PriceFilter.over60:
        result = result.where((product) {
          return product.price > 60;
        }).toList();
        break;
    }

    // 3. SORTARE
    switch (_sortOption) {
      case SortOption.defaultOrder:
        break;

      case SortOption.priceLowToHigh:
        result.sort(
              (a, b) => a.price.compareTo(b.price),
        );
        break;

      case SortOption.priceHighToLow:
        result.sort(
              (a, b) => b.price.compareTo(a.price),
        );
        break;

      case SortOption.nameAZ:
        result.sort(
              (a, b) => a.name.compareTo(b.name),
        );
        break;
    }

    // 4. EMPTY SAU SUCCESS
    if (result.isEmpty) {
      emit(StoreEmpty());
    } else {
      emit(
        StoreSuccess(
          products: result,
          favorites: Set<String>.from(
            _favorites,
          ),
        ),
      );
    }
  }
}