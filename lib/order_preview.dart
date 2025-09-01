import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderPreviewPage extends StatefulWidget {
  final Map<String, String> order;
  const OrderPreviewPage({super.key, required this.order});

  @override
  State<OrderPreviewPage> createState() => _OrderPreviewPageState();
}

class RouteService {
  static const String _osrmBaseUrl = 'https://router.project-osrm.org/route/v1/driving';

  static Future<List<LatLng>> getRoutePoints(LatLng start, LatLng end) async {
    try {
      final String url = '$_osrmBaseUrl/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> geometry = data['routes'][0]['geometry']['coordinates'];
        
        // Convert GeoJSON coordinates [lng, lat] to LatLng objects [lat, lng]
        return geometry.map((coord) => LatLng(coord[1], coord[0])).toList();
      } else {
        throw Exception('Failed to load route: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to straight line if routing fails
      return [start, end];
    }
  }
}

class _OrderPreviewPageState extends State<OrderPreviewPage> {
  static const Color emerald = Color.fromARGB(255, 51, 187, 120);
  static const Color backgroundWhite = Color(0xFFF7F8FA);
  static const Color textPrimary = Color(0xFF222B45);
  static const Color textSecondary = Color(0xFF8F9BB3);

  List<LatLng> routePoints = [];
  bool isLoadingRoute = false;

  @override
  void initState() {
    super.initState();
    _loadRoute();
  }

  Future<void> _loadRoute() async {
    final LatLng? pickup = _tryLatLng(widget.order['pickupLat'], widget.order['pickupLng']);
    final LatLng? dropoff = _tryLatLng(widget.order['dropoffLat'], widget.order['dropoffLng']);
    
    if (pickup != null && dropoff != null) {
      setState(() => isLoadingRoute = true);
      try {
        final points = await RouteService.getRoutePoints(pickup, dropoff);
        setState(() => routePoints = points);
      } catch (e) {
        // Fallback to straight line
        setState(() => routePoints = [pickup, dropoff]);
      } finally {
        setState(() => isLoadingRoute = false);
      }
    }
  }

  double _calculateOptimalZoom(LatLngBounds bounds) {
    final double latDiff = (bounds.north - bounds.south).abs();
    final double lngDiff = (bounds.east - bounds.west).abs();
    final double maxDiff = max(latDiff, lngDiff);
    
    if (maxDiff < 0.005) return 16; // Very close points
    if (maxDiff < 0.01) return 15;  // Close points
    if (maxDiff < 0.03) return 14;  // Medium-close
    if (maxDiff < 0.06) return 13;  // Medium distance
    if (maxDiff < 0.1) return 12;   // Medium-long
    if (maxDiff < 0.3) return 11;   // Long distance
    return 10; // Very long distance
  }

  double _calculateRouteDistance(List<LatLng> points) {
    double distance = 0;
    for (int i = 1; i < points.length; i++) {
      distance += const Distance().as(LengthUnit.Meter, points[i-1], points[i]);
    }
    return distance;
  }

  Widget _routeInfoCard() {
    if (routePoints.length <= 2 || isLoadingRoute) return const SizedBox();

    final double distance = _calculateRouteDistance(routePoints);
    final String distanceText = distance > 1000 
        ? '${(distance / 1000).toStringAsFixed(1)} km' 
        : '${distance.toStringAsFixed(0)} m';

    return Positioned(
      top: 70,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.route, color: emerald, size: 20),
            const SizedBox(width: 8),
            Text('Route: $distanceText', style: const TextStyle(fontWeight: FontWeight.w600)),
            const Spacer(),
            if (isLoadingRoute)
              const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
          ],
        ),
      ),
    );
  }

  final Map<String, Map<String, dynamic>> statusConfig = {
    'New': {
      'button': 'Mark as Picked Up',
      'next': 'Picked Up',
    },
    'Picked Up': {
      'button': 'Mark as On The Way',
      'next': 'On The Way',
    },
    'On The Way': {
      'button': 'Mark as Delivered',
      'next': 'Delivered',
    },
    'Delivered': {
      'button': 'Delivered',
      'next': '',
    },
    'Accepted': {
      'button': 'Mark as Picked Up',
      'next': 'Picked Up',
    },
  };

  @override
  Widget build(BuildContext context) {
    final Map<String, String> order = Map<String, String>.from(widget.order);
    final LatLng? pickup = _tryLatLng(order['pickupLat'], order['pickupLng']);
    final LatLng? dropoff = _tryLatLng(order['dropoffLat'], order['dropoffLng']);

    final List<LatLng> points = [
      if (pickup != null) pickup,
      if (dropoff != null) dropoff,
    ];

    // Calculate bounds for optimal zoom
    final LatLngBounds? bounds = points.length >= 2
        ? LatLngBounds.fromPoints(points)
        : null;

    final LatLng center = bounds?.center ?? const LatLng(-1.2921, 36.8219);
    final double zoom = bounds != null ? _calculateOptimalZoom(bounds) : 13;

    final String status = order['status'] ?? 'New';
    final String buttonLabel = (statusConfig[status] ?? statusConfig['New']!)['button'] as String;
    final String nextStatus = (statusConfig[status] ?? statusConfig['New']!)['next'] as String;

    return Scaffold(
      backgroundColor: backgroundWhite,
      appBar: AppBar(
        backgroundColor: backgroundWhite,
        elevation: 0,
        centerTitle: true,
        title: const Text('Delivery Details', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700)),
      ),
      body: Stack(
        children: [
          // Full-screen map background
          FlutterMap(
            options: MapOptions(
              initialCenter: center,
              initialZoom: zoom,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.amanahmvp.app',
              ),
              
              // Show loading indicator while route is being calculated
              if (isLoadingRoute)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: center,
                      width: 60,
                      height: 60,
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              
              // Show actual route when available
              if (routePoints.length > 1 && !isLoadingRoute)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints, 
                      color: emerald,
                      strokeWidth: 6,
                      gradientColors: [emerald, emerald.withOpacity(0.7)],
                    ),
                  ],
                ),
              
              // Fallback to straight line if routing failed
              if (routePoints.isEmpty && pickup != null && dropoff != null && !isLoadingRoute)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [pickup, dropoff], 
                      color: Colors.grey,
                      strokeWidth: 4,
                      strokeCap: StrokeCap.round,
                      // isDotted: true,
                    ),
                  ],
                ),
              
              if (pickup != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: pickup, 
                      width: 40, 
                      height: 40, 
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.local_shipping, color: Colors.orange, size: 24),
                        ),
                      )
                    ]
                  ),
              if (dropoff != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: dropoff,
                    width: 40,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.home, color: Colors.green, size: 24),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Route info card
          _routeInfoCard(),

          // Draggable bottom sheet with order details
          DraggableScrollableSheet(
            initialChildSize: 0.45,
            minChildSize: 0.3,
            maxChildSize: 0.92,
            builder: (context, controller) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView(
                        controller: controller,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        children: [
                          _earningsCard(order),
                          const SizedBox(height: 12),
                          _sectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(order['merchant'] ?? '-', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary)),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(Icons.place_outlined, color: Colors.green),
                                    const SizedBox(width: 8),
                                    const Text('Pickup Location', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary)),
                                    const Spacer(),
                                    _roundIconButton(Icons.near_me_outlined, () => _showMapsOptions(order['pickup'] ?? '')),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(order['pickup'] ?? '-', style: const TextStyle(color: textSecondary)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          _sectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Customer Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary)),
                                const SizedBox(height: 12),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(order['customer'] ?? '-', style: const TextStyle(fontWeight: FontWeight.w700, color: textPrimary)),
                                          const SizedBox(height: 4),
                                          Text(order['customerPhone'] ?? '-', style: const TextStyle(color: textSecondary)),
                                          const SizedBox(height: 12),
                                          Row(children: [
                                            const Icon(Icons.place_rounded, color: Colors.red),
                                            const SizedBox(width: 8),
                                            const Text('Drop-off Location', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary)),
                                            const Spacer(),
                                            _roundIconButton(Icons.near_me_outlined, () => _showMapsOptions(order['dropoff'] ?? '')),
                                          ]),
                                          const SizedBox(height: 4),
                                          Text(order['dropoff'] ?? '-', style: const TextStyle(color: textSecondary)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    _roundIconButton(Icons.call_outlined, () => _makeCall(order['customerPhone'] ?? '')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          if ((order['items'] ?? '').isNotEmpty)
                            _sectionCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Order Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary)),
                                  const SizedBox(height: 8),
                                  ...order['items']!
                                      .split(',')
                                      .map((e) => e.trim())
                                      .where((e) => e.isNotEmpty)
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4),
                                            child: Row(children: [const Text('• ', style: TextStyle(color: textSecondary)), Expanded(child: Text(e, style: const TextStyle(color: textPrimary)))]),
                                          ))
                                      .toList(),
                                ],
                              ),
                            ),
                          if ((order['instructions'] ?? '').isNotEmpty) ...[
                            const SizedBox(height: 12),
                            _sectionCard(
                              background: const Color(0xFFFFF4E6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Special Instructions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.orange)),
                                  const SizedBox(height: 8),
                                  Text(order['instructions']!, style: const TextStyle(color: textPrimary)),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: nextStatus.isEmpty ? Colors.grey : emerald,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: nextStatus.isEmpty
                                  ? null
                                  : () async {
                                      final deliveryId = widget.order['id'] ?? '';
                                      if (deliveryId.isNotEmpty) {
                                        await Supabase.instance.client
                                            .from('deliveries')
                                            .update({'status': nextStatus})
                                            .eq('id', deliveryId);
                                      }
                                    },
                              child: Text(buttonLabel, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _earningsCard(Map<String, String> order) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEFFAF4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD6F5E5)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        children: [
          Text(
            order['price']?.startsWith('KSh') == true ? order['price']! : '\$${order['price'] ?? '0.00'}',
            style: const TextStyle(color: Colors.green, fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          const Text('Estimated earnings', style: TextStyle(color: textSecondary)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.navigation_outlined, size: 16, color: textSecondary),
              const SizedBox(width: 6),
              Text(order['distance'] ?? '-', style: const TextStyle(color: textSecondary)),
              const SizedBox(width: 16),
              const Icon(Icons.timer_outlined, size: 16, color: textSecondary),
              const SizedBox(width: 6),
              Text(order['eta'] ?? '-', style: const TextStyle(color: textSecondary)),
            ],
          )
        ],
      ),
    );
  }

  Widget _sectionCard({required Widget child, Color background = Colors.white}) {
    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  Widget _roundIconButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: Color(0xFFE6E6E6))),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: textPrimary),
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
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 12),
            const Text('Open in...', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: textPrimary)),
            const SizedBox(height: 8),
            _sheetAction(
              icon: Icons.map_outlined,
              label: 'Google Maps',
              onTap: () async {
                final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encoded');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
                if (mounted) Navigator.pop(context);
              },
            ),
            _sheetAction(
              icon: Icons.navigation_outlined,
              label: 'Waze',
              onTap: () async {
                final uri = Uri.parse('https://waze.com/ul?q=$encoded');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
                if (mounted) Navigator.pop(context);
              },
            ),
            _sheetAction(
              icon: Icons.directions_outlined,
              label: 'Apple Maps',
              onTap: () async {
                final uri = Uri.parse('https://maps.apple.com/?q=$encoded');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
                if (mounted) Navigator.pop(context);
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
            Expanded(child: Text(label, style: const TextStyle(color: textPrimary, fontSize: 16))),
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
          backgroundColor: Colors.white,
          foregroundColor: textPrimary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
        ),
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  LatLng? _tryLatLng(String? lat, String? lng) {
    if (lat == null || lng == null) return null;
    final double? la = double.tryParse(lat);
    final double? ln = double.tryParse(lng);
    if (la == null || ln == null) return null;
    return LatLng(la, ln);
  }

  Future<void> _makeCall(String phoneNumber) async {
    if (phoneNumber.isEmpty) return;
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }
}