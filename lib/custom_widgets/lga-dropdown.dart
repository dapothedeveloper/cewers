import 'package:cewers/model/lga.dart';
import 'package:flutter/material.dart';
import 'package:cewers/extensions/string.dart';

class LocalGovernmentDropdown extends StatefulWidget {
  final Future allLgaAndComm;

  LocalGovernmentDropdown({Key key, this.allLgaAndComm}) : super(key: key);
  _LocalGovernmentDropdown createState() => _LocalGovernmentDropdown();
}

class _LocalGovernmentDropdown extends State<LocalGovernmentDropdown> {
  String lgaValue;
  List<String> lgaValues;
  List<String> communities;
  String community;
  initState() {
    super.initState();
    communities = [];
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
              future: widget.allLgaAndComm,
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
                      List<LocalGovernmentModel> lga = List.from(value);
                      return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  isExpanded: true,
                                  hint: Text(
                                      lgaValue ?? "Select Local government"),
                                  items: []..addAll(
                                      lga.map(
                                        (l) => DropdownMenuItem(
                                          child: Text(
                                              l.name.toString().capitalize()),
                                          value: l.name,
                                          onTap: () {
                                            LocalGovernmentModel locals;
                                            lga.forEach((lc) {
                                              if (l.name.toLowerCase() ==
                                                  lc.name.toLowerCase())
                                                locals = l;
                                            });
                                            setState(() {
                                              lgaValue = l.name;
                                              community = null;
                                              communities = locals.communities;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  onChanged: (value) {
                                    setState(() {
                                      lgaValue = value;
                                    });
                                  })));
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
          Card(
            margin: EdgeInsets.only(bottom: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            // width: MediaQuery.of(context).size.width
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text(community ?? "Select community"),
                  onChanged: setComunity,
                  items: []..addAll(
                      communities
                          .map(
                            (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e.capitalize() ?? "-"),
                            ),
                          )
                          .where((element) => element != null),
                    ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  setComunities(List<String> values) {
    setState(() {
      communities = values;
    });
  }

  setComunity(String value) {
    setState(() {
      community = value;
    });
  }

  Widget loading = Container(
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}
