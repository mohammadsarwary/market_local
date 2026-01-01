import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// A reusable product card widget for displaying product information
/// 
/// This widget displays a product with its image, title, price, location,
/// and time posted. It includes a favorite button with animation and optional
/// condition badge. The card is designed for use in grid layouts.
/// 
/// Features:
/// - Hero animation for smooth image transitions
/// - Animated favorite button with scale effect
/// - Optional condition badge (New, Used, etc.)
/// - Tap handlers for card and favorite button
/// 
/// Example:
/// ```dart
/// ProductCard(
///   imageUrl: 'https://example.com/image.jpg',
///   title: 'Mountain Bike',
///   price: 299.99,
///   location: 'San Francisco, CA',
///   timeAgo: '2h ago',
///   isLiked: true,
///   condition: 'New',
///   onTap: () => Navigator.pushNamed(context, '/details'),
///   onFavoriteTap: () => controller.toggleFavorite(id),
///   heroTag: 'product_123',
/// )
/// ```
class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double price;
  final String location;
  final String timeAgo;
  final bool isLiked;
  final String? condition;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final String heroTag;

  /// Creates a product card widget
  /// 
  /// All parameters except [onTap] and [onFavoriteTap] are required.
  /// 
  /// Parameters:
  /// - [imageUrl] The URL of the product image
  /// - [title] The product title
  /// - [price] The product price
  /// - [location] The product location
  /// - [timeAgo] Time since the product was posted (e.g., '2h ago')
  /// - [isLiked] Whether the product is favorited (defaults to false)
  /// - [condition] Optional condition badge text (e.g., 'New', 'Used')
  /// - [onTap] Optional callback when the card is tapped
  /// - [onFavoriteTap] Optional callback when the favorite button is tapped
  /// - [heroTag] Unique tag for Hero animation (defaults to empty string)
  /// - [key] Optional widget key
  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.location,
    required this.timeAgo,
    this.isLiked = false,
    this.condition,
    this.onTap,
    this.onFavoriteTap,
    this.heroTag = '',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: AspectRatio(
                    aspectRatio: 1.1,
                    child: Hero(
                      tag: 'product_image_$heroTag',
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: AnimatedScale(
                        scale: isLiked ? 1.2 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: isLiked ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                if (condition != null)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        condition!.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        timeAgo,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
