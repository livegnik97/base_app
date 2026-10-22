import 'package:flutter/material.dart';
import 'package:base_app/core/helpers/debounce_utils.dart';
import 'package:base_app/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:base_app/presentation/widgets/forms_widget/custom_text_form_field.dart';
import 'package:base_app/presentation/widgets/shared/history_autocomplete_text_field.dart';

class SearchBarGlobal extends StatefulWidget {
  const SearchBarGlobal({
    super.key,
    required this.onSearch,
    required this.hint,
    this.contentFilters,
    required this.historyAutocompleteKey,
    this.initialValue,
  });

  final Function(String value) onSearch;
  final String hint;
  final Widget? contentFilters;
  final HistoryAutocompleteKeyEnum historyAutocompleteKey;
  final String? initialValue;

  @override
  State<SearchBarGlobal> createState() => _SearchBarGlobalState();
}

class _SearchBarGlobalState extends State<SearchBarGlobal> {
  // final TextEditingController _searchController = TextEditingController();

  final Debounce debounce = Debounce(milliseconds: 600);

  late final TextEditingController controller;

  @override
  initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    controller.dispose();
    debounce.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    debounce.run(() => widget.onSearch.call(query));
  }

  bool showSuffixIcon = false;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: HistoryAutocompleteTextField(
              historyAutocompleteKey: widget.historyAutocompleteKey,
              controller: controller,
              onSelected: (_) => _onChanged(controller),
              builder: (context, controller, focusNode) {
                return CustomTextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  hint: widget.hint,
                  prefixIcon: Icons.search,
                  onChanged: (_) => _onChanged(controller),
                  onTapOutside: (_) => focusNode.unfocus(),
                  suffixIcon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: FadeTransition(opacity: animation, child: child),
                    ),
                    child: showSuffixIcon
                        ? CustomIconButton(
                            icon: Icons.close,
                            onPressed: () {
                              controller.clear();
                              setState(() => showSuffixIcon = false);
                              widget.onSearch.call('');
                            },
                          )
                        : SizedBox.shrink(),
                  ),
                );
              },
            ),
          ),
          if (widget.contentFilters != null) ...[
            const SizedBox(width: 12),
            IconButton.filled(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  enableDrag: true,
                  isScrollControlled: true,
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: widget.contentFilters,
                        ),
                      ),
                    );
                  },
                );
              },
              icon: Icon(
                Icons.filter_list_rounded,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _onChanged(TextEditingController controller) {
    final value = controller.text.trim();
    _onSearchChanged(value);
    final text = controller.text;
    if (text.isNotEmpty) {
      if (!showSuffixIcon) {
        setState(() => showSuffixIcon = true);
      }
    } else if (showSuffixIcon) {
      setState(() => showSuffixIcon = false);
    }
  }
}
