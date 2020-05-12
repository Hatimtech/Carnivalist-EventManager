import 'package:eventmanagement/bloc/addon/addon_bloc.dart';
import 'package:eventmanagement/bloc/user/user_bloc.dart';
import 'package:eventmanagement/intl/app_localizations.dart';
import 'package:eventmanagement/main.dart';
import 'package:eventmanagement/ui/page/addons/addon_page.dart';
import 'package:eventmanagement/utils/vars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssignAddonPage extends StatefulWidget {
  final List<String> selectedAddons;

  const AssignAddonPage(this.selectedAddons);

  @override
  _AssignAddonPageState createState() => _AssignAddonPageState();
}

class _AssignAddonPageState extends State<AssignAddonPage> {
  AddonBloc _addonBloc;

  @override
  void initState() {
    super.initState();
    _addonBloc = BlocProvider.of<AddonBloc>(context);
    _addonBloc
        .authTokenSave(BlocProvider.of<UserBloc>(context).state.authToken);
    _addonBloc.previousAddonSelection(widget.selectedAddons);
    _addonBloc.getAllAddons();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildTopBgContainer(context),
          Expanded(
            child: AddonPage(
              allowRefresh: false,
              allowCreate: false,
              allowAction: false,
              enableSelection: true,
            ),
          ),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildTopBgContainer(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          AppLocalizations.of(context).labelAddons,
          style: Theme.of(context).appBarTheme.textTheme.title,
        ),
      ),
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColorSecondary,
        image: DecorationImage(
          colorFilter: ColorFilter.mode(colorHeaderBgFilter, BlendMode.srcATop),
          image: AssetImage(headerBackgroundImage),
          fit: BoxFit.fitWidth,
        ),
        borderRadius: isPlatformAndroid
            ? null
            : const BorderRadius.only(
                topLeft: const Radius.circular(16.0),
                topRight: const Radius.circular(16.0),
              ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32.0,
        vertical: 8.0,
      ),
      child: RaisedButton(
        onPressed: () => Navigator.pop(context, _addonBloc.addonIds),
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: Text(
          AppLocalizations.of(context).btnSave,
          style: Theme.of(context).textTheme.button,
        ),
      ),
    );
  }
}
