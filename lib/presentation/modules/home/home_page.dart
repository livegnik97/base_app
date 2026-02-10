import 'package:base_app/core/extensions/custom_context.dart';
import 'package:base_app/core/extensions/double_utils.dart';
import 'package:base_app/core/helpers/dialog_manager.dart';
import 'package:base_app/presentation/dialogs/dialog_loading.dart';
import 'package:base_app/presentation/dialogs/dialog_select_language.dart';
import 'package:base_app/presentation/modules/home/provider/home_provider.riverpod.dart';
import 'package:base_app/presentation/providers/conectivity_status/connectivity_status_provider.riverpod.dart';
import 'package:base_app/presentation/providers/socketio/socketio_provider.dart';
import 'package:base_app/presentation/widgets/buttons/custom_filled_button.dart';
import 'package:base_app/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:base_app/presentation/widgets/buttons/custom_outlined_button.dart';
import 'package:base_app/presentation/widgets/buttons/custom_text_button.dart';
import 'package:base_app/presentation/widgets/containers/custom_container.dart';
import 'package:base_app/presentation/widgets/containers/custom_informative_container.dart';
import 'package:base_app/presentation/widgets/forms_widget/count_down_widget.dart';
import 'package:base_app/presentation/widgets/forms_widget/custom_dropdown_button.dart';
import 'package:base_app/presentation/widgets/forms_widget/custom_inmutable_text.dart';
import 'package:base_app/presentation/widgets/forms_widget/custom_text_form_field.dart';
import 'package:base_app/presentation/widgets/shared/custom_appbar.dart';
import 'package:base_app/presentation/widgets/shared/history_autocomplete_text_field.dart';
import 'package:base_app/presentation/widgets/shared/language_picker.dart';
import 'package:base_app/presentation/widgets/shared/theme_change.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        //* keep alive providers
        Consumer(
          builder: (_, WidgetRef ref, _) {
            ref.watch(connectivityStatusProvider);
            ref.watch(socketioProvider);
            ref.watch(homeProvider);
            return SizedBox.shrink();
          },
        ),
        Expanded(
          child: Scaffold(
            appBar: CustomAppbar(
              context,
              title: 'Home Page',
              actions: [ThemeChangeWidget()],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      spacing: 8,
                      children: <Widget>[
                        SizedBox(height: 8),
                        HistoryAutocompleteTextField(
                          historyAutocompleteKey:
                              HistoryAutocompleteKeyEnum.forSearch,
                          delayToSave: 1000,
                          builder: (context, controller, focusNode) =>
                              CustomTextFormField(
                                controller: controller,
                                focusNode: focusNode,
                                label: 'CustomTextFormField',
                                hint: 'hint',
                              ),
                        ),
                        CustomInmutableText(
                          title: 'CustomInmutableText',
                          subTitle: 'subTitle',
                          icon: Icons.add,
                          onActionPressed: () {},
                          onDelete: () {},
                        ),
                        CustomDropdownButton(
                          items: ['a', 'b', 'c'],
                          hint: 'hint',
                          itemBuilder: (item) => Text(item),
                          onChanged: (value) {},
                        ),
                        CountDownWidget(timeOut: () {}),
                        LanguagePicker(),
                        CustomFilledButton(
                          label: 'CustomFilledButton',
                          onPressed: () {
                            DialogManager.showCustomDialog(
                              context,
                              child: DialogSelectLanguage(),
                            );
                          },
                        ),
                        CustomOutlinedButton(
                          label: 'CustomOutlinedButton',
                          onPressed: () {
                            DialogManager.showConfirmDialog(
                              context,
                              title: 'Confirm',
                              message:
                                  'Consequat est mollit qui voluptate non voluptate consectetur sit.',
                              subMessage: 'subMessage',
                            );
                          },
                        ),
                        CustomTextButton(
                          label: 'CustomTextButton',
                          onPressed: () async {
                            int progress = 0;
                            final dialogProgressController =
                                DialogLoadingController();
                            bool isCloseDialog = false;
                            DialogManager.showLoadingDialog(
                              context,
                              waitTimeInSeconds: 2,
                              dialogProgressController:
                                  dialogProgressController,
                            ).then((_) {
                              isCloseDialog = true;
                            });
                            await Future.delayed(const Duration(seconds: 4));
                            for (int i = 0; i < 20; i++) {
                              progress += 5;
                              if (isCloseDialog) break;
                              dialogProgressController.updateProgress(
                                (progress / 100).toSafePercent(),
                              );
                              await Future.delayed(
                                const Duration(milliseconds: 100),
                              );
                            }
                            if (!isCloseDialog) {
                              context.pop();
                            }
                          },
                        ),
                        CustomIconButton(
                          icon: Icons.add,
                          tooltip: 'CustomIconButton',
                          onPressed: () {
                            DialogManager.showConfirmWithTextDialog(
                              context,
                              title: 'Confirm with text',
                              textFieldLabel: 'label',
                              textFieldHint: 'hint',
                              onConfirm: (value) async {
                                return 'error';
                              },
                            );
                          },
                        ),
                        CustomContainer(
                          withBorder: true,
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Dolore occaecat cupidatat incididunt enim voluptate consequat excepteur eu elit et in quis. Elit labore dolore sunt deserunt. Enim quis do ex cillum do deserunt eiusmod aute mollit in enim. Do velit mollit aliquip est ex amet eiusmod in. Nostrud culpa eiusmod ex deserunt adipisicing labore. Nulla ullamco magna veniam excepteur.',
                          ),
                        ),
                        CustomInformativeContainer(
                          text:
                              'Et deserunt elit tempor irure sit aliquip nisi voluptate ex nostrud ad officia dolor.',
                          color: context.error,
                          icon: Icons.warning_amber_rounded,
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
