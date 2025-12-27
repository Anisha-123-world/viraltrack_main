Viral Track 🏥

Viral Track is a Flutter-based healthcare application designed to help doctors and healthcare professionals efficiently manage patient records, track consultations, and generate digital prescriptions.

🚀 Key Features

Doctor's Dashboard: Real-time insights including total patients, pending cases, and today's visits.

Patient Management (CRUD): Add, update, search, and delete patient profiles seamlessly.

Advanced Filtering: Filter patients by disease categories (Diabetes, Hypertension, Asthma, etc.) and search by name or diagnosis.

Consultation System: Log symptoms and diagnoses for every visit.

Prescription Builder: Dynamic tool to add or remove medicines during live consultations.

Medical History: Track complete consultation and prescription history for each patient.

🏗️ Architecture & State Management

The app uses Provider-based state management to maintain a clean separation of concerns and ensure a responsive UI.

Core Providers:

DashboardProvider: Manages global app state, doctor's profile, and key statistics.

PatientProvider: Handles patient lists, search, and filtering logic.

ConsultationProvider: Manages prescription states during checkups and saves final consultation history.

🛠️ Technical Stack

Frontend: Flutter

Language: Dart

State Management: Provider

Data Models: Custom models for User, Patient, Consultation, Prescription, and Stats
