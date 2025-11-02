# Class Manager - Implementation Checklist

## Files to Modify

**Important** : This document is a help not to be taken as complete. You need to write any missing methods. The exam requirment is given inside the word file.

### 1. DAOs (Database Access Objects)

- [ ] `lib/core/data/database/daos/class_dao.dart`

  - [ ] Add appropriate Floor annotations to the class and all methods
- [ ] `lib/core/data/database/daos/student_dao.dart`

  - [ ] Add appropriate Floor annotations to the class and all methods

### 2. Navigation

- [ ] `lib/core/navigations/app_router.dart`
  - [ ] Implement route for path: '/'
  - [ ] Implement route for path: '/class/:id/students'
  - [ ] Implement route for path: '/class/:classId/edit-student/:studentId'

### 3. Providers

- [ ] `lib/features/dashboard/presentation/providers/class_provider.dart`

  - [ ] Implement build() method
  - [ ] Implement getClassById() method
- [ ] `lib/features/dashboard/presentation/providers/student_provider.dart`

  - [ ] Implement build() method
  - [ ] Implement getStudentsByClass() method
  - [ ] Implement addStudent() method
  - [ ] Implement updateStudent() method
  - [ ] Implement deleteStudent() method
  - [ ] Implement getStudentById() method

### 4. Screens

- [ ] `lib/features/dashboard/presentation/screens/dashboard_screen.dart`

  - [ ] Implement dashboard UI with ListView
  - [ ] Load classes using the profider
  - [ ] Handle loading/error/data states
  - [ ] Navigate to students screen when class card is tapped
- [ ] `lib/features/dashboard/presentation/screens/students_by_class_screen.dart`

  - [ ] Implement students list UI
  - [ ] Load class and students for specific class
  - [ ] Display students in ListView using StudentCard widget
- [ ] `lib/features/dashboard/presentation/screens/add_edit_student_screen.dart`

  - [ ] Implement student form UI
  - [ ] Load student data if studentId exists
  - [ ] Save student data (add or update)

### 5. Widgets

- [ ] `lib/features/dashboard/presentation/widgets/student_card.dart`
  - [ ] Implement navigation to edit student screen (Edit button)
  - [ ] Implement delete functionality (Delete button)

## Notes

- Database and repository layers are already implemented
- StudentCard widget UI is provided - only implement the navigation/actions
- Use ref.watch() to load data in screens
- Use ref.read() to call provider methods
