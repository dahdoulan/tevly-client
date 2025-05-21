import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tevly_client/upload_component/constants/upload_constants.dart';
import 'package:tevly_client/upload_component/providers/video_provider.dart';

class UploadButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const UploadButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth < 600 ? screenWidth * 0.8 : 320.0;

    return Consumer<VideoUploadProvider>(
      builder: (context, provider, child) => SizedBox(
        width: buttonWidth,
        height: 50,
        child: ElevatedButton(
          onPressed: provider.isUploading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            disabledBackgroundColor: kPrimaryColor.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: provider.isUploading
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: kSecondaryColor,
                        strokeWidth: 3,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Uploading...',
                      style: TextStyle(fontSize: 16, color: kSecondaryColor),
                    ),
                  ],
                )
              : Text(
                  text,
                  style: const TextStyle(fontSize: 16, color: kSecondaryColor),
                ),
        ),
      ),
    );
  }
}
