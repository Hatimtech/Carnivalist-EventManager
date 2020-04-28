import 'package:eventmanagement/bloc/event/createfield/create_field_bloc.dart';
import 'package:eventmanagement/bloc/event/createfield/create_field_state.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/hexacolor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateFieldsDialog extends StatefulWidget {
  @override
  createState() => _CreateFieldsState();
}

class _CreateFieldsState extends State<CreateFieldsDialog> {
  CreateFieldBloc _createFieldBloc;
  final TextEditingController _fieldNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _createFieldBloc = BlocProvider.of<CreateFieldBloc>(context);
    _createFieldBloc.customFieldMenu();
    _createFieldBloc.selectCustomFieldName('Text');
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
    return ListView(shrinkWrap: true, children: <Widget>[
      Container(
          padding: EdgeInsets.all(10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(AppLocalizations
                    .of(context)
                    .titleCustomField,
                    textAlign: TextAlign.left,
                    style: Theme
                        .of(context)
                        .textTheme
                        .title),
                const SizedBox(height: 20.0),
                Container(
                    child: BlocBuilder(
                        bloc: _createFieldBloc,
                        builder: (context, CreateFieldState state) =>
                            Container(
                                margin: EdgeInsets.only(
                                    top: 10.0, bottom: 10.0),
                                decoration: BoxDecoration(
                                    color: HexColor('#EEEEEF'),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                                child: Row(
                                    children: state.customFieldMeuList.map((
                                        data) {
                                      return Expanded(
                                          child: GestureDetector(
                                              onTap: () {
                                                _createFieldBloc
                                                    .selectCustomFieldName(
                                                    data.name);
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: state
                                                          .customFieldName ==
                                                          data.name
                                                          ? HexColor('#8c3ee9')
                                                          : Colors.transparent,
                                                      borderRadius:
                                                      BorderRadius.circular(5)),
                                                  padding: EdgeInsets.all(8),
                                                  child: Text(data.name,
                                                      textAlign: TextAlign
                                                          .center,
                                                      style: Theme
                                                          .of(context)
                                                          .textTheme
                                                          .body1
                                                          .copyWith(
                                                          fontSize: 12.0)))));
                                    }).toList())))),
                const SizedBox(height: 20.0),
                Text(AppLocalizations
                    .of(context)
                    .labelFieldName,
                    style: Theme
                        .of(context)
                        .textTheme
                        .body2),
                const SizedBox(height: 4.0),
                widget.inputFieldRectangle(_fieldNameController,
                    hintText: AppLocalizations
                        .of(context)
                        .typeFieldName,
                    labelStyle: Theme
                        .of(context)
                        .textTheme
                        .body1),
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
                      Switch(value: true, onChanged: (newVal) {})
                    ]),
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
                      onPressed: () {},
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
              ]))
    ]);
  }
}
