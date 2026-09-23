enum OrderType {
  sell,
  buy,
  repair,
}

enum UnifiedOrderStatus {
  placed,
  confirmed,
  technicianAssigned,
  outForPickupDelivery,
  completed,
  cancelled,
}

class UnifiedOrder {
  final String orderId;
  final OrderType type;
  final String deviceTitle;
  final String deviceSubtitle;
  final double amount;
  final DateTime orderDate;
  final UnifiedOrderStatus status;
  final String statusText;
  final String? trackingId;
  final String? address;

  const UnifiedOrder({
    required this.orderId,
    required this.type,
    required this.deviceTitle,
    required this.deviceSubtitle,
    required this.amount,
    required this.orderDate,
    required this.status,
    required this.statusText,
    this.trackingId,
    this.address,
  });
}
