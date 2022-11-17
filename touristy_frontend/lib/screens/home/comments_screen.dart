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
  bool _isLoading = false;
  late bool _isInit;

  @override
  void initState() {
    super.initState();
    _isInit = true;
  }

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      postId = ModalRoute.of(context)!.settings.arguments as int;
      setState(() {
        _isLoading = true;
      });

      try {
        //get comments
        await Provider.of<Comments>(context).fetchAndSetCommentsByPost(postId);

        setState(() {
          _isLoading = false;
        });
      } on HttpException catch (error) {
        setState(() {
          _isLoading = false;
        });
        SnakeBarCommon.show(context, error.toString());
      } catch (error) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        SnakeBarCommon.show(context, error.toString());
      }
      _isInit = false;
    }
  }

  Future<void> _addComment(String comment) async {
    setState(() {
      _isLoading = true;
    });
    try {
      //add comment
      await Provider.of<Comments>(context, listen: false)
          .addComment(postId, comment);

//update comments count
      final post = Provider.of<Posts>(context, listen: false).findById(postId);

      Provider.of<Posts>(context, listen: false)
          .updateCommentCount(postId, post!.comments! + 1);

      setState(() {
        _isLoading = false;
      });
      SnakeBarCommon.show(context, 'Comment added successfully');
    } on HttpException catch (error) {
      SnakeBarCommon.show(context, error.toString());
    } catch (error) {
      if (!mounted) return;

      SnakeBarCommon.show(context, error.toString());
    }

    setState(() {
      _isLoading = false;
    });
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
          Provider.of<Comments>(context, listen: false)
              .fetchAndSetCommentsByPost(postId);
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 4.0),
                      sliver: CommentsList(isLoading: _isLoading),
                    )
                  ],
                ),
              ),
              MessageInput(
                sendMessage: _addComment,
                placeHolder: 'Add a comment',
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CommentsList extends StatelessWidget {
  const CommentsList({
    Key? key,
    required bool isLoading,
  })  : _isLoading = isLoading,
        super(key: key);

  final bool _isLoading;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const SizedBox(height: 16),
          Consumer<Comments>(
            builder: (context, comments, child) {
              return _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : comments.comments.isEmpty
                      ? const Center(
                          child: Text('No comments yet'),
                        )
                      : ListView.builder(
                          reverse: true,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: comments.comments.length,
                          itemBuilder: (context, index) {
                            return CommentItem(
                              comment: comments.comments[index],
                            );
                          },
                        );
            },
          ),
        ],
      ),
    );
  }
}
