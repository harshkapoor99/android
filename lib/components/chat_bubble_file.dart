import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guftagu_mobile/components/easy_image_provider.dart';
import 'package:guftagu_mobile/components/fade_asset_placeholder_image.dart';
import 'package:guftagu_mobile/components/fade_network_placeholder_image.dart';
import 'package:guftagu_mobile/components/utility_components/nip_painter.dart';
import 'package:guftagu_mobile/enums/chat_type.dart';
import 'package:guftagu_mobile/gen/assets.gen.dart';
import 'package:guftagu_mobile/models/master/chat_message.dart';
import 'package:guftagu_mobile/routes.dart';
import 'package:guftagu_mobile/utils/context_less_nav.dart';
import 'package:guftagu_mobile/utils/date_formats.dart';
import 'package:guftagu_mobile/utils/download_util.dart';
import 'package:guftagu_mobile/utils/extensions.dart';
import 'package:guftagu_mobile/utils/file_name_form_url.dart';
import 'package:guftagu_mobile/utils/file_type_from_mime.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

class ChatBubbleFile extends ConsumerWidget {
  final ChatMessage message;
  final bool isMe;
  final String imageUrl;
  final DateTime? time;
  final String? path;
  final String? url;

  const ChatBubbleFile({
    super.key,
    required this.message,
    required this.isMe,
    required this.imageUrl,
    this.time,
    this.path,
    this.url,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            Container(
              margin: const EdgeInsets.only(right: 10, bottom: 15),

              width: 30,
              height: 30,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: NetworkImageWithPlaceholder(
                  imageUrl: imageUrl,
                  placeholder: SvgPicture.asset(
                    Assets.svgs.icProfilePlaceholder,
                  ),
                  fit: BoxFit.cover,
                  errorWidget: SvgPicture.asset(
                    Assets.svgs.icProfilePlaceholder,
                  ),
                ),
              ),
            ),
          Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!isMe)
                    CustomPaint(
                      size: const Size(6, 6),
                      painter: BubbleNipPainter(
                        color: context.colorExt.bubble,
                        isMe: isMe,
                      ),
                    ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),

                    decoration: BoxDecoration(
                      color: context.colorExt.bubble,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(10),
                        topRight: const Radius.circular(10),
                        bottomLeft: Radius.circular(isMe ? 10 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 10),
                      ),
                    ),
                    constraints: BoxConstraints(maxWidth: screenWidth * 0.7),
                    child: Column(
                      crossAxisAlignment:
                          isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Container(
                          padding:
                              message.chatType != ChatType.image.name
                                  ? const EdgeInsets.all(5)
                                  : null,
                          decoration: BoxDecoration(
                            color:
                                message.chatType != ChatType.image.name
                                    ? context.colorExt.primary.withAlpha(50)
                                    : null,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              if (message.chatType == ChatType.image.name) {
                                if (message.filePath != null) {
                                  showImageViewer(
                                    context,
                                    ProgressWidgetProvider(
                                      Image.file(File(message.filePath!)).image,
                                    ).provider,
                                  );
                                } else if (message.fileUrl != null) {
                                  var res = await downloadAssetFromUrl(
                                    message.fileUrl!,
                                  );
                                  showImageViewer(
                                    context,
                                    ProgressWidgetProvider(
                                      Image.file(File(res.filePath)).image,
                                    ).provider,
                                  );
                                }
                              }
                            },
                            child: Column(
                              children: [
                                if (message.chatType == ChatType.image.name)
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(2),
                                        child: Builder(
                                          builder: (context) {
                                            if (message.filePath != null) {
                                              return AssetImageWithPlaceholder(
                                                imagePath: message.filePath,
                                                // width: screenWidth * 0.6,
                                                // height: screenWidth * 0.6,
                                                // fit: BoxFit.cover,
                                              );
                                            }
                                            if (message.fileUrl != null) {
                                              return NetworkImageWithPlaceholder(
                                                imageUrl: message.fileUrl!,
                                                // width: screenWidth * 0.6,
                                                // height: screenWidth * 0.6,
                                                // fit: BoxFit.cover,
                                              );
                                            }
                                            return const Text(
                                              "Some error occured with image display.",
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                if (message.chatType != ChatType.image.name &&
                                    url != null)
                                  PdfPreviewChatBubble(pdfUrl: url!),
                                if (message.chatType != ChatType.image.name)
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 10,
                                    children: [
                                      const Icon(
                                        Icons.file_present_rounded,
                                        size: 30,
                                      ),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              message.fileName ??
                                                  getFileNameFromUrl(url ?? ""),
                                              style:
                                                  context
                                                      .appTextStyle
                                                      .textSmall,
                                              overflow: TextOverflow.fade,
                                            ),

                                            Text(
                                              getFileTypeFromMime(
                                                lookupMimeType(
                                                  message.fileName ??
                                                      path ??
                                                      getFileNameFromUrl(
                                                        url ?? "",
                                                      ),
                                                ),
                                              ),
                                              style: context
                                                  .appTextStyle
                                                  .textSmall
                                                  .copyWith(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (message.message.hasValue)
                          Text(
                            message.message!,
                            style: context.appTextStyle.textSmall,
                          ),
                      ],
                    ),
                  ),
                  if (isMe)
                    CustomPaint(
                      size: const Size(6, 6),
                      painter: BubbleNipPainter(
                        color: context.colorExt.bubble,
                        isMe: isMe,
                      ),
                    ),
                ],
              ),

              // Text(
              //   "Duration ${(playerState.playerController.maxDuration / 1000).floor()}",
              // ),
              // Text(
              //   "ph${provider.messageId} pch${playerState.playerController.hashCode} wfh${playerState.playerController.waveformData.hashCode}",
              // ),
              // Text(
              //   "ph${provider.hashCode} plh${player.hashCode} psh${playerState.hashCode}",
              // ),
              Text(
                time != null ? formatTime(time!) : "",
                style: context.appTextStyle.textSmall.copyWith(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PdfPreviewChatBubble extends StatefulWidget {
  final String pdfUrl;

  const PdfPreviewChatBubble({super.key, required this.pdfUrl});

  @override
  State<PdfPreviewChatBubble> createState() => _PdfPreviewChatBubbleState();
}

class _PdfPreviewChatBubbleState extends State<PdfPreviewChatBubble> {
  String? _pdfPath;
  Uint8List? _thumbnail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _downloadAndLoadThumbnail();
  }

  // Downloads the PDF from the URL, saves it to a temporary file,
  // and then generates a thumbnail from that file.
  Future<void> _downloadAndLoadThumbnail() async {
    try {
      // 1. Determine the local file path
      final tempDir = await getTemporaryDirectory();
      final tempFilePath =
          '${tempDir.path}/${getFileNameFromUrl(widget.pdfUrl)}';

      // 2. Download the PDF from the URL directly to the file using Dio
      final dio = Dio();
      await dio.download(widget.pdfUrl, tempFilePath);

      // 3. Store the local file path
      _pdfPath = tempFilePath;

      // 4. Generate the thumbnail from the local file
      final document = await PdfDocument.openFile(_pdfPath!);
      final page = await document.getPage(1);
      final pageImage = await page.render(
        width: 150,
        height: 200,
        format: PdfPageImageFormat.png,
      );
      await page.close();
      await document.close();

      setState(() {
        _thumbnail = pageImage?.bytes;
        _isLoading = false;
      });
    } on DioError catch (e) {
      print('DioError downloading PDF: $e');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading PDF: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap:
            _pdfPath == null
                ? null // Disable tap while loading or on error
                : () {
                  context.nav.pushNamed(
                    Routes.pdfViewer,
                    arguments: {
                      "path": _pdfPath!,
                      "fileName": getFileNameFromUrl(widget.pdfUrl),
                    },
                  );
                },
        child: Container(
          height: 200,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
          child:
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _thumbnail != null
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(2),
                          child: Image.memory(
                            _thumbnail!,
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ],
                  )
                  : Center(
                    child: Text(
                      'Failed to load PDF',
                      style: context.appTextStyle.text,
                    ),
                  ),
        ),
      ),
    );
  }
}
