import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/ad/ad_models.dart';

class ProductImageSection extends StatelessWidget {
  final AdModel product;

  const ProductImageSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'product_${product.id}',
      child: Container(
        height: 350,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              product.images.isNotEmpty ? product.images.first : 'https://via.placeholder.com/500',
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
