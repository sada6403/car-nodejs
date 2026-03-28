import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../models/invoice.dart';
import '../models/auth_service.dart';
import '../utils/pdf_helper.dart';

enum FilterType { date, month, year }

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  FilterType _filterType = FilterType.date;
  String _activeQuickFilter = 'Today';
  String? _selectedCustomerName;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;

  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Color(0xFF2C3545)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sales Reports',
              style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Jaffna Vehicle Spot • ${AuthService().branch}',
              style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(child: _buildReportsList()),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      child: Column(
        children: [
          SegmentedButton<FilterType>(
            segments: const [
              ButtonSegment(value: FilterType.date, label: Text('Date'), icon: Icon(LucideIcons.calendar, size: 16)),
              ButtonSegment(value: FilterType.month, label: Text('Month'), icon: Icon(LucideIcons.calendarDays, size: 16)),
              ButtonSegment(value: FilterType.year, label: Text('Year'), icon: Icon(LucideIcons.calendarCheck, size: 16)),
            ],
            selected: {_filterType},
            onSelectionChanged: (Set<FilterType> newSelection) {
              setState(() {
                _filterType = newSelection.first;
              });
            },
            style: const ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(height: 20),
          _buildQuickFilters(),
          _buildCustomerFilter(),
          const SizedBox(height: 16),
          _buildPicker(),
        ],
      ),
    );
  }

  Widget _buildQuickFilters() {
    if (_filterType != FilterType.date) return const SizedBox();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('Today', () {
            setState(() {
              _activeQuickFilter = 'Today';
              _startDate = DateTime.now();
              _endDate = DateTime.now();
            });
          }),
          _buildFilterChip('Yesterday', () {
            setState(() {
              _activeQuickFilter = 'Yesterday';
              _startDate = DateTime.now().subtract(const Duration(days: 1));
              _endDate = DateTime.now().subtract(const Duration(days: 1));
            });
          }),
          _buildFilterChip('Last 7 Days', () {
            setState(() {
              _activeQuickFilter = 'Last 7 Days';
              _startDate = DateTime.now().subtract(const Duration(days: 6));
              _endDate = DateTime.now();
            });
          }),
          _buildFilterChip('Last 30 Days', () {
            setState(() {
              _activeQuickFilter = 'Last 30 Days';
              _startDate = DateTime.now().subtract(const Duration(days: 29));
              _endDate = DateTime.now();
            });
          }),
        ],
      ),
    );
  }

  Widget _buildCustomerFilter() {
    return ValueListenableBuilder<List<Invoice>>(
      valueListenable: InvoiceService().invoicesNotifier,
      builder: (context, invoices, child) {
        final customers = invoices.map((e) => e.customerName).toSet().toList();
        customers.sort();

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedCustomerName,
              hint: Row(
                children: [
                  const Icon(LucideIcons.user, size: 16, color: Color(0xFF64748B)),
                  const SizedBox(width: 8),
                  const Text('Filter by Customer (Optional)', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                ],
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('All Customers', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                ),
                ...customers.map((c) => DropdownMenuItem(
                  value: c,
                  child: Text(c, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                )),
              ],
              onChanged: (val) => setState(() => _selectedCustomerName = val),
              icon: const Icon(LucideIcons.chevronDown, size: 16, color: Color(0xFF64748B)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onTap) {
    bool isActive = _activeQuickFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF2C3545) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: isActive ? const Color(0xFF2C3545) : const Color(0xFFE2E8F0)),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPicker() {
    if (_filterType == FilterType.date) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIndividualDatePicker(
            label: 'From',
            date: _startDate,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _startDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                setState(() {
                  _activeQuickFilter = 'Custom';
                  _startDate = date;
                  if (_endDate.isBefore(_startDate)) _endDate = _startDate;
                });
              }
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(LucideIcons.arrowRight, size: 16, color: Colors.grey),
          ),
          _buildIndividualDatePicker(
            label: 'To',
            date: _endDate,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _endDate,
                firstDate: _startDate,
                lastDate: DateTime.now(),
              );
              if (date != null) {
                setState(() {
                  _activeQuickFilter = 'Custom';
                  _endDate = date;
                });
              }
            },
          ),
        ],
      );
    } else if (_filterType == FilterType.month) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSimpleDropdown(
            value: _selectedMonth,
            items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
            labelGenerator: (val) => _months[(val as int) - 1],
            onChanged: (val) => setState(() => _selectedMonth = val as int),
          ),
          const SizedBox(width: 12),
          _buildSimpleDropdown(
            value: _selectedYear,
            items: List.generate(5, (i) => DateTime.now().year - i),
            labelGenerator: (val) => val.toString(),
            onChanged: (val) => setState(() => _selectedYear = val as int),
          ),
        ],
      );
    } else {
      return _buildSimpleDropdown(
        value: _selectedYear,
        items: List.generate(10, (i) => DateTime.now().year - i),
        labelGenerator: (val) => val.toString(),
        onChanged: (val) => setState(() => _selectedYear = val as int),
      );
    }
  }

  Widget _buildIndividualDatePicker({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    bool isCustom = _activeQuickFilter == 'Custom';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isCustom ? const Color(0xFF2C3545).withValues(alpha: 0.05) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isCustom ? const Color(0xFF2C3545).withValues(alpha: 0.3) : Colors.transparent),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.calendar, size: 14, color: isCustom ? const Color(0xFF2C3545) : const Color(0xFF64748B)),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMM d, yyyy').format(date),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isCustom ? const Color(0xFF2C3545) : const Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleDropdown({
    required dynamic value,
    required List<dynamic> items,
    required String Function(dynamic) labelGenerator,
    required Function(dynamic) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<dynamic>(
        value: value,
        underline: const SizedBox(),
        icon: const Icon(LucideIcons.chevronDown, size: 16, color: Colors.grey),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(labelGenerator(item), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildReportsList() {
    return ValueListenableBuilder<List<Invoice>>(
      valueListenable: InvoiceService().invoicesNotifier,
      builder: (context, invoices, child) {
        final filtered = invoices.where((inv) {
          final date = DateTime.parse(inv.date);
          final cleanDate = DateTime(date.year, date.month, date.day);
          if (_filterType == FilterType.date) {
            final start = DateTime(_startDate.year, _startDate.month, _startDate.day);
            final end = DateTime(_endDate.year, _endDate.month, _endDate.day);
            bool inRange = cleanDate.isAtSameMomentAs(start) || 
                   cleanDate.isAtSameMomentAs(end) || 
                   (cleanDate.isAfter(start) && cleanDate.isBefore(end));
            if (!inRange) return false;
          } else if (_filterType == FilterType.month) {
            if (date.year != _selectedYear || date.month != _selectedMonth) return false;
          } else {
            if (date.year != _selectedYear) return false;
          }

          if (_selectedCustomerName != null && inv.customerName != _selectedCustomerName) {
            return false;
          }

          return true;
        }).toList();

        if (filtered.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.fileSearch, size: 48, color: Colors.grey.withValues(alpha: 0.5)),
                const SizedBox(height: 16),
                const Text('No sales found for the selected period.', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
              ],
            ),
          );
        }

        double total = 0;
        for (var inv in filtered) {
          total += double.tryParse(inv.amount.replaceAll(',', '')) ?? 0;
        }

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF2C3545),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF2C3545).withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 8)),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Period Sales', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text(
                          'LKR ${total.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      String title = '';
                      if (_filterType == FilterType.date) {
                        title = _startDate.day == _endDate.day && _startDate.month == _endDate.month && _startDate.year == _endDate.year
                            ? DateFormat('yyyy-MM-dd').format(_startDate)
                            : '${DateFormat('yyyy-MM-dd').format(_startDate)}_to_${DateFormat('yyyy-MM-dd').format(_endDate)}';
                      } else if (_filterType == FilterType.month) {
                        title = '${_months[_selectedMonth - 1]} $_selectedYear';
                      } else {
                        title = 'Year $_selectedYear';
                      }
                      if (_selectedCustomerName != null) {
                        title += '_${_selectedCustomerName!.replaceAll(' ', '_')}';
                      }
                      PdfHelper.downloadSalesReportPdf(filtered, title);
                    },
                    icon: const Icon(LucideIcons.download, size: 16),
                    label: const Text('Download', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8BC44),
                      foregroundColor: const Color(0xFF2C3545),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final inv = filtered[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(LucideIcons.receipt, color: Color(0xFF2C3545), size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(inv.customerName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF1E293B))),
                              Text('${inv.id} • ${inv.date}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('LKR ${inv.amount}', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                _buildSmallAction(LucideIcons.eye, () => PdfHelper.viewPdf(inv)),
                                const SizedBox(width: 8),
                                _buildSmallAction(LucideIcons.download, () => PdfHelper.downloadPdf(inv)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSmallAction(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Icon(icon, size: 16, color: const Color(0xFF64748B)),
    );
  }
}
