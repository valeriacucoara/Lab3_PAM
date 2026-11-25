import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/store_cubit.dart';
import '../cubit/store_state.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'product_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final StoreCubit cubit = context.read<StoreCubit>();

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),

              // HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.menu),

                    const Text(
                      'GemStore',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Icon(Icons.notifications_none),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // CATEGORII
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Category(
                      icon: Icons.female,
                      text: 'Women',
                    ),
                    Category(
                      icon: Icons.male,
                      text: 'Men',
                    ),
                    Category(
                      icon: Icons.remove_red_eye_outlined,
                      text: 'Accessories',
                    ),
                    Category(
                      icon: Icons.brush_outlined,
                      text: 'Beauty',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // AUTUMN COLLECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/1.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),

                      const Positioned(
                        right: 15,
                        top: 25,
                        child: Text(
                          'Autumn\nCollection\n2021',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ====================================================
              // SEARCH - NOU IN LAB 3
              // ====================================================

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  onChanged: (value) {
                    cubit.searchProducts(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // ====================================================
              // FILTER + SORT - NOI IN LAB 3
              // ====================================================

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [

                    Expanded(
                      child: DropdownButtonFormField<PriceFilter>(
                        value: cubit.priceFilter,
                        decoration: InputDecoration(
                          labelText: 'Filter',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: PriceFilter.all,
                            child: Text('All'),
                          ),
                          DropdownMenuItem(
                            value: PriceFilter.under40,
                            child: Text('Under \$40'),
                          ),
                          DropdownMenuItem(
                            value: PriceFilter.between40And60,
                            child: Text('\$40 - \$60'),
                          ),
                          DropdownMenuItem(
                            value: PriceFilter.over60,
                            child: Text('Over \$60'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            cubit.filterByPrice(value);
                          }
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: DropdownButtonFormField<SortOption>(
                        value: cubit.sortOption,
                        decoration: InputDecoration(
                          labelText: 'Sort',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: SortOption.defaultOrder,
                            child: Text('Default'),
                          ),
                          DropdownMenuItem(
                            value: SortOption.priceLowToHigh,
                            child: Text('Price ↑'),
                          ),
                          DropdownMenuItem(
                            value: SortOption.priceHighToLow,
                            child: Text('Price ↓'),
                          ),
                          DropdownMenuItem(
                            value: SortOption.nameAZ,
                            child: Text('Name A-Z'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            cubit.sortProducts(value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // FEATURE PRODUCTS
              const SectionTitle(
                title: 'Feature Products',
              ),

              const SizedBox(height: 15),

              // ====================================================
              // PRODUSELE ACUM VIN DIN JSON
              // ====================================================

              BlocBuilder<StoreCubit, StoreState>(
                builder: (context, state) {

                  // LOADING
                  if (state is StoreLoading) {
                    return const SizedBox(
                      height: 240,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 12),
                            Text('Loading products...'),
                          ],
                        ),
                      ),
                    );
                  }

                  // ERROR
                  if (state is StoreError) {
                    return SizedBox(
                      height: 220,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.redAccent,
                              size: 45,
                            ),

                            const SizedBox(height: 10),

                            Text(state.message),

                            const SizedBox(height: 10),

                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<StoreCubit>()
                                    .loadProducts();
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // EMPTY
                  if (state is StoreEmpty) {
                    return const SizedBox(
                      height: 220,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 50,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'No products found',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // SUCCESS
                  if (state is StoreSuccess) {
                    return SizedBox(
                      height: 265,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(
                          left: 25,
                          right: 10,
                        ),
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          final Product product =
                          state.products[index];

                          return ProductCard(
                            product: product,

                            isFavorite: state.favorites.contains(
                              product.id,
                            ),

                            // FAVORITE
                            onFavorite: () {
                              context
                                  .read<StoreCubit>()
                                  .toggleFavorite(
                                product.id,
                              );
                            },

                            // PRODUCT DETAILS
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductPage(
                                        product: product,
                                      ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),

              const SizedBox(height: 25),

              // HANG OUT - RAMANE DIN LAB 2
              Image.asset(
                'assets/images/3.png',
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),

              const SizedBox(height: 30),

              // RECOMMENDED - RAMANE DESIGNUL DIN LAB 2
              const SectionTitle(
                title: 'Recommended',
              ),

              const SizedBox(height: 15),

              Image.asset(
                'assets/images/4.png',
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),

              const SizedBox(height: 30),

              // TOP COLLECTION
              const SectionTitle(
                title: 'Top Collection',
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Image.asset(
                  'assets/images/5.png',
                  width: double.infinity,
                ),
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Image.asset(
                  'assets/images/6.png',
                  width: double.infinity,
                ),
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Image.asset(
                  'assets/images/7.png',
                  width: double.infinity,
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ===============================================================
// CATEGORIE - PASTRATA DIN LAB 2
// ===============================================================

class Category extends StatelessWidget {
  final IconData icon;
  final String text;

  const Category({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xFFF5F5F5),
          child: Icon(
            icon,
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          text,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

// ===============================================================
// TITLURI - PASTRAT DIN LAB 2
// ===============================================================

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Text(
            'Show all',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}