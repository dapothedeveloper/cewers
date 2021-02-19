import 'package:cewers/bloc/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:cewers/extensions/string.dart';

class LocalGovernmentDropdown extends StatefulWidget {
  final Future lga;
  final Future wards;

  LocalGovernmentDropdown({Key key, @required this.lga, @required this.wards})
      : super(key: key);
  _LocalGovernmentDropdown createState() => _LocalGovernmentDropdown();
}

class _LocalGovernmentDropdown extends State<LocalGovernmentDropdown> {
  String lgaValue;
  List<String> lgaValues;
  List<WardModel> communities;
  List<String> filteredCommunities;
  String community;
  initState() {
    super.initState();
    communities = [];
    filteredCommunities = [];
  }

  List<String> _wardsFilter(String lga) {
    var list = communities?.where((ward) => ward?.lga == lga)?.toList();
    List<String> result = [];
    for (var ward in list) {
      if (!result.contains(ward.name)) {
        result.add(ward.name);
      }
    }
    return result;
  }

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.only(bottom: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: FutureBuilder(
              future: widget.lga,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return loading;
                    break;
                  case ConnectionState.waiting:
                    return loading;
                    break;
                  case ConnectionState.active:
                    return loading;
                    break;
                  case ConnectionState.done:
                    var value = snapshot.data;
                    if (!snapshot.hasError) {
                      if (value is String) return Text(value);
                      debugPrint(value.toString());
                      List<String> lga =
                          List<String>.from(value).toSet().toList();
                      // List<String> lga = list.toSet().toList();

                      return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              isExpanded: true,
                              value: lgaValue,
                              hint: Text("Select Local government"),
                              items: []..addAll(
                                  lga.map(
                                    (l) => DropdownMenuItem<String>(
                                      child: Text(l.capitalize()),
                                      value: l,
                                      onTap: () {
                                        debugPrint(l.toString());
                                        setState(() {
                                          community = null;
                                          filteredCommunities = _wardsFilter(l);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              onChanged: (value) {
                                setState(() {
                                  lgaValue = value;
                                });
                              }),
                        ),
                      );
                    } else {
                      return Flexible(
                          child: Text("Error " + snapshot.error.toString(),
                              style: TextStyle(), softWrap: true));
                    }
                    break;
                  default:
                    return Text("LGA not available");
                    break;
                }
              },
            ),
          ),
          communityDropDown()
        ],
      ),
    );
  }

  setComunities(List<WardModel> values) {
    setState(() {
      communities = values;
    });
  }

  setComunity(String value) {
    setState(() {
      community = value;
    });
  }

  Widget communityDropDown() {
    return FutureBuilder(
      future: widget.wards,
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.done) {
          if (snap.hasData) {
            var response = snap.data;
            if (response is Iterable<WardModel>) {
              communities = response.toList();
              return Card(
                margin: EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                // width: MediaQuery.of(context).size.width
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text("Select community"),
                      value: community,
                      onChanged: setComunity,
                      items: []..addAll(filteredCommunities == null ||
                              filteredCommunities == []
                          ? []
                          : filteredCommunities
                              ?.map(
                                (e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e.capitalize() ?? "-"),
                                ),
                              )
                              ?.where((e) => e != null)),
                    ),
                  ),
                ),
              );
            } else {
              return Text(response.toString());
            }
          } else {
            return Text(
              snap.error.toString(),
              textAlign: TextAlign.left,
            );
          }
        } else {
          return loading;
        }
      },
    );
  }

  Widget loading = Container(
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}
