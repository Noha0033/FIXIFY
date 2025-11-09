import 'package:flutter/material.dart';
import 'package:handy_hub/core/Views/Themes/app_colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class CraftsmanDetailsScreen extends StatefulWidget {
  const CraftsmanDetailsScreen({super.key});

  @override
  State<CraftsmanDetailsScreen> createState() => _CraftsmanDetailsScreenState();
}

class _CraftsmanDetailsScreenState extends State<CraftsmanDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'تفاصيل الحرفي',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ صورة الحرفي
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                'https://www.w3schools.com/w3images/avatar2.png',
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),

            // ✅ الاسم + التخصص
            const Text(
              'أحمد عبد الله',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'سباك محترف',
              style: TextStyle(color: Colors.grey[700], fontSize: 16),
            ),
            const SizedBox(height: 8),

            // ✅ التقييم
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                    (index) => const Icon(Icons.star, color: Colors.amber, size: 20),
              ),
            ),

            const SizedBox(height: 16),

            // ✅ أزرار التواصل
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Iconsax.call, color: Colors.white),
                  label: const Text('اتصال'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Iconsax.message, color: Colors.white),
                  label: const Text('مراسلة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ✅ نبذة عن الحرفي
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'نبذة عن الحرفي',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'خبرة أكثر من 10 سنوات في مجال السباكة والصيانة المنزلية. '
                  'متواجد في صنعاء ويمكنه الوصول إلى معظم المناطق بسرعة. '
                  'يتميز بالدقة في العمل والالتزام بالمواعيد.',
              style: TextStyle(color: Colors.grey[700], height: 1.5),
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 24),

            // ✅ معرض أعمال الحرفي
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'أعمالي السابقة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildWorkImage('https://www.w3schools.com/w3images/house.jpg'),
                  _buildWorkImage('https://www.w3schools.com/w3images/house2.jpg'),
                  _buildWorkImage('https://www.w3schools.com/w3images/house3.jpg'),
                  _buildWorkImage('https://www.w3schools.com/w3images/house4.jpg'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ ويدجت صغيرة لعرض صور الأعمال السابقة
  Widget _buildWorkImage(String imageUrl) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}
