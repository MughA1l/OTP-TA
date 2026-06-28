import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../data/models/operation_model.dart';
import '../../data/models/analytics_model.dart';

class PdfGenerator {
  /// Generates and triggers print/save preview for an Operation Summary PDF.
  static Future<void> generateOperationSummaryPdf(OperationModel op) async {
    final pdf = pw.Document();

    final dateStr = DateFormat('MMMM dd, yyyy').format(op.scheduledDate);
    final team = op.surgicalTeam;
    final outcome = op.outcome;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header Banner
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: const pw.BoxDecoration(
                    color: PdfColor.fromInt(0xFF1E3A8A), // Navy Blue
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'OT OPERATION SUMMARY',
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        'ID: ${op.operationId}',
                        style: pw.TextStyle(color: PdfColors.white, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 24),

                // General Info Table
                pw.Text('General Details', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.Divider(thickness: 1),
                pw.SizedBox(height: 8),

                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  children: [
                    _buildRow('Patient Name', op.patientName),
                    _buildRow('Surgery Type', op.surgeryType),
                    _buildRow('OT Room', op.otRoom),
                    _buildRow('Scheduled Date', dateStr),
                    _buildRow('Scheduled Time', op.scheduledTime),
                    _buildRow('Status', op.status.name.toUpperCase()),
                  ],
                ),
                pw.SizedBox(height: 24),

                // Surgical Team Info
                pw.Text('Assigned Surgical Team', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.Divider(thickness: 1),
                pw.SizedBox(height: 8),
                
                pw.Bullet(text: 'Primary Doctor ID: ${team.primaryDoctorId}'),
                pw.Bullet(text: 'Anaesthesiologist ID: ${team.anaesthesiologistId}'),
                if (team.nursingStaff.isNotEmpty)
                  pw.Bullet(text: 'Nursing Staff: ${team.nursingStaff.join(", ")}'),

                pw.SizedBox(height: 24),

                // Outcome & Notes
                pw.Text('Operation Outcome Details', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.Divider(thickness: 1),
                pw.SizedBox(height: 8),

                if (outcome != null) ...[
                  pw.Text('Patient Condition: ${outcome.patientCondition}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 6),
                  pw.Text('Complications: ${outcome.complications.isNotEmpty ? outcome.complications : "None"}'),
                  pw.SizedBox(height: 6),
                  pw.Text('Clinical Notes: ${outcome.notes}'),
                  pw.SizedBox(height: 6),
                  pw.Text('Submitted At: ${DateFormat('MM/dd/yyyy HH:mm').format(outcome.submittedAt)}'),
                ] else ...[
                  pw.Text('No outcome recorded yet for this operation.', style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
                ],

                pw.Spacer(),
                pw.Divider(thickness: 0.5),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    'Generated on ${DateFormat('MM/dd/yyyy HH:mm').format(DateTime.now())} | OTP-TA System',
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'operation_summary_${op.operationId}.pdf',
    );
  }

  /// Generates and triggers print/save preview for a Doctor Performance report PDF.
  static Future<void> generateDoctorPerformancePdf(DoctorPerformanceModel docPerf) async {
    final pdf = pw.Document();

    final punctuality = docPerf.punctualityRate * 100;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.Start,
              children: [
                // Header Banner
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: const pw.BoxDecoration(
                    color: PdfColor.fromInt(0xFF1E3A8A), // Navy Blue
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'DOCTOR PERFORMANCE SUMMARY',
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        'Dr. ID: ${docPerf.doctorId}',
                        style: pw.TextStyle(color: PdfColors.white, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 24),

                // Metrics Table
                pw.Text('Key Performance Indicators', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.Divider(thickness: 1),
                pw.SizedBox(height: 8),

                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  children: [
                    _buildRow('Doctor Name', 'Dr. ${docPerf.doctorName.isNotEmpty ? docPerf.doctorName : docPerf.doctorId}'),
                    _buildRow('Operations Completed', '${docPerf.operationsCompleted}'),
                    _buildRow('Punctuality Score', '${punctuality.toStringAsFixed(1)}%'),
                    _buildRow('Avg Surgery Duration', '${docPerf.avgDurationMinutes.toStringAsFixed(1)} minutes'),
                  ],
                ),
                pw.SizedBox(height: 24),

                // Informational Note
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    border: pw.Border.all(color: PdfColors.grey300),
                  ),
                  child: pw.Text(
                    'Punctuality score measures the percentage of scheduled surgeries started on-time. Average duration compiles completed surgeries in active OT rooms.',
                    style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                  ),
                ),

                pw.Spacer(),
                pw.Divider(thickness: 0.5),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    'Generated on ${DateFormat('MM/dd/yyyy HH:mm').format(DateTime.now())} | OTP-TA System',
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'doctor_performance_${docPerf.doctorId}.pdf',
    );
  }

  /// Generates a PDF summary for Operations Analytics.
  static Future<void> generateAnalyticsSummaryPdf(AnalyticsCacheModel cache) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF1E3A8A)),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'OT PERFORMANCE ANALYTICS REPORT',
                        style: pw.TextStyle(color: PdfColors.white, fontSize: 16, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text('LIVE REPORT', style: pw.TextStyle(color: PdfColors.white, fontSize: 10)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 24),

                pw.Text('Key Performance Indicators', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.Divider(thickness: 1),
                pw.SizedBox(height: 8),

                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  children: [
                    _buildRow('Total Operations Executed', '${cache.totalOperations}'),
                    _buildRow('Clinical Success Rate', '${cache.successRate.toStringAsFixed(1)}%'),
                    _buildRow('Avg Surgical Duration', '${cache.avgDurationMinutes.toStringAsFixed(1)} minutes'),
                  ],
                ),
                pw.SizedBox(height: 24),

                pw.Text('Surgery Type Distribution', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.Divider(thickness: 1),
                pw.SizedBox(height: 8),

                for (var entry in cache.operationsBySurgeryType.entries)
                  pw.Bullet(text: '${entry.key}: ${entry.value} surgeries'),

                pw.Spacer(),
                pw.Divider(thickness: 0.5),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    'Generated on ${DateFormat('MM/dd/yyyy HH:mm').format(DateTime.now())} | OTP-TA System',
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'operations_performance_report.pdf',
    );
  }

  /// Generates a PDF summary for Patient Recovery Analytics.
  static Future<void> generateRecoverySummaryPdf(Map<String, dynamic> stats) async {
    final pdf = pw.Document();

    final total = stats['totalWithOutcome'] ?? 0;
    final rate = stats['readmissionRate'] ?? 0.0;
    final dist = stats['distribution'] as Map<String, dynamic>? ?? {};

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF1E3A8A)),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'PATIENT RECOVERY ANALYTICS',
                        style: pw.TextStyle(color: PdfColors.white, fontSize: 16, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text('RECOVERY REPORT', style: pw.TextStyle(color: PdfColors.white, fontSize: 10)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 24),

                pw.Text('Outcomes Summary', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.Divider(thickness: 1),
                pw.SizedBox(height: 8),

                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  children: [
                    _buildRow('Tracked Patients Outpatient', '$total'),
                    _buildRow('Readmission Rate', '${rate.toStringAsFixed(1)}%'),
                  ],
                ),
                pw.SizedBox(height: 24),

                pw.Text('Recovery Room Duration Distribution', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                pw.Divider(thickness: 1),
                pw.SizedBox(height: 8),

                for (var cat in ['< 2h', '2-4h', '4-8h', '> 8h'])
                  pw.Bullet(text: '$cat: ${dist[cat] ?? 0} patients'),

                pw.Spacer(),
                pw.Divider(thickness: 0.5),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    'Generated on ${DateFormat('MM/dd/yyyy HH:mm').format(DateTime.now())} | OTP-TA System',
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'patient_recovery_report.pdf',
    );
  }

  static pw.TableRow _buildRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(value),
        ),
      ],
    );
  }
}
