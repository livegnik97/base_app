import 'package:flutter/material.dart';
import 'package:base_app/core/extensions/color_extension.dart';
import 'package:base_app/presentation/widgets/forms_widget/custom_text_form_field.dart';

class SearchTextFieldWidget extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint;
  final Function(String)? onChanged;
  final bool showHistory;
  final List<String>? recentSearches;
  final Function(String)? onSearchSubmitted;
  final VoidCallback? onClearHistory;
  final Color? backgroundColor;

  const SearchTextFieldWidget({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.showHistory = false,
    this.recentSearches,
    this.onSearchSubmitted,
    this.onClearHistory,
    this.backgroundColor,
  });

  @override
  State<SearchTextFieldWidget> createState() => _SearchTextFieldWidgetState();
}

class _SearchTextFieldWidgetState extends State<SearchTextFieldWidget> {
  late TextEditingController _internalController;
  bool _showSuggestions = false;
  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ?? TextEditingController();
    _internalController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    } else {
      _internalController.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  void _onTextChanged() {
    final text = _internalController.text;
    widget.onChanged?.call(text);

    if (widget.showHistory && text.isNotEmpty) {
      setState(() {
        _filteredSuggestions = (widget.recentSearches ?? [])
            .where((s) => s.toLowerCase().contains(text.toLowerCase()))
            .toList();
        _showSuggestions = _filteredSuggestions.isNotEmpty;
      });
    } else {
      setState(() {
        _showSuggestions = false;
      });
    }
  }

  void _onSuggestionSelected(String suggestion) {
    _internalController.text = suggestion;
    setState(() {
      _showSuggestions = false;
    });
    widget.onSearchSubmitted?.call(suggestion);
  }

  void _clearHistory() {
    widget.onClearHistory?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextFormField(
          controller: _internalController,
          hint: widget.hint ?? 'Buscar...',
          prefixIcon: Icons.search,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          onFieldSubmitted: widget.onSearchSubmitted,
          backgroundColor: widget.backgroundColor,
        ),
        if (_showSuggestions && _filteredSuggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity2(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredSuggestions.length,
              itemBuilder: (context, index) {
                final suggestion = _filteredSuggestions[index];
                return ListTile(
                  leading: const Icon(Icons.history, size: 18),
                  title: Text(suggestion),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    onPressed: _clearHistory,
                  ),
                  onTap: () => _onSuggestionSelected(suggestion),
                  dense: true,
                );
              },
            ),
          ),
      ],
    );
  }
}
