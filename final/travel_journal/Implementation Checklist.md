# Travel Journal - Implementation Checklist

## Overview

This exam requires you to implement a complete Flutter application using **Supabase** as the backend. You will work with two related entities: **Trips** and **Activities** (one-to-many relationship).

**Important**: This document is a guide to help you. The complete exam requirements are in the Word file.

---

## Setup Steps

### 1. Supabase Project Setup

- [ ] Create a new Supabase project at [supabase.com](https://supabase.com)
- [ ] Run `supabase/01_create_tables.sql` in SQL Editor to create tables
- [ ] Run `supabase/02_seed_data.sql` in SQL Editor to insert sample data
- [ ] Copy your Supabase URL and anon key from Project Settings > API

### 2. Environment Configuration

- [ ] Update `.env` file with your Supabase credentials:
  ```
  SUPABASE_URL=https://your-project.supabase.co
  SUPABASE_ANON_KEY=your-anon-key
  ```

---

## Files to Implement

### 1. Supabase Repository (`lib/features/dashboard/data/repository/`)

- [ ] `trip_repo_supabase.dart`

  - [ ] Implement `getTrips()` - Return Stream of all trips using `.stream()`
  - [ ] Implement `getTripById(int id)` - Fetch single trip by ID
  - [ ] Implement `addTrip(Trip trip)` - Insert new trip
  - [ ] Implement `updateTrip(Trip trip)` - Update existing trip
  - [ ] Implement `deleteTrip(Trip trip)` - Delete trip by ID
- [ ] `activity_repo_supabase.dart`

  - [ ] Implement `getActivities()` - Return Stream of all activities
  - [ ] Implement `getActivitiesByTrip(int tripId)` - Filter activities by trip_id
  - [ ] Implement `addActivity(Activity activity)` - Insert new activity
  - [ ] Implement `updateActivity(Activity activity)` - Update existing activity
  - [ ] Implement `deleteActivity(Activity activity)` - Delete activity by ID

### 2. Repository Providers (`lib/features/dashboard/presentation/providers/`)

- [ ] `repo_providers.dart`
  - [ ] Create `tripRepoProvider` - Wire TripRepoSupabase to Supabase client
  - [ ] Create `activityRepoProvider` - Wire ActivityRepoSupabase to Supabase client

### 3. State Providers (`lib/features/dashboard/presentation/providers/`)

- [ ] `trip_provider.dart`

  - [ ] Create `tripNotifierProvider` using AsyncNotifier
  - [ ] Implement `build()` - Subscribe to trips stream
  - [ ] Implement `addTrip(Trip trip)`
  - [ ] Implement `updateTrip(Trip trip)`
  - [ ] Implement `deleteTrip(Trip trip)`
  - [ ] Implement `getTripById(int id)`
- [ ] `activity_provider.dart`

  - [ ] Create `activityNotifierProvider` using AsyncNotifier
  - [ ] Implement `build()` - Subscribe to activities stream
  - [ ] Implement `getActivitiesByTrip(int tripId)`
  - [ ] Implement `addActivity(Activity activity)`
  - [ ] Implement `updateActivity(Activity activity)`
  - [ ] Implement `deleteActivity(Activity activity)`

---

## Database Schema

### trips table

| Column      | Type      | Description             |
| ----------- | --------- | ----------------------- |
| id          | int8 (PK) | Auto-generated ID       |
| name        | text      | Trip name               |
| destination | text      | Trip destination        |
| start_date  | text      | Start date (YYYY-MM-DD) |
| end_date    | text      | End date (YYYY-MM-DD)   |
| image_url   | text      | Trip image URL          |

### activities table

| Column       | Type      | Description           |
| ------------ | --------- | --------------------- |
| id           | int8 (PK) | Auto-generated ID     |
| title        | text      | Activity title        |
| description  | text      | Activity description  |
| is_completed | bool      | Completion status     |
| trip_id      | int8 (FK) | Reference to trips.id |

---
