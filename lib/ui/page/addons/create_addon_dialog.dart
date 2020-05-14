import 'dart:io';

import 'package:eventmanagement/bloc/addon/create/create_addon_bloc.dart';
import 'package:eventmanagement/bloc/addon/create/create_addon_state.dart';
import 'package:eventmanagement/bloc/user/user_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/model/addons/addon_response.dart';
import 'package:eventmanagement/utils/extensions.dart';
import 'package:eventmanagement/utils/hexacolor.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:path/path.dart' as Path;

class CreateAddonDialog extends StatefulWidget {
  @override
  createState() => _CreateAddonState();
}

class _CreateAddonState extends State<CreateAddonDialog> {
  CreateAddonBloc _createAddonBloc;

  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeTotalAva = FocusNode();
  final FocusNode _focusNodePrice = FocusNode();
  final FocusNode _focusNodeDescription = FocusNode();
  final FocusNode _focusNodeConvenienceFee = FocusNode();

  Future _futureSystemPath;

  @override
  void initState() {
    super.initState();
    _createAddonBloc = BlocProvider.of<CreateAddonBloc>(context);
    final _userBloc = BlocProvider.of<UserBloc>(context);
    _createAddonBloc.authTokenSave(_userBloc.state.authToken);
    _createAddonBloc.createAddonDefault();
    _futureSystemPath = getSystemDirPath();
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
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildErrorReceiverEmptyBloc(),
            Text(AppLocalizations.of(context).titleCreateAddon,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.title),
            const SizedBox(height: 16.0),
            Text(AppLocalizations.of(context).labelAddonName,
                style: Theme.of(context).textTheme.body2),
            const SizedBox(height: 4.0),
            addonNameInput(),
            const SizedBox(height: 10.0),
            _buildStartAndEndDates(),
            const SizedBox(height: 10.0),
            _buildTotalAvailableAndPriceInput(),
            const SizedBox(height: 10.0),
            Text(AppLocalizations.of(context).labelAddonDesc,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.body2),
            const SizedBox(height: 4.0),
            descriptionInput(),
            _buildActiveAndPrivacySwitch(),
            _buildChargeConvFeeLabel(),
            _buildConvenienceFeeType(),
            const SizedBox(height: 12.0),
            _buildAddonImage(),
            const SizedBox(height: 12.0),
            Row(children: <Widget>[
              Expanded(
                child: RaisedButton(
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    AppLocalizations.of(context).btnClose,
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: RaisedButton(
                  onPressed: _createTicketToApi,
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    AppLocalizations.of(context).btnSave,
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              )
            ]),
          ],
        ),
      ),
    );
  }

  Row _buildActiveAndPrivacySwitch() {
    return Row(
      children: <Widget>[
        Text(AppLocalizations.of(context).labelAddonIsActive,
            style: Theme.of(context).textTheme.body1),
        BlocBuilder<CreateAddonBloc, CreateAddonState>(
          bloc: _createAddonBloc,
          condition: (prevState, newState) {
            return prevState.active != newState.active;
          },
          builder: (_, state) {
            return Switch.adaptive(
              value: state.active,
              onChanged: _createAddonBloc.activeInput,
            );
          },
        ),
        const SizedBox(width: 16.0),
        Text(AppLocalizations.of(context).labelAddonPrivacy,
            style: Theme.of(context).textTheme.body1),
        BlocBuilder<CreateAddonBloc, CreateAddonState>(
          bloc: _createAddonBloc,
          condition: (prevState, newState) {
            return prevState.privacy != newState.privacy;
          },
          builder: (_, state) {
            return Switch.adaptive(
              value: state.privacy == 'PRIVATE',
              onChanged: _createAddonBloc.addonPrivacyInput,
            );
          },
        ),
      ],
    );
  }

  Row _buildConvenienceFeeType() {
    return Row(
      children: <Widget>[
        Expanded(
          child: BlocBuilder<CreateAddonBloc, CreateAddonState>(
            bloc: _createAddonBloc,
            condition: (prevState, newState) =>
                prevState.convenienceFeeType != newState.convenienceFeeType,
            builder: (_, state) {
              return DecoratedBox(
                decoration: BoxDecoration(
                    color: HexColor('#EEEEEF'),
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: Row(
                    children: state.addonConvFeeTypeList.map((data) {
                  return Expanded(
                      child: GestureDetector(
                          onTap: () {
                            _createAddonBloc.convenienceFeeTypeInput(data.name);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: state.convenienceFeeType == data.name
                                      ? bgColorButton
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.all(8),
                              child: Text(uiValueAddonConvFeeType(data.name),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  style: Theme.of(context)
                                      .textTheme
                                      .body1
                                      .copyWith(fontSize: 12.0)))));
                }).toList()),
              );
            },
          ),
        ),
        const SizedBox(width: 4.0),
        SizedBox(
          height: 36.0,
          width: 60.0,
          child: addonConvenienceFeeInput(),
        ),
      ],
    );
  }

  Row _buildChargeConvFeeLabel() {
    return Row(
      children: <Widget>[
        Text(AppLocalizations.of(context).labelAddonConvFee,
            style: Theme.of(context).textTheme.body1),
        BlocBuilder<CreateAddonBloc, CreateAddonState>(
          bloc: _createAddonBloc,
          condition: (prevState, newState) {
            return prevState.chargeConvenienceFee !=
                newState.chargeConvenienceFee;
          },
          builder: (_, state) {
            return Switch.adaptive(
              value: state.chargeConvenienceFee,
              onChanged: _createAddonBloc.chargeConvenienceFeeInput,
            );
          },
        ),
      ],
    );
  }

  Row _buildTotalAvailableAndPriceInput() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(AppLocalizations.of(context).labelAddonTotalAvailable,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.body2),
              const SizedBox(height: 4.0),
              totalAvailableInput(),
            ],
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(AppLocalizations.of(context).labelAddonPrice,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.body2),
              SizedBox(height: 4.0),
              addonPriceInput(),
            ],
          ),
        ),
      ],
    );
  }

  Row _buildStartAndEndDates() {
    return Row(
      children: <Widget>[
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Text(AppLocalizations.of(context).labelAddonStartDate,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.body2),
              const SizedBox(height: 4.0),
              _addonStartDateInput(),
            ])),
        const SizedBox(width: 10.0),
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Text(AppLocalizations.of(context).labelAddonEndDate,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.body2),
              const SizedBox(height: 4.0),
              _addonEndDateInput(),
            ])),
      ],
    );
  }

  Widget _buildErrorReceiverEmptyBloc() =>
      BlocBuilder<CreateAddonBloc, CreateAddonState>(
        bloc: _createAddonBloc,
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

  Widget _addonStartDateInput() =>
      BlocBuilder<CreateAddonBloc, CreateAddonState>(
          condition: (prevState, newState) =>
              prevState.startDate != newState.startDate,
          bloc: _createAddonBloc,
          builder: (BuildContext context, state) {
            return InkWell(
              onTap: () => _pickDate(
                  DateTime.now(), _createAddonBloc.startDateTimeInput),
              child: Container(
                height: 48,
                padding: EdgeInsets.only(left: 3.0),
                decoration: boxDecorationRectangle(),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    state.startDate != null
                        ? DateFormat.yMMMMd().format(state.startDate)
                        : AppLocalizations.of(context).inputHintDate,
                    style: Theme.of(context).textTheme.body1.copyWith(
                        color: state.startDate != null
                            ? null
                            : Theme.of(context).hintColor),
                  ),
                ),
              ),
            );
          });

  Widget _addonEndDateInput() => BlocBuilder<CreateAddonBloc, CreateAddonState>(
      condition: (prevState, newState) => prevState.endDate != newState.endDate,
      bloc: _createAddonBloc,
      builder: (BuildContext context, state) {
        return InkWell(
          onTap: () =>
              _pickDate(DateTime.now(), _createAddonBloc.endDateTimeInput),
          child: Container(
            height: 48,
            padding: EdgeInsets.only(left: 3.0),
            decoration: boxDecorationRectangle(),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                state.endDate != null
                    ? DateFormat.yMMMMd().format(state.endDate)
                    : AppLocalizations.of(context).inputHintDate,
                style: Theme.of(context).textTheme.body1.copyWith(
                    color: state.endDate != null
                        ? null
                        : Theme.of(context).hintColor),
              ),
            ),
          ),
        );
      });

  String uiValueAddonConvFeeType(String value) {
    switch (value) {
      case 'Amount':
        return AppLocalizations
            .of(context)
            .labelAmount;
      case 'Percentage':
        return AppLocalizations
            .of(context)
            .labelPercentage;
      default:
        return '';
    }
  }

  _createTicketToApi() async {
    FocusScope.of(context).requestFocus(FocusNode());
    context.showProgress(context);

    _createAddonBloc.uploadNewAddon((results) {
      context.hideProgress(context);
      if (results is AddonResponse) {
        if (results.code == apiCodeSuccess) {
          Navigator.pop(context);
        }
      }
    });
  }

  Widget addonNameInput() => widget.inputFieldRectangle(
        null,
        initialValue: _createAddonBloc.state.addonName,
        textInputAction: TextInputAction.next,
        onChanged: _createAddonBloc.addonNameInput,
        maxLength: 100,
        hintText: AppLocalizations.of(context).inputHintAddonName,
        labelStyle: Theme.of(context).textTheme.body1,
        focusNode: _focusNodeName,
        nextFocusNode: _focusNodeTotalAva,
      );

  Widget totalAvailableInput() => widget.inputFieldRectangle(
        null,
        initialValue: _createAddonBloc.state.totalAvailable,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        maxLength: 6,
        onChanged: _createAddonBloc.totalAvailableInput,
        hintText: AppLocalizations.of(context).inputHintQuantity,
        labelStyle: Theme.of(context).textTheme.body1,
        focusNode: _focusNodeTotalAva,
        nextFocusNode: _focusNodePrice,
      );

  Widget addonPriceInput() => widget.inputFieldRectangle(
        null,
        initialValue: _createAddonBloc.state.price,
        onChanged: _createAddonBloc.priceInput,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        maxLength: 6,
        hintText: AppLocalizations.of(context).inputHintAddonPrice,
        labelStyle: Theme.of(context).textTheme.body1,
        focusNode: _focusNodePrice,
        nextFocusNode: _focusNodeDescription,
      );

  descriptionInput() => widget.inputFieldRectangle(
        null,
        initialValue: _createAddonBloc.state.description,
        onChanged: _createAddonBloc.descriptionInput,
        hintText: AppLocalizations.of(context).inputHintDescription,
        labelStyle: Theme.of(context).textTheme.body1,
        maxLines: 5,
        maxLength: 500,
        focusNode: _focusNodeDescription,
        nextFocusNode: _focusNodeConvenienceFee,
      );

  Widget addonConvenienceFeeInput() {
    return BlocBuilder<CreateAddonBloc, CreateAddonState>(
        condition: (prevState, newState) {
          return prevState.chargeConvenienceFee !=
              newState.chargeConvenienceFee;
        },
        bloc: _createAddonBloc,
        builder: (_, state) {
          return widget.inputFieldRectangle(
            null,
            initialValue: _createAddonBloc.state.convenienceFee,
            onChanged: _createAddonBloc.convenienceFeeInput,
            enabled: state.chargeConvenienceFee,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            maxLength: 6,
            hintText: AppLocalizations.of(context).inputHintAddonConvenienceFee,
            labelStyle: Theme.of(context).textTheme.body1,
            focusNode: _focusNodeConvenienceFee,
          );
        });
  }

  Widget _buildAddonImage() => Align(
        child: FutureBuilder(
            future: _futureSystemPath,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return SizedBox.shrink();
              else
                return GestureDetector(
                  onTap: () => showImagePickerBottomSheet(true, false),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    child: Container(
                        width: 108.0,
                        height: 108.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: bgColorSecondary,
                        ),
                        child: BlocBuilder<CreateAddonBloc, CreateAddonState>(
                            bloc: _createAddonBloc,
                            condition: (prevState, newState) {
                              return prevState.image != newState.image;
                            },
                            builder: (context, state) {
                              return Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  if (isValid(state.image))
                                    Image(
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      image: state.image.startsWith('http')
                                          ? NetworkToFileImage(
                                              url: state.image,
                                              file: File(Path.join(
                                                  snapshot.data,
                                                  'Pictures',
                                                  state.image.substring(state
                                                          .image
                                                          .lastIndexOf('/') +
                                                      1))),
                                              debug: true,
                                            )
                                          : FileImage(
                                              File(state.image),
                                            ),
                                    ),
                                  if (!isValid(state.image))
                                    Text(
                                      AppLocalizations.of(context)
                                          .labelAddonUploadImage,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle
                                          .copyWith(fontSize: 14.0),
                                      textAlign: TextAlign.center,
                                    ),
                                ],
                              );
                            })),
                  ),
                );
            }),
      );

  void showImagePickerBottomSheet(bool banner, bool video) {
    if (isPlatformAndroid)
      showModalBottomSheet(
          context: context,
          builder: (ctx) => _buildImagePickerView(banner, video));
    else
      showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
            child: _buildImagePickerView(banner, video),
          );
        },
      );
  }

  Widget _buildImagePickerView(bool banner, bool video) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            _openCamera(banner, video);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.camera,
                  size: 32.0,
                ),
                Text(AppLocalizations.of(context).labelCamera),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            _openGallery(banner, video);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.filter,
                  size: 32.0,
                ),
                Text(AppLocalizations.of(context).labelGallery),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openCamera(bool banner, bool video) async {
    var image;

    if (video)
      image = await ImagePicker.pickVideo(source: ImageSource.camera);
    else
      image = await ImagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 80);

    print('Camera Image/Video Path--->${image?.path}');
    if (image != null) {
      if (banner) {
        await _deleteExistingBanner();
        _createAddonBloc.imageInput(image.path);
      }
    }
  }

  Future<void> _openGallery(bool banner, bool video) async {
    var image;
    if (video)
      image = await ImagePicker.pickVideo(source: ImageSource.gallery);
    else
      image = await ImagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 80);

    print('Gallery Image/Video Path--->${image?.path}');
    if (image != null) {
      if (banner) {
        await _deleteExistingBanner();
        _createAddonBloc.imageInput(image.path);
      }
    }
  }

  Future<void> _deleteExistingBanner() async {
    if (isValid(_createAddonBloc.state.image)) {
      File fileToDelete;

      if (_createAddonBloc.state.image.startsWith('http')) {
        fileToDelete = File(Path.join(
            await getSystemDirPath(),
            'Pictures',
            _createAddonBloc.state.image
                .substring(_createAddonBloc.state.image.lastIndexOf('/') + 1)));
      } else {
        fileToDelete = File(_createAddonBloc.state.image);
      }

      bool exist = await fileToDelete.exists();

      print('fileToDelete.path ${fileToDelete.path} $exist');
      if (exist) fileToDelete.delete();
    }
  }

  _pickDate(DateTime initialDate, Function dateHandler) async {
    DateTime pickedDate;

    if (isPlatformAndroid) {
      final currentDate = DateTime.now();

      pickedDate = await showDatePicker(
        context: context,
        firstDate:
            DateTime(currentDate.year, currentDate.month, currentDate.day),
        lastDate: DateTime(DateTime.now().year + 20),
        initialDate: initialDate,
      );
    } else {
      pickedDate = await _cupertinoPickDate(initialDate);
    }
    if (pickedDate != null) {
      dateHandler(pickedDate);
    }

    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<DateTime> _cupertinoPickDate(DateTime initialDate) async {
    final currentDate = DateTime.now();

    return await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          DateTime localPickedTime = initialDate;
          return SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CupertinoButton(
                        child: Text(AppLocalizations.of(context).btnCancel),
                        onPressed: () => Navigator.pop(context),
                      ),
                      CupertinoButton(
                        child: Text(AppLocalizations.of(context).btnConfirm),
                        onPressed: () {
                          Navigator.pop(context, localPickedTime);
                        },
                      )
                    ],
                  ),
                  Expanded(
                    child: CupertinoDatePicker(
                      initialDateTime: initialDate,
                      onDateTimeChanged: (DateTime date) {
                        localPickedTime = date;
                      },
                      maximumDate: DateTime(DateTime.now().year + 20),
                      minimumDate: DateTime(
                          currentDate.year, currentDate.month, currentDate.day),
                      mode: CupertinoDatePickerMode.date,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  boxDecorationRectangle() => BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.all(
            Radius.circular(5.0) //                 <--- border radius here
            ),
      );
}
