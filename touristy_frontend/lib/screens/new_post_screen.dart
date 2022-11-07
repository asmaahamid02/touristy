import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:touristy_frontend/providers/posts.dart';
import '../widgets/profile_avatar.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});
  static const routeName = '/new-post';
  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  late ImagePicker imagePicker;
  late int idGenerator;
  late List<XFile> imageFileList;

  //cation controller
  final captionController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    imageFileList = [];
    imagePicker = ImagePicker();
  }

  Future<void> _selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      //check if the image is already selected
      imageFileList.addAll(selectedImages);
    }
    setState(() {});
  }

  void _deleteImage(int index) {
    imageFileList.removeAt(index);
    setState(() {});
  }

  void _showSnakeBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ),
    );
  }

  Future<void> _addNewPost() async {
    if (captionController.text.isEmpty && imageFileList.isEmpty) {
      return;
    }

    final List<File> imageFileListConverted =
        imageFileList.map((image) => File(image.path)).toList(growable: false);

    setState(() {
      _isLoading = true;
    });

    try {
      //add post
      await Provider.of<Posts>(context, listen: false).addPost(
        captionController.text,
        imageFileListConverted,
      );
    } on HttpException catch (error) {
      _showSnakeBar(error.toString());
    } catch (error) {
      _showSnakeBar('Could not add post. Please try again later.');
    } finally {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    super.dispose();
    captionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: const Text('New Post'),
      leading: TextButton(
        child: Text(
          'Cancel',
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      leadingWidth: 80,
      actions: [
        Container(
          margin: const EdgeInsets.all(10),
          child: TextButton(
            onPressed: () {
              _addNewPost();
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColor)),
            child: const Text(
              'Post',
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: SizedBox(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.95,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const _PostHeader(),
                    Expanded(
                      child: Card(
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              maxLines: null,
                              autofocus: true,
                              controller: captionController,
                              decoration: const InputDecoration.collapsed(
                                  hintText: "Type a memory..."),
                            ),
                          )),
                    ),
                    Column(
                      children: [
                        _ImagesGrid(
                            imageFileList: imageFileList,
                            deleteImage: _deleteImage),
                        _BottomActionBar(selectImages: _selectImages),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  const _PostHeader({
    Key? key,
  }) : super(key: key);

  DropdownMenuItem<String> _buildDropdownMenuItem(
      BuildContext context, String value, IconData icon) {
    return DropdownMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 15,
            color: Colors.white,
          ),
          const SizedBox(width: 5),
          Text(value.toLowerCase(),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.white)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          const ProfileAvatar(
            imageUrl: 'https://picsum.photos/200',
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Username', style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 5),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: Theme.of(context).primaryColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).backgroundColor,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 15,
                      color: Colors.white,
                    ),
                    items: [
                      _buildDropdownMenuItem(context, 'Public', Icons.public),
                      _buildDropdownMenuItem(context, 'Friends', Icons.people),
                    ],
                    dropdownColor: Theme.of(context).primaryColor,
                    value: 'Public',
                    onChanged: (value) {
                      print(value);
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({required this.selectImages});
  final Function() selectImages;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        IconButton(
            onPressed: () {
              selectImages();
            },
            icon: Icon(
              Icons.image_outlined,
              color: Colors.lightGreen[600],
            )),
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.location_on,
              color: Colors.red[600],
            ))
      ]),
    );
  }
}

class _ImagesGrid extends StatelessWidget {
  _ImagesGrid({required this.imageFileList, required this.deleteImage});
  final List<XFile> imageFileList;
  final Function(int index) deleteImage;

  double imageWidth = 100;
  double imageHeight = 80;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: imageFileList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(5),
            child: Stack(children: [
              SizedBox(
                height: imageHeight,
                width: imageWidth,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(imageFileList[index].path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: InkWell(
                  onTap: () {
                    deleteImage(index);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withOpacity(0.7),
                    ),
                    child: const Icon(
                      Icons.clear,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              )
            ]),
          );
        },
      ),
    );
  }
}
