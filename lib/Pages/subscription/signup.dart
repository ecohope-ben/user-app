import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/components/subscription/features.dart';

import '../../components/subscription/payment_detail_row.dart';
import '../../models/subscription_models.dart';
import '../../style.dart';

class SubscriptionSignUp extends StatefulWidget {
  final PlanListItem plan;
  final List<String> features;
  const SubscriptionSignUp({super.key, required this.plan, required this.features});

  @override
  State<SubscriptionSignUp> createState() => _SubscriptionSignUpState();
}

class _SubscriptionSignUpState extends State<SubscriptionSignUp> {
  late final Color themeColor;
  late final String imagePath;

  // Dropdown values
  String? selectedRegion = 'Kowloon';
  String? selectedDistrict = 'Lok Fu';
  final TextEditingController addressController = TextEditingController(
      text: "Chinachem Leighton Plaza, 29 Leighton Road...");


  @override
  void initState() {
    super.initState();
    if (widget.plan.billingCycle == BillingCycle.monthly) {
      themeColor = mainPurple;
      imagePath = "assets/widget/subscription_header_monthly.png";
    } else {
      themeColor = blueBorder;
      imagePath = "assets/widget/subscription_header_yearly.png";
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0,
            height: 200,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/widget/subscription_signup_header.png") as ImageProvider,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // scrollable content
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          "Monthly Plan",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // let title be center
                    ],
                  ),
                ),

                // 主要滾動內容
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: mainPurple, width: 1.2),
                            // borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.features.map((feature){
                              return FeaturesListItem(feature, color: themeColor);
                            }).toList()
                          ),
                        ),

                        const SizedBox(height: 15),

                        //  Details Box
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Color(0xFFfafafa),
                              border: Border.all(color: const Color(0xFFC7C7C7))
                          ),
                          child: Column(
                            children: [
                              PaymentDetailRow("Type", "Monthly Plan", isBold: true),
                              const SizedBox(height: 8),
                              PaymentDetailRow("Renewing on", "15 Nov 2025", isBold: true),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 100,
                                    child: Text("Amount", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w700)),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "\$0 | pay nothing until 15 Nov 2025",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Auto-renews every 1 month, cancel anytime.",
                                          style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Address Section
                        const Text(
                          "Your Address",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "This address will be used both for delivering your free recycle bag and for the pick-up address.",
                          style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 20),

                        // Dropdowns Row
                        Row(
                          children: [
                            // Region Dropdown
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Region", style: TextStyle(color: Colors.black54)),
                                  const SizedBox(height: 6),
                                  DropdownButtonFormField<String>(
                                    initialValue: selectedRegion,
                                    isExpanded: true, menuMaxHeight: 0,

                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.zero
                                        ),
                                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8)
                                    ),
                                    items: ["Kowloon", "Hong Kong Island", "New Territories"]
                                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                        .toList(),
                                    onChanged: (v) => setState(() => selectedRegion = v),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            // District Dropdown
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("District", style: TextStyle(color: Colors.black54)),
                                  const SizedBox(height: 6),
                                  DropdownButtonFormField<String>(
                                    initialValue: selectedDistrict,
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.zero,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8)
                                    ),
                                    items: ["Lok Fu", "Mong Kok", "Tsim Sha Tsui"]
                                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                        .toList(),
                                    onChanged: (v) => setState(() => selectedDistrict = v),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Address Line Input
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Address line", style: TextStyle(color: Colors.black54)),
                            const SizedBox(height: 6),
                            TextFormField(
                              maxLines: 3,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8)
                              ),
                              controller: addressController,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Bottom Button
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              border: Border(
                                bottom: BorderSide(color: blueTextUnderline, width: 3.0),
                              ),
                            ),
                            child: TextButton(
                              onPressed: (){},
                              child: const Text(
                                "Confirm and proceed to payment",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            )
                        ),


                        const SizedBox(height: 16),

                        // T&C
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.black54, fontSize: 14, height: 1.5),
                            children: [
                              const TextSpan(text: "By clicking here, you agree to our "),
                              TextSpan(
                                text: "terms",
                                style: const TextStyle(decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()..onTap = () {},
                              ),
                              const TextSpan(text: " and have read and acknowledge our "),
                              TextSpan(
                                text: "privacy policy.",
                                style: const TextStyle(decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()..onTap = () {},
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
