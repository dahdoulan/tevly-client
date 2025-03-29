import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:dotted_border/dotted_border.dart';

import '../constants/upload_constants.dart';

class DropZoneWidget extends StatelessWidget {
  final Function(dynamic) onDrop;
  final Function() onDragEnter;
  final Function() onDragLeave;
  final bool isDragging;
  final Function(DropzoneViewController) onDropzoneCreated;

  const DropZoneWidget({
    super.key,
    required this.onDrop,
    required this.onDragEnter,
    required this.onDragLeave,
    required this.isDragging,
    required this.onDropzoneCreated,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(12),
      color: isDragging ? kSecondaryColor : kPrimaryColor,
      strokeWidth: 2,
      dashPattern: const [8, 4],
      child: Container(
        decoration: BoxDecoration(
          color: isDragging
              ? kSecondaryColor.withOpacity(0.2)
              : kPrimaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            DropzoneView(
              onCreated: onDropzoneCreated,
              onDropFile: onDrop,
              onHover: () => onDragEnter(),
              onLeave: () => onDragLeave(),
            ),
            Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxHeight < 200;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isCompact)
                        Icon(
                          Icons.cloud_upload,
                          size: constraints.maxHeight < 300 ? 40 : 64,
                          color: isDragging ? kSecondaryColor : kPrimaryColor,
                        ),
                      if (!isCompact) const SizedBox(height: 8),
                      if (!isCompact)
                        Text(
                          isDragging
                              ? 'Drop your videos here'
                              : 'Drag and drop videos here',
                          style: TextStyle(
                            fontSize: constraints.maxHeight < 300 ? 16 : 20,
                            color: isDragging ? kSecondaryColor : kPrimaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      SizedBox(height: isCompact ? 0 : 8),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
