import 'package:eventmanagement/bloc/event/createfield/create_field_bloc.dart';
import 'package:eventmanagement/bloc/event/createfield/create_field_state.dart';
import 'package:eventmanagement/utils/hexacolor.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/material.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
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
                Text(titleCustomField,
                    textAlign: TextAlign.left,
                    style: (TextStyle(
                        fontSize: 18,
                        color: colorSubHeader,
                        fontWeight: FontWeight.bold,
                        fontFamily: montserratBoldFont))),
                SizedBox(height: 20.0),
                Container(
                    child: BlocBuilder(
                        bloc: _createFieldBloc,
                        builder:
                            (context, CreateFieldState state) =>
                            Container(
                                margin: EdgeInsets.only(
                                    top: 10.0, bottom: 10.0),
                                decoration: BoxDecoration(
                                    color: HexColor('#EEEEEF'),
                                    borderRadius:
                                    BorderRadius.all(
                                        Radius.circular(
                                            5.0))),
                                child: Row(
                                    children: state.customFieldMeuList
                                        .map((data) {
                                      return Expanded(
                                          child: GestureDetector(
                                              onTap: () {
                                                _createFieldBloc
                                                    .selectCustomFieldName(
                                                    data.name);
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: state.customFieldName == data.name
                                                          ? HexColor(
                                                          '#8c3ee9')
                                                          : Colors
                                                          .transparent,
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          5)),
                                                  padding:
                                                  EdgeInsets.all(
                                                      8),
                                                  child: Text(
                                                      data.name,
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                          color: Colors
                                                              .black,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          fontSize: 12.0)))));
                                    }).toList()))
                    )),
                SizedBox(height: 20.0),
                Text(labelFieldName,
                    style: (TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontFamily: montserratBoldFont))),
                SizedBox(height: 4.0),
                widget.inputFieldRectangle(_fieldNameController),
                SizedBox(height: 20.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(labelMandatory,
                          textAlign: TextAlign.left,
                          style: (TextStyle(fontSize: 16, color: Colors.grey))),
                      SizedBox(width: 10.0),
                      Switch(value: true, onChanged: (newVal) {})
                    ]),
                SizedBox(height: 10.0),
                Row(children: <Widget>[
                  Expanded(
                      child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: HexColor('#8c3ee9'),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(btnClose,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400))))),
                  SizedBox(width: 15),
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: HexColor('#8c3ee9'),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(btnSave,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400))))
                ])
              ]))
    ]);
  }
}
