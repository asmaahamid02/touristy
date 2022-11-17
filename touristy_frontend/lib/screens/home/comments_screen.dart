import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touristy_frontend/exceptions/http_exception.dart';
import '../../providers/providers.dart';
import '../../utilities/utilities.dart';
import '../../widgets/widgets.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  static const routeName = '/comments';

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late int postId;
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
      postId = ModalRoute.of(context)!.settings.arguments as int;

      Provider.of<Comments>(context, listen: false).resetComments();
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
      postId = ModalRoute.of(context)!.settings.arguments as int;

      //get comments
      final comments = await Provider.of<Comments>(context, listen: false)
          .fetchAndSetCommentsByPost(postId);

      print(comments.length);

      setState(() {
        _isLoading = false;
        if (comments.length < maxLength) {
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
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
      SnakeBarCommon.show(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      backgroundColor: brightness == Brightness.light
          ? Theme.of(context).cardColor
          : Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _hasMore = true;
          Provider.of<Comments>(context, listen: false).resetComments();
          _loadMore();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(height: 16),
                    Consumer<Comments>(
                      builder: (context, comments, child) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: comments.comments.length,
                          itemBuilder: (context, index) {
                            return CommentItem(
                              comment: comments.comments[index],
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    if (!_hasMore)
                      const Center(
                        child: Text('No more comments'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
