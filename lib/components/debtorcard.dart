import 'package:debt_manager/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DebtorsCard extends StatefulWidget {
  final String? imagepath;
  final String? titile;
  final String? Total_dollor;
  final String? Total_shiling_somali;
  final int? index;
  final void Function()? onTap;

  DebtorsCard({
    required this.imagepath,
    required this.titile,
    required this.Total_dollor,
    required this.Total_shiling_somali,
    required this.index,
    required this.onTap,
  });

  @override
  _DebtorsCardState createState() => _DebtorsCardState();
}

class _DebtorsCardState extends State<DebtorsCard> {
  Offset _tapPosition = Offset.zero;

  void _showContextMenu(BuildContext context, TapDownDetails details) async {
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromLTRB(
      details.globalPosition.dx,
      details.globalPosition.dy,
      overlay.size.width - details.globalPosition.dx,
      overlay.size.height - details.globalPosition.dy,
    );

    final result = await showMenu(
      context: context,
      position: position,
      items: [
        const PopupMenuItem<String>(
          value: "delete",
          child: Text('Delete', style: TextStyle(color: Colors.black)),
        ),
      ],
    );

    if (result == "delete") {
      deleteDebtor(widget.index!);
    }
  }

  void deleteDebtor(int index) async {
    final debtorsBox = Hive.box("debtorsBox");
    final itemsBox = Hive.box("itemsBox");

    // Store items to potentially roll back if needed
    Map<dynamic, dynamic> itemsToDelete = {};
    itemsBox.toMap().forEach((key, value) {
      if (value[0] == debtorsBox.getAt(index)[0]) {
        // Assuming 0 index is debtor's name
        itemsToDelete[key] = value;
      }
    });
    print(itemsToDelete);

    // Attempt to delete items
    bool itemsDeleted = false;
    try {
      itemsToDelete.keys.forEach((key) {
        itemsBox.delete(key);
      });
      itemsDeleted = true;
    } catch (e) {
      print("Failed to delete items: $e");
    }

    // If items successfully deleted, attempt to delete debtor
    if (itemsDeleted) {
      try {
        debtorsBox.deleteAt(index);
        homeStateKey.currentState
            ?.updateUI(); // Update UI after successful deletion
      } catch (e) {
        print("Failed to delete debtor, rolling back items deletion: $e");
        // Rollback items deletion
        itemsToDelete.forEach((key, value) {
          itemsBox.put(key, value);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: () {
        _showContextMenu(context, TapDownDetails(globalPosition: _tapPosition));
      },
      onTapDown: (TapDownDetails details) {
        setState(() {
          _tapPosition = details.globalPosition;
        });
      },
      child: ListTile(
        leading: Container(
          width: 70,
          height: 90,
          decoration: BoxDecoration(
            color: Color(0xffF1EBE2),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Image.asset(widget.imagepath!),
        ),
        title: AutoSizeText(
          widget.titile!,
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          maxLines: 1,
          minFontSize: 10,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text("0612544158"),
        trailing: Column(
          children: [
            Text(
              "\$${widget.Total_dollor}",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              "${widget.Total_shiling_somali} k",
              style: TextStyle(fontSize: 15.0),
            ),
          ],
        ),
      ),
    );
  }
}
