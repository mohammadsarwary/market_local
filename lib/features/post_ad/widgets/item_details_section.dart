import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/common_input_fields.dart';
import '../post_ad_controller.dart';

class ItemDetailsSection extends StatelessWidget {
  const ItemDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostAdController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Item Details',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),

        // Title Field
        const Text('Title', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
        const SizedBox(height: 10),
        AppTextField(
          controller: controller.titleController,
          hintText: 'What are you selling?',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),

        const SizedBox(height: 24),
        
        // Category Dropdown
        const Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
        const SizedBox(height: 10),
        Obx(() => DropdownButtonFormField<String>(
              value: controller.selectedCategory.value,
              hint: Text('Select a category', style: TextStyle(color: Colors.grey[400])),
              icon: const Icon(Icons.keyboard_arrow_down),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
              items: controller.categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) => controller.updateCategory(value),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a category';
                }
                return null;
              },
            )),

        const SizedBox(height: 24),
        
        // Condition Selection
        const Text('Condition', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
        const SizedBox(height: 12),
        Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: controller.conditions.map((condition) {
                  final isSelected = controller.selectedCondition.value == condition;
                  return GestureDetector(
                    onTap: () => controller.updateCondition(condition),
                    child: Container(
                      width: 95,
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.grey[300]!,
                        ),
                      ),
                      child: Text(
                        condition,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            )),

        const SizedBox(height: 24),
        
        // Price Field
        const Text('Price', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
        const SizedBox(height: 10),
        AppPriceField(
          controller: controller.priceController,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a price';
            }
            final price = double.tryParse(value.trim());
            if (price == null || price <= 0) {
              return 'Please enter a valid price';
            }
            return null;
          },
        ),

        const SizedBox(height: 24),
        
        // Description Field
        const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
        const SizedBox(height: 10),
        AppTextArea(
          controller: controller.descriptionController,
          hintText: 'Describe your item in detail (brand, usage, faults)...',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a description';
            }
            if (value.trim().length < 10) {
              return 'Description must be at least 10 characters';
            }
            return null;
          },
        ),
      ],
    );
  }
}
