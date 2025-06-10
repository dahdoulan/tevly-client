import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tevly_client/admin_component/providers/admin_provider.dart';
import 'package:tevly_client/auth_components/service/login_service.dart';
import 'package:tevly_client/commons/util/snackbar.dart';
import 'package:tevly_client/home_component/models/theme.dart';
import 'package:tevly_client/upload_component/providers/video_provider.dart';
import 'package:tevly_client/upload_component/widgets/upload_form_widget.dart';

import '../constants/upload_constants.dart';
import '../widgets/drop_zone_widget.dart';
import '../widgets/upload_button_widget.dart';
import '../widgets/video_list_widget.dart';
import '../widgets/thumbnail_drop_zone_widget.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  @override
  Widget build(BuildContext context) {
        final provider = Provider.of<AdminDashboardProvider>(context);

    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
 
    return  Scaffold(
        appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textColor),
          onPressed: () {
          if(LoginService.role == "ADMIN")
            Navigator.pushNamed(context, '/admin');
          else
          Navigator.pushNamed(context, '/login');
          },
        ),
        title: Text(
          'Filmmaker Dashboard',
          style: AppTheme.headerStyle.copyWith(color: AppTheme.textColor),
          
        ),
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        

      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: provider.selectedIndex,
        onTap: (index) => provider.onItemTappedFilmmaker(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ), 
        ],
      ),
      body: Stack(
      children: [Consumer<VideoUploadProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.black,
            body: Center(
              child: LayoutBuilder(builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Upload Your Videos',
                                  style: TextStyle(
                                      color: kSecondaryColor, fontSize: 20),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            const Text(
                              'Upload Thumbnail',
                              style:
                                  TextStyle(color: kSecondaryColor, fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            const ThumbnailDropZoneWidget(),
                            const SizedBox(height: 32),
                            const Text(
                              'Upload Video',
                              style:
                                  TextStyle(color: kSecondaryColor, fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: screenSize.height *
                                  0.5, // Reduced height to accommodate thumbnail
                              child: DropZoneWidget(
                                onDrop: (file) {
                                  if (provider.selectedThumbnail == null) {
                                    SnackbarUtil.showErrorSnackbar(
                                      context,
                                      'Please upload a thumbnail first',
                                    );
                                    return;
                                  }
                                  showDialog(
                                      context: context,
                                      useSafeArea: true,
                                      builder: (context) => UploadFormWidget(
                                            onPressed: () {
                                              provider.handleDrop(
                                                file,
                                                provider.titleController.text,
                                                provider
                                                    .descriptionController.text,
                                              );
                                              Navigator.pop(context);
                                              provider.clearTextControllers();
                                            },
                                          ));
                                  provider.isDragging = false;
                                },
                                onDragEnter: () => provider.isDragging = true,
                                onDragLeave: () => provider.isDragging = false,
                                isDragging: provider.isDragging,
                                onDropzoneCreated: (controller) =>
                                    provider.setDropzoneController(controller),
                              ),
                            ),
                            if (provider.videos.isNotEmpty)
                              SizedBox(
                                height: 200,
                                child: VideoListWidget(
                                  onRemove: provider.removeVideo,
                                  isSmallScreen: isSmallScreen,
                                ),
                              ),
                            const SizedBox(height: 16),
                            UploadButtonWidget(
                              text:
                                  'Upload ${provider.videos.isNotEmpty ? provider.videos.length : ""} ${provider.videos.length == 1 ? "Video" : "Videos"}',
                              onPressed: () async {
                                if (provider.videos.isNotEmpty) {
                                  try {
                                    await provider.uploadVideos();
                                    if (context.mounted) {
                                      SnackbarUtil.showSnackbar(context,
                                          'Videos uploaded successfully!');
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      SnackbarUtil.showErrorSnackbar(
                                        context,
                                        'Failed to upload videos. Please try again.',
                                      );
                                    }
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        },
      ),
      ],
      ),   
    );
  }
}
