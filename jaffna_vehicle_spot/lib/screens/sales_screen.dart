import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/invoice.dart';
import '../models/auth_service.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Sales Analytics',
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: ValueListenableBuilder<List<Invoice>>(
        valueListenable: InvoiceService().invoicesNotifier,
        builder: (context, allInvoices, _) {
          final authService = AuthService();
          final isStaff = authService.userPost.startsWith('Staff');
          
          // Filter invoices if the user is staff
          final invoices = isStaff 
              ? allInvoices.where((inv) => inv.salesPersonId == authService.userId).toList()
              : allInvoices;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryGrid(invoices),
                const SizedBox(height: 24),
                _buildChartSection('Sales Trend (Volume)', _buildBarChart(invoices)),
                const SizedBox(height: 24),
                _buildChartSection('Category Breakdown', _buildPieChart(invoices)),
                const SizedBox(height: 24),
                const Text(
                  'Recent Transactions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                ),
                const SizedBox(height: 16),
                _buildRecentSalesList(invoices),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryGrid(List<Invoice> invoices) {
    // Basic calculation for mock data "24.5M" style strings
    double totalRevenue = 0;
    for (var inv in invoices) {
      double val = double.tryParse(inv.amount.replaceAll('M', '').replaceAll('Rs. ', '').replaceAll(',', '')) ?? 0;
      if (inv.amount.contains('M')) val *= 1000000;
      totalRevenue += val;
    }

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildMetricCard(
          label: 'Total Revenue',
          value: 'Rs. ${(totalRevenue / 1000000).toStringAsFixed(1)}M',
          icon: LucideIcons.dollarSign,
          color: const Color(0xFF059669),
        ),
        _buildMetricCard(
          label: 'Vehicles Sold',
          value: '${invoices.length}',
          icon: LucideIcons.car,
          color: const Color(0xFF2C3545),
        ),
      ],
    );
  }

  Widget _buildMetricCard({required String label, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280), fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF111827))),
        ],
      ),
    );
  }

  Widget _buildChartSection(String title, Widget chart) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          const SizedBox(height: 24),
          SizedBox(height: 200, child: chart),
        ],
      ),
    );
  }

  Widget _buildBarChart(List<Invoice> invoices) {
    if (invoices.isEmpty) {
      return const Center(child: Text('No data available', style: TextStyle(color: Colors.grey)));
    }

    final Map<int, int> monthlyCounts = {};
    for (var inv in invoices) {
      final date = DateTime.tryParse(inv.date);
      if (date != null) {
        monthlyCounts[date.month] = (monthlyCounts[date.month] ?? 0) + 1;
      }
    }

    // Get last 6 months list
    final List<int> displayMonths = [];
    final currentMonth = DateTime.now().month;
    for (int i = 5; i >= 0; i--) {
      int m = currentMonth - i;
      if (m <= 0) m += 12;
      displayMonths.add(m);
    }

    final double maxVal = monthlyCounts.values.isEmpty 
        ? 5 
        : (monthlyCounts.values.reduce((a, b) => a > b ? a : b).toDouble() + 1);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxVal,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const monthNames = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                final monthIdx = displayMonths[value.toInt() % displayMonths.length];
                return Text(monthNames[monthIdx], style: const TextStyle(color: Color(0xFF6B7280), fontSize: 10));
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        barGroups: List.generate(displayMonths.length, (index) {
          final month = displayMonths[index];
          final count = (monthlyCounts[month] ?? 0).toDouble();
          return _generateGroup(index, count);
        }),
      ),
    );
  }

  BarChartGroupData _generateGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: const Color(0xFF2C3545),
          width: 16,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildPieChart(List<Invoice> invoices) {
    if (invoices.isEmpty) {
      return const Center(child: Text('No data available', style: TextStyle(color: Colors.grey)));
    }

    final Map<String, int> categories = {};
    for (var inv in invoices) {
      categories[inv.vehicleType] = (categories[inv.vehicleType] ?? 0) + 1;
    }

    final List<Color> colors = [
      const Color(0xFF2C3545),
      const Color(0xFF8B5CF6),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF06B6D4),
    ];

    int colorIndex = 0;
    final List<PieChartSectionData> sections = categories.entries.map((entry) {
      final color = colors[colorIndex % colors.length];
      colorIndex++;
      
      final percentage = (entry.value / invoices.length * 100).toStringAsFixed(0);
      
      return PieChartSectionData(
        color: color,
        value: entry.value.toDouble(),
        title: '${entry.key}\n$percentage%',
        radius: 60,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      );
    }).toList();

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: sections,
      ),
    );
  }

  Widget _buildRecentSalesList(List<Invoice> invoices) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: invoices.length > 5 ? 5 : invoices.length,
      itemBuilder: (context, index) {
        final inv = invoices[invoices.length - 1 - index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
                child: const Icon(LucideIcons.fileText, color: Color(0xFF2C3545)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(inv.customerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(inv.vehicleName, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Rs. ${inv.amount}', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF2C3545))),
                  Text(inv.date, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 10)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

