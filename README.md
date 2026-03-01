# TOTPly

iOS‑приложение для хранения и отображения TOTP‑кодов (двухфакторная аутентификация).

---

## Архитектура

Используется **MVP с роутером**.

Presenter обновляет View через протокол `render(state)` и не зависит от UIKit. Роутер выносит переходы между экранами в отдельный слой, чтобы презентер не знал о навигации. Данные изолированы в моделях и соответствующих репозиториях; сервисы ([TODO] Network, Storage) - общая инфраструктура. Независимость слоёв улучшает тестируемость и позволяет без избыточного рефакторинга проектировать/подменять конкретные реализации.

В сравнении с MVC: логика не сливается с UI.

В сравнении с MVVM: удобнее в чистом UIKIt без реактивных фреймворков или ручных биндингов.

Остальные варианты вроде VIPER / YARCH (Clean Swift) / др. избыточны для текущего масштаба приложения и его функциональных требований. Ориентируемся на принцип YAGNI.

---

## Модули и ответственности

| Модуль | Ответственность |
|--------|------------------|
| **Auth** | Вход в приложение: Welcome (выбор входа/регистрации), Login, Registration, сценарии верификации email и восстановления пароля. |
| **Dashboard** | Список TOTP‑записей: отображение кодов, таймер, поиск, маскирование кодов, переход в детали, добавление, удаление, обновление с сервера. |
| **Code Detail** | Один TOTP: показ кода, копирование, таймер, редактирование имени/issuer, дополнительная информация. |
| **Add TOTP** | Добавление новой записи: ручной ввод (name, issuer, secret), сканирование QR, сохранение. |
| **Core** | Общие модели и ошибки, [TODO] сборка через AppCoordinator, [TODO] Network, Storage (протокол и ключи). |
| **Services** | [TODO] Реализации репозиториев, Storage, Network, генератор TOTP. |

---

## Экраны: вход, выход, сценарии

### Welcome
- **Вход:** нет.
- **Выход:** переход на Login или на Registration.
- **Сценарии:** нажатие «Войти» → открыть Login; нажатие «Создать аккаунт» → открыть Registration.

### Login
- **Вход:** нет (переход с Welcome или с Registration).
- **Выход:** переход на экран верификации email, на Registration, на восстановление пароля или остаться на экране с ошибкой.
- **Сценарии:** ввод email/пароль и вход → успех, и нужен ещё код с почты Email Verification, или не успех по логину паролю и ошибка; «У меня нет аккаунта» → Registration; «Забыл пароль» → Email Verification с последующим Password Reset.

### [TODO] Password Reset

- **Вход:** временный токен подтверждения почты (переход с Email Verification).
- **Выход:** переход на Dashboard при успехе или остаться с ошибкой.
- **Сценарии:** ввод пароля дважды → успех, переход на Dashboard; несоответствие пароля требованиям; «Назад» → Email Verification (странный сценарий)

### Registration
- **Вход:** нет (переход с Welcome или с Login).
- **Выход:** переход на экран верификации email или обратно на Login.
- **Сценарии:** ввод email, пароль, displayName и регистрация → успех и нужен ещё код с почты Email Verification; «Аккаунт с такой почтой уже есть» → предложение перейти на Login.

### Email Verification
- **Вход:** email, тип (registration / login / passwordReset).
- **Выход:** переход на Dashboard при успехе или остаться с ошибкой/оставшимися попытками.
- **Сценарии:** ввод кода и проверка → успех, переход на Dashboard; повторная отправка кода; «Назад» → предыдущий экран.

### Dashboard
- **Вход:** нет (корневой экран после авторизации).
- **Выход:** переход на Code Detail (тап по записи), на Add TOTP (кнопка добавления), [TODO] на Settings/Profile (кнопки в шапке) или остаться на списке.
- **Сценарии:** отображение списка TOTP и таймеров; pull-to-refresh → обновление с сервера; поиск по имени/issuer; тап по строке → Code Detail; кнопка с иконкой копирования → копирование кода; свайп вправо «Delete» → удаление записи с подтверждением; кнопка «+» → Add TOTP; кнопка с иконкой глаза → маскирование/показ кодов.

### Code Detail
- **Вход:**: id записи, опционально предзагруженный `TOTPItem`.
- **Выход:** возврат на Dashboard после просмотра, редактирования, удаления.
- **Сценарии:** показ кода и таймера; копирование кода; дополнительная информация; переход в режим редактирования имени/issuer и сохранение; удаление с подтверждением.

### Add TOTP
- **Вход:**: опционально презаполненные name, issuer, secret (после сканирования QR).
- **Выход:** возврат на Dashboard (pop) после сохранения или отмены.
- **Сценарии:** ввод name, issuer, secret и сохранение; «Scan QR» → открытие сканера, разбор otpauth и подстановка в форму, затем сохранение; отмена без сохранения.

---

## Ключевые протоколы и модели

### Auth
- **Протоколы:** `WelcomeView`, `WelcomePresenter`, `WelcomeRouter`; `LoginView`, `LoginPresenter`; `RegistrationView`, `RegistrationPresenter`; `AuthRouter`; `VerificationView`, `VerificationPresenter`; `AuthRepository`. 
- **Модели:** `WelcomeViewState`; `LoginViewState`, `RegistrationViewState`, `VerificationViewState`, `VerificationType`; `AuthResult` (`.session(UserSession)` / `.requiresEmailVerification(email)`); запросы/ответы: `LoginRequest`/`LoginResponse`, `RegistrationRequest`/`RegistrationResponse`, `VerifyEmailRequest`/`VerificationResponse`, `ResendVerificationRequest`/`ResendVerificationResponse`, `PasswordResetRequest`/`PasswordResetResponse`, `PasswordResetVerifyRequest`/`PasswordResetVerifyResponse`, `DeviceInfo`.

### Dashboard
- **Протоколы:** `DashboardView`, `DashboardPresenter`, `DashboardRouter`; `TOTPRepository`; `TOTPGenerator`.
- **Модели:** `DashboardViewState`, `DashboardTOTPItem`; доменная `TOTPItem`, `TOTPAlgorithm`; DTO и запросы/ответы: `TOTPItemDTO`, `TOTPItemsRequest`/`TOTPItemsResponse`, `CreateTOTPItemRequest`/`CreateTOTPItemResponse`, `UpdateTOTPItemRequest`/`UpdateTOTPItemResponse`, `DeleteTOTPItemRequest`/`DeleteTOTPItemResponse`.

### Code Detail
- **Протоколы:** `CodeDetailView`, `CodeDetailPresenter`, `CodeDetailRouter`.
- **Модели:** `CodeDetailViewState`, `CodeDetailInput`.

### Add TOTP
- **Протоколы:** `AddTOTPView`, `AddTOTPPresenter`, `AddTOTPRouter`.
- **Модели:** `AddTOTPViewState`, `AddTOTPInput`; [TODO] `ParsedOtpAuth`, [TODO] `OtpAuthParser` (разбор otpauth URL из QR).

### Core
- **[TODO] Сеть:** протокол `NetworkService`; `APIEndpoint`, `HTTPMethod`, `AppConfiguration`.
- **Хранилище:** протокол `StorageService` (save, load, delete, exists, clearAll по ключу); `StorageKey` (`userSession`, `totpItems`).
- **Общие модели:** `Result<T>` (success/failure с `AppError`); `UserSession`; `LoadingState` (initial, loading, loaded, error).
- **Ошибки:** `AppError` (networkError, authError, validationError, storageError, unknown); `NetworkError`; `AuthError`.
