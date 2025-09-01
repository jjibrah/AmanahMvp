import 'package:flutter/material.dart';
import 'package:amanahmvp/models/active_order.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsPage extends StatefulWidget {
  final ActiveOrder order;
  const OrderDetailsPage({super.key, required this.order});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  static const Color emerald = Color.fromARGB(255, 51, 187, 120);
  static const Color backgroundWhite = Color(0xFFF7F8FA);
  static const Color cardBg = Colors.white;
  static const Color textPrimary = Color(0xFF222B45);
  static const Color textSecondary = Color(0xFF8F9BB3);
  static const Color divider = Color(0xFFF1F1F1);

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    return Scaffold(
      backgroundColor: backgroundWhite,
      appBar: AppBar(
        title: const Text('Order Details', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: backgroundWhite,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: emerald,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: order.status == OrderStatus.delivered
                ? null
                : () {
                    setState(() => order.status = OrderStatus.delivered);
                    Navigator.of(context).pop(order);
                  },
            icon: const Icon(Icons.check_circle_outline),
            label: Text(order.status == OrderStatus.delivered ? 'Delivered' : 'Mark as delivered'),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _infoTile(Icons.store_mall_directory_outlined, order.merchantOrTitle, bold: true),
          const SizedBox(height: 6),
          _infoTile(Icons.person_outline, 'Customer: ${order.customerName}'),
          const SizedBox(height: 6),
          _infoTile(Icons.location_on_outlined, 'Pickup: ${order.pickupAddress}'),
          const SizedBox(height: 6),
          _infoTile(Icons.flag_outlined, 'Drop-off: ${order.dropoffAddress}'),
          const SizedBox(height: 6),
          _infoTile(Icons.route_outlined, '${order.distanceKm.toStringAsFixed(1)} km • ETA ${order.etaMinutes} min'),
          const SizedBox(height: 12),
          const Divider(color: divider),
          const SizedBox(height: 12),
          Row(
            children: [
              _chip(order.type, const Color(0xFFEFF7FF), const Color(0xFF1F7AE0)),
              const SizedBox(width: 8),
              _chip(_statusLabel(order.status), _statusBg(order.status), _statusFg(order.status)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String text, {bool bold = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: textPrimary, fontWeight: bold ? FontWeight.w600 : FontWeight.w400),
          ),
        ),
      ],
    );
  }

  Widget _chip(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
      child: Text(label, style: TextStyle(color: fg, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }

  String _statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.pickedUp:
        return 'Picked Up';
      case OrderStatus.onTheWay:
        return 'On the Way';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  Color _statusBg(OrderStatus status) {
    switch (status) {
      case OrderStatus.pickedUp:
        return const Color(0xFFE6F7F1);
      case OrderStatus.onTheWay:
        return const Color(0xFFE8F0FE);
      case OrderStatus.delivered:
        return const Color(0xFFEFF7E9);
    }
  }

  Color _statusFg(OrderStatus status) {
    switch (status) {
      case OrderStatus.pickedUp:
        return emerald;
      case OrderStatus.onTheWay:
        return const Color(0xFF1F7AE0);
      case OrderStatus.delivered:
        return const Color(0xFF3E8E41);
    }
  }

  Widget _iconButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: textSecondary.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Icon(icon, color: emerald, size: 24),
      ),
    );
  }

  void _showNavigateSheet(String address, String locationType) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Navigate to $locationType',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            _sheetAction(
              icon: Icons.near_me_outlined,
              label: 'Google Maps',
              onTap: () async {
                final encoded = Uri.encodeComponent(address);
                final url = 'https://www.google.com/maps/search/?api=1&query=$encoded';
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
                Navigator.pop(context);
              },
            ),
            _sheetAction(
              icon: Icons.near_me,
              label: 'Waze',
              onTap: () async {
                final encoded = Uri.encodeComponent(address);
                final url = 'https://waze.com/ul?q=$encoded';
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
                Navigator.pop(context);
              },
            ),
            _sheetAction(
              icon: Icons.map_outlined,
              label: 'Apple Maps',
              onTap: () async {
                final encoded = Uri.encodeComponent(address);
                final url = 'https://maps.apple.com/?q=$encoded';
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 8),
            _cancelSheetButton(),
          ],
        ),
      ),
    );
  }

  Widget _sheetAction({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFEDEDED))),
        ),
        child: Row(
          children: [
            Icon(icon, color: textSecondary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: textPrimary, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cancelSheetButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: cardBg,
          foregroundColor: textPrimary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
        ),
        onPressed: () => Navigator.pop(context),
        child: const Text(
          'Cancel',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
} 