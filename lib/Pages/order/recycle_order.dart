import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/api/index.dart';
import 'package:user_app/components/register/action_button.dart';
import 'package:user_app/models/recycle_models.dart';
import 'package:user_app/models/subscription_models.dart';
import 'package:user_app/style.dart';

import '../../api/endpoints/recycle_api.dart';

class SchedulePickUpOrderPage extends StatefulWidget {
  final SubscriptionDetail subscriptionDetail;
  const SchedulePickUpOrderPage(this.subscriptionDetail, {super.key});

  @override
  State<SchedulePickUpOrderPage> createState() => _SchedulePickUpOrderPageState();
}

class _SchedulePickUpOrderPageState extends State<SchedulePickUpOrderPage> {
  final TextEditingController _addressController = TextEditingController();

  // Pickup slots data
  List<PickupSlotDate>? _availableDates;
  String? _selectedDate;
  String? _selectedTime;
  bool _isLoading = true;
  bool _isSubmitLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    print("--address: ${widget.subscriptionDetail.deliveryAddress.fullAddress}");
    print("--address: ${widget.subscriptionDetail.deliveryAddress.fullAddress?.isEmpty}");
    print("--address: ${widget.subscriptionDetail.deliveryAddress.address}");
    if((widget.subscriptionDetail.deliveryAddress.fullAddress?.isEmpty ?? true) || widget.subscriptionDetail.deliveryAddress.fullAddress == null){
      _addressController.text = widget.subscriptionDetail.deliveryAddress.address;
    }else {
      _addressController.text = widget.subscriptionDetail.deliveryAddress.fullAddress!;
    }
    _loadPickupSlots();
  }

  Future<void> onSubmit() async {
    // Validate required fields
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('請選擇取件日期'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('請選擇取件時間'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      setState(() {
        _isSubmitLoading = true;
        _errorMessage = null;
      });

      // Create order request
      final request = RecycleOrderCreateRequest(
        subscriptionId: widget.subscriptionDetail.id,
        pickupDate: _selectedDate!,
        pickupTime: _selectedTime!,
      );

      // Call API to create order
      final response = await Api.instance().recycle().createOrder(request: request);

      setState(() {
        _isSubmitLoading = false;
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('取件預約已成功建立！'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
        // Navigate back after showing success message
        context.replace("/order/confirmation", extra: response.id);
      }
    } on RecycleException catch (e){
      setState(() {
        _isSubmitLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }catch (e) {
      print(e);
      setState(() {
        _isSubmitLoading = false;
      });

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('建立訂單失敗，請稍後再試'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _loadPickupSlots() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final response = await Api.instance().recycle().getPickupSlots();
      
      setState(() {
        _availableDates = response.data.availableDates;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load pickup slots. Please try again.';
      });
    }
  }

  // Get available timeslots for selected date
  List<PickupSlotTimeslot>? _getAvailableTimeslots() {
    if (_selectedDate == null || _availableDates == null) {
      return null;
    }
    
    try {
      final selectedDateSlot = _availableDates!.firstWhere(
        (dateSlot) => dateSlot.date == _selectedDate,
      );
      return selectedDateSlot.timeslots;
    } catch (e) {
      return null;
    }
  }

  // Format date for display
  String _formatDateForDisplay(String date) {
    try {
      final dateTime = DateTime.parse(date);
      // Format: "Mon, Jan 15, 2024" or similar
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${weekdays[dateTime.weekday - 1]}, ${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text(
          "Recycle Now | Schedule Pick Up",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 2. 訂閱 Banner (Subscription Card)
              _buildSubscriptionBanner(),
              const SizedBox(height: 24),

              // 3. 標題區域
              Row(
                children: const [
                  Text(
                    "Pick Up Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.help_outline, size: 20, color: Colors.black54),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                "Please fill in the information for smooth pick up.",
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 20),

              // 4. 表單區域
              // Pick Up Date
              _buildLabel("Pick Up Date *"),
              _buildDateDropdown(),
              const SizedBox(height: 16),

              // Pick Up Time
              _buildLabel("Pick Up Time *"),
              _buildTimeDropdown(),
              const SizedBox(height: 16),

              // Address
              _buildLabel("Address"),
              Container(
                color: Colors.black12,
                child: TextField(
                  readOnly: true,
                  controller: _addressController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                        borderRadius: BorderRadius.zero
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.zero
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 30),

              // 5. 確認按鈕
              ActionButton("Confirm Pick Up Schedule", onTap: onSubmit, showLoading: _isSubmitLoading),
              const SizedBox(height: 16),

              // 6. 底部條款文字
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  children: [
                    TextSpan(text: "By clicking here, you agree to our "),
                    TextSpan(
                      text: "terms",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(text: " and have read and acknowledge our "),
                    TextSpan(
                      text: "privacy policy.",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 輔助方法：構建 Banner
  Widget _buildSubscriptionBanner() {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],

        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/widget/subscription_header.png") as ImageProvider,
        ),
      ),
      child: Stack(
        children: [
          // 文字內容
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tr("subscription.${widget.subscriptionDetail.plan.billingCycle.name}"),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 輔助方法：構建標籤文本
  Widget _buildLabel(String text) {
    bool isRequired = text.contains("*");
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          text: text.replaceAll("*", ""),
          style: const TextStyle(color: Colors.black54, fontSize: 14),
          children: [
            if (isRequired)
              const TextSpan(
                text: " *",
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  // 輔助方法：構建日期下拉選單
  Widget _buildDateDropdown() {
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text(
              'Loading...',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null && _availableDates == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade300, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red.shade700, fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }

    final dateItems = _availableDates?.map((dateSlot) {
      final displayDate = _formatDateForDisplay(dateSlot.date);
      return DropdownMenuItem<String>(
        value: dateSlot.date,
        child: Text(displayDate),
      );
    }).toList() ?? [];

    return DropdownButtonFormField<String>(
      initialValue: _selectedDate,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black12, width: 1),
          borderRadius: BorderRadius.zero,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: purpleUnderline, width: 1),
          borderRadius: BorderRadius.zero,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black12, width: 1),
          borderRadius: BorderRadius.zero,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      style: const TextStyle(fontSize: 14, color: Colors.black),
      icon: const Icon(
        Icons.keyboard_arrow_down_sharp,
        size: 20,
        color: Colors.black54,
      ),
      isExpanded: true,
      hint: const Text(
        "Select Date",
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
      items: dateItems,
      onChanged: (value) {
        setState(() {
          _selectedDate = value;
          _selectedTime = null; // Reset time when date changes
        });
      },
    );
  }

  // 輔助方法：構建時間下拉選單
  Widget _buildTimeDropdown() {
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text(
              'Loading...',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      );
    }

    final timeslots = _getAvailableTimeslots();
    final timeItems = timeslots?.map((timeslot) {
      return DropdownMenuItem<String>(
        value: timeslot.value,
        child: Text(timeslot.displayTime),
      );
    }).toList() ?? [];

    return DropdownButtonFormField<String>(
      initialValue: _selectedTime,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: _selectedDate != null ? Colors.black12 : Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.zero,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: _selectedDate != null ? purpleUnderline : Colors.grey.shade300,
            width: 1,
          ),

          borderRadius: BorderRadius.zero,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: _selectedDate != null ? Colors.black12 : Colors.grey.shade300,
            width: 1,
          ),

          borderRadius: BorderRadius.zero,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      style: TextStyle(
        fontSize: 14,
        color: _selectedDate != null ? Colors.black : Colors.grey,
      ),
      icon: Icon(
        Icons.keyboard_arrow_down_sharp,
        size: 20,
        color: Colors.black54,
      ),
      isExpanded: true,
      hint: Text(
        "Select Time",
        style: TextStyle(
          fontSize: 14,
          color: _selectedDate != null ? Colors.grey : Colors.grey.shade400,
        ),
      ),
      items: timeItems,
      onChanged: _selectedDate != null
          ? (value) {
              setState(() {
                _selectedTime = value;
              });
            }
          : null,
    );
  }
}