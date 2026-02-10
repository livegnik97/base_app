import 'package:base_app/core/extensions/list_utils.dart';
import 'package:base_app/core/extensions/string_utils.dart';
import 'package:base_app/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: implementation_imports
import 'package:flutter_typeahead/src/common/base/types.dart';

//* agregar al enum los keys para los que se quiere guardar un historial diferente
enum HistoryAutocompleteKeyEnum { forSearch }

class HistoryAutocompleteTextField extends StatefulWidget {
  const HistoryAutocompleteTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.onSelected,
    this.delayToSave = 3000,
    this.hideOnEmptyText = true,
    required this.builder,
    required this.historyAutocompleteKey,
  });

  final HistoryAutocompleteKeyEnum historyAutocompleteKey;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextFieldBuilder builder;
  final Function(String value)? onSelected;
  final int delayToSave;
  final bool hideOnEmptyText;

  @override
  State<HistoryAutocompleteTextField> createState() =>
      _HistoryAutocompleteTextFieldState();
}

class _HistoryAutocompleteTextFieldState
    extends State<HistoryAutocompleteTextField> {
  late TextEditingController controller;
  late FocusNode focusNode;
  final SuggestionsController<String> suggestionsController =
      SuggestionsController();

  late String key;

  late Debouncer saveTextDebouncer = Debouncer();

  final List<String> predictiveList = <String>[];

  @override
  void initState() {
    super.initState();
    key = widget.historyAutocompleteKey.toString();
    controller = widget.controller ?? TextEditingController();
    focusNode = widget.focusNode ?? FocusNode();
    controller.addListener(onTextChanged);
    loadPredictiveList();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    } else {
      try {
        controller.removeListener(onTextChanged);
      } catch (_) {}
    }
    if (widget.focusNode == null) {
      focusNode.dispose();
    }
    suggestionsController.dispose();
    saveTextDebouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<String>(
      suggestionsController: suggestionsController,
      controller: controller,
      focusNode: focusNode,
      suggestionsCallback: (search) => filterSearch(search),
      hideOnError: true,
      emptyBuilder: (context) => const SizedBox.shrink(),
      errorBuilder: (context, _) => const SizedBox.shrink(),
      builder: widget.builder,
      itemBuilder: (context, value) => Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(value),
            ),
          ),
          CustomIconButton(
            icon: Icons.close_rounded,
            onPressed: () {
              removeHistory(value);
            },
          ),
        ],
      ),
      onSelected: (value) {
        controller.text = value;
        focusNode.hasFocus ? focusNode.unfocus() : null;
        widget.onSelected?.call(value);
        setState(() {});
      },
    );
  }

  List<String>? filterSearch(String search) {
    search = search.trim().toLowerCase();
    if (search.isEmpty && widget.hideOnEmptyText) return null;
    final List<String> list = <String>[];
    for (var element in predictiveList) {
      if (element.toLowerCase().containsPlusUltra(search) &&
          element.toLowerCase() != search) {
        list.add(element);
      }
    }
    return list;
  }

  Future<void> loadPredictiveList() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(key) ?? [];
    predictiveList.clear();
    predictiveList.addAll(list);
    suggestionsController.refresh();
    setState(() {});
  }

  void saveTextToHistory() async {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList(key) ?? [];
    final exist =
        list.firstWhereOrNull(
          (element) => element.toLowerCase() == text.toLowerCase(),
        ) !=
        null;
    if (!exist) {
      list.add(text);
      list.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      prefs.setStringList(key, list);
      loadPredictiveList();
    }
  }

  void onTextChanged() {
    try {
      saveTextDebouncer.debounce(
        duration: Duration(milliseconds: widget.delayToSave),
        onDebounce: () {
          saveTextToHistory();
        },
      );
    } catch (_) {}
  }

  void removeHistory(String value) async {
    predictiveList.remove(value);
    setState(() {});
    suggestionsController.refresh();
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, predictiveList);
  }
}
