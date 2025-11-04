# 🧩 Auth With Supabase (SwiftUI + Arquitectura Limpia)

![Swift](https://img.shields.io/badge/Swift-5.9-orange?logo=swift)
![iOS](https://img.shields.io/badge/iOS-17%2B-blue?logo=apple)
![Architecture](https://img.shields.io/badge/Architecture-MVVM%20%7C%20SOLID%20%7C%20DI-green)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

Aplicación iOS modular construida con **SwiftUI**, que implementa **autenticación y gestión de perfiles** utilizando [Supabase](https://supabase.com).  
Diseñada con **MVVM**, **principios SOLID** y **inyección de dependencias** para lograr un código limpio, escalable y completamente testeable.

---

## 🏗️ Arquitectura

El proyecto sigue una arquitectura **Clean Architecture + MVVM**, con capas bien separadas para favorecer la mantenibilidad y los tests unitarios.


### ✅ Principios clave
- MVVM + Clean Architecture  
- Principios SOLID (clases pequeñas y desacopladas)  
- Inyección de dependencias (sin singletons)  
- Mapeadores de errores y entidades  
- Mock y Dummy UseCases para testing y previews  

---

## 📱 Funcionalidades principales

| Módulo | Descripción |
|--------|--------------|
| **Auth** | Registro, inicio y cierre de sesión con Supabase Auth |
| **Profile** | Creación, actualización y eliminación de perfiles de usuario |
| **Avatar** | Subida, borrado y caché (memoria + disco) de imágenes de perfil |
| **NavigationCoordinator** | Coordinación de navegación y hojas modales |
| **Mock Factory** | Factoría de ViewModels completamente mockeada para pruebas y previews |

---

## 🧠 Componentes principales

### 🔹 Punto de entrada
- **`YourApp`** – Configura Supabase, inyecta dependencias y lanza `RootView`.

### 🔹 Inyección de dependencias
- **`ViewModelFactory`** – Crea e inyecta todos los UseCases y ViewModels.  
- **`MockViewModelFactory`** – Versión simulada para pruebas unitarias y SwiftUI Previews.

### 🔹 Autenticación
- **`AuthViewModel`** – Gestiona login, logout y restauración de sesión.  
- **`AuthRepository`** – Encapsula la API de autenticación de Supabase.  
- **`AuthErrorMapper`** – Traduce errores del SDK a errores de dominio (`AuthError`).

### 🔹 Perfiles
- **`ProfileRepository`** – CRUD sobre la tabla `profiles` en Supabase.  
- **`ProfileViewModel`** – Lógica reactiva de la vista de perfil.  
- **`ProfileErrorMapper`** – Mapea errores de red o de PostgREST.

### 🔹 Avatares e imágenes
- **`AvatarUploader`** – Subida y borrado de imágenes en el bucket Supabase.  
- **`CompositeAvatarCache`** – Combina caché en memoria y en disco.  
- **`ImageLoader`** – Descarga y cachea imágenes de forma eficiente.

### 🔹 Vistas SwiftUI
- **`RootView`** – Decide si mostrar la pantalla de login o el Home.  
- **`HomeView`** – Pantalla principal con acceso al perfil.  
- **`SignUpRegisterUserOrCreateOrEditProfileView`** – Vista reutilizable para registrar, crear o editar perfil.  
- **`ProfileDetailView`** – Muestra y permite eliminar o editar el perfil.

---

## 🧪 Testing

El proyecto incluye **mocks y dummies** para cada capa, permitiendo probar sin conexión a la red.

- `MockAuthRepository`  
- `MockProfileRepository`  
- `MockSupabaseClientProvider`  
- `DummySignUpCoordinator`, `DummyUseCases`, etc.  

Esto permite realizar **tests unitarios completamente aislados**, sin dependencias reales del backend.

---

## ⚙️ Requisitos

- Xcode 15 o superior  
- iOS 17+  
- Swift 5.9+  
- Proyecto Supabase con URL y anon key válidos  

## 🚀 Instalación
- git clone https://github.com/GraceToa/Authentication-And-Create-Profile-with-Supabase.git
- open Auth_With_Supabase.xcodeproj
  
## 🧪 Ejecutar los tests
Cmd + U

## 👩‍💻 Autora

Grace Toa
Desarrolladora iOS – SwiftUI
📧 gracetoa29@gmail.com

💼 LinkedIn
https://www.linkedin.com/in/grace-toa/


