import 'package:flutter/material.dart';

class ExploreBanner extends StatelessWidget {
  const ExploreBanner({super.key});

  final Color bannerColor = const Color(0xFF1F7A66); // banner color

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bannerColor,
          borderRadius: BorderRadius.zero,
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              const Color(0xFF1A5E4D),
              const Color(0xFF2A9D84),
            ],
          ),
        ),
        child: Row(
          children: [
            // Star
            const Icon(
              Icons.auto_awesome_outlined,
              color: Colors.white,
              size: 36,
            ),
            const SizedBox(width: 16),

            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Limited Offer, Join Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Free Trial available',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Explore
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              ),
              child: const Text('Explore'),
            ),
          ],
        ),
      );
  }
}
