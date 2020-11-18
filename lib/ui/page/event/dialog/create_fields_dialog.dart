import 'package:eventmanagement/bloc/event/createfield/create_field_bloc.dart';
import 'package:eventmanagement/bloc/event/createfield/create_field_state.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/service/viewmodel/mock_data.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/hexacolor.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateFieldsDialog extends StatefulWidget {
  @override
  createState() => _CreateFieldsState();
}

class _CreateFieldsState extends State<CreateFieldsDialog> {
  CreateFieldBloc _createFieldBloc;

  ScrollController _scrollController;

  final TextEditingController _listItemController = TextEditingController();
  final FocusNode _focusNodeFieldLabel = FocusNode();
  final FocusNode _focusNodeFieldPlaceholder = FocusNode();
  final FocusNode _focusNodeFieldListItem = FocusNode();

  bool dropdownSelected = false;

  @override
  void initState() {
    super.initState();
    _createFieldBloc = BlocProvider.of<CreateFieldBloc>(context);
    _createFieldBloc.customFieldMenu();
//    _createFieldBloc.selectCustomFieldName(getCustomField()[0]);
    if (!isPlatformAndroid) {
      _scrollController = ScrollController();
      _scrollController.addListener(_scrollListener);
    }
  }

  _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        child: dialogContent(context));
  }

  dialogContent(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
          padding: EdgeInsets.all(10),
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
              Widget>[
            BlocBuilder<CreateFieldBloc, CreateFieldState>(
              cubit: _createFieldBloc,
              buildWhen: (prevState, newState) => newState.errorCode != null,
              builder: (context, CreateFieldState state) {
                if (state.errorCode != null) {
                  String errorMsg = getErrorMessage(state.errorCode, context);
                  context.toast(errorMsg);
                  state.errorCode = null;
                }

                return SizedBox.shrink();
              },
            ),
            Text(AppLocalizations
                .of(context)
                .titleCustomField,
                textAlign: TextAlign.left,
                style: Theme
                    .of(context)
                    .textTheme
                    .title),
            const SizedBox(height: 20.0),
            BlocBuilder<CreateFieldBloc, CreateFieldState>(
                cubit: _createFieldBloc,
                buildWhen: (prevState, newState) {
                  return prevState.type != newState.type ||
                      prevState.customFieldMeuList !=
                          newState.customFieldMeuList;
                },
                builder: (context, CreateFieldState state) {
                  return Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      decoration: BoxDecoration(
                          color: HexColor('#EEEEEF'),
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Row(
                          children: state.customFieldMeuList.map((data) {
                            return Expanded(
                                child: GestureDetector(
                                    onTap: () {
                                      _createFieldBloc.selectCustomFieldName(
                                          data);
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: state.type == data.value
                                                ? HexColor('#8c3ee9')
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                                5)),
                                        padding: EdgeInsets.all(8),
                                        child: Text(data.name,
                                            textAlign: TextAlign.center,
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .body1
                                                .copyWith(fontSize: 12.0)))));
                          }).toList()));
                }),
            const SizedBox(height: 20.0),
            Text(AppLocalizations
                .of(context)
                .labelFieldName,
                style: Theme
                    .of(context)
                    .textTheme
                    .body2),
            const SizedBox(height: 4.0),
            fieldLabelInput(),
            const SizedBox(height: 20.0),
            Text(AppLocalizations
                .of(context)
                .labelFieldPlaceholder,
                style: Theme
                    .of(context)
                    .textTheme
                    .body2),
            const SizedBox(height: 4.0),
            placeholderInput(),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(AppLocalizations
                    .of(context)
                    .labelMandatory,
                    textAlign: TextAlign.left,
                    style: Theme
                        .of(context)
                        .textTheme
                        .body1),
                const SizedBox(width: 10.0),
                BlocBuilder<CreateFieldBloc, CreateFieldState>(
                  cubit: _createFieldBloc,
                  buildWhen: (prevState, newState) =>
                  prevState.required != newState.required,
                  builder: (BuildContext context, state) =>
                      Switch.adaptive(
                        value: _createFieldBloc.state.required,
                        onChanged: _createFieldBloc.mandatoryInput,
                      ),
                )
              ],
            ),
            BlocBuilder<CreateFieldBloc, CreateFieldState>(
                cubit: _createFieldBloc,
                buildWhen: (prevState, newState) =>
                prevState.type != newState.type,
                builder: (context, CreateFieldState state) {
                  final customFields = getCustomField();
                  if (state.type == customFields[2].value ||
                      state.type == customFields[3].value) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 10.0),
                        Text(
                          AppLocalizations
                              .of(context)
                              .titleFieldListDetails,
                          textAlign: TextAlign.left,
                          style: Theme
                              .of(context)
                              .textTheme
                              .body1
                              .copyWith(
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        BlocBuilder<CreateFieldBloc, CreateFieldState>(
                          cubit: _createFieldBloc,
                          buildWhen: (prevState, newState) =>
                          prevState.configurations !=
                              newState.configurations ||
                              prevState.configurations.length !=
                                  newState.configurations.length,
                          builder: (context, CreateFieldState state) {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: state.configurations.length,
                                itemBuilder: (context, position) {
                                  final configuration =
                                  state.configurations[position];
                                  return Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Text(configuration,
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .body1
                                                  .copyWith(
                                                  fontWeight:
                                                  FontWeight.w500))),
                                      IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            _createFieldBloc
                                                .removeDropdownConfiguration(
                                                configuration);
                                          }),
                                    ],
                                  );
                                });
                          },
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                  controller: _listItemController,
                                  maxLength: 100,
                                  focusNode: _focusNodeFieldListItem,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .body1,
                                  onFieldSubmitted: (_) {
                                    _focusNodeFieldListItem.unfocus();
                                  },
                                  decoration: InputDecoration(
                                    counterText: '',
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: colorFocusedBorder,
                                            width: 1)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1)),
                                    contentPadding: EdgeInsets.all(5),
                                    hintText: AppLocalizations
                                        .of(context)
                                        .typeListItemValue,
                                  )),
                            ),
                            const SizedBox(width: 12.0),
                            RaisedButton(
                              onPressed: () {
                                if (isValid(_listItemController.text)) {
                                  _createFieldBloc.addDropdownConfiguration(
                                      _listItemController.text);
                                  _listItemController.text = '';
                                }
                              },
                              color: Colors.amber,
                              child: Text(
                                AppLocalizations
                                    .of(context)
                                    .btnListItemAdd,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .button,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  return SizedBox.shrink();
                }),
            const SizedBox(height: 10.0),
            Row(children: <Widget>[
              Expanded(
                child: RaisedButton(
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    AppLocalizations
                        .of(context)
                        .btnClose,
                    style: Theme
                        .of(context)
                        .textTheme
                        .button,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: RaisedButton(
                  onPressed: _createNewFormField,
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    AppLocalizations
                        .of(context)
                        .btnSave,
                    style: Theme
                        .of(context)
                        .textTheme
                        .button,
                  ),
                ),
              )
            ])
          ])),
    );
  }

  fieldLabelInput() =>
      widget.inputFieldRectangle(context,
        null,
        initialValue: _createFieldBloc.state.label,
        onChanged: _createFieldBloc.fieldLabelInput,
        hintText: AppLocalizations
            .of(context)
            .typeFieldName,
        labelStyle: Theme
            .of(context)
            .textTheme
            .body1,
        textInputAction: TextInputAction.next,
        maxLength: 100,
        focusNode: _focusNodeFieldLabel,
        nextFocusNode: _focusNodeFieldPlaceholder,
      );

  placeholderInput() =>
      widget.inputFieldRectangle(context,
        null,
        initialValue: _createFieldBloc.state.placeholder,
        onChanged: _createFieldBloc.fieldPlaceholderInput,
        hintText: AppLocalizations
            .of(context)
            .typeFieldPlaceholder,
        labelStyle: Theme
            .of(context)
            .textTheme
            .body1,
        maxLength: 100,
        focusNode: _focusNodeFieldPlaceholder,
      );

  _createNewFormField() async {
    FocusScope.of(context).requestFocus(FocusNode());

    context.showProgress(context);

    _createFieldBloc.createFormField((results) {
      context.hideProgress(context);
      if (results ?? false) {
        Navigator.pop(context);
      }
    });
  }
}
