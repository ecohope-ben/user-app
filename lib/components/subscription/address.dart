import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/logistics_models.dart';

class SubscriptionAddress extends StatelessWidget {

  const SubscriptionAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class AddressDistrictSelect extends StatelessWidget {
  final List<District> districts;
  final District? selectedDistrict;
  final SubDistrict? selectedSubDistrict;
  final ValueChanged<District?> onDistrictChanged;
  final ValueChanged<SubDistrict?> onSubDistrictChanged;

  const AddressDistrictSelect({
    super.key,
    required this.districts,
    this.selectedDistrict,
    this.selectedSubDistrict,
    required this.onDistrictChanged,
    required this.onSubDistrictChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Region Dropdown (District in API terms)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tr("region"), style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 6),
              DropdownButtonFormField<District>(
                value: selectedDistrict,
                isExpanded: true,
                menuMaxHeight: 300,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.zero
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8)
                ),
                items: districts
                    .map((district) => DropdownMenuItem(
                  value: district,
                  child: FittedBox(child: Text(district.name)),
                ))
                    .toList(),
                onChanged: onDistrictChanged,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Sub-District Dropdown
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tr("district"), style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 6),
              DropdownButtonFormField<SubDistrict>(
                value: selectedSubDistrict,
                isExpanded: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8)
                ),
                items: selectedDistrict?.subDistricts
                    .map((subDistrict) => DropdownMenuItem(
                  value: subDistrict,
                  child: FittedBox(child: Text(subDistrict.name)),
                ))
                    .toList() ??
                    [],
                onChanged: onSubDistrictChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

