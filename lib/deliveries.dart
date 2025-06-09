import 'package:flutter/material.dart';

class DeliveryStatus {
  static const String inTransit = 'IN TRANSIT';
  static const String pending = 'PENDING';
  static const String delivered = 'DELIVERED';
  static const String cancelled = 'CANCELLED';
}

class Delivery {
  final String id;
  final String pickupLocation;
  final String dropoffLocation;
  final DateTime date;
  final double amount;
  final String status;

  Delivery({
    required this.id,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.date,
    required this.amount,
    required this.status,
  });
}

class DeliveriesPage extends StatefulWidget {
  const DeliveriesPage({Key? key}) : super(key: key);

  @override
  State<DeliveriesPage> createState() => _DeliveriesPageState();
}

class _DeliveriesPageState extends State<DeliveriesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;  // Add this to track selected tab
  
  // Sample data - replace with actual data from your backend
  final List<Delivery> _deliveries = [
    Delivery(
      id: 'AM2023001',
      pickupLocation: 'Westlands, Nairobi',
      dropoffLocation: 'Kilimani, Nairobi',
      date: DateTime(2025, 5, 26),
      amount: 450.00,
      status: DeliveryStatus.inTransit,
    ),
    Delivery(
      id: 'AM2023002',
      pickupLocation: 'Karen, Nairobi',
      dropoffLocation: 'Lavington, Nairobi',
      date: DateTime(2025, 5, 26),
      amount: 350.00,
      status: DeliveryStatus.pending,
    ),
    Delivery(
      id: 'AM2023003',
      pickupLocation: 'CBD, Nairobi',
      dropoffLocation: 'Parklands, Nairobi',
      date: DateTime(2025, 5, 25),
      amount: 650.00,
      status: DeliveryStatus.delivered,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case DeliveryStatus.inTransit:
        return const Color.fromARGB(255, 51, 187, 120);
      case DeliveryStatus.pending:
        return Colors.orange;
      case DeliveryStatus.delivered:
        return Colors.green;
      case DeliveryStatus.cancelled:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  List<Delivery> _getFilteredDeliveries(String filter) {
    if (filter == 'All') return _deliveries;
    return _deliveries.where((delivery) => 
      delivery.status == filter.toUpperCase()).toList();
  }

  static const Color emerald = Color.fromARGB(255, 51, 187, 120);
  static const Color backgroundWhite = Color(0xFFF7F8FA);
  static const Color textPrimary = Color(0xFF222B45);

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
              padding: EdgeInsets.zero,
              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
              indicatorColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: textPrimary,
              indicator: null,
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
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDeliveryList('All'),
          _buildDeliveryList('In Transit'),
          _buildDeliveryList('Delivered'),
          _buildDeliveryList('Cancelled'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement new delivery creation
        },
        backgroundColor: const Color.fromARGB(255, 51, 187, 120),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDeliveryList(String filter) {
    final filteredDeliveries = _getFilteredDeliveries(filter);
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
                        color: const Color.fromARGB(255, 51, 187, 120).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.local_shipping_outlined,
                        color: const Color.fromARGB(255, 51, 187, 120),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '#${delivery.id}',
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
                        color: _getStatusColor(delivery.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        delivery.status,
                        style: TextStyle(
                          color: _getStatusColor(delivery.status),
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
                    Text(
                      delivery.pickupLocation,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 20,
                      color: Color.fromARGB(255, 51, 187, 120),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      delivery.dropoffLocation,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
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
                          '${delivery.date.day}/${delivery.date.month}/${delivery.date.year}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'KSh ${delivery.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 51, 187, 120),
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
            color: _tabController.index == index ? const Color.fromARGB(255, 51, 187, 120) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _tabController.index == index ? const Color.fromARGB(255, 51, 187, 120) : textPrimary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: _tabController.index == index ? FontWeight.w600 : FontWeight.w500,
                color: _tabController.index == index ? Colors.white : textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
