import 'package:ceeb_mobile/models/lending.dart';

class ReportLending {
  final int totalOpenLendings;
  final int totalLateLendings;
  final List<Lending> lateLendings;

  ReportLending(
      this.totalOpenLendings, this.totalLateLendings, this.lateLendings);
}
