import 'package:ceeb_mobile/components/dialog.dart';
import 'package:ceeb_mobile/models/book.dart';
import 'package:ceeb_mobile/models/lending.dart';
import 'package:ceeb_mobile/providers/book_provider.dart';
import 'package:ceeb_mobile/providers/lending_provider.dart';
import 'package:ceeb_mobile/providers/reader_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LendingFormPage extends StatefulWidget {
  const LendingFormPage({super.key});

  @override
  State<LendingFormPage> createState() => _LendingFormPageState();
}

class _LendingFormPageState extends State<LendingFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String readerId = '';
  String readerName = '';
  String bookId = '';
  String bookName = '';
  String bookCode = '';

  TextEditingController dateController = TextEditingController();
  TextEditingController filterReader = TextEditingController();

  Future? getListBooks;
  Future? getListReaders;
  final filterBookController = TextEditingController();
  final filterReaderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController.text = '';
  }

  @override
  void dispose() {
    super.dispose();
    dateController.dispose();
    filterBookController.dispose();
    filterReaderController.dispose();
  }

  Future<void> _loadBooksFilter(BuildContext context) =>
      Provider.of<BookProvider>(context, listen: false)
          .loadBooksFilter(filterBookController.text);

  Future<void> _loadReadersFilter(BuildContext context) =>
      Provider.of<ReaderProvider>(context, listen: false)
          .loadReadersFilter(filterReaderController.text);

  Future<void> _submitForm(BuildContext context) async {
    _formKey.currentState?.save();
    setState(() => _isLoading = true);

    if (readerId == '' || bookId == '' || dateController.text == '') {
      await Dialogs.showMyDialog(
          context, 'Atenção!', 'Preencha todas as informações!');
      setState(() => _isLoading = false);
      return;
    }

    try {
      final dateBorrow = DateFormat('dd/MM/yyyy').parse(dateController.text);

      final lending = Lending();
      lending.date = DateFormat('dd/MM/yyyy').parse(dateController.text);
      lending.expectedDate = dateBorrow.add(const Duration(days: 30));
      lending.readerId = readerId;
      lending.readerName = readerName;
      lending.bookId = bookId;
      lending.bookName = bookName;
      lending.bookCode = bookCode;
      lending.returned = false;
      lending.sync = false;

      await Provider.of<LendingProvider>(context, listen: false)
          .borrow(lending);
      await Dialogs.showMyDialog(context, 'SUCESSO',
          'Data de Entrega: ${DateFormat('dd/MM/yyyy').format(lending.expectedDate ?? DateTime.now())}');
      Navigator.of(context).pop();
    } catch (e) {
      await Dialogs.showMyDialog(
          context, 'Ocorreu um erro!', 'Não foi possível salvar o empréstimo');
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
          "Empréstimo",
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
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(
                              bookName.isEmpty
                                  ? '''Pesquise o livro no botão ao lado'''
                                  : '$bookName - $bookCode',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: () => showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Livros"),
                                  content: SizedBox(
                                    width: deviceSize.width - 100,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: deviceSize.width / 2,
                                          child: TextField(
                                            controller: filterBookController,
                                            decoration: const InputDecoration(
                                                labelText: 'Pesquisar'),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        ElevatedButton.icon(
                                          onPressed: () => setState(() {
                                            getListBooks =
                                                _loadBooksFilter(context);
                                          }),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 10,
                                            ),
                                          ),
                                          icon: const Icon(Icons.search),
                                          label: const Text('Pesquisar'),
                                        ),
                                        Expanded(
                                          child: FutureBuilder(
                                            future: getListBooks,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              } else if (snapshot.error !=
                                                  null) {
                                                return const Center(
                                                    child: Text(
                                                        'Ocorreu um erro!'));
                                              } else {
                                                return Consumer<BookProvider>(
                                                  builder:
                                                      ((ctx, values, child) =>
                                                          ListView.builder(
                                                            itemCount:
                                                                values.count,
                                                            itemBuilder:
                                                                ((ctx, index) =>
                                                                    Column(
                                                                      children: [
                                                                        ListTile(
                                                                          title: Text(values
                                                                              .books[index]
                                                                              .name!),
                                                                          subtitle:
                                                                              Text('${values.books[index].code!} - ${values.books[index].edition}'),
                                                                          trailing: values.books[index].borrow == false
                                                                              ? IconButton(
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      bookId = values.books[index].id!;
                                                                                      bookName = values.books[index].name!;
                                                                                      bookCode = values.books[index].code!;
                                                                                    });
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  icon: const Icon(
                                                                                    Icons.check_circle_outline,
                                                                                    color: Colors.green,
                                                                                    size: 40,
                                                                                  ),
                                                                                )
                                                                              : const Icon(
                                                                                  Icons.error_outline,
                                                                                  color: Colors.red,
                                                                                  size: 40,
                                                                                ),
                                                                        ),
                                                                        const Divider(),
                                                                      ],
                                                                    )),
                                                          )),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                            ),
                            icon: const Icon(Icons.search),
                            label: const Text('Pesquisar'),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(
                              readerName.isEmpty
                                  ? '''Pesquise o leitor no botão ao lado'''
                                  : readerName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: () => showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Leitor"),
                                  content: SizedBox(
                                    width: deviceSize.width - 100,
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: filterReaderController,
                                          decoration: const InputDecoration(
                                              labelText: 'Pesquisar'),
                                        ),
                                        const SizedBox(height: 10),
                                        ElevatedButton.icon(
                                          onPressed: () => setState(() {
                                            getListReaders =
                                                _loadReadersFilter(context);
                                          }),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 10,
                                            ),
                                          ),
                                          icon: const Icon(Icons.search),
                                          label: const Text('Pesquisar'),
                                        ),
                                        Expanded(
                                          child: FutureBuilder(
                                            future: getListReaders,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              } else if (snapshot.error !=
                                                  null) {
                                                return const Center(
                                                    child: Text(
                                                        'Ocorreu um erro!'));
                                              } else {
                                                return Consumer<ReaderProvider>(
                                                  builder:
                                                      ((ctx, values, child) =>
                                                          ListView.builder(
                                                            itemCount:
                                                                values.count,
                                                            itemBuilder:
                                                                ((ctx, index) =>
                                                                    Column(
                                                                      children: [
                                                                        ListTile(
                                                                          title: Text(values
                                                                              .readers[index]
                                                                              .name!),
                                                                          trailing: values.readers[index].openLoan == false
                                                                              ? IconButton(
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      readerId = values.readers[index].id!;
                                                                                      readerName = values.readers[index].name!;
                                                                                    });
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  icon: const Icon(
                                                                                    Icons.check_circle_outline,
                                                                                    color: Colors.green,
                                                                                    size: 40,
                                                                                  ),
                                                                                )
                                                                              : const Icon(
                                                                                  Icons.error_outline,
                                                                                  color: Colors.red,
                                                                                  size: 40,
                                                                                ),
                                                                        ),
                                                                        const Divider(),
                                                                      ],
                                                                    )),
                                                          )),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                            ),
                            label: const Text('Pesquisar'),
                            icon: const Icon(Icons.search),
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: Align(
                          child: SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () => _submitForm(context),
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
