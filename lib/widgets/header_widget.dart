import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String username;
  final String profileImageUrl;
  final VoidCallback onLogout;

  const HeaderWidget({
    super.key,
    required this.username,
    required this.profileImageUrl,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(profileImageUrl),
                radius: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Olá, $username',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: onLogout,
          ),
        ],
      ),
    );
  }
}
