# Learn Registration and Login System using Shell Script

## **Documentation In *Bahasa (ID/INA)***

### Question Description
Peter Griffin hendak membuat suatu sistem register pada script `louis.sh` dari setiap user yang berhasil didaftarkan di dalam file `/users/users.txt`. Peter Griffin juga membuat sistem login yang dibuat di script `retep.sh`
- Untuk memastikan password pada register dan login aman, maka ketika proses input passwordnya harus memiliki ketentuan berikut
  - Minimal 8 karakter
  - Memiliki minimal 1 huruf kapital dan 1 huruf kecil
  - Alphanumeric
  - Tidak boleh sama dengan username 
  - Tidak boleh menggunakan kata chicken atau ernie
- Setiap percobaan login dan register akan tercatat pada `log.txt` dengan format : YY/MM/DD hh:mm:ss MESSAGE. Message pada log akan berbeda tergantung aksi yang dilakukan user.
  - Ketika mencoba register dengan username yang sudah terdaftar, maka message pada log adalah REGISTER: ERROR User already exists
  - Ketika percobaan register berhasil, maka message pada log adalah REGISTER: INFO User USERNAME registered successfully
  - Ketika user mencoba login namun passwordnya salah, maka message pada log adalah LOGIN: ERROR Failed login attempt on user USERNAME
  - Ketika user berhasil login, maka message pada log adalah LOGIN: INFO User USERNAME logged in

### Questions and Conditions
1. Pengguna (Users) melakukan registrasi menggunakan script `louis.sh` dengan mengikuti beberapa ketentuan Password. Kemudian data pengguna akan terdaftar dan masuk kedalam `/users/users.txt`. 
2. Setelah berhasil melakukan registrasi ,pengguna (Users) dapat melakukan login menggunakan data yang telah terdaftar melalui script `retep.sh`, dimana didalam script `retep.sh` akan secara otomatis membaca data pengguna yang berada di dalam `users/users.txt`.
3. Perlu diperhatikan, bahwa untuk setiap registrasi data yang dimasukkan harus benar-benar sesuai ketentuan seperti ***password***. Karena jika tidak sesuai ketentuan, maka secara otomatis sistem tidak dapat menyimpan data registrasi tersebut. Hal ini berlaku juga untuk login, dimana data ***username*** dan ***password*** yang dimasukkan harus sesuai dengan data yang telah terdaftar didalam `/users/users.txt`.
4. Semua aktivitas **Registrasi** dan **Login** akan dicatat otomatis kedalam file `log.txt`.

### Code Explanation


### - **`louis.sh`**

Sebagai ketetapan untuk bagian baris awal dari `louis.sh`, kami buat sebuah function `log_message` pada `Line 6-8` seperti berikut ini : 

```R
function log_message {
   echo $(date +"%y/%m/%d %T") $1 >> log.txt
}
```
Function tersebut berguna untuk mencatat sebuah aktivitas dari sebuah **Registrasi** yang terjadi dalam `louis.sh`. Kemudian catatan aktivitas tersebut akan masuk berurutan kedalam `log.txt` sesuai waktu yang berjalan. 
- `$(date +"%y/%m/%d %T")` merupakan perintah untuk menampilkan waktu saat ini, di mana `date` adalah perintah untuk menampilkan atau mengatur waktu sistem dan `%y/%m/%d %T` adalah format waktu yang akan ditampilkan.
- `%y` akan menampilkan dua digit terakhir dari `tahun`, `%m` akan menampilkan `bulan` dalam format dua digit, `%d` akan menampilkan `tanggal` dalam format dua digit.
- `%T` akan menampilkan waktu dalam format `jam:menit:detik`.
- `$1` merupakan argumen pertama yang diberikan pada program, yang akan ditampilkan setelah waktu saat ini. 

Contoh log meesage : 

![log](https://user-images.githubusercontent.com/91828276/224346360-3c3103c0-cfce-478c-83bb-9fbdafc44352.png)

Selanjutnya, terdapat function `register_users` seperti berikut :
```R
#Register a new user
function register_user {
   #read user & pw from user input
   read -p "Masukkan Username : " username
   read -p "Masukkan Password : " password
```
Function tersebut menggunakan perintah `read -p` yang digunakan untuk menangkap dan membaca `Username` dan `Password` yang di-input oleh Pengguna (Users) pada halaman awal. Contoh input seperti dibawah ini :
![input](https://user-images.githubusercontent.com/91828276/224346346-43be847f-d9ab-4d1d-8419-12778c315327.png)

Kemudian didalam function `register_user` juga terdapat sebuah fungsi perulangan `password_requirements` pada `Line 16-21` seperti berikut :
```R
#Password Requirements
   if ! [[ $password =~ ^[A-Za-z0-9]+_[A-Za-z0-9]+.*$ && ${#password} -ge 8 && "$password" != *chicken* && "$password" != *ernie* && "$password" != "$username" && "$password" == *[A-Z]* && "$password" == *[a-z]* && "$password" == *[0-9]* ]];
      then
        echo "Password does not match!"
        exit 1
   fi
```
Dengan menggunakan perulangan `if`, penjabaran isi nya seperti dibawah ini :
- Menggunakan `!` setelah if menunjukkan kondisi bernilai `false` yang dimana jika tidak sesuai ketentuan kondisi didalam `if` maka akan mengeluarkan output `"Password does not match!"` kemudian akan secara otomatis `terminate` dari system dengan `exit 1` (exit yang di-indikasikan karena terjadi sebuah kesalahan dalam program/sistem).
- `$password =~ ^[A-Za-z0-9]+_[A-Za-z0-9]+.*$` merupakan sebuah pola regex untuk memastikan password mengikuti konvensi penamaan snake_case, yaitu terdiri dari satu atau lebih huruf, angka, atau garis bawah `([A-Za-z0-9]+)`, diikuti oleh satu garis bawah `(_)`, diikuti lagi oleh satu atau lebih huruf, angka, atau garis bawah `([A-Za-z0-9]+)`, dan diikuti oleh karakter apa pun `(.*)`. Operator `=~` merupakan sebuah operator yang digunakan membandingkan sebuah string dengan sebuah pola regex.
- `${#password}` merupakan variabel untuk mendapatkan panjang string `$password`.
- `"$password" != *chicken* dan "$password" != *ernie*` digunakan untuk memastikan bahwa password tidak mengandung kata `"chicken"` atau `"ernie"`.
- `"$password" != "$username"` digunakan memastikan bahwa password tidak sama dengan username
- `"$password" == *[A-Z]*, "$password" == *[a-z]*, dan "$password" == *[0-9]*` digunakan untuk memastikan bahwa string `$password` mengandung minimal satu huruf kapital, satu huruf kecil, dan satu angka.

Sehingga, secara keseluruhan ekspresi kondisi tersebut akan bernilai `true` hanya jika semua kondisi yang disebutkan di atas terpenuhi, dan bernilai `false` jika ada salah satu kondisi yang tidak terpenuhi.

Dengan menggunakan perulangan if, maka dapat diketahui tujuan dari adanya perulangan `password_requirements` yaitu untuk membaca `Password` yang dimasukkan oleh Pengguna (Users) ***"Apakah memenuhi ketentuan atau tidak?"***.  Untuk Percobaan sistem password tersebut seperti ini :

![pw1](https://user-images.githubusercontent.com/91828276/224346382-44f5ee46-302b-43cc-bde5-9699a3dcbd20.png) 

****Dalam contoh tersebut, dinyatakan password tidak sesuai karena dalam input nya tidak terdapat `angka`*** 

![pw2](https://user-images.githubusercontent.com/91828276/224346391-f0a90d8e-d00c-4ab7-aab3-755aef8b7a81.png) 

****Dalam contoh tersebut, dinyatakan password tidak sesuai karena dalam input nya tidak terdapat `underscore`***

![pw3](https://user-images.githubusercontent.com/91828276/224346386-410224a3-5c53-40c4-aa0e-07493d789367.png)

****Dalam contoh tersebut, dinyatakan password tidak sesuai karena dalam input nya tidak terdapat `kapital`***
*dll.*

****Untuk semua kondisi akan tercetak sama jika tidak sesuai ketentuan yaitu `Password does not match!** 

Tak hanya ketentuan `Password` saja, didalam function `register_user` juga ditambahkan ketentuan selanjutnya yaitu `Check Username`. Dengan menggunakan perulangan `if-else` pada `Line 24-36` seperti berikut ini :
```R
#Check username
   if grep -q "^$username: " /users/users.txt;
      then
      log_message "REGISTER : ERROR User already exist"
      echo "ERROR : User already exist."
      echo "-----------Oops!-----------"
   else
      #Add user to users.txt
      echo "$username : $password" >> /users/users.txt
      log_message "REGISTER : INFO User $username registered successfully"
      echo "Success : User $username registered successfully"
      echo "-------------------Welcome!---------------------"
      exit 1
   fi
```
Perulangan `if` menggunakan perintah `grep -q` yang digunakan untuk mencari sebuah pola atau string tertentu dalam sebuah teks atau file, yang kemudian mengembalikan status keluaran yang menandakan apakah pola tersebut ditemukan atau tidak ditemukan dalam teks atau file tersebut. `-q` sendiri yakni merupakan perintah yang terdapat pada perintah`grep` dengan fungsi yaitu menjalankan perintah `grep` dalam mode diam (quiet mode) yaitu mode di mana tidak ada output yang ditampilkan ke layar dan hanya status keluaran yang dikembalikan. Secara terperinci penjelasan nya seperti dibawah ini :
- `if grep -q "^$username: " /users/users.txt;` bahwa dapat dilihat perintah `grep -q` melakukan pencarian `username` yang di-input oleh Pengguna(Users)  pada `$username` yang terdapat didalam `/users/users.txt`. 
- Jika ditemukan, maka akan otomatis menjalankan 
  ```R
  log_message "REGISTER : ERROR User already exist"
  echo "ERROR : User already exist."
  echo "-----------Oops!-----------" 
  ```
  - *(`log_message` akan ditampilkan didalam file `log.txt`)*
  -  *(Untuk perintah `echo` akan ditampilkan secara langsung didalam file `louis.sh`)*

- Sebaliknya `echo "$username : $password" >> /users/users.txt` perulangan `else echo` demikian akan aktif jika `username` masih tersedia yang kemudian `$username : $password` akan tercatat didalam `/users/users.txt`
- Dan akan secara otomatis mengeluarkan output demikian 
  ```R
  log_message "REGISTER : INFO User $username registered successfully"`
  echo "Success : User $username registered successfully"
  echo "-------------------Welcome!---------------------"
  exit 1  
  ```
  - *(`log_message` dan `echo` memiliki output yang sama seperti perulangan `if` sebelum ini)*
  - *(`exit 1` memiliki arti bahwa program selesai karena kondisi tersebut)*

**Untuk dokumentasi `pesan` berisi sama seperti pada dokumentasi `log.txt` seperti berikut :*
![docreg](https://user-images.githubusercontent.com/91828276/224346380-f9602dfe-bd27-4b2f-b716-e89d4e4d7012.png)

***Cakupan function `register_user` berakhir setelah perulangan `if-else`.*** 

Dari semua proses yang terjadi, tentu tak luput dari `Interface` dari sebuah sistem, maka dari itu dalam sebuah sistem `louis.sh` tentu terdapat `Interface` pada `Line 40-44` sebagai berikut :
```R
#Interface
while true;
do
  echo "Let's Register!"
	  register_user
done
```
Menggunakan perulangan while untuk menggunakan akses function `register_user` dengan action `do` sebagai akses `Interface`. Hasilnya seperti ini :

![intf](https://user-images.githubusercontent.com/91828276/224346355-5c5f0654-5d0a-4ce9-a060-20f220a63474.png)

**Untuk `interface` "Masukkan Password" akan muncul ketika User telah memasukkan `Username`*
<br> 

### - **`retep.sh`**
Sama seperti `louis.sh` yakni dimana diawal sistem saya buat function `log_message` pada `Line 6-8` seperti berikut:
```R
#Deliver message to log.txt
function log_message {
   echo $(date +"%y/%m/%d %T") $1 >> log.txt
}
```
Function tersebut berguna untuk mencatat sebuah aktivitas dari sebuah **Login** yang terjadi dalam `retep.sh`. Kemudian catatan aktivitas tersebut akan masuk berurutan kedalam `log.txt` sesuai waktu yang berjalan. 
- `$(date +"%y/%m/%d %T")` merupakan perintah untuk menampilkan waktu saat ini, di mana `date` adalah perintah untuk menampilkan atau mengatur waktu sistem dan `%y/%m/%d %T` adalah format waktu yang akan ditampilkan.
- `%y` akan menampilkan dua digit terakhir dari `tahun`, `%m` akan menampilkan `bulan` dalam format dua digit, `%d` akan menampilkan `tanggal` dalam format dua digit.
- `%T` akan menampilkan waktu dalam format `jam:menit:detik`.
- `$1` merupakan argumen pertama yang diberikan pada program, yang akan ditampilkan setelah waktu saat ini.
   
   ****Untuk dokumentasi log_message pada `retep.sh` sama persis dengan `louis.sh`***

Kemudian, pada `retep.sh` juga terdapat function `login_user` pada `Line 11-14` yang memiliki isi hampir sama dengan `louis.sh` seperti berikut :
```R
#Login user
function login_user {
    #read user & pw  from user input
    read -p "Masukkan Username : " username
    read -p "Masukkan Password : " password
```   
Function tersebut menggunakan perintah `read -p` yang digunakan untuk menangkap dan membaca `Username` dan `Password` yang di-input oleh Pengguna (Users) pada halaman awal.

   ****Untuk dokumentasi input login_user pada `retep.sh` sama persis dengan `louis.sh`***

Setelah itu, langkah selanjutnya sedikit berbeda dengan `louis.sh`, dimana pada `retep.sh` terdapat ketentuan didalam function `login_user` memasukkan `Username` dan `Password` pada `Line 17-27` seperti berikut :
```R
#check if username exist in users.txt and password is correct
if grep -q "^$username : $password" /users/users.txt
```
Perbedaan nya terletak pada perulangan tersebut digunakan untuk melakukan `checking` pada `Username` dan `Password` ***"Apakah Username dan Password sudah benar dan terdapat didalam /users/users.txt?"***

Isi dari `/users/users.txt` sebagai berikut :

![us](https://user-images.githubusercontent.com/91828276/224346395-a893fc64-fef0-4e7f-b15c-4ade3511ec2a.png)

Jika tersedia, maka akan mengeluarkan output demikian :
```R
log_message "LOGIN : INFO User $username logged in"
      echo "Success : User $username logged in"
      echo "---------Congratulations!---------"
	exit 1
```
![logg](https://user-images.githubusercontent.com/91828276/224346374-2cce0929-849b-403f-8da1-f012dcf930e4.png)
- Secara kelesuruhan memang sama dengan `louis.sh`, dimana untuk `log_message` akan masuk kedalam `log.txt` dan untuk `echo` akan langsung ditampilkan didalam file `retep.sh`
- Perbedaan nya terdapat pada `exit 1`, artinya jika Pengguna(Users) telah berhasil login dengan `Username` dan `Password` yang telah terdaftar dan benar, maka akan langsung `terminate` dari sistem.


Sebaliknya / else, jika belum memenuhi ketentuan login, maka mengeluarkan output berikut :
```R
log_message "LOGIN : ERROR Failed login attempt on user $username"
      echo "Error : Failed login attempt on user $username "
      echo "------------------Try again-------------------" 
```      
![logf](https://user-images.githubusercontent.com/91828276/224346366-d8546dbe-11c2-4a9c-99dd-a1e04514cf5e.png)
- Program akan terus `looping` hingga Pengguna(Users) memasukkan `Username` dan `Password` pada halaman login dengan benar dan sesuai ketentuan. 
- Saat ini, untuk melakukan `terminate program` cukup dengan tekan `CTRL + Z` 

***Cakupan function `login_user` berakhir setelah perulangan `if-else`.*** 

Setelah melewati semua proses login, tentu dibutuhkan sebuah `Interface` dalam sebuah sistem. Untuk `Interface` pada `retep.sh` memang sama dengan `Interface louis.sh` yakni seperti demikian :
```R
while true;
do
  echo "Let's Login!"
	login_user
done
```
Kesamaan nya yaitu menggunakan perulangan while untuk menggunakan akses function `register_user` dengan action `do` sebagai akses `Interface`.

****Untuk dokumentasi input interface pada `retep.sh` sama persis dengan `louis.sh`***

### Obstacles  
Beberapa kendala / rintangan yang dialami adalah 
- Ketika membuat `requirements_password`. Seringkali ketika melakukan testing selalu bernilai `true` padahal kondisi sebenarnya `false`.
- Sempat bingung titik akhir/terminate dari sistem `Register-Login` ini, tetapi akhirnya menetapkan nya seperti yang tertera pada penjelasan.