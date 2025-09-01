import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'order_preview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({Key? key}) : super(key: key);

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  static const Color emerald = Color.fromARGB(255, 51, 187, 120);
  static const Color backgroundWhite = Color(0xFFF7F8FA);
  static const Color cardBg = Colors.white;
  static const Color textPrimary = Color(0xFF222B45);
  static const Color textSecondary = Color(0xFF8F9BB3);

  bool isOnline = false;

  // Deliveries loaded from Supabase
  final List<Map<String, String>> _activeDeliveries = [];
  bool _isLoading = false;

  final Map<String, Map<String, dynamic>> statusConfig = {
    'Assigned': {
      'button': 'Mark as Pickup in Progress',
      'next': 'Pickup in Progress',
      'badge': 'Assigned',
      'badgeColor': const Color(0xFFFAE1D3), // Soft orange background
      'buttonColor': const Color(0xFFF57C00), // Deep orange
    },
    'Pickup in Progress': {
      'button': 'Mark as Picked Up',
      'next': 'Picked Up',
      'badge': 'Pickup in Progress',
      'badgeColor': const Color(0xFFD0E8FF), // Soft blue background
      'buttonColor': const Color(0xFF1976D2), // Blue
    },
    'Picked Up': {
      'button': 'Mark as On The Way',
      'next': 'On The Way',
      'badge': 'Picked Up',
      'badgeColor': const Color(0xFFE1D7FA), // Soft purple background
      'buttonColor': const Color(0xFF7E57C2), // Purple
    },
    'On The Way': {
      'button': 'Mark as Delivered',
      'next': 'Delivered',
      'badge': 'On The Way',
      'badgeColor': const Color(0xFFD3FAD6), // Soft green background
      'buttonColor': const Color(0xFF388E3C), // Green
    },
    'Delivered': {
      'button': 'Delivered',
      'next': '',
      'badge': 'Delivered',
      'badgeColor': const Color(0xFF388E3C), // Soft grey background
      'buttonColor': const Color(0xFF388E3C), // Grey
    },
  };

  // Helper to get badge color
  Color _getBadgeColor(String status) {
    switch (status) {
      case 'Assigned':
        return const Color(0xFFF57C00); // Deep orange
      case 'Pickup in Progress':
        return const Color(0xFF1976D2); // Blue
      case 'Picked Up':
        return const Color(0xFF7E57C2); // Purple
      case 'On The Way':
        return const Color(0xFF388E3C); // Green
      case 'Delivered':
        return const Color(0xFF388E3C); // Grey
      default:
        return const Color(0xFFBDBDBD); // Default grey
    }
  }

  void _openOrderPreview(Map<String, String> d) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => OrderPreviewPage(order: d)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundWhite,
      appBar: AppBar(
        backgroundColor: backgroundWhite,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.notifications_none, color: textPrimary),
          ),
        ],
      ),
      body: SafeArea(child: _buildDashboardBody()),
    );
  }

  // --- Supabase integration ---
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _subscribeToDeliveryChanges();
    _loadDeliveries();
  }

  Future<void> _loadDeliveries() async {
    setState(() => _isLoading = true);
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }
    final List<dynamic> rows = await _supabase
        .from('deliveries')
        .select()
        .eq('rider_id', userId)
        .order('created_at', ascending: false)
        .limit(50);

    _activeDeliveries
      ..clear()
      ..addAll(rows.map<Map<String, String>>((r) => _mapDbRowToUi(r)));
    setState(() => _isLoading = false);
  }

  Map<String, String> _mapDbRowToUi(Map<String, dynamic> r) {
    return {
      'id': r['id']?.toString() ?? '',
      'merchant': r['merchant']?.toString() ?? '',
      'customer': r['customer_name']?.toString() ?? '',
      'pickup': r['pickup']?.toString() ?? '',
      'dropoff': r['dropoff']?.toString() ?? '',
      'price': (r['price'] ?? r['amount'] ?? '').toString(),
      'status': r['status']?.toString() ?? 'New',
      'pickupPhone': r['pickup_phone']?.toString() ?? '',
      'customerPhone': r['customer_phone']?.toString() ?? '',
      'pickupQuery': r['pickup']?.toString() ?? '',
      'dropoffQuery': r['dropoff']?.toString() ?? '',
      'eta': r['eta']?.toString() ?? '',
      'distance': r['distance']?.toString() ?? '',
      'pickupLat': (r['pickup_lat']?.toString() ?? ''),
      'pickupLng': (r['pickup_lng']?.toString() ?? ''),
      'dropoffLat': (r['dropoff_lat']?.toString() ?? ''),
      'dropoffLng': (r['dropoff_lng']?.toString() ?? ''),
      'items': r['items']?.toString() ?? '',
      'instructions': r['instructions']?.toString() ?? '',
    };
  }

  void _subscribeToDeliveryChanges() {
    _supabase
        .channel('deliveries-changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'deliveries',
          callback: (payload) {
            final updated = payload.newRecord;
            setState(() {
              final index = _activeDeliveries.indexWhere(
                (d) => d['id'] == (updated['id']?.toString() ?? ''),
              );
              if (index != -1) {
                _activeDeliveries[index]['status'] = (updated['status'] ?? '')
                    .toString();
              }
            });
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'deliveries',
          callback: (payload) {
            final inserted = payload.newRecord;
            final userId = Supabase.instance.client.auth.currentUser?.id;
            if (inserted['rider_id']?.toString() == userId) {
              setState(() {
                _activeDeliveries.insert(0, _mapDbRowToUi(inserted));
              });
            }
          },
        )
        .subscribe();
  }

  Future<void> _updateDeliveryStatus(
    String deliveryId,
    String newStatus,
  ) async {
    await _supabase
        .from('deliveries')
        .update({'status': newStatus})
        .eq('id', deliveryId);
  }

  Widget _buildDashboardBody() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: _buildOverlayContent(),
    );
  }

  Widget _buildOverlayContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AppBar already renders title and bell
          const SizedBox(height: 4),
          // Online status card
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: isOnline ? emerald : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isOnline ? "You're Online" : "You're Offline",
                        style: const TextStyle(
                          color: textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        isOnline
                            ? 'Ready to receive orders'
                            : 'Go online to receive orders',
                        style: const TextStyle(color: textSecondary),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isOnline,
                  activeColor: emerald,
                  onChanged: (v) => setState(() => isOnline = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Stats row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(title: 'Deliveries', value: '5'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(title: 'Online', value: '4.5h'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            )
          else ...[
            const Text(
              'Active Deliveries',
              style: TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            ..._activeDeliveries.map((d) => _buildDeliveryCard(d)).toList(),
          ],
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildStatCard({required String title, required String value}) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              color: emerald,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(color: textSecondary)),
        ],
      ),
    );
  }

  Widget _iconButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: textPrimary),
      ),
    );
  }

  void _showNavigateSheet(Map<String, String> d) {
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
            const Text(
              'Navigate',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            _sheetAction(
              icon: Icons.location_on,
              label: 'Navigate to Pickup',
              onTap: () {
                Navigator.pop(context);
                _showMapsOptions(d['pickup'] ?? '');
              },
            ),
            _sheetAction(
              icon: Icons.location_on,
              label: 'Navigate to Drop-off',
              onTap: () {
                Navigator.pop(context);
                _showMapsOptions(d['dropoff'] ?? '');
              },
            ),
            const SizedBox(height: 8),
            _cancelSheetButton(),
          ],
        ),
      ),
    );
  }

  void _showMapsOptions(String query) {
    if (query.isEmpty) return;
    final encoded = Uri.encodeComponent(query);

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
            const Text(
              'Open in...',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            _sheetActionImage(
              assetPath: 'assets/icons/googlemaps.png',
              label: 'Google Maps',
              onTap: () async {
                final url =
                    'https://www.google.com/maps/search/?api=1&query=$encoded';
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
                Navigator.pop(context);
              },
            ),
            _sheetActionImage(
              assetPath: 'assets/icons/waze.png',
              label: 'Waze',
              onTap: () async {
                final url = 'https://waze.com/ul?q=$encoded';
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
                Navigator.pop(context);
              },
            ),
            _sheetActionImage(
              assetPath: 'assets/icons/apple_maps.png',
              label: 'Apple Maps',
              onTap: () async {
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

  void _showContactSheet(Map<String, String> d) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
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
            const Text(
              'Contact',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            _sheetAction(
              icon: Icons.phone,
              label: 'Call Pickup Location ${d['pickupPhone'] ?? ''}',
              onTap: () => _makeCall(d['pickupPhone'] ?? ''),
            ),
            _sheetAction(
              icon: Icons.phone,
              label: 'Call Customer ${d['customerPhone'] ?? ''}',
              onTap: () => _makeCall(d['customerPhone'] ?? ''),
            ),
            _sheetAction(
              icon: Icons.message_outlined,
              label: 'Text Customer ${d['customerPhone'] ?? ''}',
              onTap: () => _sendText(d['customerPhone'] ?? ''),
            ),
            _sheetAction(
              icon: Icons.chat_bubble_outline,
              label: 'WhatsApp Customer ${d['customerPhone'] ?? ''}',
              onTap: () => _openWhatsApp(d['customerPhone'] ?? ''),
            ),
            const SizedBox(height: 8),
            _cancelSheetButton(),
          ],
        ),
      ),
    );
  }

  Widget _sheetAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
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

  Widget _sheetActionImage({
    required String assetPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFEDEDED))),
        ),
        child: Row(
          children: [
            Image.asset(assetPath, width: 24, height: 24),
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
        onPressed: () => Navigator.of(context).pop(),
        child: const Text(
          'Cancel',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Future<void> _openMapsQuery(String query) async {
    if (query.isEmpty) return;
    final encoded = Uri.encodeComponent(query);
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$encoded',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _makeCall(String phoneNumber) async {
    if (phoneNumber.isEmpty) return;
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _sendText(String phoneNumber) async {
    if (phoneNumber.isEmpty) return;
    final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    if (phoneNumber.isEmpty) return;
    final clean = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    final Uri whatsappUri = Uri.parse('https://wa.me/$clean');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    }
  }

  // Update _buildDeliveryCard to use the mapping
  Widget _buildDeliveryCard(Map<String, String> d) {
    final config = statusConfig[d['status']] ?? statusConfig['New']!;
    final buttonLabel = config['button'] as String;
    final nextStatus = config['next'] as String;
    final badgeText = config['badge'] as String;
    final badgeColor = config['badgeColor'] as Color;
    final buttonColor = config['buttonColor'] as Color;

    return InkWell(
      onTap: () => _openOrderPreview(d),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge at top left
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  d['merchant'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                const Spacer(),
                _iconButton(
                  icon: Icons.near_me_outlined,
                  onTap: () => _showNavigateSheet(d),
                ),
                const SizedBox(width: 8),
                _iconButton(
                  icon: Icons.call_outlined,
                  onTap: () => _showContactSheet(d),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              'Order for ${d['customer']}',
              style: const TextStyle(color: textSecondary),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Pickup: ${d['pickup']}',
                    style: const TextStyle(color: textPrimary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.green),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Drop-off: ${d['dropoff']}',
                    style: const TextStyle(color: textPrimary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // ETA and Distance row
            Row(
              children: [
                if (d['eta'] != null)
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 16, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        'ETA: ${d['eta']}',
                        style: const TextStyle(
                          color: textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                if (d['eta'] != null && d['distance'] != null)
                  const SizedBox(width: 16),
                if (d['distance'] != null)
                  Row(
                    children: [
                      const Icon(Icons.route, size: 16, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        'Distance: ${d['distance']}',
                        style: const TextStyle(
                          color: textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(child: SizedBox()),
                Text(
                  'KSh ${d['price']}',
                  style: TextStyle(
                    color: emerald,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed: nextStatus.isEmpty
                    ? null
                    : () async {
                        final deliveryId = d['id']!;
                        await _updateDeliveryStatus(deliveryId, nextStatus);
                        setState(() {
                          d['status'] = nextStatus;
                        });
                        // Optionally, reload all deliveries:
                        // await _loadDeliveries();
                      },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      buttonLabel,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
