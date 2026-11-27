import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_9/fcm_token_card.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Akun Firebase'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.blue.shade100,
                    backgroundImage:
                        (user?.photoURL != null && user!.photoURL!.isNotEmpty)
                        ? NetworkImage(user.photoURL!)
                        : null,
                    child: (user?.photoURL == null || user!.photoURL!.isEmpty)
                        ? const Icon(Icons.person, size: 48, color: Colors.blue)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.displayName ?? 'Nama Belum Diatur',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '-',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.fingerprint, color: Colors.blue),
                    title: const Text('User ID (UID)'),
                    subtitle: SelectableText(
                      user?.uid ?? '-',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.blue),
                    title: const Text('Email'),
                    subtitle: Text(user?.email ?? '-'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.blue),
                    title: const Text('Status Email Verified'),
                    subtitle: Text(
                      (user?.emailVerified ?? false)
                          ? 'Sudah Diverifikasi'
                          : 'Belum Diverifikasi',
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.calendar_today,
                      color: Colors.blue,
                    ),
                    title: const Text('Akun Dibuat'),
                    subtitle: Text(
                      user?.metadata.creationTime?.toLocal().toString() ?? '-',
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.access_time, color: Colors.blue),
                    title: const Text('Login Terakhir'),
                    subtitle: Text(
                      user?.metadata.lastSignInTime?.toLocal().toString() ??
                          '-',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const FcmTokenCard(),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
              label: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
