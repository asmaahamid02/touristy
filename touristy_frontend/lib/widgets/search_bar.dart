import 'package:flutter/material.dart';
import '../../utilities/utilities.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
    required this.searchController,
  }) : super(key: key);

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: double.infinity,
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle:
                const TextStyle(color: AppColors.textFaded, fontSize: 14),
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.textFaded,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(50.0),
              ),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(8.0),
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }
}
