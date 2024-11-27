import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final calculadora = GlobalKey<FormState>();
  final montoCtrl = TextEditingController();
  final plazoCtrl = TextEditingController();
  final interesCtrl = TextEditingController();

  List<Map<String, dynamic>> tablaM = [];
  var cuotaMensual = 0.0;
  var totalInteres = 0.0;

  void calcular() {
    var monto = double.parse(montoCtrl.text);
    var plazo = double.parse(plazoCtrl.text);
    var tazaAnual = double.parse(interesCtrl.text);
    var tazaMensual = tazaAnual / 12 / 100;
    var cuota = monto *
        (tazaMensual * pow((1 + tazaMensual), plazo)) /
        (pow((1 + tazaMensual), plazo) - 1);
    tablaM.clear();
    var balance = monto;
    var interesTotal = 0.0;

    for (var i = 0; i <= plazo; i++) {
      var interesMensual = balance * tazaMensual;
      var capital = cuota - interesMensual;
      balance -= capital;
      totalInteres += interesMensual;

      tablaM.add({
        'numero': i,
        'cuota': cuota,
        'capital': capital,
        'interes': interesMensual,
        'balance': balance > 0 ? balance : 0,
      });
    }
    setState(() {
      cuotaMensual = cuota;
      interesTotal = totalInteres;
      print(tablaM);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Calculadora de Prestamos'),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: 400,
                    height: 300,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Form(
                              key: calculadora,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: montoCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Monto',
                                      hintText: 'Monto',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Campo requerido';
                                      }
                                      return null;
                                    },
                                    // onSaved: (value) {
                                    //   monto = int.parse(
                                    //       value!); //double.tryParse(value!)!;
                                    // }
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  TextFormField(
                                    controller: plazoCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Cuotas',
                                      hintText: 'Cuotas',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Campo requerido';
                                      }
                                      return null;
                                    },
                                    // onSaved: (value) {
                                    //   cuotas = int.parse(
                                    //       value!); //double.tryParse(value!)!;
                                    // }
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  TextFormField(
                                    controller: interesCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Interés anual',
                                      hintText: 'Interés anual',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Campo requerido';
                                      }
                                      return null;
                                    },
                                    // onSaved: (value) {
                                    //   interesAnual = int.parse(
                                    //       value!); //double.tryParse(value!)!;
                                    // }
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (calculadora.currentState!
                                          .validate()) {
                                        calculadora.currentState!.save();
                                        calcular();
                                      }
                                    },
                                    child: const Text('Calcular'),
                                  )
                                ],
                              ))
                        ]),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                      padding: const EdgeInsets.all(16),
                      // width: 400,
                      // height: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Datos generales'),
                          Wrap(
                            children: [
                              const Text('Cuotas Mensuales :'),
                              const SizedBox(width: 16),
                              Text(
                                cuotaMensual.toStringAsFixed(2),
                              ),
                              const SizedBox(width: 16),
                              const Text('Total Intereses :'),
                              const SizedBox(width: 16),
                              Text(
                                totalInteres.toStringAsFixed(2),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text('Tabla de amortizacion'),
                          const SizedBox(
                            height: 20,
                          ),
                          DataTable(
                            columns: const [
                              DataColumn(
                                label: Text('No.'),
                                numeric: true,
                              ),
                              DataColumn(
                                label: Text('Cuota'),
                                numeric: true,
                              ),
                              DataColumn(
                                label: Text('Capital'),
                                numeric: true,
                              ),
                              DataColumn(
                                label: Text("Interés"),
                                numeric: true,
                              ),
                              DataColumn(
                                label: Text("Balance"),
                                numeric: true,
                              ),
                            ],
                            rows: tablaM.map((row) {
                              return DataRow(cells: [
                                DataCell(Text(row['numero'].toString())),
                                DataCell(Text(
                                    '\$${row['cuota'].toStringAsFixed(2)}')),
                                DataCell(Text(
                                    '\$${row['capital'].toStringAsFixed(2)}')),
                                DataCell(Text(
                                    '\$${row['interes'].toStringAsFixed(2)}')),
                                DataCell(Text(
                                    '\$${row['balance'].toStringAsFixed(2)}')),
                              ]);
                            }).toList(),
                          )
                        ],
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
