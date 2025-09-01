enum OrderStatus { pickedUp, onTheWay, delivered }

class ActiveOrder {
  final String id;
  final String merchantOrTitle;
  final String customerName;
  final String pickupAddress;
  final String dropoffAddress;
  final double distanceKm;
  final int etaMinutes;
  final String type; // Food, Parcel, Medicine, etc.
  OrderStatus status;
  final double earnings;

  ActiveOrder({
    required this.id,
    required this.merchantOrTitle,
    required this.customerName,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.distanceKm,
    required this.etaMinutes,
    required this.type,
    required this.status,
    required this.earnings,
  });
} 