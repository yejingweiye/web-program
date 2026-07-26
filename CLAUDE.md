# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

同城分层社区搭子平台 — A full-stack same-city tiered community social platform with Vue3 frontend and Spring Boot 3.x backend.

## Quick Start

```bash
bash start.sh    # Start both backend (port 8080) and frontend (port 5173)
bash stop.sh     # Stop both services
```

**Prerequisites**: JDK 17 (required), Node.js, Docker (for MySQL), Maven 3.9.x.

**Database**: MySQL 8.0 via Docker container `mysql-dazi-community` on port 3306, user `root` / password `123456`. DB `dazi_community` initialized with 25 tables.

**Test login**: Any phone number + any verification code (e.g. `13800138001` + `1234`).

## Build Commands

```bash
# Backend
cd dazi-community-backend
JAVA_HOME=/usr/local/Cellar/openjdk@17/17.0.19/libexec/openjdk.jdk/Contents/Home mvn clean package -DskipTests

# Frontend
cd dazi-community-frontend
npm install
npm run dev          # Dev server
npm run build        # Production build (vue-tsc check + vite build)
```

## Key Architecture

### Backend (`dazi-community-backend/`)

Spring Boot 3.2.5 + MyBatis-Plus 3.5.7 + MySQL 8.0 + JWT + WebSocket

- **package**: `com.dazi.community`
- **Entry**: `DaziCommunityApplication.java` with `@MapperScan("com.dazi.community.mapper")`
- **API prefix**: `/api/v1/`
- **Auth**: JWT via `JwtInterceptor` — GET requests are public, POST/PUT/DELETE require `Authorization: Bearer <token>`. User ID extracted from token and set as `request.getAttribute("userId")`.
- **Auth flow**: `/auth/login` → get JWT token → attach to subsequent requests
- **Real-name tiers**: 0=未实名, 1=手机实名, 2=人脸实名 (face auth requires admin approval)
- **Lombok**: Entity classes use `@Data`. Lombok annotation processor is configured in `pom.xml`.
- **DB column naming**: Uses `description` (not `desc` which is a MySQL reserved word).
- **Unified response**: `Result<T>` with `{code, msg, data}` format.
- **Exception handling**: `BusinessException` → `GlobalExceptionHandler` → proper error codes.
- **Payment**: Demo mode — all payments auto-set to `pay_status=1` (paid).
- **Profile**: `application-dev.yml` activates by default with `spring.profiles.active: dev`.

### Frontend (`dazi-community-frontend/`)

Vue 3 + Vite + TypeScript + Element Plus + Pinia + Axios

- **Router**: Hash mode (`createWebHashHistory`), lazy-loaded routes in `src/router/index.ts`
- **API layer**: `src/api/*.ts` — each module maps to a backend controller
- **Auth**: Token stored in localStorage via `src/utils/token.ts`. Axios interceptor in `src/utils/request.ts` auto-attaches `Authorization` header and handles 401 redirects.
- **State**: Pinia stores in `src/stores/`
- **Vite proxy**: `/api` → `localhost:8080`, `/ws` → `ws://localhost:8080`
- **CSS**: Design tokens via CSS custom properties in `src/assets/style.css`. Theme colors use Indigo primary (`--primary: #6366f1`).

### Database (`dazi-community-backend/sql/`)

3-tier community model: `community_first` (fixed 6 categories) → `community_second` (user-created) → `circle_info` (private/public circles)

Key tables: `sys_user`, `user_face_auth`, `community_first`, `community_second`, `community_manager`, `community_member`, `community_join_apply`, `circle_info`, `circle_member`, `post_info`, `post_comment`, `post_like`, `activity_info`, `activity_order`, `top_order`, `vip_package`, `vip_order`, `chat_message`, `report_info`, `shop_info`, `manager_income_log`, `sys_config`.

All tables have `create_time`, `update_time`, `delete_flag` (logical delete).

### Seed Data

```bash
cd dazi-community-backend/sql
# init.sql — schema + base data (6 community categories, 4 VIP packages)
# seed_data.sql — 8 users, 12 communities, 20 posts, 30 comments, 6 activities, 7 circles
# Import: docker cp sql/seed_data.sql mysql-dazi-community:/tmp/ && docker exec mysql mysql -uroot -p123456 -e "source /tmp/seed_data.sql"
```
