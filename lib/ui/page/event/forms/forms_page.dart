import 'package:eventmanagement/bloc/event/basic/basic_bloc.dart';
import 'package:eventmanagement/bloc/event/createfield/create_field_bloc.dart';
import 'package:eventmanagement/bloc/event/form/form_bloc.dart';
import 'package:eventmanagement/bloc/event/form/form_state.dart' as FS;
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/model/event/field_data.dart';
import 'package:eventmanagement/ui/platform/widget/platform_scroll_bar.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../dialog/create_fields_dialog.dart';

class FormsPage extends StatefulWidget {
  @override
  createState() => _FormsState();
}

class _FormsState extends State<FormsPage> {
  FormBloc _formBloc;

  @override
  void initState() {
    super.initState();
    _formBloc = BlocProvider.of<FormBloc>(context);
    final _basicBloc = BlocProvider.of<BasicBloc>(context);
    if (_basicBloc.state.uploadRequired || _formBloc.eventDataToUpload == null)
      _formBloc.eventDataToUpload = _basicBloc.eventDataToUpload;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        child: Column(children: <Widget>[
          _buildErrorReceiverEmptyBloc(),
          Align(
              alignment: Alignment.topRight,
              child: RaisedButton(
                  splashColor: Colors.black.withOpacity(0.2),
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                  onPressed: _onCreateFieldButtonPressed,
                  child: Text(AppLocalizations
                      .of(context)
                      .btnCreateFields,
                      style: TextStyle(color: Colors.white)))),
          Expanded(
              child: Container(
                  child: BlocBuilder<FormBloc, FS.FormState>(
                      bloc: _formBloc,
                      condition: (prevState, nextState) {
                        return prevState.fieldList != nextState.fieldList ||
                            prevState.fieldList.length !=
                                nextState.fieldList.length;
                      },
                      builder: (context, FS.FormState snapshot) {
                        return snapshot.loading
                            ? Container(
                            alignment: FractionalOffset.center,
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    colorProgressBar)))
                            : formsList(snapshot.fieldList);
                      }))),
        ]));
  }

  Widget _buildErrorReceiverEmptyBloc() =>
      BlocBuilder<FormBloc, FS.FormState>(
        bloc: _formBloc,
        condition: (prevState, newState) => newState.uiMsg != null,
        builder: (context, state) {
          if (state.uiMsg != null) {
            String errorMsg = state.uiMsg is int
                ? getErrorMessage(state.uiMsg, context)
                : state.uiMsg;
            context.toast(errorMsg);

            state.uiMsg = null;
          }

          return SizedBox.shrink();
        },
      );

  formsList(List<FieldData> fieldDataList) =>
      PlatformScrollbar(
        child: ListView.builder(
            itemCount: fieldDataList.length,
            itemBuilder: (context, position) {
              final fieldData = fieldDataList[position];
              return GestureDetector(
                onTap: () {
                  if (!(fieldData.solid ?? false))
                    return showFieldActions(fieldData);
                  else
                    return null;
                },
                child: Card(
                    margin:
                    EdgeInsets.only(top: 5, left: 0, right: 0, bottom: 5),
                    child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(children: <Widget>[
                          Row(children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(fieldData.label,
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .body1
                                              .copyWith(
                                            fontWeight: FontWeight.w500,
                                          )),
                                      const SizedBox(height: 5),
                                      Text(fieldData.typeUI,
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .body2
                                              .copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ))
                                    ])),
                            Expanded(
                                flex: 0,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      const SizedBox(height: 2),
                                      Text(
                                          AppLocalizations
                                              .of(context)
                                              .labelMandatory,
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .body1
                                              .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.0,
                                          )),
                                      Text(
                                          fieldData.required
                                              ? AppLocalizations
                                              .of(context)
                                              .labelYes
                                              : AppLocalizations
                                              .of(context)
                                              .labelNo,
                                          style:
                                          Theme
                                              .of(context)
                                              .textTheme
                                              .body2)
                                    ]))
                          ])
                        ]))),
              );
            }),
      );

  Future<void> showFieldActions(FieldData fieldData) async {
    if (isPlatformAndroid)
      await showModalBottomSheet(
          context: this.context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
          ),
          builder: (context) {
            return _buildMaterialFormActionSheet(fieldData);
          });
    else {
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) =>
            _buildCupertinoFormActionSheet(fieldData),
      );
    }
  }

  Widget _buildMaterialFormActionSheet(FieldData fieldData) =>
      ListView(
        shrinkWrap: true,
        children: <Widget>[
          _buildMaterialFieldAction(
            AppLocalizations
                .of(context)
                .labelEditField,
            fieldData,
            editField,
            true,
          ),
          _buildMaterialFieldAction(
            AppLocalizations
                .of(context)
                .labelDeleteField,
            fieldData,
            deleteField,
            false,
          ),
        ],
      );

  Widget _buildMaterialFieldAction(String name, FieldData fieldData,
      Function handler, bool showDivider) {
    return InkWell(
        onTap: () {
          Navigator.pop(context);
          handler(fieldData);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 8.0,
              ),
              child: Text(
                name,
                style: Theme
                    .of(context)
                    .textTheme
                    .subtitle
                    .copyWith(
                  color: colorTextAction,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (showDivider) const Divider(),
          ],
        ));
  }

  Widget _buildCupertinoFormActionSheet(FieldData fieldData) {
    return CupertinoActionSheet(
      actions: [
        _buildCupertinoTicketAction(
            AppLocalizations
                .of(context)
                .labelEditField, fieldData, editField),
        _buildCupertinoTicketAction(
            AppLocalizations
                .of(context)
                .labelDeleteField,
            fieldData,
            deleteField),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          AppLocalizations
              .of(context)
              .btnCancel,
          style: Theme
              .of(context)
              .textTheme
              .title
              .copyWith(
            color: colorTextAction,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildCupertinoTicketAction(String name, FieldData fieldData,
      Function handler) {
    return CupertinoActionSheetAction(
      onPressed: () {
        Navigator.pop(context);
        handler(fieldData);
      },
      child: Text(
        name,
        style: Theme
            .of(context)
            .textTheme
            .subtitle
            .copyWith(
          color: colorTextAction,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void editField(FieldData fieldData) {
    _onCreateFieldButtonPressed(fieldId: fieldData.id);
  }

  Future<void> deleteField(FieldData fieldData) async {
    bool delete = await context.showConfirmationDialog(
        AppLocalizations
            .of(context)
            .fieldDeleteTitle,
        AppLocalizations
            .of(context)
            .fieldDeleteMsg,
        posText: AppLocalizations
            .of(context)
            .deleteButton,
        negText: AppLocalizations
            .of(context)
            .btnCancel);

    if (delete ?? false) {
      _formBloc.deleteField(fieldData.id);
    }
  }

  Future<void> _onCreateFieldButtonPressed({String fieldId}) async {
    var formBloc = BlocProvider.of<FormBloc>(context);
    await showDialog(
      context: context,
      builder: (BuildContext context) =>
          BlocProvider(
            create: (context) => CreateFieldBloc(formBloc, fieldId),
            child: CreateFieldsDialog(),
          ),
    );
    formBloc = null;
  }
}
