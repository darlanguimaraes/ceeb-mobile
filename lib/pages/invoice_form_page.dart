import 'package:ceeb_mobile/dto/invoice_dto.dart';
import 'package:ceeb_mobile/models/category.dart';
import 'package:ceeb_mobile/models/invoice.dart';
import 'package:ceeb_mobile/providers/category_provider.dart';
import 'package:ceeb_mobile/providers/invoice_provider.dart';
import 'package:ceeb_mobile/utils/enum_payment_type.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InvoiceFormPage extends StatefulWidget {
  const InvoiceFormPage({super.key});

  @override
  State<InvoiceFormPage> createState() => _InvoiceFormPageState();
}

class _InvoiceFormPageState extends State<InvoiceFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};
  bool _isLoading = false;
  List<Category> _categories = [];

  TextEditingController dateController = TextEditingController();

  bool _isCredit = true;

  @override
  void initState() {
    super.initState();
    dateController.text = '';
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    final dto = ModalRoute.of(context)?.settings.arguments as InvoiceDTO;
    _categories = dto.categories;

    if (dto.invoice != null) {
      final invoice = dto.invoice!;
      _formData['id'] = invoice.id.toString();
      _isCredit = invoice.credit!;
      _formData['category'] = invoice.category;
      _formData['categoryId'] = invoice.categoryId;
      _formData['quantity'] = invoice.quantity.toString();
      _formData['value'] = invoice.value.toString();
      _formData['paymentType'] = invoice.paymentType;
      dateController.text = DateFormat('dd/MM/yyyy').format(invoice.date!);
      if (invoice.remoteId != null) {
        _formData['remoteId'] = invoice.remoteId!;
      }
    }
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    _formKey.currentState?.save();
    setState(() => _isLoading = true);

    try {
      final invoice = Invoice();
      invoice.id = _formData['id']?.toString();
      invoice.credit = _isCredit;
      invoice.category = _formData['category'];
      invoice.categoryId = _formData['category']?.id;
      invoice.quantity = double.tryParse(_formData['quantity'].toString()) ?? 0;
      invoice.value = double.tryParse(_formData['value'].toString()) ?? 0;
      invoice.date = DateFormat('dd/MM/yyyy').parse(dateController.text);
      invoice.paymentType = _formData['paymentType'].toString();
      invoice.sync = false;
      if (_formData['remoteId'] != null) {
        invoice.remoteId = _formData['remoteId'].toString();
      }

      await Provider.of<InvoiceProvider>(context, listen: false)
          .persist(invoice);
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('SUCESSO!'),
          content: const Text('Conta Registrada.'),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro!'),
          content: const Text('Ocorreu um erro para salvar.'),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Conta',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                padding: const EdgeInsets.all(15),
                width: deviceSize.width > 500 ? 500 : double.infinity,
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Selecione a data',
                          icon: Icon(Icons.calendar_today),
                        ),
                        controller: dateController,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2050),
                          );
                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('dd/MM/yyyy').format(pickedDate);
                            setState(() {
                              dateController.text = formattedDate;
                            });
                          }
                        },
                      ),
                      DropdownButtonFormField<Category>(
                        hint: const Text('Categoria'),
                        isExpanded: true,
                        items: _categories.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e.name.toString()),
                          );
                        }).toList(),
                        onSaved: ((newValue) =>
                            _formData['category'] = newValue),
                        value: _formData['category'],
                        onChanged: (value) {
                          setState(() {
                            _formData['category'] = value!;
                          });
                        },
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Quantidade'),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        onSaved: (quantity) =>
                            _formData['quantity'] = quantity ?? 0,
                        initialValue: _formData['quantity'],
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Valor'),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        onSaved: (value) => _formData['value'] = value ?? 0,
                        initialValue: _formData['value'],
                      ),
                      DropdownButtonFormField<String>(
                        hint: const Text('Tipo de pagamaneto'),
                        isExpanded: true,
                        items: [
                          DropdownMenuItem(
                            value: PaymentType.Dinheiro.name,
                            child: const Text('Dinheiro'),
                          ),
                          DropdownMenuItem(
                            value: PaymentType.PIX.name,
                            child: const Text('PIX'),
                          ),
                        ],
                        onSaved: ((newValue) =>
                            _formData['paymentType'] = newValue.toString()),
                        value: _formData['paymentType']?.toString(),
                        onChanged: (value) {
                          setState(() {
                            _formData['paymentType'] = value!;
                          });
                        },
                      ),
                      Column(
                        children: [
                          RadioListTile(
                            title: Text("Entrada"),
                            value: true,
                            groupValue: _isCredit,
                            onChanged: (value) {
                              setState(() {
                                _isCredit = true;
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text("Saída"),
                            value: false,
                            groupValue: _isCredit,
                            onChanged: (value) {
                              setState(() {
                                _isCredit = false;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: Align(
                          child: SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 8,
                                ),
                              ),
                              child: const Text('Salvar'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
