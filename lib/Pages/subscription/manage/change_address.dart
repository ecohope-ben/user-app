import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/district_cubit.dart';
import '../../../blocs/subscription_cubit.dart';
import '../../../components/subscription/address.dart';
import '../../../models/logistics_models.dart';
import '../../../models/subscription_models.dart';
import '../../../style.dart';
import '../../../utils/snack.dart';

class SubscriptionChangeAddress extends StatelessWidget {
  final SubscriptionDetail subscriptionDetail;
  const SubscriptionChangeAddress(this.subscriptionDetail, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DistrictCubit()..loadDistricts()),
        BlocProvider(create: (_) => SubscriptionCubit()),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainPurple,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              context.pop();
            },
          ),
          title: const Text(
            "Edit Your Address",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: _ChangeAddressView(subscriptionDetail: subscriptionDetail),
      ),
    );
  }
}

class _ChangeAddressView extends StatefulWidget {
  final SubscriptionDetail subscriptionDetail;

  const _ChangeAddressView({required this.subscriptionDetail});

  @override
  State<_ChangeAddressView> createState() => _ChangeAddressViewState();
}

class _ChangeAddressViewState extends State<_ChangeAddressView> {
  final TextEditingController _addressController = TextEditingController();
  District? _selectedDistrict;
  SubDistrict? _selectedSubDistrict;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize with existing address
    _addressController.text = widget.subscriptionDetail.deliveryAddress.address;
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _initializeDistrictSelection(List<District> districts) {
    if (_isInitialized) return; // Already initialized

    final currentAddress = widget.subscriptionDetail.deliveryAddress;
    
    // Find matching district
    District? foundDistrict;
    SubDistrict? foundSubDistrict;
    
    for (final district in districts) {
      if (district.id == currentAddress.districtId) {
        foundDistrict = district;
        
        // Find matching sub-district
        for (final subDistrict in district.subDistricts) {
          if (subDistrict.id == currentAddress.subDistrictId) {
            foundSubDistrict = subDistrict;
            break;
          }
        }
        break;
      }
    }
    
    if (foundDistrict != null) {
      // Use addPostFrameCallback to avoid calling setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _selectedDistrict = foundDistrict;
            _selectedSubDistrict = foundSubDistrict;
            _isInitialized = true;
          });
        }
      });
    } else {
      _isInitialized = true; // Mark as initialized even if not found
    }
  }

  void _onDistrictChanged(District? district) {
    setState(() {
      _selectedDistrict = district;
      // Reset sub-district when district changes
      _selectedSubDistrict = district?.subDistricts.isNotEmpty == true
          ? district!.subDistricts.first
          : null;
    });
  }

  void _onSubDistrictChanged(SubDistrict? subDistrict) {
    setState(() {
      _selectedSubDistrict = subDistrict;
    });
  }

  Future<void> _handleUpdateAddress() async {
    // Validate inputs
    if (_selectedDistrict == null) {
      popSnackBar(context, '請選擇區域 (Region)');
      return;
    }

    if (_selectedSubDistrict == null) {
      popSnackBar(context, '請選擇地區 (District)');
      return;
    }

    final address = _addressController.text.trim();
    if (address.isEmpty) {
      popSnackBar(context, '請輸入地址');
      return;
    }

    // Create update request
    final request = UpdateAddressRequest(
      districtId: _selectedDistrict!.id,
      subDistrictId: _selectedSubDistrict!.id,
      address: address,
    );

    // Call update address via cubit
    final subscriptionCubit = context.read<SubscriptionCubit>();
    await subscriptionCubit.updateAddress(
      widget.subscriptionDetail.id,
      request,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubscriptionCubit, SubscriptionState>(
      listener: (context, state) {
        if (state is SubscriptionActionSuccess && state.action == 'update_address') {
          popSnackBar(context, '地址已成功更新');
          // Return true to indicate successful update
          context.pop(true);
        } else if (state is SubscriptionError) {
          popSnackBar(context, state.message);
        }
      },
      child: BlocBuilder<DistrictCubit, DistrictState>(
        builder: (context, districtState) {
          if (districtState is DistrictLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (districtState is DistrictError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('載入地區資料失敗: ${districtState.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DistrictCubit>().loadDistricts();
                    },
                    child: const Text('重試'),
                  ),
                ],
              ),
            );
          }

          if (districtState is DistrictLoaded) {
            // Initialize district selection once when districts are loaded
            _initializeDistrictSelection(districtState.districts);

            return BlocBuilder<SubscriptionCubit, SubscriptionState>(
              builder: (context, subscriptionState) {
                final isUpdating = subscriptionState is SubscriptionLoading &&
                    subscriptionState.operation == 'update_address';

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Your Address",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 0),
                      const Text(
                        "This address will be used to deliver your one-time free recycling bag and for future pick up.",
                        style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 30),
                      AddressDistrictSelect(
                        districts: districtState.districts,
                        selectedDistrict: _selectedDistrict,
                        selectedSubDistrict: _selectedSubDistrict,
                        onDistrictChanged: _onDistrictChanged,
                        onSubDistrictChanged: _onSubDistrictChanged,
                      ),
                      const SizedBox(height: 24),
                      // Address input field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Address",
                            style: TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _addressController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                              hintText: '請輸入詳細地址',
                            ),
                            maxLines: 3,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Update button
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black,
                        ),
                        child: TextButton(
                          onPressed: isUpdating ? null : _handleUpdateAddress,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 0),
                          ),
                          child: isUpdating
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  '更新地址',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
