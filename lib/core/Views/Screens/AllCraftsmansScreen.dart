import 'package:flutter/material.dart';
import 'package:handy_hub/core/Views/Themes/app_colors.dart';

class AllCraftsmanScreen extends StatelessWidget {
  final String serviceName;
  final List<Map<String, dynamic>> artisans; // البيانات القادمة من API أو مؤقتة

  const AllCraftsmanScreen({
    super.key,
    required this.serviceName,
    required this.artisans,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(serviceName),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: artisans.isEmpty
            ? Center(
          child: Text(
            "لا يوجد حرفيين في هذه الخدمة بعد",
            style: TextStyle(color: Colors.grey[700], fontSize: 16),
          ),
        )
            : Expanded(
              child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // عدد الأعمدة
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75, // ارتفاع البطاقة
                        ),
                        itemCount: artisans.length,
                        itemBuilder: (context, index) {
              final artisan = artisans[index];
              return _buildArtisanCard(context, artisan);
                        },
                      ),
            ),
      ),
    );
  }

  Widget _buildArtisanCard(BuildContext context, Map<String, dynamic> artisan) {
    return GestureDetector(
      onTap: () {
        // الانتقال لتفاصيل الحرفي
        Navigator.pushNamed(context, '/Craftsmandetailsscreen', arguments: artisan);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // صورة الحرفي
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                artisan['imageUrl'] ??
                    'https://www.w3schools.com/w3images/avatar2.png',
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),

            // الاسم
            Text(
              artisan['name'] ?? 'اسم الحرفي',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),

            // التخصص
            Text(
              artisan['profession'] ?? 'تخصص الحرفي',
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
            const SizedBox(height: 4),

            // التقييم
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                    (i) => Icon(
                  i < (artisan['rating'] ?? 4).round()
                      ? Icons.star
                      : Icons.star_border_outlined,
                  color: Colors.amber,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // زر التفاصيل
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Craftsmandetailsscreen', arguments: artisan);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "التفاصيل",
                style: TextStyle(fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }
}
