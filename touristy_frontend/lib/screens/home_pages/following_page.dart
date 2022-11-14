import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touristy_frontend/utilities/utilities.dart';
import '../../exceptions/http_exception.dart';
import '../../providers/posts.dart';
import '../../widgets/widgets.dart';

class FollowingPage extends StatefulWidget {
  const FollowingPage({super.key});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  late ScrollController _scrollController;

  final int maxLength = 10;

  bool _isLoading = false;

  bool _isInit = true;

  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.95 &&
          !_isLoading) {
        if (_hasMore) {
          _loadMore();
        }
      }
    });
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _loadMore();
      _isInit = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _loadMore() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final posts = await Provider.of<Posts>(context, listen: false)
          .fetchAndSetFollowingPosts();
      setState(() {
        _isLoading = false;
        if (posts.length < maxLength) {
          _hasMore = false;
        }
      });
    } on HttpException catch (error) {
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
      SnakeBarCommon.show(context, error.toString());
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
      SnakeBarCommon.show(context, error.toString());
    }
  }

  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<Posts>(context, listen: false)
        .fetchAndSetFollowingPosts();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () => _refreshData(context),
        child: SafeArea(
          child: Consumer<Posts>(
            builder: (context, postsData, _) => ListView.builder(
                itemCount: postsData.followingPosts.length + (_hasMore ? 1 : 0),
                itemBuilder: ((context, index) {
                  if (index == postsData.followingPosts.length) {
                    return SizedBox(
                      height: 50,
                      child: Center(
                        child: _hasMore
                            ? const CircularProgressIndicator()
                            : const Center(
                                child: Text('No more posts'),
                              ),
                      ),
                    );
                  }
                  final post = postsData.followingPosts[index];
                  return PostContainer(post: post);
                })),
          ),
        ));
  }
}
