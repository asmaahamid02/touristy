import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:touristy_frontend/utilities/utilities.dart';

import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

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

  late Map<String, dynamic> _coordinates;

  bool _isLoading = false;
  bool _isInit = true;

  int? postId;

  @override
  void initState() {
    super.initState();

    imageFileList = [];
    imagePicker = ImagePicker();
    _coordinates = {
      'latitude': null,
      'longitude': null,
      'address': null,
    };
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (_isInit) {
      postId = ModalRoute.of(context)!.settings.arguments != null
          ? ModalRoute.of(context)!.settings.arguments as int
          : 0;
      if (postId! > 0) {
        final post =
            Provider.of<Posts>(context, listen: false).findById(postId as int);

        captionController.text = post!.content != null ? post.content! : '';

        // imageFileList = post.mediaUrls!
        //     .map((e) => XFile(e['media_path']))
        //     .toList(); //convert string to XFile

        _coordinates['address'] = post.address;
      }
    }
    _isInit = false;
  }

  @override
  void dispose() {
    super.dispose();
    captionController.dispose();
  }

//add image from gallery
  Future<void> _selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      //check if the image is already selected
      imageFileList.addAll(selectedImages);
    }
    setState(() {});
  }

//DELETE IMAGE FROM LIST
  void _deleteImage(int index) {
    imageFileList.removeAt(index);
    setState(() {});
  }

//SAVE POST / UPDATE POST
  Future<void> _addNewPost() async {
    if (captionController.text.isEmpty && imageFileList.isEmpty) {
      return;
    }

    List<File> imageFileListConverted = [];
    if (imageFileList.isNotEmpty) {
      imageFileListConverted = imageFileList
          .map((image) => File(image.path))
          .toList(growable: false);
    }
    setState(() {
      _isLoading = true;
    });
    String msg = 'add';
    if (postId! > 0) {
      msg = 'update';
    }
    try {
      //add post
      if (postId == null || postId == 0) {
        await Provider.of<Posts>(context, listen: false).addPost(
            captionController.text, imageFileListConverted, _coordinates);
        //update post
      } else {
        // await Provider.of<Posts>(context, listen: false).editPost(
        //   postId as int,
        //   captionController.text,
        //   imageFileListConverted,
        // );
      }
    } on HttpException catch (error) {
      SnakeBarCommon.show(context, error.toString());
    } catch (error) {
      SnakeBarCommon.show(context,
          'Could not $msg post. Please try again later. ${error.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
      SnakeBarCommon.show(context, '${msg}ed successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          // backgroundColor: Theme.of(context).cardColor,
          appBar: _postModalAppBar(context),
          body: SingleChildScrollView(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const _PostHeader(),
                      Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            maxLines: null,
                            controller: captionController,
                            decoration: const InputDecoration.collapsed(
                                hintText: "Type a memory..."),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          imageFileList.isNotEmpty
                              ? _ImagesGrid(
                                  imageFileList: imageFileList,
                                  deleteImage: _deleteImage)
                              : const SizedBox.shrink(),
                          _BottomActionBar(
                              selectImages: _selectImages,
                              coordinates: _coordinates),
                        ],
                      ),
                    ],
                  ),
          )),
    );
  }

  AppBar _postModalAppBar(BuildContext context) {
    return AppBar(
      title: const Text('New Post'),
      leading: TextButton(
        child: const Text(
          'Cancel',
          style: TextStyle(fontSize: 16.0, color: AppColors.accent),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      leadingWidth: 80,
      actions: [
        Container(
          margin: const EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: () {
              _addNewPost();
            },
            child: const Text(
              'Post',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        )
      ],
    );
  }
}

class _PostHeader extends StatelessWidget {
  const _PostHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<Users>(context).currentUser;
    final StoryData storyData = StoryData(
      id: currentUser.id,
      url: currentUser.profilePictureUrl,
      isOnline: true,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Avatar.medium(
            imageUrl: storyData.url,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${currentUser.firstName} ${currentUser.lastName}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 5),
              Row(
                children: const [
                  Icon(
                    Icons.public_outlined,
                    size: 15,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Public',
                    style: TextStyle(color: AppColors.textFaded),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomActionBar extends StatefulWidget {
  const _BottomActionBar(
      {required this.selectImages, required this.coordinates});
  final Function() selectImages;
  final Map<String, dynamic> coordinates;

  @override
  State<_BottomActionBar> createState() => _BottomActionBarState();
}

class _BottomActionBarState extends State<_BottomActionBar> {
  String? address;

  @override
  void initState() {
    super.initState();

    address = widget.coordinates['address'];
  }

  void updateAddress(String newValue) {
    setState(() {
      address = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                address != null && address != ''
                    ? ModalBottomSheetCommon.show(
                        context,
                        _RemoveLocation(
                            coordinates: widget.coordinates,
                            updateAddress: updateAddress),
                        height: 160)
                    : null;
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  address ?? '',
                  style: const TextStyle(color: AppColors.textFaded),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                widget.selectImages();
              },
              icon: Icon(
                Icons.image_outlined,
                color: Colors.lightGreen[600],
              )),
          IconButton(
              onPressed: () {
                ModalBottomSheetCommon.show(
                    context,
                    _LocationChoicesList(
                        coordinates: widget.coordinates,
                        updateAddress: updateAddress),
                    height: 300);
              },
              icon: Icon(
                Icons.location_on,
                color: Colors.red[600],
              ))
        ],
      ),
    );
  }
}

class _LocationChoicesList extends StatefulWidget {
  const _LocationChoicesList({
    Key? key,
    required this.coordinates,
    required this.updateAddress,
  }) : super(key: key);
  final Map<String, dynamic> coordinates;
  final Function(String) updateAddress;

  @override
  State<_LocationChoicesList> createState() => _LocationChoicesListState();
}

class _LocationChoicesListState extends State<_LocationChoicesList> {
  Future<void> _getCurrentPosition() async {
    final hasPermission =
        await LocationHandler().handleLocationPermission(context);
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      widget.coordinates['latitude'] = position.latitude;
      widget.coordinates['longitude'] = position.longitude;
      _getAddressFromLatLng(position);
      Navigator.pop(context);
    }).catchError((e) {
      SnakeBarCommon.show(context, 'Failed to get location');
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      final String address =
          await LocationHandler().getAddressFromLatLng(position);
      widget.coordinates['address'] = address;

      widget.updateAddress(address);
    } catch (error) {
      SnakeBarCommon.show(context, 'Failed to get location');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //current location
          LocationOption(
              icon: Icons.location_on_outlined,
              label: 'Current Location',
              onTap: _getCurrentPosition),
          const Divider(),
          //search location
          LocationOption(
            icon: Icons.search,
            label: 'Search Location',
            onTap: () {},
          ),
          const Divider(),
          //choose from map
          LocationOption(
            icon: Icons.map_outlined,
            label: 'Choose from Map',
            onTap: () {},
          ),
          const Divider(),
          //cancel
          LocationOption(
            icon: Icons.cancel_outlined,
            label: 'Cancel',
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}

class LocationOption extends StatelessWidget {
  const LocationOption({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
  }) : super(key: key);
  final String label;
  final IconData icon;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () => onTap(),
    );
  }
}

class _RemoveLocation extends StatefulWidget {
  const _RemoveLocation(
      {required this.coordinates, required this.updateAddress});
  final Map<String, dynamic> coordinates;
  final Function(String) updateAddress;

  @override
  State<_RemoveLocation> createState() => _RemoveLocationState();
}

class _RemoveLocationState extends State<_RemoveLocation> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //remove location
          LocationOption(
            icon: Icons.remove_circle_outline,
            label: 'Remove Location',
            onTap: () {
              widget.coordinates['latitude'] = null;
              widget.coordinates['longitude'] = null;
              widget.coordinates['address'] = null;

              widget.updateAddress(widget.coordinates['address']);

              Navigator.pop(context);
            },
          ),
          const Divider(),
          //cancel
          LocationOption(
            icon: Icons.cancel_outlined,
            label: 'Cancel',
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          const Divider(),
        ],
      ),
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
