import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/appDrawer.dart';

class CetakLaporan extends StatefulWidget {
  const CetakLaporan({super.key});

  @override
  State<CetakLaporan> createState() => _CetakLaporanState();
}

class _CetakLaporanState extends State<CetakLaporan> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _tanggalMulaiController = TextEditingController();
  final TextEditingController _tanggalAkhirController = TextEditingController();

  String _jenisLaporan = 'Semua';
  final List<String> _jenisLaporanList = ['Semua', 'Pemasukan', 'Pengeluaran'];

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E7D32),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  void _resetForm() {
    setState(() {
      _tanggalMulaiController.clear();
      _tanggalAkhirController.clear();
      _jenisLaporan = 'Semua';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      backgroundColor: const Color(0xFFF4F6F8),

      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: 120,
              left: 24,
              right: 24,
              bottom: 24,
            ),
            child: Center(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 850),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cetak Laporan Keuangan',
                          style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ================== FORM TANGGAL ==================
                        Row(
                          children: [
                            Expanded(
                              child: _buildDateField(
                                label: "Tanggal Mulai",
                                controller: _tanggalMulaiController,
                              ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: _buildDateField(
                                label: "Tanggal Akhir",
                                controller: _tanggalAkhirController,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ================== DROPDOWN JENIS ==================
                        const Text(
                          "Jenis Laporan",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),

                        DropdownButtonFormField<String>(
                          value: _jenisLaporan,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF1F8E9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          items: _jenisLaporanList.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (value) =>
                              setState(() => _jenisLaporan = value!),
                        ),

                        const SizedBox(height: 28),

                        // ================== BUTTONS ==================
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: const Icon(
                                Icons.picture_as_pdf,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Download PDF',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            OutlinedButton(
                              onPressed: _resetForm,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                side: const BorderSide(
                                  color: Color(0xFF2E7D32),
                                  width: 1.4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Reset',
                                style: TextStyle(
                                  color: Color(0xFF2E7D32),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // MENU BUTTON
          Positioned(
            top: 25,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.menu, size: 28, color: Colors.black87),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================================
  // CUSTOM DATE FIELD
  // ======================================================================
  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF1F8E9),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.calendar_today_outlined,
                color: Color(0xFF2E7D32),
              ),
              onPressed: () => _selectDate(context, controller),
            ),
            hintText: 'DD/MM/YYYY',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}
