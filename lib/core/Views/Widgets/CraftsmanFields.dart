import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handy_hub/core/Views/Widgets/Custom_TextFiled.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import '../../ViewModels/worker_register/worker_register_cubit.dart';
import '../google.dart';
import '../Themes/app_colors.dart';

class CraftsmanFields extends StatefulWidget {
  final TextEditingController professionController;
  final TextEditingController companyController;

  const CraftsmanFields({
    super.key,
    required this.professionController,
    required this.companyController,
  });

  @override
  State<CraftsmanFields> createState() => _CraftsmanFieldsState();
}

class _CraftsmanFieldsState extends State<CraftsmanFields> {
  final picker = ImagePicker();
  String? governorate;
  String? district;

  List<File> gallery = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkerRegisterCubit(),
      child: BlocConsumer<WorkerRegisterCubit, WorkerRegisterState>(
        listener: (context, state) {
          if (state.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("تم حفظ بيانات الحرفي بنجاح")),
            );
          } else if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        builder: (context, state) {
          final cubit = context.read<WorkerRegisterCubit>();

          return SafeArea(
            child: Column(
              children: [
                SizedBox(height: 14),
                CustomTextField(
                  controller: widget.professionController,
                  hintText: 'المهنة / الحرفة',
                  prefixIcon: Icons.build,
                  borderSide: BorderSide(color: AppColors.primary, width: 1),
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: widget.companyController,
                  hintText: 'سنوات الخبرة',
                  prefixIcon: Icons.timer,
                  keyboardType: TextInputType.number,
                  borderSide: BorderSide(color: AppColors.primary, width: 1),
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: widget.companyController,
                  hintText: "نبذة عن الحرفي",
                  prefixIcon: Icons.info,
                  borderSide: BorderSide(color: AppColors.primary, width: 1),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    // زر اختيار المحافظة
                    Expanded(
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.location_city,
                              color: AppColors.primary,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            hintText: "المحافظة",
                          ),
                          value: governorate,
                          items: ["صنعاء", "عدن", "تعز", "إب"]
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => governorate = v),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.primary,
                          ),
                          dropdownColor: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // زر اختيار المديرية
                    Expanded(
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.map_outlined,
                              color: AppColors.primary,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            hintText: "المديرية",
                          ),
                          value: district,
                          items: ["التحرير", "معين", "بني الحارث", "السبعين"]
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => district = v),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.primary,
                          ),
                          dropdownColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.photo_library_outlined,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "أضف صور لأعمالك",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: AppColors.primary,
                            ),
                            onPressed: () async {
                              if (gallery.length >= 3) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("يمكنك إضافة 3 صور فقط"),
                                  ),
                                );
                                return;
                              }
                              final picked = await picker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (picked != null) {
                                setState(() => gallery.add(File(picked.path)));
                              }
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // عرض الصور المختارة
                      if (gallery.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (var img in gallery)
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      img,
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: -8,
                                    right: -8,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() => gallery.remove(img));
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        )
                      else
                        const Text(
                          "لم يتم إضافة صور بعد",
                          style: TextStyle(color: Colors.black45, fontSize: 14),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // زر اختيار الموقع
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary, width: 1),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withOpacity(0.3), // لون مائي شفاف
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MapScreen()),
                      );

                      if (result != null) {
                        context.read<WorkerRegisterCubit>().setLocation(result as LatLng);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.map, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          cubit.selectedLocation != null
                              ? "تم اختيار الموقع"
                              : "اختر الموقع",
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 14,)

              ],
            ),
          );
        },
      ),
    );
  }
}
