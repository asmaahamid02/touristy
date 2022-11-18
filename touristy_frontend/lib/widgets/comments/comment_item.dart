import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utilities/utilities.dart';
import '../../widgets/widgets.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({super.key, required this.comment});
  final Comment comment;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final double contWidth = MediaQuery.of(context).size.width * 0.9;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar.small(
            imageUrl: comment.profilePicture,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: contWidth,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: brightness == Brightness.light
                        ? AppColors.backgroundLightGrey
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              comment.userName!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14.0,
                                letterSpacing: 0.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            comment.createdAt!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12.0,
                              color: AppColors.textFaded,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        comment.content!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //likes count
                        Text(
                          comment.likesCount.toString(),
                          style: TextStyle(
                            fontSize: 12.0,
                            color: comment.isLiked!
                                ? AppColors.secondary
                                : AppColors.textFaded,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        CommentButtons(
                          color: comment.isLiked!
                              ? AppColors.secondary
                              : AppColors.textFaded,
                          label: 'Like',
                          onTap: () {
                            try {
                              Provider.of<Comments>(context, listen: false)
                                  .toggleLikeStatus(comment.id!);
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),
                      ],
                    ),
                    CommentButtons(
                      color: AppColors.textFaded,
                      label: 'Reply',
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
