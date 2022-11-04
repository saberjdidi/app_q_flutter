import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Models/employe_model.dart';
import '../../../../Services/action/action_service.dart';
import '../../../../Services/action/local_action_service.dart';
import '../../../../Utils/custom_colors.dart';
import '../../../../Utils/shared_preference.dart';
import '../../../../Utils/snack_bar.dart';
import 'intervenant_action_realisation_page.dart';

class NewIntervenant extends StatefulWidget {
  final idAction;
  final idSousAction;

  const NewIntervenant(
      {Key? key, required this.idAction, required this.idSousAction})
      : super(key: key);

  @override
  State<NewIntervenant> createState() => _NewIntervenantState();
}

class _NewIntervenantState extends State<NewIntervenant> {
  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  final matricule = SharedPreference.getMatricule();

  ActionService actionService = ActionService();
  LocalActionService localActionService = LocalActionService();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final _filterEditTextController = TextEditingController();

  List<EmployeModel> listEmployeSelected =
      List<EmployeModel>.empty(growable: true);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Action N° ${widget.idAction}",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: SingleChildScrollView(
            child: Form(
                key: _addItemFormKey,
                child: Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 8.0,
                        ),
                        DropdownSearch<EmployeModel>.multiSelection(
                          searchFieldProps: TextFieldProps(
                            controller: _filterEditTextController,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  _filterEditTextController.clear();
                                },
                              ),
                            ),
                          ),
                          mode: Mode.DIALOG,
                          isFilteredOnline: true,
                          showClearButton: false,
                          showSelectedItems: true,
                          compareFn: (item, selectedItem) =>
                              item?.mat == selectedItem?.mat,
                          showSearchBox: true,
                          /* dropdownSearchDecoration: InputDecoration(
                                  labelText: 'User *',
                                  filled: true,
                                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                                ), */
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "List Employes",
                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                            border: OutlineInputBorder(),
                          ),
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          validator: (u) => u == null || u.isEmpty
                              ? "employe field is required "
                              : null,
                          onFind: (String? filter) => getEmploye(filter),
                          onChanged: (data) {
                            listEmployeSelected = data;
                            //print(data);
                            //print('mat: ${data.map((e) => e.mat)}');
                            listEmployeSelected.forEach((element) {
                              print(
                                  'nomprenom: ${element.nompre}, matricule: ${element.mat}');
                            });
                          },
                          dropdownBuilder: _customDropDownExampleMultiSelection,
                          popupItemBuilder: _customPopupItemBuilderExample,
                          popupSafeArea:
                              PopupSafeAreaProps(top: true, bottom: true),
                          scrollbarProps: ScrollbarProps(
                            isAlwaysShown: true,
                            thickness: 7,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        _isProcessing
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    CustomColors.firebaseOrange,
                                  ),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  saveBtn();
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    CustomColors.googleBackground,
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Save',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: CustomColors.firebaseWhite,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ))),
          ),
        ),
      )),
    );
  }

  Future saveBtn() async {
    if (_addItemFormKey.currentState!.validate()) {
      try {
        setState(() {
          _isProcessing = true;
        });

        listEmployeSelected.forEach((element) async {
          print('mat: ${element.mat}');
          await actionService
              .saveIntervenant(
                  widget.idAction, widget.idSousAction, element.mat)
              .then((resp) async {
            ShowSnackBar.snackBar("Intervenant Successfully",
                "${element.mat} added", Colors.green);
            //Get.back();
            Get.to(IntervenantsActionRealisationPage(
              idAction: widget.idAction,
              idSousAction: widget.idSousAction,
            ));
          }, onError: (err) {
            _isProcessing = false;
            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          });
        });
      } catch (ex) {
        _isProcessing = false;
        AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.ERROR,
          body: Center(
            child: Text(
              ex.toString(),
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          title: 'Error',
          btnCancel: Text('Cancel'),
          btnOkOnPress: () {
            Navigator.of(context).pop();
          },
        )..show();
        print("throwing new error " + ex.toString());
        throw Exception("Error " + ex.toString());
      } finally {
        _isProcessing = false;
      }
    }
  }

  //Product
  Future<List<EmployeModel>> getEmploye(filter) async {
    try {
      List<EmployeModel> employeList =
          await List<EmployeModel>.empty(growable: true);
      List<EmployeModel> employeFilter = await <EmployeModel>[];

      await actionService.getIntervenantEmploye({
        "nact": widget.idAction.toString(),
        "nsact": widget.idSousAction.toString(),
        "mat": "",
        "nom": ""
      }).then((resp) async {
        resp.forEach((data) async {
          var model = EmployeModel();
          model.nompre = data['nompre'];
          model.mat = data['mat'];
          employeList.add(model);
        });
      }, onError: (err) {
        ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
      });

      employeFilter = employeList.where((u) {
        var name = u.nompre.toString().toLowerCase();
        var description = u.mat!.toLowerCase();
        return name.contains(filter) || description.contains(filter);
      }).toList();
      return employeFilter;
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      return Future.error('service : ${exception.toString()}');
    }
  }

  Widget _customDropDownExampleMultiSelection(
      BuildContext context, List<EmployeModel?> selectedItems) {
    if (selectedItems.isEmpty) {
      return ListTile(
        contentPadding: EdgeInsets.all(0),
        //leading: CircleAvatar(),
        title: Text("No item selected"),
      );
    }

    return Wrap(
      children: selectedItems.map((e) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              /* leading: CircleAvatar(
                // this does not work - throws 404 error
                // backgroundImage: NetworkImage(item.avatar ?? ''),
              ),
              */
              title: Text(e?.nompre ?? ''),
              subtitle: Text(
                e?.mat.toString() ?? '',
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _customPopupItemBuilderExample(
      BuildContext context, EmployeModel? item, bool isSelected) {
    /*if(isSelected == true){
      print('produit ${item?.produit}');
    } */
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.nompre ?? ''),
        subtitle: Text(item?.mat?.toString() ?? ''),
        leading: CircleAvatar(
            // this does not work - throws 404 error
            // backgroundImage: NetworkImage(item.avatar ?? ''),
            ),
      ),
    );
  }
}
