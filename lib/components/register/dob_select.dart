import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:user_app/style.dart';
Map monthToWords = {
  "1": "January",
  "2": "February",

};


class BirthdayOneStepPicker {
  /// return {'month': int, 'day': int} or null
  static Future<Map<String, int>?> show(
      BuildContext context, {
        int? initialMonth,
        int? initialDay,
      }) async {
    return showDialog<Map<String, int>>(
      context: context,
      builder: (context) => _BirthdayOneStepDialog(
        initialMonth: initialMonth,
        initialDay: initialDay,
      ),
    );
  }
}

class _BirthdayOneStepDialog extends StatefulWidget {
  final int? initialMonth;
  final int? initialDay;

  const _BirthdayOneStepDialog({
    this.initialMonth,
    this.initialDay,
  });

  @override
  State<_BirthdayOneStepDialog> createState() => _BirthdayOneStepDialogState();
}

class _BirthdayOneStepDialogState extends State<_BirthdayOneStepDialog> {
  late int selectedMonth;
  late int selectedDay;

  @override
  void initState() {
    super.initState();
    selectedMonth = widget.initialMonth ?? 1;
    selectedDay = widget.initialDay ?? 1;
  }

  int get maxDays => [
    0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
  ][selectedMonth];

  void _updateDayIfNeeded() {
    if (selectedDay > maxDays) {
      setState(() => selectedDay = maxDays);
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateDayIfNeeded();

    return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      title: Container(
        color: mainPurple,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr("register.select_date_of_birth"),
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              "${tr("month_to_words.$selectedMonth")} $selectedDay",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
      content: SizedBox(
        width: 340,
        height: 420,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // month area
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                tr("month"),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black45),
              ),
            ),
            SizedBox(
              height: 160,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.8,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 3,
                ),
                itemCount: 12,
                itemBuilder: (context, i) {
                  final month = i + 1;
                  final isSelected = month == selectedMonth;

                  return InkWell(
                    onTap: () => setState(() => selectedMonth = month),
                    child: Container(

                      decoration: BoxDecoration(
                        color: isSelected
                            ? mainPurple
                            : Theme.of(context).colorScheme.surfaceContainer,
                        // border: Border.all(
                        //   color: isSelected
                        //       ? Colors.transparent
                        //       : Theme.of(context).dividerColor,
                        //   width: 1,
                        // ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        tr("month_to_words.$month"),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // === days area ===
            Text(
              tr("date"),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black45),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1.1,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                ),
                itemCount: maxDays,
                itemBuilder: (context, i) {
                  final day = i + 1;
                  final isSelected = day == selectedDay;

                  return InkWell(
                    onTap: () => setState(() => selectedDay = day),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? mainPurple
                            : null,
                        // border: Border.all(
                        //   color: Theme.of(context).dividerColor,
                        //   width: 0.8,
                        // ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "$day",
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : null,

                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(tr("cancel"), style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, {
              'month': selectedMonth,
              'day': selectedDay,
            });
          },
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
            backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
          ),
          child: Text(tr("ok"), style: TextStyle(color: mainPurple, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}