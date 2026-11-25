import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/store_cubit.dart';
import '../models/product.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  const ProductPage({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final bool favorite =
    context.watch<StoreCubit>().isFavorite(product.id);

    // Doar Sportwear Set foloseste detaliile din JSON
    final bool useJsonDetails = product.id == 'p003';

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // Imaginea mare
              SizedBox(
                height: 420,
                child: Stack(
                  alignment: Alignment.center,
                  children: [

                    Container(
                      width: 260,
                      height: 260,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF1EC),
                        shape: BoxShape.circle,
                      ),
                    ),

                    // Pentru Sportwear Set pastram imaginea din Lab 2
                    product.id == 'p003'
                        ? Image.asset(
                      'assets/images/8.png',
                      height: 400,
                      fit: BoxFit.contain,
                    )
                        : Image.network(
                      product.imageUrl,
                      height: 330,
                      width: 260,
                      fit: BoxFit.cover,

                      loadingBuilder: (
                          context,
                          child,
                          loadingProgress,
                          ) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return const SizedBox(
                          height: 330,
                          width: 260,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },

                      errorBuilder: (
                          context,
                          error,
                          stackTrace,
                          ) {
                        return Container(
                          height: 330,
                          width: 260,
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),

                    // Buton inapoi
                    Positioned(
                      top: 15,
                      left: 20,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    // Favorite
                    Positioned(
                      top: 15,
                      right: 20,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: () {
                            context
                                .read<StoreCubit>()
                                .toggleFavorite(product.id);
                          },
                          icon: Icon(
                            favorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: favorite
                                ? Colors.redAccent
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Detaliile produsului
              Container(
                padding: const EdgeInsets.all(25),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Nume si pret
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Expanded(
                          child: Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),

                        const SizedBox(width: 15),

                        Text(
                          '\$ ${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Rating
                    useJsonDetails
                        ? Row(
                      children: [
                        const Text(
                          '★★★★★',
                          style: TextStyle(
                            color: Color(0xFF4E8E82),
                          ),
                        ),

                        const SizedBox(width: 5),

                        Text(
                          '(${product.ratingCount ?? 83})',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),

                        const Spacer(),

                        Text(
                          product.rating?.toStringAsFixed(1) ?? '4.9',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                        : const Text(
                      '★★★★★  (83)',
                      style: TextStyle(
                        color: Color(0xFF4E8E82),
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Divider(),

                    // Color si Size
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Color'),
                        Text('Size'),
                      ],
                    ),

                    const SizedBox(height: 20),

                    useJsonDetails
                        ? Row(
                      children: [

                        // Culorile din JSON
                        ...product.availableColors.map(
                              (productColor) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                right: 12,
                              ),
                              child: circleColor(
                                hexToColor(productColor.value),
                                selected:
                                product.selectedColor ==
                                    productColor.id,
                              ),
                            );
                          },
                        ),

                        const Spacer(),

                        // Marimile din JSON
                        ...product.availableSizes.map(
                              (size) {
                            return sizeCircle(
                              size,
                              selected:
                              product.selectedSize == size,
                            );
                          },
                        ),
                      ],
                    )
                        : Row(
                      children: [

                        // Culorile din Lab 2
                        circleColor(
                          const Color(0xFFEFC6AA),
                        ),

                        const SizedBox(width: 12),

                        circleColor(
                          Colors.black,
                        ),

                        const SizedBox(width: 12),

                        circleColor(
                          Colors.redAccent,
                        ),

                        const Spacer(),

                        // Marimile din Lab 2
                        sizeCircle('S'),
                        sizeCircle('M'),
                        sizeCircle(
                          'L',
                          selected: true,
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    const Divider(),

                    // Description
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Description',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Text(
                      useJsonDetails
                          ? (product.description ??
                          'Sportswear is no longer under culture, '
                              'it is no longer indie or cobbled together '
                              'as it once was. Sport is fashion today. '
                              'The top is oversized in fit and style, '
                              'may need to size down.')
                          : 'Sportswear is no longer under culture, '
                          'it is no longer indie or cobbled together '
                          'as it once was. Sport is fashion today. '
                          'The top is oversized in fit and style, '
                          'may need to size down.',
                      style: const TextStyle(
                        color: Colors.grey,
                        height: 1.5,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Divider(),

                    // Reviews
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Reviews'),
                        Icon(
                          Icons.keyboard_arrow_down,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Imaginea cu distributia ratingurilor din Lab 2
                    Image.asset(
                      'assets/images/9.png',
                      width: double.infinity,
                    ),

                    const SizedBox(height: 30),

                    // Pentru Sportwear Set review-urile vin din JSON
                    if (useJsonDetails)
                      ...product.reviews.map(
                            (productReview) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: 30,
                            ),
                            child: reviewFromJson(
                              productReview,
                            ),
                          );
                        },
                      )
                    else ...[
                      // Review-urile originale din Lab 2
                      review(
                        'assets/images/10.png',
                        'Jennifer Rose',
                        '5m ago',
                        'I love it. Awesome customer service!! '
                            'Helped me out with adding an additional '
                            'item to my order. Thanks again!',
                      ),

                      const SizedBox(height: 30),

                      review(
                        'assets/images/11.png',
                        'Kelly Rihana',
                        '9m ago',
                        'I\'m very happy with order, it was delivered '
                            'on and good quality. Recommended!',
                      ),
                    ],

                    const SizedBox(height: 30),

                    const Divider(),

                    // Similar Product
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Similar Product',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Image.asset(
                      'assets/images/12.png',
                      width: double.infinity,
                    ),

                    const SizedBox(height: 25),

                    // Add To Cart
                    Image.asset(
                      'assets/images/13.png',
                      width: double.infinity,
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Creeaza cercurile pentru culori
Widget circleColor(
    Color color, {
      bool selected = false,
    }) {
  return Container(
    width: 32,
    height: 32,
    padding: const EdgeInsets.all(3),
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      border: selected
          ? Border.all(
        color: Colors.grey.shade500,
        width: 2,
      )
          : null,
      boxShadow: selected
          ? [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 5,
        ),
      ]
          : null,
    ),
    child: Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    ),
  );
}

// Transforma culoarea din JSON in Color
Color hexToColor(String hex) {
  String value = hex.replaceAll('#', '');

  if (value.length == 6) {
    value = 'FF$value';
  }

  return Color(
    int.parse(value, radix: 16),
  );
}

// Creeaza cercurile pentru marimi
Widget sizeCircle(
    String text, {
      bool selected = false,
    }) {
  return Container(
    margin: const EdgeInsets.only(left: 8),
    width: 32,
    height: 32,
    decoration: BoxDecoration(
      color: selected
          ? Colors.grey.shade700
          : Colors.grey.shade100,
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          color: selected
              ? Colors.white
              : Colors.grey,
        ),
      ),
    ),
  );
}

// Review folosit pentru produsele care pastreaza designul din Lab 2
Widget review(
    String image,
    String name,
    String time,
    String description,
    ) {
  return Column(
    children: [

      Row(
        children: [

          ClipOval(
            child: Image.asset(
              image,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Text(
                  '★★★★★',
                  style: TextStyle(
                    color: Color(0xFF4E8E82),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Text(
            time,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),

      const SizedBox(height: 12),

      Text(
        description,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 11,
          height: 1.5,
        ),
      ),
    ],
  );
}

// Review citit din JSON
Widget reviewFromJson(ProductReview review) {
  return Column(
    children: [

      Row(
        children: [

          ClipOval(
            child: Image.network(
              review.avatarUrl,
              width: 40,
              height: 40,
              fit: BoxFit.cover,

              errorBuilder: (
                  context,
                  error,
                  stackTrace,
                  ) {
                return Container(
                  width: 40,
                  height: 40,
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  review.author,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),

                Text(
                  createStars(review.rating),
                  style: const TextStyle(
                    color: Color(0xFF4E8E82),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Text(
            review.createdAtLabel,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),

      const SizedBox(height: 12),

      Text(
        review.text,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 11,
          height: 1.5,
        ),
      ),
    ],
  );
}

// Creeaza stelele in functie de rating
String createStars(double rating) {
  final int starCount = rating.round();

  return List.generate(
    5,
        (index) => index < starCount ? '★' : '☆',
  ).join();
}