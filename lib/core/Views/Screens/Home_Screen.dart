import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handy_hub/core/Views/Themes/app_colors.dart';

import '../../Models/SearchModel.dart';
import '../../Repository/LocationService.dart';
import '../../ViewModels/Location_google/LocationCubit.dart';
import '../../ViewModels/SearchCubit/SearchCubitVM.dart';
import '../../ViewModels/homeVM/home_cubit.dart';
import '../../ViewModels/homeVM/home_state.dart';
import '../../models/category_model.dart'; // أضف هذا الاستيراد
import '../Widgets/NearbyArtisanButton.dart';
import '../widgets/category_button.dart';
import 'AllCraftsmansScreen.dart';
import 'SearchScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  String searchQuery = '';
  final _storage = GetStorage();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool get isLoggedIn => _storage.read('isLoggedIn') ?? false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()..loadCategories()),
        BlocProvider(create: (_) => SearchCubit()),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.primary,
          body: SafeArea(
            child: Column(
              children: [
                // 🔹 الجزء الثابت (البحث وزر الاكتشاف)
                _buildStickyHeader(),

                // 🔹 الجزء القابل للتمرير
                Expanded(
                  child: BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      return RefreshIndicator(
                        onRefresh: () async => context.read<HomeCubit>().loadCategories(),
                        color: AppColors.primary,
                        child: _buildScrollableContent(state),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          bottomNavigationBar: _buildBottomNavigationBar(),
        ),
      ),
    );
  }

  // 🔹 الجزء الثابت (البحث وزر الاكتشاف)
  Widget _buildStickyHeader() {
    return Container(
      color: AppColors.primary,
      child: Column(
        children: [
          // 🔹 AppBar مخصص
          _buildAppBar(),

          // 🔹 شريط البحث
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: "ابحث عن الحرفيين أو الخدمات...",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        searchQuery = '';
                      });
                    },
                  )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: context.read<SearchCubit>(),
                        child: const SearchResultsScreen(),
                      ),
                    ),
                  );
                },
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
          ),

          // 🔹 زر اكتشاف الحرفيين الأقرب لك
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: BlocProvider(
              create: (_) => LocationCubit(LocationService()),
              child: Builder(
                builder: (context) {
                  return NearbyArtisanButton(
                    onPressed: () async {
                      final cubit = context.read<LocationCubit>();
                      await cubit.fetchCurrentLocation();

                      if (cubit.state is LocationLoaded) {
                        final loc = (cubit.state as LocationLoaded).location;
                        Navigator.pushNamed(
                          context,
                          '/nearbyArtisans',
                          arguments: {
                            'latitude': loc.latitude,
                            'longitude': loc.longitude,
                          },
                        );
                      } else if (cubit.state is LocationError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                (cubit.state as LocationError).message),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ),


          // 🔹 خط فاصل
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  // 🔹 AppBar مخصص
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'نخبة الحرفيين',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          if (!isLoggedIn)
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.person_add_alt_1,
                  color: AppColors.primary,
                  size: 20,
                ),
                tooltip: 'تسجيل الدخول',
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ),
        ],
      ),
    );
  }

  // 🔹 المحتوى القابل للتمرير
  Widget _buildScrollableContent(HomeState state) {
    // حالة التحميل
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

    // حالة الخطأ
    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              state.error!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
              ),
              onPressed: () => context.read<HomeCubit>().loadCategories(),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    // حالة النجاح
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // 🔹 قسم الخدمات
        SliverToBoxAdapter(
          child: _buildServicesSection(state.categories),
        ),

        // 🔹 قسم الحرفيين المميزين
        SliverToBoxAdapter(
          child: _buildFeaturedArtisansSection(),
        ),

        // 🔹 قسم العروض الخاصة
        SliverToBoxAdapter(
          child: _buildSpecialOffersSection(),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 20),
        ),
      ],
    );
  }

  // 🔹 قسم الخدمات
  Widget _buildServicesSection(List<CategoryModel> categories) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "الخدمات المتاحة",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              Text(
                "(${categories.length})",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];

                return SizedBox(
                  width: 120,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(4, 9, 9, 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CategoryButton(
                      category: category,
                      onTap: () {
                        // 👇 بيانات مؤقتة للحرفيين
                        List<Map<String, dynamic>> mockArtisans = [
                          {
                            'name': 'أحمد عبد الله',
                            'profession': category.title,
                            'imageUrl': 'https://www.w3schools.com/w3images/avatar2.png',
                            'rating': 4.5,
                          },
                          {
                            'name': 'محمد علي',
                            'profession': category.title,
                            'imageUrl': 'https://www.w3schools.com/w3images/avatar6.png',
                            'rating': 4.0,
                          },
                          {
                            'name': 'خالد سعيد',
                            'profession': category.title,
                            'imageUrl': null,
                            'rating': 5.0,
                          },
                        ];

                        // الانتقال لشاشة عرض جميع الحرفيين
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AllCraftsmanScreen(
                              serviceName: category.title,
                              artisans: mockArtisans,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 قسم الحرفيين المميزين
  Widget _buildFeaturedArtisansSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "حرفيين مميزين",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/featuredArtisans');
                },
                child: Text(
                  "عرض الكل",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 120,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(4, 9, 9, 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: AppColors.primary.withOpacity(0.2),
                          child: Icon(
                            Icons.person,
                            color: AppColors.primary,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "الحرفي ${index + 1}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 14),
                            const SizedBox(width: 2),
                            Text(
                              "4.${index + 5}",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 قسم العروض الخاصة
  Widget _buildSpecialOffersSection() {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "عروض خاصة",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  width: 200,
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "خصم ${20 + index * 10}%",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "على خدمات ${['إصلاح المنازل', 'التنظيف', 'الصيانة'][index]}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "استخدم الكود: OFFER${index + 1}",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        backgroundColor: Colors.white,
        elevation: 0,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });

          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushNamed(context, '/orders');
              break;
            case 2:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "الرئيسية",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt),
            label: "طلباتي",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: "حسابي",
          ),
        ],
      ),
    );
  }
}

// 🔹 واجهة جديدة لنتائج البحث
