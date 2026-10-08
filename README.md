# RenoDesign — AI-Powered Interior Transformation Platform

> **Real Production-Ready Full-Stack Platform for Interior Renovation & Architectural Finishing**
> 

---

## 🌟 Overview

**RenoDesign** is an end-to-end luxury renovation and real-estate finishing solution. The platform allows homeowners, designers, and real estate professionals to take a real photograph of an existing room and use **architectural AI image-to-image transformation** to reimagine it with premium materials, bespoke lighting, and curated styles.

Users can compare the transformation in real time with an **interactive Before/After slider**, save their favorite visions, regenerate styles, and submit **formal quote requests** directly to the RenoDesign engineering and finishing team.

---

## 📐 Technology Architecture

```
                       📱 Flutter Mobile App (Android / iOS)
                                       │
                                       │ REST / Multipart / JWT
                                       ▼
                       ☕ Spring Boot 3.3.4 (Java 21)
                                       │
               ┌───────────────────────┼──────────────────────┐
               │                       │                      │
               ▼                       ▼                      ▼
       🐘 PostgreSQL 16      🤖 AI Transformation API    📁 Media Storage
     (Flyway Migrations)     (Stability / Replicate /    (Local / S3)
                             OpenAI Image-to-Image)
```

### 1. Mobile (Flutter + Dart)
* **Framework:** Flutter 3.24.5 / Dart 3.5.4
* **State Management:** `flutter_riverpod` (v2.6.1)
* **Navigation:** `go_router` (v14.8.1) with ShellRoute & bottom navigation
* **Networking:** `dio` (v5.4.3) with automated JWT `AuthInterceptor` & multipart upload
* **Design & Typography:** Google Fonts (`Playfair Display` serif headlines & `Plus Jakarta Sans` body), Custom Champagne Gold palette, frosted glass containers (`BackdropFilter`)
* **Camera & Media:** `image_picker`, `permission_handler`
* **Storage:** `flutter_secure_storage` (encrypted JWT storage)
* **Interactive UI:** Custom interactive Before/After comparison slider (`BeforeAfterSlider`) with horizontal drag clipping and haptic-feel knob.

### 2. Backend (Spring Boot + Java 21)
* **Framework:** Spring Boot 3.3.4
* **Security:** Stateless Spring Security 6 with JWT (`jjwt` 0.12.6)
* **Database:** PostgreSQL 16 with automated Flyway versioned migrations
* **Asynchronous AI Engine:** Multi-provider abstraction (`AITransformationService`) with real integrations:
  - **Stability AI** (`StabilityAITransformationService` via Stable Diffusion XL image-to-image)
  - **Replicate** (`ReplicateAITransformationService` via adirik/interior-design)
  - **OpenAI** (`OpenAITransformationService` via DALL-E image edits)
* **Prompt Engine:** Dynamic architectural prompt generator preserving room proportions, windows, doors, and geometry while applying authentic materials.
* **API Documentation:** Swagger / OpenAPI 3 (`/swagger-ui.html`)
* **File Service:** Multi-part image upload with MIME validation and local/S3 persistence.

---

## 🗄️ Database Schema & Entities

The PostgreSQL schema is fully managed via Flyway migrations (`V1__init_schema.sql` and `V2__seed_data.sql`):

| Table | Description |
|---|---|
| `users` | User accounts with BCrypt passwords, role (`ADMIN`, `CLIENT`), profile info |
| `styles` | Architectural interior design styles (Modern Luxury, Scandinavian, Minimalist...) |
| `materials` | Wall coverings and flooring materials with pricing tier |
| `services` | RenoDesign core company services (Painting, Flooring, Wall coverings...) |
| `projects` | Portfolio projects featuring before and after showcase images |
| `transformations` | AI transformations with room type, style, prompt, status (`PENDING`, `PROCESSING`, `COMPLETED`, `FAILED`) |
| `quote_requests` | Formal renovation quote submissions linked to user and transformation |
| `favorites` | Saved projects and designs |
| `notifications` | User alerts and transformation completion status |

---

## 🚀 Getting Started

### 1. Prerequisites
- **Java 21 JDK** installed
- **Maven 3.9+** (or use `./mvnw`)
- **PostgreSQL 16** running locally
- **Flutter SDK** (3.24+)

---

### 2. Backend Setup & Run

1. **Start PostgreSQL service & create database:**
   ```bash
   brew services start postgresql@16
   psql -U $(whoami) -d postgres -c "CREATE DATABASE renodesign;"
   ```

2. **Configure environment variables in `backend/.env`:**
   ```env
   DATABASE_URL=jdbc:postgresql://localhost:5432/renodesign
   DATABASE_USERNAME=your_username
   DATABASE_PASSWORD=
   JWT_SECRET=404E635266556A586E3272357538782F413F4428472B4B6250645367566B5970

   # Choose one AI provider:
   AI_PROVIDER=stability
   AI_API_KEY=your_stability_ai_key
   # or replicate / openai
   ```

3. **Run automated test suite:**
   ```bash
   cd backend
   ./mvnw test -Dspring.profiles.active=test
   ```

4. **Launch Spring Boot backend:**
   ```bash
   ./mvnw spring-boot:run
   ```
   Backend will start on `http://localhost:8081`.  
   Swagger UI is accessible at: `http://localhost:8081/swagger-ui.html`

---

### 3. Mobile Setup & Run

1. **Configure API base URL in `mobile/.env`:**
   - For Android Emulator:
     ```env
     API_BASE_URL=http://10.0.2.2:8081
     ```
   - For Physical Android Phone (connected on same Wi-Fi):
     ```env
     API_BASE_URL=http://<YOUR_COMPUTER_LOCAL_IP>:8081
     ```
   - For macOS Desktop / Web:
     ```env
     API_BASE_URL=http://localhost:8081
     ```

2. **Fetch dependencies & run Flutter:**
   ```bash
   cd mobile
   flutter pub get
   flutter analyze
   flutter run
   ```

---

## 🔑 Seed User Accounts

Pre-populated in database with sample transformations and projects:

- **Admin Account:**
  - Email: `admin@renodesign.com`
  - Password: `Admin123!`
  - Role: `ROLE_ADMIN`
- **Client Account:**
  - Email: `client@renodesign.com`
  - Password: `Client123!`
  - Role: `ROLE_CLIENT`

---

## 🎨 UI Design System & Brand Identity

* **Primary Accents:** Champagne Gold (`#C5A059`), Tuscan Gold (`#E5C578`)
* **Backgrounds:** Deep Obsidian (`#0D0E12`), Rich Slate Surface (`#15171D`)
* **Editorial Headlines:** Playfair Display
* **Interface Body & Metadata:** Plus Jakarta Sans
* **Core Interactive Widgets:**
  - `BeforeAfterSlider`: Smooth drag comparison with divider line and gold handle
  - `GlassContainer`: Frosted glass containers with blur filter
  - `HeroBanner`: Visual showcase with CTA
  - `TransformationWorkflowScreen`: 5-step intuitive architectural customizer
