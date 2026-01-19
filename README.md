# 📘 Aplikasi Pendataan Murid (Flutter)

## 1. Deskripsi Aplikasi

Aplikasi Pendataan Murid adalah aplikasi mobile berbasis **Flutter** yang digunakan untuk melakukan autentikasi admin dan mengelola data murid. Aplikasi menerapkan **Clean Architecture** dan **BLoC** sebagai state management, mendukung mode **online & offline**, penyimpanan lokal, penggantian tema, serta notifikasi menggunakan **Firebase Cloud Messaging (FCM)**.

---

## 2. Fitur Utama

* Login (Online via Dummy API & Offline Hardcode)
* Manajemen Data Murid (List, Detail, Tambah)
* Penyimpanan Data Lokal (Hive)
* Pengaturan Tema (SharedPreferences)
* Push Notification (Firebase Cloud Messaging)

---

## 3. Teknologi yang Digunakan

* Flutter
* Clean Architecture
* BLoC (flutter_bloc)
* GetIt (Dependency Injection)
* Hive (Local Database)
* SharedPreferences
* Firebase Cloud Messaging (FCM)

---

## 4. Alur Aplikasi

1. User membuka aplikasi
2. User melakukan login

   * Online: POST ke Dummy API
   * Offline: Validasi hardcode
3. Jika login berhasil, masuk ke **Student List Screen**
4. User dapat:

   * Melihat daftar murid
   * Melihat detail murid
   * Menambahkan murid baru
5. User dapat mengganti tema aplikasi
6. Aplikasi menerima notifikasi dari Firebase

---

## 5. Spesifikasi Login

### Kredensial

* Username: `admin`
* Password: `admin123`

### Dummy API Login

* Method: `POST`

* Link: 

  ```
  https://login-lemon-psi-55.vercel.app/api
  ```

* Endpoint:

  ```
  /login
  ```

* Request Body:

  ```json
  {
    "username": "admin",
    "password": "admin123"
  }
  ```

* Response API:

  ```json
  {
    "code": 200,
    "status": "success",
    "message": "Login berhasil",
  }
  ```

  ```json
  {
    "code": 400,
    "status": "error",
    "message": "Username dan password wajib diisi"
  }
  ```

  ```json
  {
    "code": 401,
    "status": "error",
    "message": "Username atau password salah"
  }
  ```

  ```json
  {
    "code": 405,
    "status": "error",
    "message": "Method not allowed"
  }
  ```

### Mode Offline

* Validasi username dan password menggunakan data hardcode

---

## 6. Fitur Student

### Student List Screen

Menampilkan daftar murid dengan data:

* Nama
* NISN
* Jurusan

### Student Detail Screen

Menampilkan detail murid:

* Nama
* NISN
* Tanggal Lahir
* Jurusan
* Umur

### Tambah Murid

Field input:

* Nama
* NIS / NISN
* Tanggal Lahir
* Jurusan

Penyimpanan data menggunakan **Hive (Local Storage)**.

---

## 7. Fitur Tema

* Mengganti tema (Light / Dark)
* Status tema disimpan menggunakan **SharedPreferences**

---

## 8. Fitur Notifikasi

* Menggunakan **Firebase Cloud Messaging (FCM)**
* Menampilkan push notification dari Firebase

---

## 9. Struktur Folder Project

```
lib/
│
├── core/
│   ├── error/
│   ├── network/
│   └── style/
│
├── features/
│   ├── login/
│   ├── student/
│   ├── tema/
│   └── notifikasi/
│
├── injection.dart
└── main.dart
```

---

## 10. Struktur Clean Architecture (Per Feature)

```
feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
│
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
│
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

---

## 11. Dependency Injection

* Menggunakan **GetIt**
* File: `lib/injection.dart`
* Mengatur:

  * Datasource
  * Repository
  * Usecase
  * Bloc

---

## 12. Struktur Folder Test

Folder test sejajar dengan `main.dart` dan berisi file langsung (tanpa sub-folder):

```
test/
├── login_test.dart
├── student_test.dart
├── notification_test.dart
└── theme_test.dart
```

---

## 13. State Management

* Menggunakan **BLoC Pattern**
* Setiap feature memiliki Bloc, Event, dan State masing-masing

---

## 14. Catatan

* API Login hanya simulasi (Dummy API)
* FCM dapat menggunakan mode simulasi / Firebase Console
* Aplikasi mendukung penggunaan offline

---

## 15. Author

Dikembangkan menggunakan Flutter dengan pendekatan Clean Architecture & BLoC
