import 'package:ceeb_mobile/models/category.dart';
import 'package:ceeb_mobile/models/invoice.dart';

class InvoiceDTO {
  final List<Category> categories;
  Invoice? invoice;

  InvoiceDTO(this.categories);
}
