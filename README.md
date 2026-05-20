# Animeks Responsi Mobile IF-D

Project Flutter untuk studi kasus responsi **Animeks**, aplikasi browsing anime yang mengambil data dari **Kitsu API**.

## Ketentuan yang Diimplementasikan

### 1. Login Page
- Autentikasi sederhana memakai input `username` dan `password` bebas.
- Data login/session disimpan memakai `SharedPreferences`.
- Jika user sudah login, aplikasi langsung masuk ke halaman utama saat dibuka kembali.

### 2. Home Page
- Menggunakan `BottomNavigationBar` dengan 3 page utama: **Home**, **Favorite**, dan **Profile**.
- Daftar anime diambil dari endpoint:
  `https://kitsu.io/api/edge/anime/?page[limit]=20&page[offset]=0`
- Data anime ditampilkan dalam `GridView`.
- Setiap item anime menampilkan:
  - Poster image
  - Nama anime `en_jp`
  - Rating umur
  - Jumlah episode
  - Rating
- Ada loading indicator saat fetch data API.

### 3. Detail Page
- Detail dibuka ketika anime pada Home/Favorite diklik.
- Navigasi hanya mengirim `anime_id`, kemudian Detail fetch ulang ke endpoint:
  `https://kitsu.io/api/edge/anime/{anime_id}`
- Detail menampilkan:
  - Cover image sebagai hero image besar
  - Rating
  - Rating umur
  - Jumlah episode
  - Sinopsis
  - Button static **Nonton**
  - Button tambah/hapus Favorite dengan UI berbeda sesuai state
- Ada loading indicator saat fetch detail anime.
- User dapat kembali dari Detail ke Home/Favorite memakai tombol back AppBar.

### 4. Favorite Page
- Menampilkan anime favorit dalam bentuk list.
- Setiap item menampilkan poster, nama, dan rating.
- Ada tombol delete untuk menghapus anime dari library.
- Item favorit dapat diklik untuk membuka Detail Page.
- Data Favorite disimpan dan dikelola memakai `Hive`, sehingga tetap ada setelah aplikasi ditutup.

### 5. Profile Page
- Menampilkan username dari `SharedPreferences`.
- Menampilkan jumlah anime favorit dari `Hive`.
- Terdapat tombol logout yang menghapus session dan mengarahkan user ke Login Page.

### 6. Implementasi Tambahan dari Modul
- Model class `Anime` untuk parsing data API.
- `api_service.dart` terpisah untuk fetch dan parse API.
- GetX untuk state management, route management, dan dependency injection.
- Local Notification:
  - Notifikasi saat anime ditambahkan ke Favorite.
  - Tombol tes notifikasi.
  - Reminder harian pukul 19.00.
- LBS:
  - Ambil lokasi pengguna.
  - Menampilkan koordinat dan alamat.

## Struktur Folder

```text
lib/
  main.dart
  core/
    constants/
    routes/
    theme/
    utils/
    widgets/
  data/
    models/
    services/
  presentation/
    bindings/
    controllers/
    screens/
    widgets/
```

## Cara Menjalankan

```bash
flutter create .
flutter pub get
flutter run
```

## Permission Android untuk Notification & LBS

Setelah menjalankan `flutter create .`, tambahkan permission berikut ke file:
`android/app/src/main/AndroidManifest.xml`

Letakkan di atas tag `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
```

Untuk iOS, tambahkan deskripsi permission lokasi di `ios/Runner/Info.plist` jika ingin menjalankan fitur LBS.

## Pengumpulan

Push project ke repository publik GitHub dengan nama:

```text
[NIM]_Responsi_Mobile
```

Lalu kumpulkan link repository di SPADA.
