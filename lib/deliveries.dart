import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeliveriesPage extends StatefulWidget {
  const DeliveriesPage({Key? key}) : super(key: key);

  @override
  State<DeliveriesPage> createState() => _DeliveriesPageState();
}

class _DeliveriesPageState extends State<DeliveriesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  final List<Map<String, String>> _deliveries = [];
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        .limit(100);
    _deliveries
      ..clear()
      ..addAll(rows.map<Map<String, String>>((r) => _mapDbRowToUi(r)));
    setState(() => _isLoading = false);
  }

  Map<String, String> _mapDbRowToUi(Map<String, dynamic> r) {
    return {
      'id': r['id']?.toString() ?? '',
      'pickup': r['pickup']?.toString() ?? '',
      'dropoff': r['dropoff']?.toString() ?? '',
      'date': r['created_at']?.toString().substring(0, 10) ?? '',
      'amount': (r['price'] ?? r['amount'] ?? '').toString(),
      'status': r['status']?.toString() ?? '',
    };
  }

  List<Map<String, String>> _getFilteredDeliveries(String filter) {
    if (filter == 'All') return _deliveries;
    if (filter == 'Active') {
      return _deliveries
          .where(
            (d) => d['status'] != 'Delivered' && d['status'] != 'Cancelled',
          )
          .toList();
    }
    return _deliveries.where((d) => d['status'] == filter).toList();
  }

  static const Color emerald = Color.fromARGB(255, 51, 187, 120);
  static const Color backgroundWhite = Color(0xFFF7F8FA);
  static const Color textPrimary = Color(0xFF222B45);

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Assigned':
      case 'Pickup in Progress':
      case 'Picked Up':
      case 'On The Way':
        return emerald;
      case 'Delivered':
        return Colors.green;
      case 'Cancelled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundWhite,
      appBar: AppBar(
        title: const Text(
          'Deliveries',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: backgroundWhite,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
              indicatorColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: textPrimary,
              tabs: [
                _buildTab('All', 0),
                _buildTab('Active', 1),
                _buildTab('Delivered', 2),
                _buildTab('Cancelled', 3),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildDeliveryList('All'),
                _buildDeliveryList('Active'),
                _buildDeliveryList('Delivered'),
                _buildDeliveryList('Cancelled'),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadDeliveries,
        backgroundColor: emerald,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  Widget _buildDeliveryList(String filter) {
    final filteredDeliveries = _getFilteredDeliveries(filter);
    if (filteredDeliveries.isEmpty) {
      return Center(
        child: Text(
          'No deliveries found.',
          style: TextStyle(color: textPrimary.withOpacity(0.5), fontSize: 16),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredDeliveries.length,
      itemBuilder: (context, index) {
        final delivery = filteredDeliveries[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.03),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: emerald.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.local_shipping_outlined,
                        color: emerald,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '#${delivery['id']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          delivery['status'] ?? '',
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        delivery['status'] ?? '',
                        style: TextStyle(
                          color: _getStatusColor(delivery['status'] ?? ''),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        delivery['pickup'] ?? '',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 20, color: emerald),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        delivery['dropoff'] ?? '',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          delivery['date'] ?? '',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'KSh ${delivery['amount'] ?? ''}',
                      style: const TextStyle(
                        color: emerald,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTab(String text, int index) {
    return Tab(
      child: IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: _tabController.index == index ? emerald : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _tabController.index == index
                  ? emerald
                  : textPrimary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: _tabController.index == index
                    ? FontWeight.w600
                    : FontWeight.w500,
                color: _tabController.index == index
                    ? Colors.white
                    : textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
