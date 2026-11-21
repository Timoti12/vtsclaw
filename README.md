[README (4).md](https://github.com/user-attachments/files/35204054/README.4.md)
# VTS-CLAW

Visual Thinking Strategy untuk Literasi Kritis dan Menulis Akademik.

Situs statis (satu file `index.html`) dengan login/daftar memakai **Supabase Auth**.

## Struktur
- `index.html` — halaman web (UI + logika login/daftar)
- `supabase/schema.sql` — tabel `profiles`, RLS, dan trigger profil otomatis

## Fitur akun
- Daftar: nama, institusi, email, kata sandi (tanpa verifikasi email; langsung masuk)
- Masuk / keluar, ubah nama & institusi
- Peran `user` dan `developer` (panel developer melihat daftar pengguna)

## Keamanan
- Kata sandi di-hash oleh Supabase Auth; tidak disimpan di kode atau repo ini.
- Kunci di `index.html` adalah *publishable key* (aman di klien). Jangan pernah memasukkan `service_role`/secret key.
- RLS aktif; peran `developer` tidak dapat diubah dari klien.

## Hosting (GitHub Pages)
Settings → Pages → Deploy from a branch → `main` / root.
Lalu tambahkan URL Pages ke Supabase → Authentication → URL Configuration (Site URL & Redirect URLs).

## Foto kampus
Foto sudah tersedia di folder yang sama dengan `index.html` (atau `img/`) dengan nama berikut (JPG, disarankan lebar ≥1600px, ukuran <500 KB):
- `uin-jakarta.jpg` — UIN Syarif Hidayatullah Jakarta
- `uin-bandung.jpg` — UIN Sunan Gunung Djati Bandung
- `umj.jpg` — Universitas Muhammadiyah Jakarta
- `uhamka.jpg` — UHAMKA
- `unindra.jpg` — UNINDRA

Foto tampil di banner dan bagian Tempat Penelitian dengan lapisan blur burgundi. Jika file belum ada, otomatis tampil latar burgundi.
