import 'package:doc_warehouse/features/presenter/widgets/custom_checkbox.dart';
import 'package:doc_warehouse/features/presenter/widgets/selectable_group/selectable_group.dart';
import 'package:flutter/material.dart';

class SelectableGroupSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final parent = SelectableGroup.of(context);
    if (parent == null) {
      throw Exception("Can not create SelectableGroupSwitch without a parent SelectableGroup");
    }
    return Row(
      children: [
        CustomCheckbox(
          value: parent.isAllSelected(),
          onChange: (newValue) {
            if (newValue == true) {
              parent.selectAll();
            } else {
              parent.unselectAll();
            }
          },
        ),
        SizedBox(width: 8),
        Text(
          'Selecionar todos',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
