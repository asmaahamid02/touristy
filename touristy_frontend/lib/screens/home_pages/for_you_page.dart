import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/widgets.dart';
import '../../providers/providers.dart';
import '../../exceptions/http_exception.dart';
import '../../utilities/utilities.dart';

class ForYouPage extends StatefulWidget {
  const ForYouPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ForYouPage> createState() => _ForYouPageState();
}

class _ForYouPageState extends State<ForYouPage> {
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
      final posts =
          await Provider.of<Posts>(context, listen: false).fetchAndSetPosts();
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
    await Provider.of<Posts>(context, listen: false).fetchAndSetPosts();
    await Provider.of<Users>(context, listen: false).fetchAndSetUsers();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshData(context),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
            sliver: SliverToBoxAdapter(
              child: TravelersAvatarsList(),
            ),
          ),
          // SliverPadding(
          //   padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
          //   sliver: SliverToBoxAdapter(
          //     child: TripsList(),
          //   ),
          // ),
          // SliverPadding(
          //     padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
          //     sliver: SliverToBoxAdapter(
          //       child: EventsList(),
          //     )),
          _PostsList(_hasMore),
        ],
      ),
    );
  }
}

class _PostsList extends StatelessWidget {
  const _PostsList(this._hasMore);
  final _hasMore;

  @override
  Widget build(BuildContext context) {
    return Consumer<Posts>(
      builder: (context, postsData, _) => SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == postsData.posts.length) {
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
            final post = postsData.posts[index];
            return PostContainer(post: post);
          },
          childCount: postsData.posts.length + (_hasMore ? 1 : 0),
        ),
      ),
    );
  }
}
