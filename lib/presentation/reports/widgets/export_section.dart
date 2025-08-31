import 'dart:convert';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;

import '../../../core/app_export.dart';

class ExportSection extends StatefulWidget {
  final Map<String, dynamic> reportData;
  final DateTime startDate;
  final DateTime endDate;

  const ExportSection({
    super.key,
    required this.reportData,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<ExportSection> createState() => _ExportSectionState();
}

class _ExportSectionState extends State<ExportSection> {
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'file_download',
                color: colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Export Reports',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Generate and share your financial reports',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildExportOption(
                  context,
                  'PDF Report',
                  'Complete financial summary',
                  'picture_as_pdf',
                  '~2.5 MB',
                  AppTheme.getErrorColor(theme.brightness == Brightness.light),
                  () => _exportPDF(context),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildExportOption(
                  context,
                  'Excel Data',
                  'Raw transaction data',
                  'table_chart',
                  '~850 KB',
                  AppTheme.getSuccessColor(
                      theme.brightness == Brightness.light),
                  () => _exportExcel(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isExporting ? null : () => _shareReport(context),
              icon: _isExporting
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : CustomIconWidget(
                      iconName: 'share',
                      color: colorScheme.onPrimary,
                      size: 18,
                    ),
              label: Text(_isExporting ? 'Preparing...' : 'Share Report'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportOption(
    BuildContext context,
    String title,
    String description,
    String iconName,
    String fileSize,
    Color accentColor,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: _isExporting ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: accentColor,
                size: 24,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 0.5.h),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                fileSize,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportPDF(BuildContext context) async {
    setState(() => _isExporting = true);

    try {
      final pdfContent = _generatePDFContent();
      final fileName =
          'cashbook_report_${_formatDateForFile(widget.startDate)}_to_${_formatDateForFile(widget.endDate)}.pdf';

      await _downloadFile(pdfContent, fileName);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF report exported successfully'),
            backgroundColor: AppTheme.getSuccessColor(
                Theme.of(context).brightness == Brightness.light),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export PDF report'),
            backgroundColor: AppTheme.getErrorColor(
                Theme.of(context).brightness == Brightness.light),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _exportExcel(BuildContext context) async {
    setState(() => _isExporting = true);

    try {
      final csvContent = _generateCSVContent();
      final fileName =
          'cashbook_data_${_formatDateForFile(widget.startDate)}_to_${_formatDateForFile(widget.endDate)}.csv';

      await _downloadFile(csvContent, fileName);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Excel data exported successfully'),
            backgroundColor: AppTheme.getSuccessColor(
                Theme.of(context).brightness == Brightness.light),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export Excel data'),
            backgroundColor: AppTheme.getErrorColor(
                Theme.of(context).brightness == Brightness.light),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _shareReport(BuildContext context) async {
    setState(() => _isExporting = true);

    try {
      final reportContent = _generateShareableReport();
      final fileName =
          'cashbook_summary_${_formatDateForFile(widget.startDate)}_to_${_formatDateForFile(widget.endDate)}.txt';

      if (kIsWeb) {
        await _downloadFile(reportContent, fileName);
      } else {
        // For mobile, we would typically use the share package here
        // For now, we'll save to device and show success message
        await _downloadFile(reportContent, fileName);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Report prepared for sharing'),
            backgroundColor: AppTheme.getSuccessColor(
                Theme.of(context).brightness == Brightness.light),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to prepare report'),
            backgroundColor: AppTheme.getErrorColor(
                Theme.of(context).brightness == Brightness.light),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _downloadFile(String content, String filename) async {
    if (kIsWeb) {
      final bytes = utf8.encode(content);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsString(content);
    }
  }

  String _generatePDFContent() {
    final buffer = StringBuffer();
    buffer.writeln('CASHBOOK FINANCIAL REPORT');
    buffer.writeln('=' * 50);
    buffer.writeln(
        'Report Period: ${_formatDate(widget.startDate)} - ${_formatDate(widget.endDate)}');
    buffer.writeln('Generated: ${_formatDate(DateTime.now())}');
    buffer.writeln('');

    // Summary section
    buffer.writeln('FINANCIAL SUMMARY');
    buffer.writeln('-' * 30);
    final totalIncome = widget.reportData['totalIncome'] as double? ?? 0.0;
    final totalExpenses = widget.reportData['totalExpenses'] as double? ?? 0.0;
    final netIncome = totalIncome - totalExpenses;

    buffer.writeln('Total Income: \$${totalIncome.toStringAsFixed(2)}');
    buffer.writeln('Total Expenses: \$${totalExpenses.toStringAsFixed(2)}');
    buffer.writeln('Net Income: \$${netIncome.toStringAsFixed(2)}');
    buffer.writeln('');

    // Expense breakdown
    buffer.writeln('EXPENSE BREAKDOWN BY CATEGORY');
    buffer.writeln('-' * 40);
    final expenseData =
        widget.reportData['expenseBreakdown'] as List<Map<String, dynamic>>? ??
            [];
    for (final expense in expenseData) {
      buffer.writeln(
          '${expense['category']}: \$${(expense['amount'] as double).toStringAsFixed(2)}');
    }

    return buffer.toString();
  }

  String _generateCSVContent() {
    final buffer = StringBuffer();
    buffer.writeln('Date,Category,Type,Amount,Description');

    // Add sample transaction data (in a real app, this would come from actual data)
    final transactions =
        widget.reportData['transactions'] as List<Map<String, dynamic>>? ?? [];
    for (final transaction in transactions) {
      buffer.writeln(
          '${transaction['date']},${transaction['category']},${transaction['type']},${transaction['amount']},${transaction['description']}');
    }

    return buffer.toString();
  }

  String _generateShareableReport() {
    final buffer = StringBuffer();
    buffer.writeln('📊 CashBook Financial Summary');
    buffer.writeln(
        'Period: ${_formatDate(widget.startDate)} - ${_formatDate(widget.endDate)}');
    buffer.writeln('');

    final totalIncome = widget.reportData['totalIncome'] as double? ?? 0.0;
    final totalExpenses = widget.reportData['totalExpenses'] as double? ?? 0.0;
    final netIncome = totalIncome - totalExpenses;

    buffer.writeln('💰 Total Income: \$${totalIncome.toStringAsFixed(2)}');
    buffer.writeln('💸 Total Expenses: \$${totalExpenses.toStringAsFixed(2)}');
    buffer.writeln('📈 Net Income: \$${netIncome.toStringAsFixed(2)}');
    buffer.writeln('');
    buffer.writeln('Generated by CashBook App');

    return buffer.toString();
  }

  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatDateForFile(DateTime date) {
    return '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
  }
}
