# adis-browse
silverstripe open new window browse than get data

Cara menggunakan:
- copy ke root project silvestripe, nama folder harus "adis-browse"
- dev/build
- akses di browser http://localhost/project/browse

File yang perlu diedit / disesuaikan:
```sh
code/BrowseController.php 
```
- method **getConfigColumns** --> menambahkan setting kolom yang ditampilkan & yang dicari
- method **windowajax** --> bagian query --> variabel **$sql**
```sh
templates/Layout/BrowseIndex.ss
```
- edit bagian win = window.open('browse/window/**[Nama Config]**', 'MyWindow', "menubar=0,toolbar=0,width=600,height=400");
- contoh: win = window.open('browse/window/**Customer**', 'MyWindow', "menubar=0,toolbar=0,width=600,height=400");
- contoh: win = window.open('browse/window/**Team**', 'MyWindow', "menubar=0,toolbar=0,width=600,height=400");
- edit method **setWindowResult** untuk menerima data yang dipilih dari window browse. data yang diterima bentuknya format JSON

## Belum lengkap:
- css perlu disempurnakan
- browse belum bisa kalau JOIN table