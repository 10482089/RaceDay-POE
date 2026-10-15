# RaceDay API Endpoint Plan

## Base URL: `/api`

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|-------------|-------|-------------|---------------|--------------|-------------------|
| **AUTHENTICATION** |
| POST | /auth/register | Create a new user account | None | { email, password, firstName, lastName, role } | 201 Created - new user |
| POST | /auth/login | Log in to the system | None | { email, password } | 200 OK - user details |
| POST | /auth/logout | End user session | Any authenticated | None | 200 OK - logged out |
| **USER PROFILE** |
| GET | /users/profile | Get your own profile | Any authenticated | None | 200 OK - user details |
| PUT | /users/profile | Update your profile | Any authenticated | { firstName, lastName } | 200 OK - updated profile |
| **EVENTS** |
| GET | /events | Get all events | None | None | 200 OK - list of events |
| GET | /events/{id} | Get one event by ID | None | None | 200 OK - event details |
| POST | /events | Create a new event | Organiser | { name, description, date, location, distance, eventTypeId } | 201 Created - new event |
| PUT | /events/{id} | Update an event | Organiser | { name, description, date, location, distance } | 200 OK - updated event |
| DELETE | /events/{id} | Delete an event | Organiser | None | 204 No Content |
| **CATEGORIES** |
| GET | /events/{eventId}/categories | Get categories for an event | None | None | 200 OK - list of categories |
| POST | /events/{eventId}/categories | Add a category to an event | Organiser | { name, description } | 201 Created - new category |
| PUT | /categories/{id} | Update a category | Organiser | { name, description } | 200 OK - updated category |
| DELETE | /categories/{id} | Delete a category | Organiser | None | 204 No Content |
| **ENROLMENTS** |
| POST | /events/{eventId}/enrol | Enrol in an event | Participant | { categoryId } | 201 Created - enrolment |
| GET | /participants/enrolments | Get your enrolments | Participant | None | 200 OK - list of enrolments |
| PUT | /enrolments/{id}/cancel | Cancel an enrolment | Participant | None | 200 OK - cancelled |
| **RESULTS** |
| POST | /events/{eventId}/results | Add results for a participant | Organiser | { enrolmentId, finishTime, finishingPosition, totalFinishers } | 201 Created - result |
| GET | /participants/results | Get your results | Participant | None | 200 OK - list of results |
| GET | /events/{eventId}/results | Get all results for an event | None | None | 200 OK - results list |