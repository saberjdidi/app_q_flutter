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
import 'new_intervenant.dart';

class IntervenantsActionRealisationPage extends StatefulWidget {
  final idAction;
  final idSousAction;

 const IntervenantsActionRealisationPage({Key? key, required this.idAction, required this.idSousAction}) : super(key: key);

  @override
  State<IntervenantsActionRealisationPage> createState() => _IntervenantsActionRealisationPageState();
}

class _IntervenantsActionRealisationPageState extends State<IntervenantsActionRealisationPage> {

  LocalActionService localService = LocalActionService();
  //ActionService actionService = ActionService();
  final matricule = SharedPreference.getMatricule();
  List<EmployeModel> listIntervenant = List<EmployeModel>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    //checkConnectivity();
    getIntervenants();
  }
  Future<void> checkConnectivity() async {
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
    }
    else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
      Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
    }
  }
  void getIntervenants() async {
    try {
        //rest api
        await ActionService().getIntervenant(widget.idAction, widget.idSousAction).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = EmployeModel();
              model.nompre = data['nompre'];
              model.mat = data['mat'];
              listIntervenant.add(model);
            });
          });
        }
            , onError: (err) {
              ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
            });

    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    }
    finally {
      //isDataProcessing(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color lightPrimary = Colors.white;
    const Color darkPrimary = Colors.white;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                lightPrimary,
                darkPrimary,
              ])),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: TextButton(
            onPressed: (){
              Get.back();
              //Get.offAll(HomePage());
            },
            child: Icon(Icons.arrow_back, color: Colors.blue,),
          ),
          title: Text(
            'Intervenants',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listIntervenant.isNotEmpty ?
            Container(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final num_action = widget.idAction;
                  final num_sous_action = widget.idSousAction;
                  return
                    Column(
                      children: [
                        ListTile(
                          title: Text(
                            ' Action: ${num_action}   \n Sous Action: ${num_sous_action}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyLarge,
                                children: [
                                  WidgetSpan(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                      child: Icon(Icons.person),
                                    ),
                                  ),
                                  TextSpan(text: '${listIntervenant[index].nompre}'),

                                  //TextSpan(text: '${action.declencheur}'),
                                ],

                              ),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1.0,
                          color: Colors.blue,
                        ),
                      ],
                    );
                },
                itemCount: listIntervenant.length,
                //itemCount: actionsList.length + 1,
              ),
            )
                : const Center(child: Text('Empty List', style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Brand-Bold'
            )),)
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
           // Get.to(NewIntervenant(idAction: widget.idAction, idSousAction: widget.idSousAction,));

            final _addItemFormKey = GlobalKey<FormState>();
            final _filterEditTextController = TextEditingController();
            List<EmployeModel> listEmployeSelected = List<EmployeModel>.empty(growable: true);

            Future<List<EmployeModel>> getEmploye(filter) async {
              try {
                List<EmployeModel> employeList = await List<EmployeModel>.empty(growable: true);
                List<EmployeModel> employeFilter = await <EmployeModel>[];

                await ActionService().getIntervenantEmploye({
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
                }
                    , onError: (err) {
                      ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
                    });

                employeFilter = employeList.where((u) {
                  var name = u.nompre.toString().toLowerCase();
                  var description = u.mat!.toLowerCase();
                  return name.contains(filter) ||
                      description.contains(filter);
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
            //bottomSheet
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30)
                    )
                ),
                builder: (context) => DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.7,
                  maxChildSize: 0.9,
                  minChildSize: 0.4,
                  builder: (context, scrollController) => SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        SizedBox(height: 5.0,),
                        Center(
                          child: Text('Ajouter Intervenant', style: TextStyle(
                              fontWeight: FontWeight.w500, fontFamily: "Brand-Bold",
                              color: Color(0xFF0769D2), fontSize: 30.0
                          ),),
                        ),
                        SizedBox(height: 15.0,),
                        Form(
                          key: _addItemFormKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: DropdownSearch<EmployeModel>.multiSelection(
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
                                  compareFn: (item, selectedItem) => item?.mat == selectedItem?.mat,
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
                                  validator: (u) =>
                                  u == null || u.isEmpty ? "employe field is required " : null,
                                  onFind: (String? filter) => getEmploye(filter),
                                  onChanged: (data) {
                                    listEmployeSelected.clear();
                                    listEmployeSelected = data;
                                    listEmployeSelected.forEach((element) {
                                      print('nomprenom: ${element.nompre}, matricule: ${element.mat}');
                                    });
                                  },
                                  dropdownBuilder: _customDropDownExampleMultiSelection,
                                  popupItemBuilder: _customPopupItemBuilderExample,
                                  popupSafeArea: PopupSafeAreaProps(top: true, bottom: true),
                                  scrollbarProps: ScrollbarProps(
                                    isAlwaysShown: true,
                                    thickness: 7,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              ConstrainedBox(
                                constraints: BoxConstraints.tightFor(width: MediaQuery.of(context).size.width / 1.1, height: 50),
                                child: ElevatedButton.icon(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    backgroundColor:
                                    MaterialStateProperty.all(CustomColors.firebaseRedAccent),
                                    padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                                  ),
                                  icon: Icon(Icons.cancel),
                                  label: Text(
                                    'Cancel',
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                              ),
                              SizedBox(height: 10,),
                              ConstrainedBox(
                                constraints: BoxConstraints.tightFor(width: MediaQuery.of(context).size.width / 1.1, height: 50),
                                child: ElevatedButton.icon(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    backgroundColor:
                                    MaterialStateProperty.all(CustomColors.googleBackground),
                                    padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                                  ),
                                  icon: Icon(Icons.save),
                                  label: Text(
                                    'Save',
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    if(_addItemFormKey.currentState!.validate()){
                                      try {
                                        listEmployeSelected.forEach((element) async {
                                          print('mat: ${element.mat}');
                                          await ActionService().saveIntervenant(widget.idAction, widget.idSousAction, element.mat).then((resp) async {

                                            }, onError: (err) {
                                            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
                                          });
                                        });
                                        setState(() {
                                          listIntervenant.clear();
                                          getIntervenants();
                                        });
                                        Get.back();
                                      }
                                      catch (ex){
                                        print("Exception" + ex.toString());
                                        ShowSnackBar.snackBar("Exception", ex.toString(), Colors.red);
                                        throw Exception("Error " + ex.toString());
                                      }
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 32,),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }

}