import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/constants.dart';
import 'package:user_app/style.dart';
import '../../blocs/profile_cubit.dart';
import '../../components/profile/date_picker.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..loadProfile(),
      child: const _EditProfilePageContent(),
    );
  }
}

class _EditProfilePageContent extends StatefulWidget {
  const _EditProfilePageContent();

  @override
  State<_EditProfilePageContent> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<_EditProfilePageContent> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  
  String? selectedGender;
  String? selectedAge;
  int? selectedMonth;
  int? selectedDay;
  
  String? phoneCountryCode;
  String? phoneNumber;

  // 主題顏色
  final Color lightGreyFill = const Color(0xFFF9F9F9);

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _parsePhone(String phone) {
    // Parse phone number like "+8521234567" into country code and number
    if (phone.startsWith('+852')) {
      phoneCountryCode = '+852';
      phoneNumber = phone.substring(4);
    } else if (phone.startsWith('852')) {
      phoneCountryCode = '+852';
      phoneNumber = phone.substring(3);
    } else {
      phoneCountryCode = '+852';
      phoneNumber = phone;
    }
  }

  void _loadProfileData(ProfileLoaded state) {
    final profile = state.profile;
    
    if (mounted) {
      setState(() {
        _nameController.text = profile.name;
        selectedGender = profile.gender.toString().split('.').last;
        selectedMonth = profile.birthMonth;
        selectedDay = profile.birthDay;
        
        _parsePhone(profile.phone);
        _phoneController.text = phoneNumber ?? '';
        
        // Note: ageGroup is not in Profile model, so we can't set it from profile
        // You may need to calculate or leave as null
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is ProfileLoaded) {
          _loadProfileData(state);
        } else if (state is ProfileUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          // Reload profile after successful update
          context.read<ProfileCubit>().loadProfile();
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: mainPurple,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text(
                'Edit Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              centerTitle: false,
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: mainPurple,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Edit Profile',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

              // 2. Name 輸入框 (模擬 Focus 狀態 - 紫色邊框)
              TextFormField(
                controller: _nameController,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  // 強制顯示紫色邊框
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: mainPurple), // 紫色
                    borderRadius: BorderRadius.zero,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: mainPurple, width: 1),
                    borderRadius: BorderRadius.zero,
                  ),

                ),
              ),
              const SizedBox(height: 16),

              // 3. Gender 和 Age (Row 排列)
              Row(
                children: [
                  // Gender
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedGender,
                      decoration: _commonInputDecoration(),
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                      items: [
                        DropdownMenuItem(value: 'male', child: Text(tr("male"))),
                        DropdownMenuItem(value: 'female', child: Text(tr("female"))),
                      ],
                      onChanged: (v) => setState(() => selectedGender = v),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Age
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedAge,
                      decoration: _commonInputDecoration(),
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                      items: ageGroup.entries.map((entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      )).toList(),
                      onChanged: (v) => setState(() => selectedAge = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 4. Date Picker
              ProfileDatePicker(
                key: ValueKey('${selectedMonth}_${selectedDay}'),
                initialMonth: selectedMonth,
                initialDay: selectedDay,
                onChange: (month, day) {
                  setState(() {
                    selectedMonth = month;
                    selectedDay = day;
                  });
                },
              ),
              const SizedBox(height: 16),

              // 5. Phone Number (區號 + 號碼)
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, profileState) {
                  String email = '';
                  if (profileState is ProfileLoaded) {
                    email = profileState.profile.email;
                  }
                  
                  return Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 80,
                            child: TextFormField(
                              controller: TextEditingController(text: phoneCountryCode ?? '+852'),
                              textAlign: TextAlign.center,
                              readOnly: true, // 模擬不可編輯
                              style: const TextStyle(color: Colors.grey),
                              decoration: _greyInputDecoration(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              readOnly: true,
                              style: const TextStyle(color: Colors.grey),
                              decoration: _greyInputDecoration(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 6. Email
                      TextFormField(
                        initialValue: email,
                        readOnly: true,
                        style: const TextStyle(color: Colors.grey),
                        decoration: _greyInputDecoration(),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

              // 7. Info Text
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Change of Account Information",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text.rich(
                  TextSpan(
                    text: "Please contact our customer support\nat ",
                    style: TextStyle(color: Colors.grey, height: 1.4),
                    children: [
                      TextSpan(
                        text: "(852) 1234 5678",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(text: " for assistance during office hour."),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // 8. Update Profile Button (黑色實心)
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, profileState) {
                  final profileCubit = context.read<ProfileCubit>();
                  final isLoading = profileState is ProfileLoading;
                  
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // 矩形
                        ),
                      ),
                      onPressed: isLoading ? null : () {
                        profileCubit.updateProfile(
                          name: _nameController.text,
                          gender: selectedGender,
                          birthMonth: selectedMonth,
                          birthDay: selectedDay,
                          ageGroup: selectedAge,
                        );
                      },
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              "Update My Profile",
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // 9. Log Out Button (白色黑框)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // 矩形
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Log Out",
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 10. Delete Account
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Delete Account",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 輔助方法：一般的輸入框樣式 (白色背景)
  InputDecoration _commonInputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.zero,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade400),
        borderRadius: BorderRadius.zero,
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  // 輔助方法：灰色的輸入框樣式 (用於 Email/Phone)
  InputDecoration _greyInputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.zero,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.zero,
      ),
      filled: true,
      fillColor: const Color(0xFFF9F9F9), // 淺灰色背景
    );
  }
}