import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ItemsPage extends StatefulWidget {
  ItemsPage({super.key, required this.debetorname});
  String? debetorname;

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

enum Options { SOS, $ }

class _ItemsPageState extends State<ItemsPage> {
  String? itemname;
  Options? _selectedOption = Options.SOS; // Default selection

  Future<void> oppendilogbox() => showDialog(
      context: context,
      builder: (context) => Dialog(
            child: Container(
              width:
                  MediaQuery.of(context).size.width * 0.95, // Adjust width here
              constraints: BoxConstraints(
                minHeight: 200.0, // Minimum height
                maxHeight:
                    MediaQuery.of(context).size.height * 0.7, // Maximum height
              ),
              child: AlertDialog(
                title: Text("Add New item"),
                content: Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        print("Changing value to: $value");

                        setState(() {
                          itemname = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Name",
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    _selectedOption == Options.SOS
                        ? TextField(
                            onChanged: (value) {
                              print("Changing value to: $value");
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              hintText: "price in dollar \$\$\$",
                              filled: true,
                              fillColor: Colors.white,
                              border: InputBorder.none,
                            ),
                          )
                        : SizedBox.shrink(),
                    SizedBox(
                      height: 20.0,
                    ),
                    _selectedOption == Options.$
                        ? TextField(
                            onChanged: (value) {
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              hintText: "price in shiling somali sos",
                              filled: true,
                              fillColor: Colors.white,
                              border: InputBorder.none,
                            ),
                          )
                        : SizedBox.shrink(),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("SOS"),
                        Radio<Options>(
                          value: Options.SOS,
                          groupValue: _selectedOption,
                          onChanged: (Options? value) {
                            print("Changing option to: $value");
                            setState(() {
                              _selectedOption = value;
                            });
                            print("Current option: $_selectedOption");
                          },
                        ),
                        Text("\$"),
                        Radio<Options>(
                          value: Options.$,
                          groupValue: _selectedOption,
                          onChanged: (Options? value) {
                            print("Changing option to: $value");
                            setState(() {
                              _selectedOption = value;
                            });
                            print("Current option: $_selectedOption");
                          },
                        ),
                      ],
                    )
                  ],
                ),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Add",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.green,
                  )
                ],
              ),
            ),
          ));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            oppendilogbox();
          }),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(25.0))),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios),
                      ),
                      SizedBox(
                        width: 120.0,
                      ),
                      Text(
                        widget.debetorname!,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    children: [
                      Text(
                        "items",
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.w300),
                      ),
                      Spacer(),
                      Text(
                        "5",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  DashedLine(
                    color: Colors.grey,
                  ),
                  Total(),
                  Total(),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 100.0, bottom: 10.0),
                      child: Row(
                        children: [
                          SizedBox(width: 12),
                          Expanded(
                            // This will allow the first text to expand
                            flex:
                                2, // You can adjust flex to control space allocation
                            child: Text(
                              "abuwalad",
                              overflow: TextOverflow
                                  .ellipsis, // Prevents text from breaking layout
                              style: TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.w400),
                            ),
                          ),
                          Expanded(
                            // This will keep this space even if there's no text
                            flex: 1,
                            child: Text(
                              "dollar",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.w400),
                            ),
                          ),
                          Expanded(
                            // This will allow the number text to expand
                            flex: 1,
                            child: Text(
                              "sos",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                    DashedLine(
                      color: Colors.grey,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          SizedBox(width: 12),
                          Expanded(
                            // This will allow the first text to expand
                            flex:
                                2, // You can adjust flex to control space allocation
                            child: Text(
                              "abuwalad",
                              overflow: TextOverflow
                                  .ellipsis, // Prevents text from breaking layout
                              style: TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.w400),
                            ),
                          ),
                          Expanded(
                            // This will keep this space even if there's no text
                            flex: 1,
                            child: Text(
                              "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.w400),
                            ),
                          ),
                          Expanded(
                            // This will allow the number text to expand
                            flex: 1,
                            child: Text(
                              "100k",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.w400),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.cancel_rounded,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Total extends StatelessWidget {
  const Total({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "total dollar",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
        Spacer(),
        Text(
          "\$10",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}

class DashedLine extends StatelessWidget {
  final double height;
  final Color color;
  final double dashWidth;
  final double dashSpace;

  const DashedLine({
    Key? key,
    this.height = 1,
    this.color = Colors.grey,
    this.dashWidth = 10,
    this.dashSpace = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashCount =
            (constraints.maxWidth / (dashWidth + dashSpace)).floor();
        return Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List<Widget>.generate(dashCount, (_) {
            return Container(
              width: dashWidth,
              height: height,
              color: color,
            );
          }),
        );
      },
    );
  }
}
