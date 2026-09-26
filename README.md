# sportsman

Этот клиент будет создан для спортсменов или просто участников мероприятий.

## Features

 - Регистрирует пользователя спомощью специального QR<br>
        (~~учитывая группу пользователя и его трассу~~)
 - Сканирует специальные QR:<br>
        - старта<br>
        - финиша<br>
        - контрольного пункта<br>
        - очистки
 - Локально хранит данные пользователя и его отметки 
 - Отображает результат пользователя ввиде рядя специальных QR.
 - ~~Нереализованный функционал~~

# Getting Started

Сборка рассчитана на Flutter 3.47.x / Dart 3.13.x. Android-конфигурация
написана на Kotlin DSL (`.gradle.kts`): Gradle 9.3.1, Android Gradle Plugin
9.1.0, Kotlin 2.4.0, целевой байткод Java/Kotlin 17.

Из каталога `sportsman` выполните:

    flutter pub get
    dart run build_runner build
    flutter analyze
    flutter build apk --debug
    flutter run

В `android/gradle.properties` временно отключена инкрементальная компиляция
Kotlin (`kotlin.incremental=false`). Это обходит ошибку кэша `mobile_scanner`
на Windows, когда проект и Pub-кэш находятся на разных дисках. Повторная
компиляция Kotlin может занимать больше времени; настройка не отключает
hot reload Dart. После размещения проекта и Pub-кэша на одном диске можно
убрать этот параметр, выполнить `flutter clean` и `flutter pub get`, затем
проверить сборку заново.
