# Выполнение домашнего задания №5 ZFS

### Предварительная подготовка: [Скрипт](/prereq.sh)

### Запуск ВМ:
```
#export VAGRANT_EXPERIMENTAL="disks"
#vagrant up server
#vagrant ssh server
```
### 1. Определение алгоритма с наилучшим сжатием (gzip,gzip9,zle,lzjb,lz4,zstd).

Создаем пул zpool:
```
zpool create zpool mirror /dev/sdb /dev/sdc
```
Создаем несколько файловых систем ZFS, на каждой задаем свой алгоритм сжатия:
```
zfs create zpool/gzip
zfs create zpool/gzip9
zfs create zpool/zle
zfs create zpool/lzjb
zfs create zpool/lz4
zfs create zpool/zstd
zfs set compression=gzip zpool/gzip
zfs set compression=gzip-9 zpool/gzip9
zfs set compression=zle zpool/zle
zfs set compression=lzjb zpool/lzjb
zfs set compression=lz4 zpool/lz4
zfs set compression=zstd zpool/zstd
zfs get compression
```
Скачиваем файл "Война и мир" и выполняем задание:
```
wget -O War_and_Peace.txt http://www.gutenberg.org/ebooks/2600.txt.utf-8
cp /tmp/War_and_Peace.txt /zpool/gzip/
cp /tmp/War_and_Peace.txt /zpool/gzip9/
cp /tmp/War_and_Peace.txt /zpool/zle/
cp /tmp/War_and_Peace.txt /zpool/lzjb/
cp /tmp/War_and_Peace.txt /zpool/lz4/
cp /tmp/War_and_Peace.txt /zpool/zstd/
zfs get compressratio
```
#### Результат:

Наилучшее сжатие у gzip (результат 2.67x)

[Лог скрипта](/script1.log)

### 2. Определение настроек импортированного пула ZFS.

Загружаем файл и распаковываем архив:
```
wget -O /tmp/task2.tar.gz https://drive.google.com/u/0/uc?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg
cd /tmp && tar -zxvf task2.tar.gz
```
Ищем файлы в каталоге, доступные для импорта:
```
zpool import -d /tmp/zpoolexport/
```
Собираем пул и определяем его настройки:
```
zpool import -d /tmp/zpoolexport/ otus
zpool list otus
zfs get recordsize otus
zfs get compression otus
zfs get checksum otus
```
#### Результат:
Настройки пула otus:
* Размер хранилища: 480M 
* Тип пула: mirror
* Значение recordsize: 128k
* Тип сжатия: zle
* Контрольная сумма: sha256

[Файл настроек zfs otus](/zfs_settings_otus.txt)

[Файл настроек zpool otus](/zpool_settings_otus.txt)

[Лог скрипта](/script2.log)

### 3. Находим сообщение от преподавателей.

Копируем файл из удаленной директории (файл был получен командой `zfs send otus/storage@task2 > otus_task2.file`):
```
wget -O /tmp/otus_task2.file https://drive.google.com/u/0/uc?id=1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG
```
Выделим два файла для будущего пула ZFS:
```
cd /tmp && echo disk{1..2} | xargs -n 1 fallocate -l 500M
```
Создаем новый пул для снапшота:
```
zpool create zpool2 /tmp/disk1 /tmp/disk2
```
Восстанавливаем файл snapshot:
```
zfs receive zpool2/message < /tmp/otus_task2.file
```
Находим файл secret_message и выводим его содержимое:
```
find /zpool2/message/ -name 'secret_message' | xargs cat
```
#### Результат:

Зашифрованное сообщение: https://github.com/sindresorhus/awesome

[Лог выполнения комманд](/script3.log)
