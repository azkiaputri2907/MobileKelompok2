import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

class KalenderPage extends StatefulWidget {
  const KalenderPage({super.key});

  @override
  State<KalenderPage> createState() => _KalenderPageState();
}

class _KalenderPageState extends State<KalenderPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Contoh data acara (Anda bisa mengganti ini dengan data dari API/database)
  final Map<DateTime, List<String>> _events = {
    DateTime.utc(2025, 6, 20): ['Rapat Dosen Jurusan', 'Bimbingan Skripsi A'],
    DateTime.utc(2025, 6, 22): ['Kuliah Umum Kewirausahaan'],
    DateTime.utc(2025, 6, 25): ['Ujian Tengah Semester', 'Rapat Koordinasi'],
    DateTime.utc(2025, 7, 5): ['Seminar Proposal B'],
  };

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null); // Inisialisasi format tanggal lokal
    _selectedDay = _focusedDay; // Set hari yang dipilih ke hari ini secara default
  }

  // Fungsi untuk mendapatkan daftar acara pada tanggal tertentu
  List<String> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Warna latar belakang yang lebih lembut
      appBar: AppBar(
        title: const Text(
          'Kalender Akademik',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF9FBADE), // Warna AppBar yang serasi
        elevation: 0, // Tanpa shadow untuk tampilan bersih
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // Warna ikon back
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kontainer untuk TableCalendar dengan desain Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5), // Pergeseran shadow
                  ),
                ],
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1), // Tanggal awal yang bisa ditampilkan
                lastDay: DateTime.utc(2030, 12, 31), // Tanggal akhir yang bisa ditampilkan
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  // Mengembalikan true jika hari ini adalah hari yang dipilih
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  // Memperbarui hari yang dipilih dan fokus
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                eventLoader: _getEventsForDay, // Menggunakan fungsi event loader
                onFormatChanged: (format) {
                  // Mengubah format kalender (bulan, minggu, 2 minggu)
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  // Memperbarui fokus ketika halaman kalender berubah
                  _focusedDay = focusedDay;
                },
                headerStyle: HeaderStyle(
                  formatButtonVisible: false, // Sembunyikan tombol format
                  titleCentered: true, // Judul di tengah
                  titleTextStyle: const TextStyle(
                    color: Color(0xFF37474F), // Warna teks judul kalender
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  leftChevronIcon: const Icon(Icons.chevron_left, color: Color(0xFF9FBADE)), // Ikon chevron kiri
                  rightChevronIcon: const Icon(Icons.chevron_right, color: Color(0xFF9FBADE)), // Ikon chevron kanan
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: const Color(0xFF9FBADE).withOpacity(0.5), // Warna biru soft transparan untuk hari ini
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: Color(0xFF9FBADE), // Warna biru soft untuk hari yang dipilih
                    shape: BoxShape.circle,
                  ),
                  outsideDaysVisible: false, // Menyembunyikan hari di luar bulan
                  defaultTextStyle: const TextStyle(color: Color(0xFF37474F)), // Warna teks tanggal
                  weekendTextStyle: TextStyle(color: Colors.grey[600]), // Warna teks akhir pekan
                  // Marker untuk acara
                  markerDecoration: BoxDecoration(
                    color: const Color(0xFFF9A888), // Warna marker acara
                    shape: BoxShape.circle,
                  ),
                  markerSize: 6.0, // Ukuran marker
                ),
              ),
            ),
            const SizedBox(height: 30), // Spasi lebih besar

            // Bagian Detail Acara
            const Text(
              'Detail Acara Hari Ini:', // Judul lebih jelas
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF37474F)),
            ),
            const SizedBox(height: 15),

            // Daftar acara pada tanggal yang dipilih
            _selectedDay != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _getEventsForDay(_selectedDay!).isEmpty
                        ? [
                            Center(
                              child: Text(
                                'Tidak ada acara untuk ${DateFormat('dd MMMM yyyy').format(_selectedDay!)}',
                                style: TextStyle(color: Colors.grey[700], fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ]
                        : _getEventsForDay(_selectedDay!)
                            .map(
                              (event) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    leading: const Icon(Icons.event, color: Color(0xFFC8A2C8)),
                                    title: Text(
                                      event,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                                    onTap: () {
                                      // Tambahkan logika ketika event ditekan (misal: tampilkan detail event)
                                      print('Acara $event ditekan!');
                                    },
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  )
                : Center(
                    child: Text(
                      'Silakan pilih tanggal untuk melihat acara.',
                      style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
