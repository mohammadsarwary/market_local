import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/ad_details_app_bar.dart';
import 'widgets/product_image_section.dart';
import 'widgets/product_info_section.dart';
import 'widgets/description_section.dart';
import 'widgets/map_section.dart';
import 'widgets/seller_info_section.dart';
import 'widgets/safety_tip_section.dart';
import 'widgets/bottom_action_bar.dart';
import '../../models/ad/ad_models.dart';

class AdDetailsScreen extends StatelessWidget {
  const AdDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AdModel? product = Get.arguments as AdModel?;
    if (product == null) {
      return const Scaffold(
        body: Center(child: Text('Product not found')),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AdDetailsAppBar(product: product),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ProductImageSection(product: product),
            
            // Product Details Container
            Container(
              transform: Matrix4.translationValues(0, -20, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Info Section
                    ProductInfoSection(product: product),
                    
                    const SizedBox(height: 24),
                    
                    // Description Section
                    DescriptionSection(
                      description: 'This item is in great condition and works perfectly. Well maintained and clean. Ready for a new owner!\n\nIncludes all original accessories and packaging. Feel free to ask any questions.',
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Map Section
                    MapSection(location: product.location),
                    
                    const SizedBox(height: 32),
                    
                    // Seller Info Section
                    SellerInfoSection(
                      sellerName: 'John Doe',
                      sellerAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&q=80&w=150',
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Safety Tip Section
                    const SafetyTipSection(),
                    
                    const SizedBox(height: 100), // Space for bottom bar
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: BottomActionBar(),
    );
  }
}
