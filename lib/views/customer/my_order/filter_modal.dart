import 'package:flutter/material.dart';
import 'package:al_rova/utils/constants/colors.dart';

class FilterModal extends StatefulWidget {
  const FilterModal({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  List<String> orderStatusOptions = [
    'On the way',
    'Delivered',
    'Cancelled',
    'Returned'
  ];

  List<String> selectedOrderStatus = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filters',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            FilterOption(
              title: 'Order Status',
              options: orderStatusOptions,
              selectedOptions: selectedOrderStatus,
              onSelectionChanged: (selected) {
                setState(() {
                  selectedOrderStatus = selected;
                });
              },
            ),
            const SizedBox(height: 20),
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(
                        () {
                          selectedOrderStatus.clear();
                        },
                      );
                    },
                    child: const Text(
                      'Clear Filter',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    color: Colors.black,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        {
                          'orderStatus': selectedOrderStatus,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterOption extends StatelessWidget {
  final String title;
  final List<String> options;
  final List<String> selectedOptions;
  final ValueChanged<List<String>> onSelectionChanged;

  const FilterOption({
    super.key,
    required this.title,
    required this.options,
    required this.selectedOptions,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Wrap(
          spacing: 15.0,
          children: options.map((option) {
            return FilterChipWidget(
              label: option,
              isSelected: selectedOptions.contains(option),
              onSelected: (selected) {
                List<String> updatedSelectedOptions =
                    List.from(selectedOptions);
                if (selected) {
                  updatedSelectedOptions.add(option);
                } else {
                  updatedSelectedOptions.remove(option);
                }
                onSelectionChanged(updatedSelectedOptions);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: AppColors.primary.withOpacity(0.2),
    );
  }
}
