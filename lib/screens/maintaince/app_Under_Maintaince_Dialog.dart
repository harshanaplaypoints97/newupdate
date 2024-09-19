import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:play_pointz/constants/app_colors.dart';

class AppUnderMaintenanceDialog extends StatelessWidget {
  const AppUnderMaintenanceDialog();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.PRIMARY_COLOR,
      body: WillPopScope(
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: size.height * (0.275),
                width: size.width * (0.8),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    "assets/new/logo.png",
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Text(
                'appUnderMaintenance',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
