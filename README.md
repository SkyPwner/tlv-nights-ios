# TLV Nights iOS

Нативное iPhone-приложение на SwiftUI по макету TLV Nights: агрегатор ночной жизни Тель-Авива.

## Что внутри

- SwiftUI, iOS 16+, Xcode project `TLVNights.xcodeproj`.
- Экраны: onboarding/login, age verification, ID scan, verified pass, Discover/Home, filters sheet, event details, MapKit map, route, friends, profile, notifications, search.
- Компоненты дизайн-системы: CTA, chips, AntiCard, LiveBadge, avatars, custom tab bar, dark TLV night theme.
- Mock data layer в `TLVNights/Data/MockTLVData.swift` и модели в `TLVNights/Models/TLVModels.swift`.
- `codemagic.yaml` для сборки simulator `.app` без code signing.

## Запуск локально на Mac

1. Открой `TLVNights.xcodeproj` в Xcode.
2. Выбери scheme `TLVNights`.
3. Выбери любой iPhone Simulator.
4. Нажми Run.

## Сборка в Codemagic

1. Подключи этот GitHub repo в Codemagic.
2. Codemagic должен автоматически найти `codemagic.yaml`.
3. Запусти workflow `TLV Nights - iOS Simulator`.
4. После сборки забери artifact `TLVNights-simulator.app.zip` или `.app` из artifacts.
5. Для Appetize загружай именно собранный `.app/.zip`, не `.xcodeproj`.
