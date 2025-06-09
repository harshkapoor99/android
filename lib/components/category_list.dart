import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/models/master/master_models.dart';
import 'package:guftagu_mobile/providers/master_data_provider.dart';

import 'package:guftagu_mobile/utils/context_less_nav.dart';

class CategoryList extends ConsumerWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(masterDataProvider);
    final categories = [
      CharacterType(
        id: "all",
        charactertypeName: "All",
        emoji: "",
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
        status: 1,
      ),
      ...provider.characterTypes,
    ];
    return SizedBox(
      height: 30,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          bool isSelected =
              category.id == (provider.seletedCharacterTypeTab?.id ?? "all");

          return Padding(
            padding: EdgeInsets.only(
              right: index < categories.length - 1 ? 8.0 : 0,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300), // Animation duration
              curve: Curves.easeInOut, // Animation curve
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? context.colorExt.primary
                        : context.colorExt.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Material(
                color:
                    Colors
                        .transparent, // Important for InkWell to work properly
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap:
                      () => ref
                          .read(masterDataProvider.notifier)
                          .selectCharacterTypeFilter(category),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: Text(
                        category.charactertypeName,
                        textAlign: TextAlign.center,
                        style: context.appTextStyle.textSemibold.copyWith(
                          color:
                              isSelected
                                  ? context.colorExt.buttonText
                                  : context.colorExt.textHint,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
