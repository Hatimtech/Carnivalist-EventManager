import 'dart:io';

import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/ui/platform/widget/platform_progress_indicator.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as Video;

class VideoThumbnail extends StatefulWidget {
  final videoPath;

  VideoThumbnail(this.videoPath) {
    if (!isValid(videoPath)) throw Exception('Invalid video path supplied');
  }

  @override
  _VideoThumbnailState createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  Future _futureVideoThumbnail;

  @override
  void initState() {
    super.initState();
    _futureVideoThumbnail = generateVideoThumbnail(widget.videoPath);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _futureVideoThumbnail,
        builder: (_, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: const PlatformProgressIndicator())
              : SizedBox.expand(
                  child: InkWell(
                    onTap: showVideoPlayerDialog,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        isValid(snapshot.data)
                            ? Image(
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                image: FileImage(File(snapshot.data)))
                            : Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 96.0,
                              ),
                        Icon(Icons.play_circle_filled),
                      ],
                    ),
                  ),
                );
        });
  }

  Future<String> generateVideoThumbnail(String videoPath) async {
    print('Generating thumbnail for image--->$videoPath');

    final thumbnailFilePath = Path.join(await getSystemDirPath(), 'Pictures',
        '${videoPath.substring(videoPath.lastIndexOf('/') + 1, videoPath.lastIndexOf('.'))}.jpg');
    print('Generating thumbnail inside--->$thumbnailFilePath');

    bool exists = await File(thumbnailFilePath).exists();
    print('Thumbnail exists--->$exists');

    if (exists) return thumbnailFilePath;

    try {
      String generatedPath = await Video.VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: thumbnailFilePath,
        imageFormat: Video.ImageFormat.JPEG,
        quality: 100,
      );
      print('Generated Thumbnail Path--->$generatedPath');
      if (isValid(generatedPath)) return generatedPath;
    } catch (error) {
      print('Exception generating thumbnail--->$error');
    }
    return null;
  }

  Future<void> showVideoPlayerDialog() async {
    if (isPlatformAndroid) {
      VideoPlayerController _controller;
      await showDialog(
          context: context,
          builder: (context) {
            String videoPath = widget.videoPath;

            if (videoPath.startsWith('http')) {
              _controller = VideoPlayerController.network(videoPath);
            } else {
              _controller = VideoPlayerController.file(File(videoPath));
            }

            return FutureBuilder(
                future: _controller.initialize(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return const Center(
                      child: const PlatformProgressIndicator(),
                    );
                  else {
                    _controller.play();
                    return Center(
                      child: Stack(
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                          Positioned(
                            right: 0,
                            child: Material(
                              child: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () => Navigator.pop(context)),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                });
          });
      Future.delayed(Duration(seconds: 1), () => _controller.dispose());
    }
  }
}
