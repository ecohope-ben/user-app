import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/auth/index.dart';
import 'package:user_app/constants.dart';
import 'package:user_app/style.dart';
import 'package:user_app/utils/snack.dart';
import '../../blocs/profile_cubit.dart';
import '../../components/profile/date_picker.dart';
import '../../utils/pop_up.dart';
import '../../utils/refresh_notifier.dart';

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

  void _handleDeleteAccount(BuildContext context) {
    showPopup(
      context,
      title: tr("profile.delete_account_confirm_title"),
      message: tr("profile.delete_account_confirm_message"),
      confirmText: tr("profile.delete_account"),
      cancelText: tr("cancel"),
      onConfirm: () {
        context.read<ProfileCubit>().deleteAccount();
      },
    );
  }

  void _loadProfileData(ProfileLoaded state) {
    final profile = state.profile;
    
    if (mounted) {
      setState(() {
        _nameController.text = profile.name;
        selectedGender = profile.gender.toString().split('.').last;
        selectedAge = profile.ageGroup;
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
          popSnackBar(context, tr("profile.update_success"));

          // Notify listeners (e.g. Home) to refresh profile
          profileRefreshNotifier.value++;
          if(mounted) {
            context.read<ProfileCubit>().loadProfile();
          }

        } else if (state is ProfileDeleteSuccess) {
          // Logout and navigate to get_start page after successful deletion
          Auth.instance().logout();
          context.go("/get_start");
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
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                tr("profile.edit_profile"),
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
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              tr("profile.edit_profile"),
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
                onTapOutside: (a){
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
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

              // 4. Date Picker
              ProfileDatePicker(
                key: ValueKey('${selectedMonth}_${selectedDay}'),
                initialMonth: selectedMonth,
                initialDay: selectedDay,
                showMainColor: false,
                onChange: (month, day) {
                  setState(() {
                    selectedMonth = month;
                    selectedDay = day;
                  });
                },
              ),

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
                              onTapOutside: (a){
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
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
                              onTapOutside: (a){
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
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
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  tr("profile.change_account_info"),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: Text.rich(
                  TextSpan(
                    text:  tr("profile.contact_our_customer_support"),
                    style: TextStyle(color: Colors.grey, height: 1.4),
                    children: [
                      TextSpan(
                        text: "(852) 1234 5678",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(text: tr("profile.for_assistance")),
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
                        if(_nameController.text.isEmpty){
                          popSnackBar(context, tr("profile.name_is_required"));
                        }else {
                          profileCubit.updateProfile(
                            name: _nameController.text,
                            gender: selectedGender,
                            birthMonth: selectedMonth,
                            birthDay: selectedDay,
                            ageGroup: selectedAge,
                          );
                        }
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
                          : Text(
                              tr("profile.update_my_profile"),
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
                  onPressed: () => showPopup(
                      context,
                      title: tr("logout.confirm"),
                      onConfirm: (){
                        Auth.instance().logout();
                        context.go("/get_start");
                      }
                  ),
                  child: Text(
                    tr("logout.title"),
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 30),

                // 10. Delete Account
                TextButton(
                  onPressed: () => _handleDeleteAccount(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    tr("profile.delete_ac"),
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
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: mainPurple),
        borderRadius: BorderRadius.zero,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
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