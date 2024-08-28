import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicapp/core/theme/app_pallete.dart';
import 'package:musicapp/core/ustils.dart';
import 'package:musicapp/core/widgets/custom_field.dart';
import 'package:musicapp/core/widgets/loader.dart';
import 'package:musicapp/features/home/repositories/home_repository.dart';
import 'package:musicapp/features/home/view/widgets/audio_wave.dart';
import 'package:musicapp/features/home/viewmodel/home_viewmodel.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final TextEditingController artistNameController = TextEditingController();
  final TextEditingController songNameController = TextEditingController();
  Color selectedColor = Pallete.cardColor;
  File? selectedImage;
  File? selectedAudio;

  final _formKey = GlobalKey<FormState>();

  Future<void> selectAudio() async {
    final pickedAudio = await pickAudio();

    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  Future<void> selectImage() async {
    final pickedImage = await pickImage();

    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    artistNameController.dispose();
    songNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(homeViewmodelProvider.select(
      (value) => value?.isLoading == true,
    ));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Upload Song'),
        actions: [
          IconButton(
              onPressed: () async {
                if (_formKey.currentState!.validate() &&
                    selectedAudio != null &&
                    selectedImage != null) {
                  print("ontaaaaaaaaaaaaaap");
                  print(selectedAudio!);
                  print(selectedImage!);
                  print(selectedColor!);
                  print("ontaaaaaaaaaaaaaap");

                  await ref.read(homeViewmodelProvider.notifier).uploadSong(
                      selectedAudio: selectedAudio!,
                      selectedThumbnail: selectedImage!,
                      songName: songNameController.text.trim(),
                      artist: artistNameController.text.trim(),
                      selectedColor: selectedColor);
                } else {
                  showSnackBar(context, 'Missing Fields ! ');
                }
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: selectImage,
                        child: selectedImage != null
                            ? SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      selectedImage!,
                                      fit: BoxFit.cover,
                                    )))
                            : DottedBorder(
                                color: Pallete.borderColor,
                                radius: const Radius.circular(10),
                                borderType: BorderType.RRect,
                                strokeCap: StrokeCap.round,
                                strokeWidth: 2,
                                dashPattern: const [10, 4],
                                child: const SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open,
                                        size: 34,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text("Select the thumnail for your song")
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      selectedAudio != null
                          ? AudioWave(
                              path: selectedAudio!.path,
                            )
                          : CustomField(
                              hintText: 'Select a Song',
                              controller: null,
                              readOnly: true,
                              onTap: selectAudio,
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomField(
                        hintText: 'Artist',
                        controller: artistNameController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomField(
                        hintText: 'Song Name',
                        controller: songNameController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ColorPicker(
                        pickersEnabled: const {ColorPickerType.wheel: true},
                        color: selectedColor,
                        onColorChanged: (Color color) {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
