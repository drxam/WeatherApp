# WeatherApp

Приложение прогноза погоды, разработанное на **SwiftUI** с архитектурой **MVVM**.  
Интегрирован сервис **AccuWeather API** для получения прогноза и реализовано локальное хранение данных через **SwiftData**.  

<img width="300" height="650" alt="Simulator Screenshot - iPhone 15 Pro - 2025-08-24 at 15 05 39" src="https://github.com/user-attachments/assets/93533f08-f042-4fb2-af4e-055e7ff44ccc" />

<img width="300" height="650" alt="Simulator Screenshot - iPhone 15 Pro - 2025-08-24 at 15 05 43" src="https://github.com/user-attachments/assets/cc094751-f1b4-49fd-be3c-f95c6983452c" />


---

## Возможности
- Отображение прогноза погоды по выбранной геолокации.  
- Поиск городов и просмотр прогноза.  
- Асинхронная загрузка данных (`async/await`) с параллельными запросами к API.  
- Сохранение истории и избранных городов с использованием **SwiftData**.  
- Кастомные UI-компоненты (динамическая градиентная шкала температуры), `TabView`-пагинация и визуальные эффекты.  
- Архитектура **MVVM**. 

---

## Технологии
- **Swift**, **SwiftUI**, **MVVM**  
- **SwiftData** (локальное хранение данных)  
- **async/await**, **REST API**  
- **AccuWeather API**  

---

## Установка и запуск

### 1. Получите API ключ
Для работы приложения требуется ключ от **AccuWeather API**.  
Создайте его на официальном сайте: [https://developer.accuweather.com/](https://developer.accuweather.com/).

### 2. Добавьте ключ в проект
В файле `Config.plist` необходимо указать ваш API ключ.
