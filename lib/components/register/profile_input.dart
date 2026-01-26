import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/blocs/profile_cubit.dart';

import '../../constants.dart';
import '../../style.dart';
import 'action_button.dart';
import 'date_picker.dart';
import 'text_input.dart';



class ProfileInput extends StatefulWidget {
  const ProfileInput({super.key});

  @override
  State<ProfileInput> createState() => _ProfileInputState();
}

class _ProfileInputState extends State<ProfileInput> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  String? _gender;
  String? _selectedAgeGroup;
  int? _birthMonth;
  int? _birthDay;

  Future<void> submit() async {


    if(mounted) {
      context.read<ProfileCubit>().updateProfileOnboarding(
          name: _nameController.text,
          gender: _gender,
          birthMonth: _birthMonth,
          birthDay: _birthDay,
          ageGroup: _selectedAgeGroup
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextInput(tr("your_name"), controller: _nameController, validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return tr("validation.required");
            }
            if (value.trim().length > 20) {
              return tr("validation.too_long");
            }
            return null;
          }),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: _dropdown<String>(
                    tr("gender"),
                    value: _gender,
                    items: [
                      DropdownMenuItem(value: 'male', child: Text(tr("male"))),
                      DropdownMenuItem(value: 'female', child: Text(tr("female"))),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return tr("validation.required");
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  )),
              SizedBox(width: 20),
              Expanded(
                  flex: 1,
                  child: _dropdown<String>(
                    tr("age"),
                    value: _selectedAgeGroup,
                    items: ageGroup.entries.map((entry) => DropdownMenuItem(
                              value: entry.key,
                              child: Text(entry.value),
                            )).toList(),
                    validator: (value) {
                      if (value == null || value == "") {
                        return tr("validation.required");
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _selectedAgeGroup = value;
                      });
                    },
                  ))
            ],
          ),
      
          DatePicker(
              validator: (value){
                if (value == null || value.isEmpty || value == "") {
                  return tr("validation.required");
                }
                return null;
              },
              onChange: (month, day){
                setState(() {
                  _birthMonth = month;
                  _birthDay = day;
                });
              }
          ),

          SizedBox(height: 20),
          ActionButton(tr("register.confirm_and_login"), onTap: (){
            if (_formKey.currentState?.validate() ?? false) {
              submit();
            }
          }, showLoading: context.read<ProfileCubit>().state is ProfileLoading)
      
        ],
      ),
    );
  }

  Widget _dropdown<T>(String title, {List<DropdownMenuItem<T>>? items, T? value, ValueChanged<T?>? onChanged, String? Function(T?)? validator}) {
    return DropdownButtonFormField<T>(
        validator: validator,
        // underline: Container(),

        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: purpleUnderline, width: 1),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: purpleUnderline, width: 1),
          ),
        ),
        style: TextStyle(fontSize: 30, color: Colors.black),
        icon: Icon(Icons.keyboard_arrow_down_sharp, size: 30, color: purpleUnderline, fontWeight: FontWeight.normal),
        isExpanded: true,
        hint: Padding(
            padding: EdgeInsets.all(0),
            child: Text(title, style: TextStyle(fontSize: 30, color: Colors.grey, fontWeight: FontWeight.normal))
        ),
        items: items,
        initialValue: value,
        onChanged: onChanged,
      );
  }
}