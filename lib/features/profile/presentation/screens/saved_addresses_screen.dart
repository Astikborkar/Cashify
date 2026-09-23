import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/badge_pill.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../domain/models/saved_address_model.dart';
import '../providers/address_provider.dart';

class SavedAddressesScreen extends ConsumerWidget {
  const SavedAddressesScreen({super.key});

  void _showAddAddressSheet(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController(text: 'Rahul Sharma');
    final phoneCtrl = TextEditingController(text: '+91 98765 43210');
    final flatCtrl = TextEditingController();
    final areaCtrl = TextEditingController();
    final landmarkCtrl = TextEditingController();
    final pincodeCtrl = TextEditingController(text: '560038');
    final cityCtrl = TextEditingController(text: 'Bengaluru');
    final stateCtrl = TextEditingController(text: 'Karnataka');
    AddressTag selectedTag = AddressTag.home;
    bool isDefault = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.cardRadiusLg)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                top: AppSpacing.lg,
                bottom: MediaQuery.of(modalCtx).viewInsets.bottom + AppSpacing.xl,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Add New Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Tag selector
                    Row(
                      children: [
                        ChoiceChip(
                          label: const Text('Home'),
                          selected: selectedTag == AddressTag.home,
                          selectedColor: AppColors.primaryLight,
                          onSelected: (_) => setModalState(() => selectedTag = AddressTag.home),
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Work'),
                          selected: selectedTag == AddressTag.work,
                          selectedColor: AppColors.primaryLight,
                          onSelected: (_) => setModalState(() => selectedTag = AddressTag.work),
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Other'),
                          selected: selectedTag == AddressTag.other,
                          selectedColor: AppColors.primaryLight,
                          onSelected: (_) => setModalState(() => selectedTag = AddressTag.other),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    AppTextField(label: 'Full Name', controller: nameCtrl),
                    const SizedBox(height: AppSpacing.sm),
                    AppTextField(label: 'Phone Number', controller: phoneCtrl, keyboardType: TextInputType.phone),
                    const SizedBox(height: AppSpacing.sm),
                    AppTextField(label: 'Flat / House No. / Building', controller: flatCtrl, hint: 'e.g., Flat 302, Sunrise Towers'),
                    const SizedBox(height: AppSpacing.sm),
                    AppTextField(label: 'Street / Colony / Locality', controller: areaCtrl, hint: 'e.g., Indiranagar 100ft Road'),
                    const SizedBox(height: AppSpacing.sm),
                    AppTextField(label: 'Landmark', controller: landmarkCtrl, hint: 'e.g., Near Metro Station'),
                    const SizedBox(height: AppSpacing.sm),

                    Row(
                      children: [
                        Expanded(child: AppTextField(label: 'Pincode', controller: pincodeCtrl, keyboardType: TextInputType.number)),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(child: AppTextField(label: 'City', controller: cityCtrl)),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.md),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Make this my default address', style: TextStyle(fontSize: 13)),
                      value: isDefault,
                      onChanged: (val) => setModalState(() => isDefault = val ?? false),
                    ),

                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      text: 'Save Address',
                      onPressed: () {
                        if (flatCtrl.text.isEmpty || areaCtrl.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill all mandatory address fields.')),
                          );
                          return;
                        }

                        final newAddress = SavedAddress(
                          id: 'ADDR-${DateTime.now().millisecondsSinceEpoch}',
                          fullName: nameCtrl.text.trim(),
                          phoneNumber: phoneCtrl.text.trim(),
                          flatHouseNumber: flatCtrl.text.trim(),
                          streetArea: areaCtrl.text.trim(),
                          landmark: landmarkCtrl.text.trim(),
                          city: cityCtrl.text.trim(),
                          state: stateCtrl.text.trim(),
                          pincode: pincodeCtrl.text.trim(),
                          tag: selectedTag,
                          isDefault: isDefault,
                        );

                        ref.read(addressNotifierProvider.notifier).addAddress(newAddress);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('New address saved successfully!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(addressNotifierProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Saved Addresses'),
      body: addresses.isEmpty
          ? const Center(
              child: Text('No saved addresses yet. Tap below to add one.'),
            )
          : ListView.separated(
              padding: AppSpacing.screenPadding,
              itemCount: addresses.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final addr = addresses[index];
                return AppCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                addr.tag == AddressTag.home
                                    ? Icons.home_rounded
                                    : addr.tag == AddressTag.work
                                        ? Icons.work_rounded
                                        : Icons.location_on_rounded,
                                size: 18,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                addr.tag.name.toUpperCase(),
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                              ),
                              if (addr.isDefault) ...[
                                const SizedBox(width: 8),
                                const BadgePill(text: 'DEFAULT', type: BadgeType.success),
                              ],
                            ],
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, size: 20, color: AppColors.neutral600),
                            onSelected: (val) {
                              if (val == 'default') {
                                ref.read(addressNotifierProvider.notifier).setDefault(addr.id);
                              } else if (val == 'delete') {
                                ref.read(addressNotifierProvider.notifier).deleteAddress(addr.id);
                              }
                            },
                            itemBuilder: (context) => [
                              if (!addr.isDefault)
                                const PopupMenuItem(
                                  value: 'default',
                                  child: Text('Set as Default'),
                                ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete Address', style: TextStyle(color: AppColors.error)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        addr.fullName,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        addr.formattedAddress,
                        style: const TextStyle(fontSize: 13, color: AppColors.neutral700, height: 1.4),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Mobile: ${addr.phoneNumber}',
                        style: const TextStyle(fontSize: 12, color: AppColors.neutral500),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: AppButton(
            text: '+ Add New Pickup / Delivery Address',
            onPressed: () => _showAddAddressSheet(context, ref),
          ),
        ),
      ),
    );
  }
}
