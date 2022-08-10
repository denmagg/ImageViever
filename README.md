# ImageViewer
___
>Привет!
>
>Этот репозиторий является pet-project'ом, за который мне не стыдно.
>
>Это просмотрщик картинок из интернета.
___
### Стек используемых технологий:
- Swift;
- UIKit;
- MVP + Router + Assembly + NetworkServices (JSON data loading);
- Cocoapods;
- [**Snapkit**](https://github.com/SnapKit/SnapKit) для AutoLayout;
- [**Nuke**](https://github.com/kean/Nuke#documentation) для хранения данных и загрузки изображений.
___
### Начинка
Помимо того, что написано в стеке:
1. Для навигации между основными экранами используется **Tab Bar Controller**;
2. Для навигации веред/назад по основным контроллерам используется **Navigation Controller**;
3. Первые 2 основных экрана имеют **схожий функционал**, поэтому **унаследованы от базового модуля**;
4. Все экраны кроме экрана просмотра написаны на основе **Table View**;
5. Для загрузки, кеширования и сохранения изображений в память телефона используется Nuke. Данный выбор обоснован [**более низким потреблением памяти**](https://medium.com/@binshakerr/image-caching-libraries-in-swift-bfcb9d7e7fe7) и [**быстрой скоростью работы**](https://github.com/kean/ImageFrameworksBenchmark), по сравнению с другими фреймворками. Nuke в своей работе использует кэш-память LRU;
6. Экран просмотра изображнения имеет интерфейс схожий с оригинальным приложением photos на iOS, он имеет:
    + Аналогичные **maximum, minimum, double-tap zooming scale**;
    + Аналогичную **смену текущего zooming scale** при повороте экрана;
    + Обработку **появления/скрытия Navigation Bar**;
    + Не дает выйти изображению за **границы экрана**;
    + **Лучший экран просмотра**, который я видел на iOS, кроме приложения фото.
7. Экран описания изображения открывается как **Popover**;
8. Покрытие **UNIT-тестами** 38,2%;
9. Поддержка **iPhone&iPad** на **OS13+**;
10. Поддержка **темной темы**.
___
### Обзор
***Основные экраны:***
![Screen 1-4](https://user-images.githubusercontent.com/48126703/153849221-e6c1b9f3-79cc-4d42-9f38-5571fc66b694.png)

***Экраны просмотра, добавления изображения и описания:***
![Screen 5-9](https://user-images.githubusercontent.com/48126703/153849176-bd133c2e-b003-4146-9ec1-dd1ff9d3300a.png)

***Различные экраны на разных устройствах с темной темой:***
![Diferent Devices + Dark Mode 2](https://user-images.githubusercontent.com/48126703/153849021-f67029e3-ca10-4c22-a444-4782d698709d.png)

>PS: Все скриншоты с темной темой сделаны на симуляторах. Navigation bar, Tab Bar, Alert и некоторые другие элементы имеют более яркий серый оттенок на реальных устройствах и не сливаются с остальнами элементами UI.
___
### Планы по развитию проекта

При наличии у меня времени на развитие данного проекта, в него будут добавлены:
+ Поддержка видео файлов;
+ Интеграция google-drive, one-drive и прочих облачных сервисов;
+ Альтернатива облачным сервисам - поддержка домашнего vpn сервера, для секьюрного хранения ваших медиа-данных;
+ Экраны галереи будут переписаны на UICollectionView, думаю так будет правильней;
+ Добавление других альбомов, помимо Favirites;
+ Увеличение способов добавления изображения в галерею.

После всего этого приложение будет опубликовано в AppStore.
___
### Установка
+ Для удобной установки скачайте cocoapods если у вас его еще нет:
    ```sh
    sudo gem install cocoapods
    ```
1. Клонируйте или скачайте репозиторий
2. Откройте терминал
3. Откройте папку с проектом 
    ```sh
    cd projectdirectory
    ```
4. Установите имеющиеся в Podfile поды
    ```sh
    pod install
    ```
5. Запустите `ImageViever.xcworkspace`
___
#### Contact me:
&nbsp;[![image-text](https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white)](https://mail.google.com/mail/#search/denmagg.work@gmail.com)&nbsp;[![image-text](https://img.shields.io/badge/Telegram-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/denis99m)&nbsp;[![image-text](https://img.shields.io/badge/head_hunter-B71C1C?style=for-the-badge&logo=hh&logoColor=white)](https://hh.ru/resume/e71c0f26ff0738b4410039ed1f37645a747272)
