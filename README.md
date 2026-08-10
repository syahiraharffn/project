# Kad Digital — Burgundy Floral

Kad jemputan digital (e-card) untuk **Wan Rusyhuddeen Faizzal & Nur Syahirah**,
29 November 2026 di Asiana Grand Hall Selayang.

Reka bentuk baharu: bingkai bunga air (watercolour) burgundy / maroon, mawar debu dan gading,
gaya satu halaman menegak untuk telefon.

> Ini **reka bentuk kedua**, berasingan daripada `Desktop\digital card`
> (versi sage green + gold) yang kini disiarkan di GitHub Pages.
> Folder ini belum di-deploy ke mana-mana.

---

## Fail

| Fail | Kegunaan |
| --- | --- |
| `index.html` | Keseluruhan kad — HTML, CSS dan JS dalam satu fail |
| `assets/bingkai-bunga.svg` | Bingkai bunga penuh (skrin pembuka + penutup) |
| `assets/sudut-bunga.svg` | Bunga sudut untuk seksyen dalaman |
| `assets/garis-bunga.svg` | Pembahagi bunga kecil antara blok teks |
| `assets/pintu-masuk.jpg` | Foto Street View arah masuk dari Jalan PS 7 |
| `assets/galeri/` | Foto galeri, dinamakan `01.jpg` hingga `13.jpg` |
| `song.mp3` | Muzik latar (disalin daripada folder `digital card`) |

Buka `index.html` terus dalam pelayar — tiada `build step`, tiada `npm`.

---

## Ciri-ciri

- Skrin pembuka **Buka Jemputan** (juga membenarkan muzik bermain — pelayar
  memerlukan satu sentuhan pengguna sebelum audio dibenarkan)
- Nama tetamu peribadi melalui URL: `index.html?to=Encik%20Ahmad`
- Butang muzik terapung (fade-in perlahan)
- Kiraan detik ke tarikh majlis
- **Simpan Ke Kalendar** — memuat turun fail `.ics`
- Pautan Google Maps + Waze
- **Galeri** masonry dua lajur + lightbox (anak panah, papan kekunci, leret pada telefon)
- Foto **Arah Masuk** dengan penanda berdenyut pada laluan masuk
  (ubah kedudukan penanda pada `style="left:76%; top:69%"` dalam `.ent-pin`)
- Ucapan & doa — disimpan dalam `localStorage` pelayar tetamu dan dihantar
  ke WhatsApp keluarga
- Hubungi — telefon + WhatsApp untuk kedua-dua bapa
- Navigasi bawah: Mula · Kalendar · Hubungi · Lokasi
- Menghormati `prefers-reduced-motion`

---

## Menyunting maklumat majlis

Semua butiran yang berubah ada di **satu tempat** di dalam `<script>`
pada penghujung `index.html`:

```js
var EVENT = {
  title   : "Walimatulurus Wan Rusyhuddeen Faizzal & Nur Syahirah",
  venue   : "Asiana Grand Hall Selayang, Emerald Avenue, 68100 Batu Caves, Selangor",
  startISO: "2026-11-29T11:00:00+08:00",
  endISO  : "2026-11-29T16:30:00+08:00",
  familyWA: "60123668030"
};
```

`venue` digunakan untuk pautan Google Maps, Waze **dan** fail kalendar.
`startISO` juga memacu kiraan detik.

Teks yang lain (nama ibu bapa, atur cara, nombor telefon) ada dalam HTML
dan boleh dicari terus mengikut nama.

Warna terkumpul dalam blok `:root` di bahagian atas fail —
tukar `--wine`, `--rose`, `--blush` untuk menukar keseluruhan tema.

---

## Melukis semula bunga

Grafik bunga dijana oleh `tools\gen-floral.ps1`. Skrip itu **deterministik**:
`seed` tetap `20261129`, jadi setiap kali dijalankan hasilnya sama.

```powershell
.\tools\gen-floral.ps1     # tulis semula ketiga-tiga SVG dalam assets\
```

Untuk susunan bunga yang lain, tukar nombor `seed` pada baris
`[System.Random]::new(20261129)`. Palet warna (`$rose`, `$wine`, `$burg`, `$ivory`, `$green`) ada betul-betul di bawahnya.

Fail SVG dalam `assets/` sudah siap — tiada keperluan menjana semula
melainkan mahu rupa yang baharu.

---

## Menambah foto galeri

Galeri membaca `assets/galeri/01.jpg` hingga `13.jpg`. **Slot yang failnya tiada
akan hilang sendiri** — tiada kotak kosong, tiada ikon rosak. Jadi untuk menambah
gambar, cukup salin fail masuk dengan nama yang betul; tak perlu sunting kod.

Kini `01`–`11` sudah ada (diambil daripada kad sage lama). `12.jpg` dan `13.jpg`
masih kosong — slot untuk gambar 5 sahabat dan gambar kumpulan besar keluarga.

Susunan grid ikut turutan nama fail. Saiz elok: sisi panjang lebih kurang 820px,
JPEG kualiti ~80 (kekalkan di bawah ~120 KB sefail supaya kad kekal ringan).

## Menyunting berdua

Repo: <https://github.com/syahiraharffn/project> — Syahirah pemilik, Wan akses tulis.

Sentiasa tarik dahulu sebelum mula menyunting:

```bash
git pull
```

Selepas siap:

```bash
git add -A
git commit -m "apa yang diubah"
git push
```

Kalau dua-dua sunting `index.html` pada masa yang sama, git akan minta
selesaikan konflik. Cara paling mudah mengelak: beritahu satu sama lain
sebelum mula, atau bahagi tugas — contohnya seorang urus teks dan butiran
majlis, seorang lagi urus gambar galeri.

## Sebelum diedarkan

1. **Repo ini `private`, jadi GitHub Pages belum boleh dihidupkan** pada pelan
   percuma. Untuk dapat pautan yang boleh dihantar melalui WhatsApp:
   Settings -> General -> Change visibility -> **Public**, kemudian
   Settings -> Pages -> Deploy from a branch -> `main` / `/ (root)`.
   Pautan akan menjadi `https://syahiraharffn.github.io/project/`.

   Ingat: menjadikannya public bermakna gambar keluarga dan nombor telefon
   dalam kad boleh dilihat oleh sesiapa sahaja yang ada pautan itu.
2. Jika kad fizikal akan menggunakan kad ini, **kod QR perlu dijana semula**
   kerana URL berbeza.
3. Tambah `og-image.jpg` + meta `og:image` supaya pratonton WhatsApp
   menunjukkan gambar (kini hanya tajuk dan penerangan).
