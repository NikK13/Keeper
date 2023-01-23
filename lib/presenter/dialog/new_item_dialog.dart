import 'package:flutter/material.dart';
import 'package:keeper/presenter/widgets/general/dialog.dart';

import '../../domain/utils/localization.dart';
import '../widgets/general/input.dart';
import '../widgets/platform/platform_button.dart';

class NewItemDialog extends StatefulWidget {
  final Function? addNewItem;

  const NewItemDialog({
    Key? key,
    this.addNewItem
  }) : super(key: key);

  @override
  State createState() => _NewItemDialogState();
}

class _NewItemDialogState extends State<NewItemDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: AppLocalizations.of(context, 'new_item'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Text(
            AppLocalizations.of(context, 'title'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700
            ),
          ),
          const SizedBox(height: 8),
          InputField(
            isDatePick: false,
            controller: _titleController,
            hint: AppLocalizations.of(context, 'typehint'),
            inputType: TextInputType.text,
          ),
          const SizedBox(height: 32),
          Text(
            AppLocalizations.of(context, 'description'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700
            ),
          ),
          const SizedBox(height: 8),
          InputField(
            isDatePick: false,
            controller: _descController,
            hint: AppLocalizations.of(context, 'typehint'),
            inputType: TextInputType.text,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: PlatformButton(
              fontSize: 20,
              onPressed: () async {
                final title = _titleController.text.trim();
                final desc = _descController.text.trim();
                if(title.isNotEmpty){
                  Navigator.pop(context);
                  await widget.addNewItem!(
                    title, desc.isNotEmpty ? desc : null
                  );
                }
                else{
                  debugPrint("Empty field now");
                }
              },
              text: AppLocalizations.of(context, 'create'),
            ),
          ),
        ],
      )
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
}