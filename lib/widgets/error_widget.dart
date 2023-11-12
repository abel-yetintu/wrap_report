import 'package:flutter/material.dart';
import 'package:wrap_report/services/api_exceptions.dart';
import 'package:wrap_report/shared/constants.dart';

class ErrorMessage extends StatelessWidget {
  final ApiException apiException;
  final IconData icon;
  const ErrorMessage({super.key, required this.apiException, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 100, color: Constants.colorWhite,),
        const SizedBox(height: 16,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(apiException.message, style: const TextStyle(fontSize: 24, color: Constants.colorWhite),),
        ),
      ],
    );
  }
}