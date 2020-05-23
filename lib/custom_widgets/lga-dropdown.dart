import 'package:cewers/model/lga.dart';
import 'package:flutter/material.dart';
import 'package:cewers/extensions/string.dart';

class LocalGovernmentDropdown extends StatefulWidget {
  final Future allLgaAndComm;
  //  Function selectLocalGoverment => localGoverment;
  //  Function selectCommunity => community;
//   String localGoverment;
// String community;
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
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3,
                child: Text("Local government"),
              ),
              Expanded(
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
                        return DropdownButton(
                            isExpanded: true,
                            hint: Text(lgaValue ?? "Select"),
                            items: []..addAll(
                                lga.map(
                                  (l) => DropdownMenuItem(
                                    child: Text(l.name.toString().capitalize()),
                                    value: l.name,
                                    onTap: () {
                                      LocalGovernmentModel locals;
                                      lga.forEach((lc) {
                                        if (l.name.toLowerCase() ==
                                            lc.name.toLowerCase()) locals = l;
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
                            });
                        // : ; //
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
              )),
            ],
          ),
          Row(children: [
            Container(
                width: MediaQuery.of(context).size.width / 3,
                child: Text("Community")),
            Expanded(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: Text(community ?? "Communities"),
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
            )
          ]),
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
