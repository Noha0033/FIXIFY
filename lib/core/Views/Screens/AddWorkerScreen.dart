import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handy_hub/core/Views/Widgets/Custom_TextFiled.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import '../../ViewModels/worker_register/worker_register_cubit.dart';
import 'SelectLocationScreen.dart';
import '../Themes/app_colors.dart';

class AddWorkerScreen extends StatefulWidget {
  const AddWorkerScreen({super.key});

  @override
  State<AddWorkerScreen> createState() => _AddWorkerScreenState();
}

class _AddWorkerScreenState extends State<AddWorkerScreen> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final experienceController = TextEditingController();
  final bioController = TextEditingController();

  String? profession;
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<WorkerRegisterCubit>();

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: AppColors.primary,
              body: SafeArea(
                child: Stack(
                  children:[ Column(
                    children: [

                      // الخلفية العلوية
                      Container(
                        height: 50,
                        //  color: AppColors.primary,
                        alignment: Alignment.center,
                        child: const Text(
                          "تسجيل بيانات الحرفي",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.background,
                          ),
                        ),
                      ),
                      // const Text(
                      //   "املأ بياناتك لإضافتها للنظام",
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(fontSize: 15, color: AppColors.background),
                      // ),

                      // النموذج
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: LayoutBuilder(
                              builder: (context, constraints) => SingleChildScrollView(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    //minHeight: constraints.maxHeight,
                                  ),
                                  child: IntrinsicHeight(
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [


                                          const SizedBox(height: 10),

                                          CustomTextField(
                                            controller: nameController,
                                            hintText: "الاسم الكامل",
                                            prefixIcon: Icons.person_outline,
                                            borderSide: BorderSide(color:AppColors.primary),
                                          ),
                                          const SizedBox(height: 10),

                                          CustomTextField(
                                            controller: phoneController,
                                            hintText: "رقم الهاتف",
                                            prefixIcon: Icons.phone,
                                            keyboardType: TextInputType.phone,
                                            borderSide: BorderSide(color:AppColors.primary),
                                          ),
                                          const SizedBox(height: 10),

                                          DropdownButtonFormField<String>(
                                            value: profession,
                                            decoration: const InputDecoration(
                                              labelText: "نوع الخدمة",
                                              prefixIcon: Icon(Icons.work),
                                            ),
                                            items: ["كهربائي","سباك","نجار","دهان","أخرى"]
                                                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                                .toList(),
                                            onChanged: (v) => setState(() => profession = v),
                                          ),
                                          const SizedBox(height: 10),

                                          CustomTextField(
                                            controller: experienceController,
                                            hintText: "سنوات الخبرة",
                                            prefixIcon: Icons.timer,
                                            keyboardType: TextInputType.number,
                                            borderSide: BorderSide(color:AppColors.primary),
                                          ),
                                          const SizedBox(height: 10),

                                          CustomTextField(
                                            controller: bioController,
                                            hintText: "نبذة عن الحرفي",
                                            prefixIcon: Icons.info_outline,
                                            borderSide: BorderSide(color:AppColors.primary),
                                            //maxLines: 3,
                                          ),
                                          const SizedBox(height: 10),

                                          DropdownButtonFormField<String>(
                                            value: governorate,
                                            decoration: const InputDecoration(
                                              labelText: "المحافظة",
                                              prefixIcon: Icon(Icons.location_city),
                                            ),
                                            items: ["صنعاء","عدن","تعز","إب"]
                                                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                                .toList(),
                                            onChanged: (v) => setState(() => governorate = v),
                                          ),
                                          const SizedBox(height: 10),

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
                                                    const Icon(Icons.photo_library_outlined, color: Colors.grey),
                                                    const SizedBox(width: 8),
                                                    const Text(
                                                      "أضف صور لأعمالك",
                                                      style: TextStyle(fontSize: 16, color: Colors.black87),
                                                    ),
                                                    const Spacer(),
                                                    IconButton(
                                                      icon: const Icon(Icons.add_a_photo, color: AppColors.primary),
                                                      onPressed: () async {
                                                        final picked = await picker.pickImage(source: ImageSource.gallery);
                                                        if (picked != null) {
                                                          setState(() => gallery.add(File(picked.path)));
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),

                                                const SizedBox(height: 8),

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
                                                                  child: const Icon(Icons.close, size: 18, color: Colors.white),
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
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.background,
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                side: BorderSide(color: AppColors.primary)
                                              ),
                                            ),
                                            icon: const Icon(Icons.map),
                                            label: Text(
                                              state.location == null ? "اختر الموقع" : "تم اختيار الموقع",
                                              style: const TextStyle(fontSize: 16,color: AppColors.primary),
                                            ),
                                            onPressed: () async {
                                              final result = await Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (_) => const SelectLocationScreen()),
                                              );
                                              if (result != null) cubit.setLocation(result as LatLng);
                                            },
                                          ),
                                          const SizedBox(height: 10),

                                          // زر الإرسال
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.primary,
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: state.isLoading ? null : () {
                                              if (!_formKey.currentState!.validate()) return;
                                              cubit.submitWorker(
                                                name: nameController.text,
                                                phone: phoneController.text,
                                                profession: profession ?? '',
                                                experience: experienceController.text,
                                                bio: bioController.text,
                                                governorate: governorate ?? '',
                                                district: district ?? '',
                                                gallery: gallery,
                                              );
                                            },
                                            child: state.isLoading
                                                ? const CircularProgressIndicator(color: Colors.white)
                                                : const Text("إرسال البيانات", style: TextStyle(fontSize: 16,color: AppColors.background)),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ]  ),
              ),
            ),
          );
        },
      ),
    );
  }
}
