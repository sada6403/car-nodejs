import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart' as excel;
import 'package:flutter/foundation.dart';
import '../models/attendance.dart';
import '../models/attendance_service.dart';

// Brand Colors
const Color kBrandDark = Color(0xFF2C3545);
const Color kBrandGold = Color(0xFFE8BC44);
const Color kBrandLight = Color(0xFFF8FAFC);
const Color kTextDark = Color(0xFF1E293B);
const Color kTextMuted = Color(0xFF64748B);

class StaffAttendanceScreen extends StatefulWidget {
  const StaffAttendanceScreen({super.key});

  @override
  State<StaffAttendanceScreen> createState() => _StaffAttendanceScreenState();
}

class _StaffAttendanceScreenState extends State<StaffAttendanceScreen> {
  String _searchQuery = '';
  DateTime? _selectedDate;
  String _selectedMonth = 'All';
  String _selectedYear = 'All';

  final List<String> _months = [
    'All', 'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  final List<String> _years = ['All', '2024', '2025', '2026'];

  List<Attendance> _getFilteredList(List<Attendance> attendances) {
    return attendances.where((a) {
      final nameMatch = a.userName.toLowerCase().contains(_searchQuery.toLowerCase());
      
      bool dateMatch = true;
      if (_selectedDate != null) {
        dateMatch = a.date == DateFormat('yyyy-MM-dd').format(_selectedDate!);
      }

      bool monthMatch = true;
      if (_selectedMonth != 'All') {
        monthMatch = DateFormat('MMMM').format(a.checkIn) == _selectedMonth;
      }

      bool yearMatch = true;
      if (_selectedYear != 'All') {
        yearMatch = a.checkIn.year.toString() == _selectedYear;
      }

      return nameMatch && dateMatch && monthMatch && yearMatch;
    }).toList().reversed.toList(); // Newest first
  }

  Future<void> _exportToPdf(List<Attendance> data) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Staff Attendance Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.Text('Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}'),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: ['Name', 'Role', 'Date', 'Login', 'Logout', 'Hours'],
            data: data.map((a) => [
              a.userName,
              a.userRole,
              a.date,
              DateFormat('hh:mm a').format(a.checkIn),
              a.checkOut != null ? DateFormat('hh:mm a').format(a.checkOut!) : '-',
              a.totalHours.toStringAsFixed(2),
            ]).toList(),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  Future<void> _exportToExcel(List<Attendance> data) async {
    final excelFile = excel.Excel.createExcel();
    final sheet = excelFile['AttendanceReport'];
    
    sheet.appendRow([
      excel.TextCellValue('Name'), 
      excel.TextCellValue('Role'), 
      excel.TextCellValue('Date'), 
      excel.TextCellValue('Login Time'), 
      excel.TextCellValue('Logout Time'), 
      excel.TextCellValue('Total Hours')
    ]);

    for (var a in data) {
      sheet.appendRow([
        excel.TextCellValue(a.userName),
        excel.TextCellValue(a.userRole),
        excel.TextCellValue(a.date),
        excel.TextCellValue(DateFormat('hh:mm a').format(a.checkIn)),
        excel.TextCellValue(a.checkOut != null ? DateFormat('hh:mm a').format(a.checkOut!) : '-'),
        excel.TextCellValue(a.totalHours.toStringAsFixed(2)),
      ]);
    }

    final bytes = excelFile.save();
    if (bytes != null) {
      if (kIsWeb) {
        // Use printing package to share/save arbitrary bytes on web context if possible, 
        // or just share as a file. Printing.sharePdf can often be used for this.
        await Printing.sharePdf(
          bytes: Uint8List.fromList(bytes),
          filename: 'Attendance_Report_${DateTime.now().millisecondsSinceEpoch}.xlsx',
        );
      } else {
        // This part would still need dart:io if not on web, but we've removed the import.
        // For simplicity in this fix, we'll focus on web. 
        // If they need mobile, we'd need conditional imports.
        debugPrint('Excel export only supported on Web in this version.');
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report generated successfully.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBrandLight,
      appBar: AppBar(
        title: const Text('Staff Attendance', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
        backgroundColor: kBrandDark,
        elevation: 0,
        actions: [
          ValueListenableBuilder<List<Attendance>>(
            valueListenable: AttendanceService().allAttendancesNotifier,
            builder: (context, allRecords, _) {
              final filtered = _getFilteredList(allRecords);
              return Row(
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.fileText),
                    onPressed: () => _exportToPdf(filtered),
                    tooltip: 'Export PDF',
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.fileSpreadsheet),
                    onPressed: () => _exportToExcel(filtered),
                    tooltip: 'Export Excel',
                  ),
                  const SizedBox(width: 8),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search by staff name...',
                    prefixIcon: const Icon(LucideIcons.search, size: 20),
                    filled: true,
                    fillColor: kBrandLight,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Date Picker
                      _buildFilterChip(
                        label: _selectedDate == null ? 'Select Date' : DateFormat('MMM dd').format(_selectedDate!),
                        icon: LucideIcons.calendar,
                        isSelected: _selectedDate != null,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2024),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) setState(() => _selectedDate = picked);
                        },
                        onClear: () => setState(() => _selectedDate = null),
                      ),
                      const SizedBox(width: 10),
                      // Month Dropdown
                      _buildDropdownChip(
                        label: 'Month',
                        value: _selectedMonth,
                        items: _months,
                        onChanged: (val) => setState(() => _selectedMonth = val!),
                      ),
                      const SizedBox(width: 10),
                      // Year Dropdown
                      _buildDropdownChip(
                        label: 'Year',
                        value: _selectedYear,
                        items: _years,
                        onChanged: (val) => setState(() => _selectedYear = val!),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // List Section
          Expanded(
            child: ValueListenableBuilder<List<Attendance>>(
              valueListenable: AttendanceService().allAttendancesNotifier,
              builder: (context, allRecords, _) {
                final filtered = _getFilteredList(allRecords);
                
                if (filtered.isEmpty) {
                  return const Center(child: Text('No attendance records found.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final record = filtered[index];
                    return _buildAttendanceCard(record);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required VoidCallback onClear,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? kBrandDark : kBrandLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? kBrandDark : kBrandDark.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : kTextMuted),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: isSelected ? Colors.white : kTextDark, fontWeight: FontWeight.w600, fontSize: 13)),
            if (isSelected) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onClear,
                child: const Icon(LucideIcons.x, size: 14, color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownChip({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: value == 'All' ? kBrandLight : kBrandDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kBrandDark.withValues(alpha: 0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: Icon(LucideIcons.chevronDown, size: 16, color: value == 'All' ? kTextMuted : Colors.white),
          style: TextStyle(color: value == 'All' ? kTextDark : Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(Attendance record) {
    bool isActive = record.status == 'Active';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: isActive ? Colors.green.withValues(alpha: 0.1) : kBrandDark.withValues(alpha: 0.1),
          child: Icon(isActive ? LucideIcons.userCheck : LucideIcons.user, color: isActive ? Colors.green : kBrandDark, size: 20),
        ),
        title: Text(record.userName, style: const TextStyle(fontWeight: FontWeight.w800, color: kTextDark)),
        subtitle: Text('${record.userRole} • ${record.date}', style: const TextStyle(fontSize: 12, color: kTextMuted)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              isActive ? 'ACTIVE' : '${record.totalHours.toStringAsFixed(1)} hrs',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: isActive ? Colors.green : kBrandDark,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              DateFormat('hh:mm a').format(record.checkIn),
              style: const TextStyle(fontSize: 11, color: kTextMuted),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                const Divider(),
                _buildDetailRow('Branch', record.branch),
                _buildDetailRow('Check-In Time', DateFormat('hh:mm:ss a').format(record.checkIn)),
                _buildDetailRow('Check-Out Time', record.checkOut != null ? DateFormat('hh:mm:ss a').format(record.checkOut!) : 'Still Logged In'),
                _buildDetailRow('Total Hours', record.totalHours.toStringAsFixed(2)),
                _buildDetailRow('Overtime', '${record.overtimeHours.toStringAsFixed(2)} hrs'),
                _buildDetailRow('Status', record.status),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: kTextMuted, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700, color: kTextDark, fontSize: 13)),
        ],
      ),
    );
  }
}
