import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/unified_order_model.dart';

class OrdersNotifier extends StateNotifier<List<UnifiedOrder>> {
  OrdersNotifier()
      : super([
          UnifiedOrder(
            orderId: 'REP-84920',
            type: OrderType.repair,
            deviceTitle: 'Apple iPhone 13 (Screen Glass Replacement)',
            deviceSubtitle: 'Doorstep Repair • Rajesh Kumar assigned',
            amount: 2899.0,
            orderDate: DateTime.now(),
            status: UnifiedOrderStatus.technicianAssigned,
            statusText: 'Technician on the way (ETA 25m)',
            trackingId: 'TRACK-REP-84920',
            address: '#402, Green View Apts, Indiranagar, Bengaluru',
          ),
          UnifiedOrder(
            orderId: 'SO-77491',
            type: OrderType.sell,
            deviceTitle: 'Apple iPhone 13 (128GB - Midnight)',
            deviceSubtitle: 'Sell Device • Pickup Completed & Paid',
            amount: 27400.0,
            orderDate: DateTime.now().subtract(const Duration(days: 2)),
            status: UnifiedOrderStatus.completed,
            statusText: 'Paid to Cashify Wallet',
            trackingId: 'PICKUP-77491',
            address: '#402, Green View Apts, Indiranagar, Bengaluru',
          ),
          UnifiedOrder(
            orderId: 'BO-91823',
            type: OrderType.buy,
            deviceTitle: 'Apple MacBook Air M1 (256GB - Space Grey)',
            deviceSubtitle: 'Refurbished Superb • 1-Year Warranty',
            amount: 54999.0,
            orderDate: DateTime.now().subtract(const Duration(days: 12)),
            status: UnifiedOrderStatus.completed,
            statusText: 'Delivered via Bluedart Express',
            trackingId: 'BLUEDART-882194',
            address: '#402, Green View Apts, Indiranagar, Bengaluru',
          ),
          UnifiedOrder(
            orderId: 'SO-66120',
            type: OrderType.sell,
            deviceTitle: 'OnePlus 8T (128GB - Aquamarine Green)',
            deviceSubtitle: 'Sell Device • Completed Pickup',
            amount: 14200.0,
            orderDate: DateTime.now().subtract(const Duration(days: 45)),
            status: UnifiedOrderStatus.completed,
            statusText: 'Paid via IMPS to HDFC Bank',
            trackingId: 'PICKUP-66120',
            address: '#402, Green View Apts, Indiranagar, Bengaluru',
          ),
        ]);

  void cancelOrder(String orderId) {
    state = state.map((o) {
      if (o.orderId == orderId) {
        return UnifiedOrder(
          orderId: o.orderId,
          type: o.type,
          deviceTitle: o.deviceTitle,
          deviceSubtitle: o.deviceSubtitle,
          amount: o.amount,
          orderDate: o.orderDate,
          status: UnifiedOrderStatus.cancelled,
          statusText: 'Cancelled by User',
          trackingId: o.trackingId,
          address: o.address,
        );
      }
      return o;
    }).toList();
  }
}

final ordersNotifierProvider = StateNotifierProvider<OrdersNotifier, List<UnifiedOrder>>((ref) {
  return OrdersNotifier();
});
