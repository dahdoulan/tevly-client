import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tevly_client/upload_component/providers/video_provider.dart';

import '../constants/upload_constants.dart';
import 'upload_button_widget.dart';

class UploadFormWidget extends StatelessWidget {
  final void Function()? onPressed;

  const UploadFormWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoUploadProvider>(
      builder: (context, provider, child) => Dialog(
        insetPadding: const EdgeInsets.all(150.0),
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    style: const TextStyle(color: kSecondaryColor),
                    controller: provider.titleController,
                    maxLength: 255,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16),
                      hintText: 'Enter video title',
                      hintStyle:
                          TextStyle(color: kSecondaryColor.withOpacity(0.6)),
                      labelText: 'Video Title',
                      labelStyle: const TextStyle(color: kSecondaryColor),
                      alignLabelWithHint: false,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    style: const TextStyle(color: kSecondaryColor),
                    controller: provider.descriptionController,
                    maxLength: 500,
                    maxLines: 5,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16),
                      hintText: 'Enter video description',
                      hintStyle:
                          TextStyle(color: kSecondaryColor.withOpacity(0.6)),
                      labelText: 'Video Description',
                      labelStyle: const TextStyle(color: kSecondaryColor),
                      alignLabelWithHint: false,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child:
                        UploadButtonWidget(text: 'Save', onPressed: onPressed),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
