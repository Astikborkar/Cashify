import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_pill.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../routes/route_paths.dart';
import '../../domain/models/unified_order_model.dart';
import '../providers/orders_provider.dart';

class OrderHistoryScreen extends ConsumerStatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  ConsumerState<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends ConsumerState<OrderHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allOrders = ref.watch(ordersNotifierProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Orders & Services',
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.neutral600,
          indicatorColor: AppColors.primary,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          isScrollable: true,
          tabs: const [
            Tab(text: 'All Orders'),
            Tab(text: 'Sell Requests'),
            Tab(text: 'Doorstep Repairs'),
            Tab(text: 'Refurbished Buys'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _OrdersListView(orders: allOrders),
          _OrdersListView(orders: allOrders.where((o) => o.type == OrderType.sell).toList()),
          _OrdersListView(orders: allOrders.where((o) => o.type == OrderType.repair).toList()),
          _OrdersListView(orders: allOrders.where((o) => o.type == OrderType.buy).toList()),
        ],
      ),
    );
  }
}

class _OrdersListView extends ConsumerWidget {
  final List<UnifiedOrder> orders;

  const _OrdersListView({required this.orders});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (orders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.neutral400),
            SizedBox(height: AppSpacing.md),
            Text('No orders in this category', style: TextStyle(color: AppColors.neutral600, fontSize: 15)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: AppSpacing.screenPadding,
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final order = orders[index];
        return AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header: Type & Order ID
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      BadgePill(
                        text: _getOrderTypeLabel(order.type),
                        type: _getOrderBadgeType(order.type),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '#${order.orderId}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.neutral700),
                      ),
                    ],
                  ),
                  Text(
                    '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}',
                    style: const TextStyle(fontSize: 11, color: AppColors.neutral500),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Device & Subtitle
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.neutral100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(_getOrderIcon(order.type), color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.deviceTitle,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          order.deviceSubtitle,
                          style: const TextStyle(fontSize: 12, color: AppColors.neutral600),
                        ),
                        if (order.address != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            order.address!,
                            style: const TextStyle(fontSize: 11, color: AppColors.neutral500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),
              const Divider(height: 1),
              const SizedBox(height: AppSpacing.sm),

              // Price & Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.type == OrderType.sell ? 'Payout Value' : 'Total Amount',
                        style: const TextStyle(fontSize: 11, color: AppColors.neutral500),
                      ),
                      Text(
                        CurrencyFormatter.format(order.amount),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.neutral900),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: order.status == UnifiedOrderStatus.completed
                          ? AppColors.success.withAlpha(25)
                          : AppColors.secondary.withAlpha(50),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order.statusText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: order.status == UnifiedOrderStatus.completed
                            ? AppColors.success
                            : AppColors.neutral900,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Action Buttons
              Row(
                children: [
                  if (order.type == OrderType.repair &&
                      order.status == UnifiedOrderStatus.technicianAssigned) ...[
                    Expanded(
                      child: AppButton(
                        text: 'Track Technician',
                        icon: Icons.navigation_rounded,
                        onPressed: () {
                          context.push(RoutePaths.repairTracking.replaceAll(':orderId', order.orderId));
                        },
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Downloading GST Invoice for #${order.orderId}...')),
                          );
                        },
                        child: const Text('Download Invoice', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                  const SizedBox(width: AppSpacing.sm),
                  IconButton(
                    icon: const Icon(Icons.support_agent_rounded, color: AppColors.primary),
                    tooltip: 'Ask Support regarding this order',
                    onPressed: () {
                      context.push(RoutePaths.supportChat);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _getOrderTypeLabel(OrderType type) {
    switch (type) {
      case OrderType.sell:
        return 'SELL';
      case OrderType.buy:
        return 'BUY';
      case OrderType.repair:
        return 'REPAIR';
    }
  }

  BadgeType _getOrderBadgeType(OrderType type) {
    switch (type) {
      case OrderType.sell:
        return BadgeType.success;
      case OrderType.buy:
        return BadgeType.primary;
      case OrderType.repair:
        return BadgeType.warning;
    }
  }

  IconData _getOrderIcon(OrderType type) {
    switch (type) {
      case OrderType.sell:
        return Icons.currency_exchange_rounded;
      case OrderType.buy:
        return Icons.phone_iphone_rounded;
      case OrderType.repair:
        return Icons.build_circle_outlined;
    }
  }
}
