import 'package:flutter/material.dart';

Widget buildTextField(TextEditingController controller, String label) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Color(0xFFC7A500).withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Color(0xFFC7A500)),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
    keyboardType: TextInputType.number,
  );
}

class UVRTable extends StatelessWidget {
  const UVRTable(
      {super.key,
      required this.listaN,
      required this.listaF,
      required this.listaUVR});

  final List<dynamic> listaN;
  final List<dynamic> listaF;
  final List<dynamic> listaUVR;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFFFD600).withOpacity(0.8),
            border: Border(bottom: BorderSide(color: Color(0xFFC7A500))),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          width: double.infinity,
          height: 48,
          child: Center(
            child: Text(
              'TABLA DE VALORES UVR',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFC7A500).withOpacity(0.3)),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: DataTable(
              headingRowHeight: 40,
              dataRowHeight: 36,
              columnSpacing: 24,
              horizontalMargin: 12,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              columns: [
                DataColumn(
                  label: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'N°',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121),
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'FECHA',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121),
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'VALOR UVR',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121),
                      ),
                    ),
                  ),
                ),
              ],
              rows: List<DataRow>.generate(
                listaF.length,
                (index) => DataRow(
                  cells: [
                    DataCell(
                      Center(
                        child: Text(
                          listaN[index].toString(),
                          style: TextStyle(color: Color(0xFF212121)),
                        ),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: Text(
                          listaF[index],
                          style: TextStyle(color: Color(0xFF212121)),
                        ),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: Text(
                          listaUVR[index].toStringAsFixed(4),
                          style: TextStyle(
                            color: Color(0xFF212121),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
