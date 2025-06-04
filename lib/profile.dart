import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const Color emerald = Color(0xFF2CA58D);
  static const Color backgroundWhite = Color(0xFFF7F8FA);
  static const Color emeraldLight = Color(0xFFB2DFDB);
  static const Color cardBg = Colors.white;
  static const Color textPrimary = Color(0xFF222B45);
  static const Color textSecondary = Color(0xFF8F9BB3);
  static const Color divider = Color(0xFFF1F1F1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundWhite,
      appBar: AppBar(
        backgroundColor: backgroundWhite, // change
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: emerald,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Profile section
          Container(
            color: backgroundWhite,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: emerald,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -50),
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white,
                        backgroundImage: const AssetImage('assets/icons/icon.jpg'),
                      ),
                    ),
                    const SizedBox(height: 1),
                    const Text(
                      'JOHN DOE',
                      style: TextStyle(
                        color: textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'john.doe@example.com',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: emerald,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                      ),
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          // Stats card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat('12', 'Shipments'),
                  _verticalDivider(),
                  _buildStat('10', 'Delivered'),
                  _verticalDivider(),
                  _buildStat('2', 'Active'),
                ],
              ),
            ),
          ),

          // Account Settings
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text('Account Settings', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          _buildSettingsCard([
            _buildSettingsTile(Icons.person_outline, 'Personal Information', 'Update your personal details', onTap: () {}),
            _buildSettingsTile(Icons.location_on_outlined, 'Saved Addresses', 'Manage your pickup and delivery addresses', onTap: () {}),
            _buildSettingsTile(Icons.credit_card_outlined, 'Payment Methods', 'Manage your payment options', onTap: () {}),
            _buildSettingsTile(Icons.notifications_none, 'Notifications', 'Manage your notification preferences',
              trailing: Switch(value: true, onChanged: (_) {})),
          ]),

          // Support
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text('Support', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          _buildSettingsCard([
            _buildSettingsTile(Icons.help_outline, 'Help Center', 'Get help with your shipments', onTap: () {}),
            _buildSettingsTile(Icons.verified_user_outlined, 'Privacy & Terms', 'View our privacy policy and terms', onTap: () {}),
          ]),

          // Logout button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Log Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),

          // Version info
          const Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(color: textSecondary, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
      // Bottom navigation bar placeholder (implement in main app if needed)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: emerald,
        unselectedItemColor: textSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Shipments'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
        onTap: (i) {},
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: textPrimary)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: textSecondary, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      height: 36,
      width: 1,
      color: divider,
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, String subtitle, {Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: emeraldLight,
        child: Icon(icon, color: emerald),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: textPrimary)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 13, color: textSecondary)),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16, color: textSecondary),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      minLeadingWidth: 36,
    );
  }
}
