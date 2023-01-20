import 'package:flutter/material.dart';

import '../../domain/utils/localization.dart';

class EventsFragment extends StatelessWidget {
  const EventsFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Center(
        child: Text(
          AppLocalizations.of(context, 'in_development'),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500
          ),
        ),
      ),
    );
  }
}