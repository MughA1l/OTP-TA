

CHAPTER # 2: ANALYSIS
 

SOFTWARE REQUIREMENT SPECIFICATION
FOR
OT Procedures & Tracking App
VERSION 1.0

Prepared by
Fahad Aziz Dar
Nabeel Afzal

10 April ,2026

                                    REVISION HISTORY	
Version	Description	Author	Date
1.0	This covers the major SRS documents   	Fahad Aziz Dar and Nabeel Afzal	10TH -April -2026
 
2.1 Introduction
In today’s fast-paced healthcare environment, hospitals and medical centers often face challenges in managing Operation Theater (OT) schedules, tracking surgical procedures, and ensuring seamless communication between surgical teams and patients. Patients and their families usually experience anxiety due to a lack of real-time updates regarding surgical statuses. The OT Procedures & Tracking App is designed to solve these problems by providing a centralized digital platform for hospital staff, doctors, and patients. Through the app, administrators can schedule operations, assign surgical teams, and manage records, while patients or their attendants can track real-time surgical progress from their smartphones. Doctors can manage prescriptions, view patient history, and securely communicate with other staff. The app also offers features like automated notifications, secure medical report storage, and detailed post-operation analytics, ensuring a smooth, transparent, and trustworthy medical experience. Overall, the app simplifies OT management, saving time, reducing administrative errors, and improving patient care.
2.1.1 Purpose
The main goal of the OT Procedures & Tracking App is to develop a user-friendly mobile and web platform where hospital staff can manage OT operations efficiently, doctors can track clinical outcomes, and patients can stay updated seamlessly.
This platform will:
•	Allow hospital admins to schedule operations, assign surgical teams, and manage doctor and patient profiles.
•	Enable doctors and medical staff to record operation outcomes, upload medical reports, and manage medication prescriptions.
•	Offer patients a dedicated portal to track real-time operation status, view assigned doctors, and access their check-up history.
•	Provide secure communication channels for real-time chat and emergency alerts among the medical staff.
•	Create a streamlined system that generates automated notifications and comprehensive analytical reports to maintain quality and transparency.
 
2.1.2 Scope
The scope of the OT Procedures & Tracking App is to develop a comprehensive platform that bridges the gap between hospital administration, surgical teams, and patients. The system is designed to meet the critical needs of healthcare facilities by digitalizing the entire operation lifecycle from pre-op scheduling and team assignment to real-time tracking, post-op medication, and outcome reporting. It provides role-based access for Admins, Doctors, and Patients to ensure data security and privacy. The platform will cover all essential functionalities required to operate a modern hospital tracking application, reducing reliance on manual paperwork and ensuring a highly reliable backend performance.
The functional scope of the OT Procedures & Tracking App includes the following main features:
•	Security Management
•	Profile Management
•	Operation & Clinical Reporting
•	Patient Portal Management
•	Medication Management
•	Communication Management
•	Notifications Management
•	Reports & Analytics Management
2.1.3 Definitions, Acronyms, and Abbreviations
Table 2.1.3.1 Table Abbreviations
Term / Abbreviation	Definition
OTPTA	OT Procedures & Tracking App
GUI	Graphical User Interface
Flutter	Mobile app development framework used with Dart programming language
Dart	Programming language used for developing the app
Firebase	Cloud-based platform used for authentication, database, and backend services
Cloudinary	Cloud storage service used for securely storing medical images and reports
UML	Unified Modelling Language
CRUD	Create, Read, Update, Delete – standard database operations
API	Application Programming Interface used to connect different system components
Draw.io	Designing tool
2.1.4 Overview
This document describes the requirements for the OT Procedures & Tracking App (OTPTA). The requirements were gathered after discussions with healthcare professionals, hospital administrators, and potential patients to understand the key challenges in tracking OT procedures and post-op care. The system aims to streamline the process of recording operations, tracking patient status, and managing clinical reports. Additionally, the app includes medication reminders, secure communications, and detailed analytics to ensure a reliable and user-friendly experience for all stakeholders involved.
2.2 Functional Requirements
2.2.1 Security Management
2.2.1.1 Process SignIn
SRS-1	The system shall allow registered users (Admin, Doctor, Patient) to sign in using their email and password.
SRS-2	The system shall verify credentials and redirect the user to their specific dashboard based on their role.
SRS-3	The system shall store user session data securely to maintain the login state.
SRS-4	If credentials are invalid, the system shall deny access and display an error message like "Invalid Email or Password".
2.2.1.2 Process SignUp
SRS-5	The system shall allow the Admin to register new Doctors and staff by providing details such as name, email, phone number, and specialty.
SRS-6	The system must validate that all required fields are filled and the password meets strict security policies (min 8 chars, 1 uppercase, 1 number, 1 special char).
SRS-7	Email and phone number must be unique for each user account to prevent duplication.
SRS-8	Upon successful registration, the system shall encrypt the password and store user data securely.
SRS-9	The system shall display a success message ('Registered Successfully').
2.2.1.3 Forgot Password
SRS-10	Users can request to reset their password if they forget it by entering their registered email.
SRS-11	The system sends a secure verification link via email for a password reset.
SRS-12	Upon clicking the link, the system shall allow the user to enter and confirm a new password following the security policy.
SRS-13	The system confirms the successful reset of the password and redirects the user to login again.
2.2.1.4 Change Account Password
SRS-14	Logged-in users can change their password from their account settings panel.
SRS-15	The user must enter their old password before setting a new one.
SRS-16	The system must store the updated password securely in encrypted form and display a snackbar message 'Password Updated Successfully'.
2.2.1.5 Manage Role Permissions
SRS-17	The system shall allow the Admin to define and modify access permissions for different roles (Lead Surgeon, Nurse, Receptionist).
SRS-18	The system shall restrict unauthorized roles from accessing sensitive medical reports or operation editing screens.
2.2.2 Profile Management
2.2.2.1 Manage Staff Profile
SRS-19	The system shall allow the Admin to register staff members (e.g., Nurses, Receptionists, Lab Technicians) by entering their personal details, contact information, and job role.
SRS-20	The system shall validate that all mandatory fields are filled before saving the staff profile.
SRS-21	Upon successful registration, the system shall generate a unique Staff ID and display a snackbar message 'Staff Profile Created Successfully'.
SRS-22	The system shall allow the Admin to update existing staff profiles, including modifying their contact details, job roles, and shift allocations.
SRS-23	The system shall automatically assign specific system access permissions based on the staff member's selected job role.
2.2.2.2 Manage Patient Profile
SRS-24	The system shall allow Admins/Reception to register patients by entering personal data, medical history, and emergency contacts.
SRS-25	The system shall allow updates to the patient profile and generate a unique Patient ID for tracking.
SRS-26	The system shall validate that all mandatory fields (e.g., name, contact, emergency info) are filled before saving the patient profile
SRS-27	Upon successful registration, the system shall display a snackbar message ‘Patient Profile Created Successfully
SRS-28	The system shall allow the Patient to view and update their basic personal details (e.g., phone number, address, profile picture) from the Patient Portal
2.2.2.3 View User Profiles
SRS-29	The system shall allow authorized users to view lists of registered doctors and patients using search and filter options.
SRS-30	The system shall display relevant profile details without exposing sensitive passwords or unauthorized medical data.
2.2.2.4 Manage Account Status
	
SRS-31	The system shall allow the Admin to activate, deactivate, or suspend any user’s account (Doctor or Patient).
SRS-32	When a deactivated user attempts to log in, the system shall display 'Your Account Has Been Deactivated. Please Contact Admin'.
2.2.3 Doctor Management
2.2.3.1 Add Doctor Profile & Specializations
SRS-33	The system shall allow the Admin to create a new doctor profile by entering details such as Name, Contact, Email, Qualifications, and Specializations.
SRS-34	The system shall validate all mandatory fields before form submission. If any required field is empty, the system shall prompt an error message "Required Fields Cannot Be Empty."
SRS-35	Upon successful creation, the system shall store the data in the database and display a snackbar message "Doctor Profile Added Successfully."
2.2.3.2 Update Doctor Profile & Specializations
SRS-36	The system shall allow the Admin or the respective Doctor to edit and update their profile details and add new specializations.
SRS-37	The system shall track and log the timestamp of the last profile update for audit purposes.
SRS-38	Upon successful update, the system shall reflect the changes in real-time and display a message "Profile Updated Successfully."

 
2.2.3.3 Manage Doctor Availability & Duty Timings
SRS-39	The system shall allow the Admin or Doctor to configure weekly availability, specifying working days and shift timings (Start Time and End Time).
SRS-40	The system shall allow marking specific dates as "On Leave" or "Unavailable" to block those dates from future appointment bookings.
SRS-41	The system shall prevent overlapping shifts for the same doctor and display a conflict error if an overlap is detected.
2.2.3.4 Manage Appointment
SRS-42	The system shall allow the scheduling authority (Admin/Receptionist) to book, reschedule, or cancel appointments based on the doctor’s real-time availability.
SRS-43	The system shall automatically update the appointment status (e.g., Pending, Confirmed, Cancelled, Completed).
SRS-44	If an appointment is cancelled, the system shall immediately free up the respective time slot for new bookings.
2.2.3.5 View Assigned Patients
SRS-45	The system shall provide a dashboard for the Doctor to view a list of all patients assigned to them for the current day.
SRS-46	The system shall display key details in the list, including Patient ID, Name, Appointment Time, and Current Status (Waiting, In-Checkup).
SRS-47	The system shall allow doctors to search for specific patients or filter the list by date to view upcoming or past patient assignments.
2.2.3.6 Track Doctor Workload
SRS-48	The system shall provide analytics view for the Admin showing the total number of active appointments and scheduled operations per doctor.
SRS-49	The system shall visually flag or generate a warning notification if a doctor's daily patient limit exceeds the predefined maximum threshold (e.g., more than 25 patients/day).
2.2.4 Patient Portal Management
2.2.4.1 View Patient Dashboard
SRS-50	The system shall provide patients with a dashboard displaying their upcoming schedules, recent reports, and current status.
SRS-51	The system shall display a clear "No active schedules" message if the patient does not have any ongoing or upcoming operations
SRS-52	The system shall ensure the dashboard layout is fully responsive, updating dynamically without requiring the user to manually refresh the page.
2.2.4.2 Track Current Status
SRS-53	The system shall allow patients/attendants to view real-time surgical progress (e.g., Pre-Op, In Surgery, Recovery Room).
SRS-54	The status shall automatically refresh based on updates made by the OT staff.
2.2.4.3 View Assigned Doctor
SRS-55	The system shall display the primary surgeon’s profile and contact details to the patient within the portal.
SRS-56	The system shall ensure data privacy by hiding the doctor's personal contact information (like personal mobile number) from the patient view.
SRS-57	The system shall allow the patient to view the doctor's specialty, PMDC number, and overall experience for assurance and trust.
2.2.4.4 Download Operation Report
SRS-58	The system shall allow patients to securely download their discharge summaries and operation reports in PDF format once approved by the doctor.
SRS-59	Upon initiating a download, the system shall show a progress indicator and display a snackbar message "Report Downloaded Successfully"
2.2.4.5 View Check-up History
SRS-60	The system shall maintain and display a chronological log of the patient's past appointments and check-ups.
SRS-61	The system shall allow patients to filter and search their check-up history by date range or specific doctor name
SRS-62	The system shall display a detailed view of a specific check-up (including doctor notes and prescriptions) when the user taps on a history record.
2.2.5 Operation & Clinical Reporting
2.2.5.1 Create Operation Record
SRS-63	The system shall allow Admins or Lead Surgeons to create a new operation record selecting the patient, surgery type, date, and OT room number.
SRS-64	Upon successful creation, the system shall display a snackbar message “Operation Record Created Successfully.”
2.2.5.2 Assign Surgical Team
SRS-65	The system shall allow the scheduling authority to assign a primary doctor, anaesthesiologist, and nursing staff to the operation record.
SRS-66	The system shall validate staff availability to prevent scheduling conflicts.
2.2.5.3 Update Surgical Team
SRS-67	The system shall allow the scheduling authority or Lead Surgeon to modify and update the assigned surgical team (primary doctor, anaesthesiologist, or nursing staff) before the operation begins.
SRS-68	The system shall re-validate the availability of the newly selected staff members to ensure there are no scheduling conflicts with other operations or shifts.
SRS-69	Upon successful update, the system shall automatically send a notification to both the newly assigned and the removed staff members regarding the schedule change.
SRS-70	The system shall maintain a log of the team update, recording the timestamp and the user who made the changes for audit purposes.
2.2.5.3 Record Operation Outcome
SRS-71	The system shall allow the assigned doctor to log post-operation details, including surgical outcomes, complications, and patient condition.
SRS-72	The system shall update the operation status to "Completed" once the outcome is submitted.
2.2.5.4 Generate Automated Credentials
SRS-73	The system shall automatically generate temporary login credentials the patient/attendant once an operation is scheduled.
SRS-74	The system shall securely send these credentials via email/SMS for tracking purposes.
2.2.5.5 Upload Medical Reports
SRS-75	The system shall allow medical staff to upload pre-op and post-op lab results, scans, and documents.
SRS-76	The system shall validate file types (PDF, JPG) and securely store them via cloud storage linked to the patient's record.
SRS-77	The system shall restrict the maximum file size for uploads to 5MB (or 10MB) per document
SRS-78	If the file size exceeds the limit or the format is invalid, the system shall display an error message "Invalid File or Size Exceeded"
2.2.5.6 View Operation History
SRS-79	The system shall allow doctors and admins to view past operations filtered by date, surgeon, or patient ID.
SRS-80	The system shall support pagination or infinite scroll for large historical records.
2.2.6 Medication Management
2.2.6.1 Add Medicine Prescription
SRS-81	The system shall allow doctors to digitally prescribe medicine, including drug name, dosage, and frequency.
SRS-82	The system shall validate that all mandatory fields are filled before allowing the doctor to submit the prescription.
SRS-83	Upon submission, the system shall display a snackbar message “Prescription Added Successfully” and update the patient's portal.
2.2.6.2 Update Medicine Dosage
SRS-84	The system shall allow doctors to edit or update an existing medication dosage based on patient recovery.
SRS-85	The system shall maintain an audit log of all changes made to a prescription (showing old dosage, new dosage, and timestamp) for medical record integrity.
2.2.6.3 View Medication Schedule
SRS-86	The system shall allow patients to view their daily medication timetable clearly formatted in the app.
2.2.7 Communication Management
2.2.7.1 Initiate Real-time Chat
SRS-87	The system shall allow doctors and assigned staff to initiate secure real-time messaging regarding a specific patient or OT schedule.
SRS-88	The chat system must comply with data privacy standards, preventing unauthorized access.

2.2.7.2 View Chat History
SRS-89	The system shall securely archive chat logs and allow participants to view previous communication history.
SRS-90	The system shall provide a "Search" functionality within the chat to allow users to easily find specific keywords, dates, or previously shared files.
SRS-91	The system shall display clear message statuses (Sent, Delivered, Read) along with exact date and time stamps for every message
2.2.7.3 Manage Emergency Alerts
SRS-92	The system shall feature an emergency button that sends an immediate high-priority alert to assigned surgical or ICU teams.
SRS-93	The system shall require the receiving medical staff to tap an "Acknowledge" button, confirming to the sender that the emergency alert has been seen and is being attended to
2.2.8 Notifications Management
2.2.8.1 Send Account Credentials
SRS-94	The system shall automatically send an email and SMS containing temporary login details and a secure verification link to newly registered users.
SRS-95	The system shall enforce a strict expiration time (e.g., 24 hours) on the account verification link for security purposes.
SRS-96	The system shall require the user to change their auto-generated temporary password immediately upon their first successful login.
2.2.8.2 Send Check-up Reminders
SRS-97	The system shall automatically dispatch push notifications and SMS reminders to patients 24 hours and 2 hours prior to their scheduled follow-up check-up.
SRS-98	The reminder notification shall include specific details such as the assigned doctor's name, appointment time, and hospital room/clinic number.
SRS-99	The system shall automatically send an immediate cancellation or rescheduling notification if the doctor updates the appointment time.
2.2.8.3 Push Notifications
SRS-100	The system shall trigger push notifications for status updates, such as when an operation moves from 'In Progress' to 'Recovery'.
2.2.8.4 View Notification History
SRS-101	The system shall provide an in-app notification center where users can view a chronological list of all previously received alerts and messages.
SRS-102	The system shall display an "Unread Badge" counter on the notification icon to indicate the number of new, unseen notifications.
SRS-103	The system shall allow users to mark individual notifications as "Read" or select a "Clear All" option to manage their notification feed effectively.
2.2.9 Reports & Analytics Management
2.2.9.1 Generate Operation Success Reports
SRS-104	The system shall allow the Admin to generate comprehensive analytical reports detailing total operations, success rates, and complication frequencies.
SRS-105	The system shall provide dynamic filters allowing the Admin to generate these reports based on specific date ranges (e.g., weekly, monthly), surgery types, or specific OT rooms.
SRS-106	The system shall represent the generated data visually using interactive graphical elements such as pie charts and bar graphs for quick analysis.
2.2.9.2 Doctor Performance Report
SRS-107	The system shall compile data on completed operations, punctuality, and patient outcomes to generate a performance summary for individual doctors.
SRS-108	The system shall enforce strict access control; a doctor can only view their own performance report, while the Admin has access to all doctors' reports.
SRS-109	The system shall include efficiency metrics in the report, such as the average duration of operations compared to their scheduled times.
2.2.9.3 Patient Recovery Analytics
SRS-110	The system shall track and visualize overall patient recovery times and readmission rates in graphical chart formats.
SRS-111
	The system shall allow administrators to filter recovery analytics by specific surgical procedures or age demographics to identify health trends.
SRS-112	The analytics dashboard shall automatically and dynamically update its charts as new operation outcomes are submitted by the medical staff.
2.2.9.4 my m2.3 Non-Functional Requirements
2.3.1 Performyance Requirements
The system should work smoothly even when multiple hospital staff and patients are accessing it simultaneously. Critical actions like updating operation statuses, sending emergency alerts, and uploading medical reports should respond quickly. The mobile app must show live status updates almost in real-time to prevent patient anxiety.
2.3.2 Usability Requirements
The Flutter mobile app and web platform should be easy to navigate for hospital staff, doctors, and patients of all tech-literacy levels. The system will show clear feedback for all actions through snack bars or alerts. All medical forms will have strict input validation and clear error messages. The mobile app will support both portrait and landscape modes for user convenience.
2.3.3 Security Requirements
Given the sensitive nature of medical data, security is paramount. All passwords will be stored safely using hashed-and-salted methods. Strict Role-Based Access Control (RBAC) will ensure that patients only see their own data, and doctors only access their assigned patients. All sensitive medical records and communications will be transmitted via secure HTTPS connections. Users will be automatically logged out after a period of inactivity for safety.
2.3.4 Reliability Requirements
The system must remain available and reliable 24/7, as hospital operations run round-the-clock. Important features like OT scheduling, emergency alerts, and prescription management will have robust backup systems so they keep working seamlessly. All database records will be backed up regularly to prevent data loss.
2.3.5 Scalability Requirements
The system should be capable of growing smoothly as the hospital expands. The infrastructure must easily accommodate new surgical departments, extra staff members, or an increased volume of patients without reducing system performance or query speeds.
 
2.3.6 Maintainability & Support
The backend and frontend code must be modular, clean, and well-documented. This ensures that when the hospital requires new features (like new medical imaging support) or bug fixes, they can be deployed efficiently.
2.3.7 Compatibility Requirements
The Flutter mobile app will support Android devices running Android 6.0 (API 23) or higher, ensuring patients with older devices can easily track statuses. The UI will be fully responsive and will automatically adjust to different screen sizes, including medical tablets used by doctors.
2.4 External Interface Requirements
This section outlines how the OT Procedures & Tracking App will interact with users, hardware, external software, and communication protocols.
2.4.1 User Interfaces:
The application is designed following Google’s Material Design guidelines to ensure a modern, clean, and distraction-free experience suitable for medical environments.
•	Mobile Interface: The Flutter-based UI will be responsive, adjusting layouts for various screen sizes (from patients' phones to doctors' tablets).
•	Web Portal: The Admin and Reception dashboard will be optimized for standard browsers (Chrome, Firefox, Edge) with a minimum resolution of 1366x768.
•	Consistency: Standardized error messages, medical color schemes (e.g., calming blues and whites), and readable fonts (e.g., Roboto) will be used across all screens.
2.4.2 Hardware Interfaces:
The application requires interaction with specific physical components of the device:
•	Camera & Gallery: Required for medical staff to scan and upload physical lab reports or patient documents.
•	Notification/Vibration Motor: Critical for immediately alerting doctors via hardware vibration for emergency alerts.
•	Network Hardware: Utilizes the device’s Wi-Fi or Cellular Data to communicate with the hospital's backend server.
•	Storage: Minimal local storage access is needed to cache user session data and temporarily save downloaded PDF reports.
2.4.3 Software Interfaces:
The system relies on specific software components and external APIs:
Operating System:
•	Android: Compatible with Android 6.0 (Marshmallow, API 23) and above.
•	Web: Compatible with modern HTML5-compliant web browsers.
•	Database Engine: The app will interact with Firebase Firestore (or a HIPAA-compliant equivalent) for storing user data, operation logs, and chat histories.
Third-Party APIs:
•	Cloudinary/Firebase Storage: For secure storage and retrieval of medical documents and images.
•	Push Notifications: Usage of Firebase Cloud Messaging (FCM) to deliver real-time OT status alerts to the app.
2.4.4 Communication Interfaces:
•	Communication Protocol: All data transfer between the client (App/Web) and the server will strictly occur over HTTPS (Hypertext Transfer Protocol Secure) to ensure patient data privacy during transit.
•	Data Format: The system will use JSON (JavaScript Object Notation) for lightweight and fast data exchange in API requests.
•	RESTful Architecture: The backend will expose RESTful APIs that the Flutter app will consume to perform critical operations like scheduling, reporting, and data retrieval.
 
Use Case Diagram
FOR
OT Procedures & Tracking App
VERSION 1.0

Prepared by
Fahad Aziz Dar
Nabeel Afzal

4 May,2026

















                                    REVISION HISTORY	
Version	Description	Author	Date
1.0	This covers the major Use case Diagram   	Fahad Aziz Dar and Nabeel Afzal	4 -May -2026

 
2.5 Use Case Diagram  
 
 
Full Dressed Use Case 
FOR
OT Procedures & Tracking App
VERSION 1.0

Prepared by
Fahad Aziz Dar
Nabeel Afzal

4 May,2026

















                                    REVISION HISTORY	
Version	Description	Author	Date
1.0	This covers the major Full dressed Use case.	Fahad Aziz Dar and Nabeel Afzal	4 -May -2026

 
2.6 Full Dressed Use Case

Use Case ID: 				UC-01 
Use Case Name: 			Process Sign In
Use Case Prepared by: 		Fahad Aziz Dar
Use Case Updated by: 		Nabeel Afzal
Use Case Prepared On: 		6th May,2026
Use Case Updated On: 		6th May,2026
            Use Case Description:	This use case describes how a registered user (Admin, Doctor, or Patient) securely signs into the system using their email and password, and is redirected to their specific dashboard based on their role.
Primary Actors:			Admin, Doctor, Patient
Stakeholders & Interest:	1. Admin/Doctor/Patient: Wants to securely log into the system to access their specific dashboard and features.
2. Needs to verify credentials, ensure unauthorized access is denied, and securely maintain user session data.
Pre-Conditions:			1) System must be in a running state.
2) The user must have an already registered and    active account in the system.
3) The user must not be currently logged in.
Main Success Scenario:
User Action	System Response
1. User navigates to the SignIn screen.	
	2. System displays the SignIn form requiring Email and Password
3. User enters their registered Email and Password.
	
	4. User clicks the "Sign In" or "Login" button.
	5. System verifies the provided credentials against the database records.
	6. System identifies the user's specific role (Admin, Doctor, or Patient).
	7. System stores user session data securely to maintain the login state.
	8. System redirects the user to their specific dashboard based on their role.
Post-Conditions:	The user is successfully authenticated, a secure active session is established, and the user is positioned at their respective role-based dashboard.
Extension Points:
5a. Invalid Credentials:
•	System detects that the entered email or password does not match the database records.
•	System denies access to the dashboard.
•	System displays an error message: "Invalid Email or Password".
•	User remains on the SignIn screen and is prompted to try again.
3a. Missing Required Fields (Optional but recommended):
•	System detects that either the email or password field is left empty.
•	System highlights the missing fields and prevents form submission.
Priority: 				 HIGH
Frequency:				 HIGH (Very frequent in use)
Cross-Reference: 			 SRS-1, SRS-2, SRS-3, SRS-4


Use Case ID:				 UC-02
Use Case Name:			Process SignUp
Use Case Prepared by: 		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On:		6th May, 2026
   Use Case Description:	This use case describes the process where an                Admin registers new Doctors and staff members into the system by providing their professional and personal details while ensuring security and data uniqueness.
Primary Actors:				Admin
Stakeholders & Interest:	Admin: Wants to efficiently register new staff/doctors to the platform.
System: Needs to ensure all data is valid, passwords are secure, and no duplicate accounts are created.
Pre-Conditions:			1) Admin must be logged into the system.
2) Admin must have the authority to access the Registration/Add User module.
Main Success Scenario:
User Action	System Response
1. Admin clicks on the "Register New Doctor/Staff" button.	
	2. System displays the registration form (Name, Email, Phone, Specialty, Password).
 3. Admin enters the Name, Email, Phone number, and Specialty.	
4. Admin sets a password for the new user.                                                                                       	                                                                                       
5. Admin clicks the "Submit" or "Register" button.	                                                                                                                   
	 6. System validates that all mandatory fields are completed.                                                                                                                     
	7. System validates that the password meets security policies (8 chars, 1 uppercase, 1 number, 1 special char).
	8. System checks for uniqueness of Email and Phone number.
	9. System encrypts the password and stores user data securely in the database.
	10. System displays a success message: 'Registered Successfully'.
  Post-Condition:	A new Doctor or Staff account is successfully created and stored in the database with an encrypted password.
Extension Points:
6a. Missing Required Fields:
•	System highlights empty fields.
•	User is prompted to fill all required information.
7a. Weak Password:
•	System detects password doesn't meet criteria (e.g., missing special char).
•	System displays an error message regarding security policy.
8a. Duplicate Email/Phone:
•	System detects that the Email or Phone number is already registered.
•	System displays an error message and prevents account creation.
Priority:				HIGH
Frequency:				Medium (Used when new staff is hired)
Cross-Reference:			SRS-5, SRS-6, SRS-7, SRS-8, SRS-9


Use Case ID:				UC-03
Use Case Name:			Forgot Password
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On:		6th May, 2026
Use Case Description:	This use case describes how a user can securely reset their password if they have forgotten it, using their registered email address to receive a verification link.
Primary Actors:			Admin, Doctor, Patient (Any Registered User)
Stakeholders & Interest: 	User: Wants to regain access to their account securely.
System: Needs to verify the user's identity via email and ensure the new password meets security standards.
Pre-Conditions:	1) User must have a registered email address in the system.
2) User must be on the SignIn/Login screen.
 
Main Success Scenario:
User Action	System Response
1. User clicks on the "Forgot Password" link on the Login screen.	
	2. System displays a form asking for the registered email address.                                                                                                             
3. User enters their registered email address and clicks "Submit".	                                                                                                                        
	4. System validates that the email exists in the database.                                                                                                                    
                                                                                                                        	5. System generates and sends a secure verification link to the user’s email.
  6. User opens their email and clicks on the verification link.	
  	                                                                                                                     7. System validates the link and displays the "Reset Password" form.
8. User enters a new password and confirms it.	
	9. System validates that the new password follows the security policy (8 chars, 1 uppercase, 1 number, 1 special char).
10. User clicks "Reset Password".	
	11. System updates the password in the database, displays a success message, and redirects the user to the Login screen.
Post-Conditions:	The user's old password is replaced with the new one, and the user is redirected to the login screen to authenticate with the new credentials.
Extension Points:
4a. Email Not Found:
•	System detects the email is not registered.
•	System displays an error message: "Email address not found."
7a. Expired/Invalid Link:
•	System detects the link has expired or is invalid.
•	System displays an error and prompts the user to request a new link.
9a. Password Mismatch / Weak Password:
•	System detects passwords do not match or fail security policy.
•	System prompts the user to correct the password according to requirements.
Priority:				HIGH
Frequency:				Moderate
Cross-Reference:			SRS-10, SRS-11, SRS-12, SRS-13


Use Case ID:				UC-04
Use Case Name:			Change Account Password
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On:		6th May, 2026
Use Case Description:	This use case describes how a logged-in user can change their existing password from their account settings panel by verifying their old password and providing a new secure one.
Primary Actors:			Admin, Doctor, Patient (Any Logged-in User)
Stakeholders & Interest:	User: Wants to update their password for better security or personal preference.
System: Needs to verify the current password and ensure the new password is encrypted and stored safely.
Pre-Conditions:	1) User must be successfully logged into the system.
2) User must have access to the Account Settings panel.
Main Success Scenario:
User Action	System Response
1. User navigates to the Account Settings panel.	
	2. System displays the "Change Password" option.
3. User clicks on "Change Password".	
	4. System displays a form asking for the Old Password, New Password, and Confirm New Password.
5. User enters the current (Old) password.	
6. User enters and confirms the new password.	
	7. System verifies if the Old Password matches the current database record.
	8. System validates that the New Password meets security policies.
9. User clicks the "Update Password" button.	
	10. System encrypts the new password and updates it in the database.
	11. System displays a snackbar message: 'Password Updated Successfully'.
Post-Conditions:	The user's password is successfully updated in the system, and they can continue using their session with the new credentials for future logins.
Extension Points:
7a. Incorrect Old Password:
•	System detects that the entered old password is incorrect.
•	System displays an error message: "Incorrect current password."
•	Password update is prevented.
8a. Password Mismatch / Security Policy Failure:
•	System detects that the "New Password" and "Confirm Password" fields do not match.
•	System detects that the new password does not meet the 8-character, uppercase, number, and special character criteria.
•	System prompts the user to correct the entries.
Priority:				MEDIUM
Frequency:	Moderate (Used occasionally for security maintenance)
Cross-Reference:			SRS-14, SRS-15, SRS-16


Use Case ID:				UC-05
Use Case Name:			Manage Role Permissions
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On:		6th May, 2026
Use Case Description:	This use case describes how the Admin defines, modifies, and restricts access levels for various roles like Lead Surgeon, Nurse, and Receptionist to ensure that sensitive medical data and operation screens are only accessible to authorized personnel.
Primary Actors:			Admin
Stakeholders & Interest:	Admin: Wants to maintain system integrity by controlling who can see or edit sensitive information.
Medical Staff (Lead Surgeon/Nurse): Need appropriate access to perform their duties while protecting patient privacy.
System: Must strictly enforce role-based access control (RBAC) to prevent unauthorized data breaches.
Pre-Conditions:	1) Admin must be authenticated and logged into the system.
2) Admin must have access to the "Role Management" or "Permissions" settings.
Main Success Scenario:
User Action	System Response
1. Admin navigates to the "Manage Roles" section in the dashboard.	
	2. System displays a list of existing roles (Lead Surgeon, Nurse, Receptionist, etc.).
3. Admin selects a specific role to modify its permissions.	
	4. System displays a checklist of accessible modules (Medical Reports, Operation Editing, etc.).
5. Admin enables or disables specific permissions for that role.	
	6. System validates the changes and ensures critical restrictions are maintained.
7. Admin clicks the "Save Permissions" button.	
	8. System updates the permission matrix in the database.
	9. System applies changes in real-time, restricting unauthorized roles from sensitive screens.
	10. System displays a success message: "Permissions Updated Successfully."
Post-Conditions:	The access rights for the selected role are updated, and the system effectively restricts or allows access to medical reports and operation screens based on the new settings.
Extension Points:
6a. Conflict in Permissions:
•	System detects a conflict (e.g., a role having "Edit" but not "View" access).
•	System prompts the Admin to resolve the logical conflict before saving.
8a. Unauthorized Access Attempt:
•	A user with a restricted role (e.g., Receptionist) attempts to access the "Operation Editing" screen.
•	System denies access and displays an error message: "Access Denied: You do not have permission to view this page."
Priority:				HIGH
Frequency:	Low (Only when roles are defined or policies change)
Cross-Reference:			SRS-17, SRS-18


Use Case ID: 				UC-06
Use Case Name: 			Manage Staff Profile
Use Case Prepared by: 		Fahad Aziz Dar
Use Case Updated by: 		Nabeel Afzal
Use Case Prepared On: 		6th May, 2026
Use Case Updated On: 		6th May, 2026
Use Case Description: 	This use case describes how the Admin registers new staff members (e.g., Nurses, Receptionists, Lab Technicians), updates existing staff profiles, assigns job roles and shift allocations, and how the system automatically grants access permissions based on the selected roles.
Primary Actors: 			Admin
Stakeholders & Interest:	Admin: Wants to easily add, manage, and update staff details to ensure smooth hospital operations and accurate access control.
System: Needs to securely store staff data, validate mandatory fields, generate unique IDs, and correctly apply role-based access permissions.
Pre-Conditions:			1. System must be in a running state.
2. The Admin must be successfully logged into the system.
3. The Admin must have the necessary access rights to view and manage user profiles.
Main Success Scenario:
User Action	System Response
1. Admin navigates to the "Manage Staff Profile" section from the dashboard.	
	2. System displays the staff management interface with options to "Add New Staff" or view/edit existing staff.
3. Admin selects "Add New Staff" and fills in personal details, contact information, and assigns a job role.	
4. Admin clicks the "Save" or "Register" button.	
	5. System validates that all mandatory fields are correctly filled.
	6. System securely saves the data and generates a unique Staff ID for the new employee.
	7. System automatically assigns specific system access permissions based on the staff member's selected job role.
	8. System displays a snackbar message: "Staff Profile Created Successfully."
Post-Conditions: 	The staff profile is successfully created or updated in the database with a unique Staff ID. The staff member is granted appropriate system access permissions corresponding to their job role, and the staff directory is updated.
Extension Points:
5a. Missing Mandatory Fields:
•	System detects that one or more required fields (e.g., Name, Contact, Job Role) are left empty.
•	System prevents the form from submitting.
•	System highlights the missing fields and displays an error message prompting the Admin to fill in the required data.
3a. Update Existing Staff Profile:
•	Admin selects an existing staff member from the directory and clicks "Edit".
•	System populates the form with the staff member's current details.
•	Admin modifies details (e.g., contact info, job role, shift allocations) and clicks "Update".
•	System validates the new inputs, saves the changes, dynamically adjusts system access permissions if the job role was changed, and displays a success message.
Priority: 				HIGH
Frequency: 	MEDIUM (Used whenever a new staff member joins or existing details/shifts need updating)
Cross-Reference: 			SRS-19, SRS-20, SRS-21, SRS-22, SRS-23

Use Case ID:				UC-07
Use Case Name:			Manage Patient Profile
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On:		6th May, 2026
Use Case Description:	This use case describes how Admins or Receptionists register new patients with their medical and emergency details, and how patients can later update their own basic information via a dedicated portal. The system ensures a unique Patient ID is assigned for tracking.
Primary Actors:			Admin, Receptionist, Patient
Stakeholders & Interest:	Patient: Wants to ensure their contact info is correct and accessible.
System: Needs to generate unique IDs, validate mandatory fields, and provide a secure portal for updates.
Pre-Conditions:			1) System must be in a running state.
2)Admin/Receptionist must be logged in to register a patient.
3)Patient must be logged into the Patient Portal to update their own details.

Main Success Scenario:
User Action	System Response
1. Admin/Receptionist selects "Register New Patient".	
	2. System displays a registration form (Personal Data, Medical History, Emergency Contact).
3. User enters the mandatory personal details, medical history, and emergency info.	
4. User clicks the "Submit" or "Save" button.	
	5. System validates that all mandatory fields (Name, Contact, Emergency Info) are filled.
	6. System generates a unique Patient ID for tracking.
	7. System saves the patient profile securely in the database.
	8. System displays a snackbar message: ‘Patient Profile Created Successfully’.
9. Patient logs into the Patient Portal to view/update details.	
	10. System allows the Patient to modify basic details (Phone, Address, Profile Picture).
11. Patient clicks "Update".	
	12. System updates the record and displays a confirmation message.
Post-Conditions:	A new patient record is created with a unique ID, or an existing record is updated, ensuring all data is saved securely in the database.
Extension Points:
5a. Missing Mandatory Fields:
•	System highlights missing fields (e.g., Emergency Contact).
•	System prevents saving and prompts the user to complete the form.
10a. Restricted Access:
•	System prevents the Patient from modifying clinical data (e.g., Medical History) from the Patient Portal.
•	Only basic personal details remain editable for the Patient.
Priority:				HIGH
Frequency:				Very Frequent
Cross-Reference: 			SRS-24, SRS-25, SRS-26, SRS-27, SRS-28


Use Case ID:				UC-08
Use Case Name:			View User Profiles
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		4th May, 2026
Use Case Updated On:		4th May, 2026
Use Case Description:	This use case describes how authorized users (Admins or designated staff) can browse, search, and filter through lists of registered doctors and patients to view their profile details while ensuring sensitive information remains protected.
Primary Actors:			Admin, Authorized Staff
Stakeholders & Interest:	Admin/Staff: Needs to quickly find specific doctor or patient profiles for management or operational tasks.
Doctors/Patients: Expect their sensitive data (passwords, unauthorized medical info) to remain hidden from general view.
System: Must provide efficient search/filter tools while strictly enforcing data privacy rules.
Pre-Conditions:			1) User must be logged into the system.
2)User must have authorized permissions to view user directories.
Main Success Scenario:
User Action	System Response
1. User navigates to the "User Directory" or "View Profiles" section.	
	2. System displays a list of registered doctors and patients.
3. User applies filters (e.g., by Specialty, Role, or Department) or enters a search query (e.g., Name or ID).	
	4. System filters the list in real-time based on the provided criteria.
5. User clicks on a specific profile to view details.	
	6. System retrieves the profile data from the database.
	7. System displays relevant profile details (Name, Contact, Specialty/ID).
	8. System explicitly hides sensitive fields like passwords and unauthorized medical data.
Post-Conditions:	The authorized user successfully views the necessary profile information without any breach of sensitive data.

Extension Points:
4a. No Results Found:
•	System detects no records matching the search/filter criteria.
•	System displays a message: "No profiles found matching your search."
8a. Unauthorized Data Access Attempt:
•	System checks the logged-in user's permission level.
•	If the user tries to access a restricted medical report from the profile, the system blocks the view and displays: "Access Restricted."
Priority:				MEDIUM
Frequency: 				High (Used daily for coordination)
Cross-Reference:			SRS-29, SRS-30


Use Case ID:				UC-09
Use Case Name:			Manage Account Status
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		4th May, 2026
Use Case Updated On:		4th May, 2026
Use Case Description:	This use case describes how an Admin can manage the operational status of any user account (Doctor or Patient) by activating, deactivating, or suspending it, and how the system prevents access for inactive accounts.
Primary Actors:			Admin
Stakeholders & Interest:	Admin: Wants to control system access for security reasons, administrative updates, or disciplinary actions.
Users (Doctor/Patient): Need to know why they cannot access the system if their account is not active.
System: Must strictly enforce status-based access control during the login process to ensure security.
Pre-Conditions:	1) Admin must be logged into the system with administrative privileges.
2)The target user account (Doctor or Patient) must exist in the database.
Main Success Scenario:
User Action	System Response
1. Admin navigates to the "User Management" section.	
	2. System displays a list of all users with their current status (Active, Deactivated, or Suspended).
3. Admin selects a specific user account to modify.	
	4. System provides options to toggle between Activate, Deactivate, or Suspend.
5. Admin updates the status and clicks "Save Changes".	
	6. System updates the status record in the database for that specific User ID.
	7. System displays a confirmation message: "Account status updated successfully."
Post-Conditions:	The user's account status is updated in the database. If the status is anything other than "Active," the user will be blocked from accessing the system in future login attempts.
Extension Points:
34a. Login Attempt by Deactivated User:
•	A user with a "Deactivated" status enters valid credentials.
•	System checks the account status before granting a session.
•	System blocks the login and displays the message: 'Your Account Has Been Deactivated. Please Contact Admin'.
34b. Login Attempt by Suspended User:
•	System detects the account is "Suspended".
•	System prevents access and displays a notification indicating the temporary suspension.
Priority: 				HIGH
Frequency:				Low to Moderate
Cross-Reference:			SRS-31, SRS-32


Use Case ID: 				UC-10
Use Case Name: 			Add Doctor Profile & Specializations
Use Case Prepared by: 		Fahad Aziz Dar
Use Case Updated by: 		Nabeel Afzal
Use Case Prepared On: 		6th May, 2026
Use Case Updated On: 		6th May, 2026
Use Case Description: 	This use case describes how the Admin creates a new doctor profile by entering personal details, qualifications, and specializations into the system.
Primary Actors: 			Admin
Stakeholders & Interest:	Admin: Wants to add new doctors to the hospital system accurately.
System: Needs to validate inputs and securely store the	doctor's profile.
Pre-Conditions:			1. System must be running.
2. Admin must be logged in with appropriate privileges.
Main Success Scenario:
User Action	System Response
1. Admin navigates to the "Doctor Management" module and clicks "Add Doctor".	
	2. System displays a form requesting Name, Contact, Email, Qualifications, and Specializations.
3. Admin fills in all the required details and clicks "Save".	
	4. System validates that all mandatory fields are filled.
	5. System saves the new profile in the database.
	6. System displays a snackbar message "Doctor Profile Added Successfully."
Post-Conditions: 	A new doctor profile is successfully created and available in the system directory.
Extension Points:
4a. Missing Mandatory Fields:
•	System detects empty required fields.
•	System prevents submission and displays an error message: "Required Fields Cannot Be Empty."
•	Admin fills the missing data and submits again.
Priority: 				HIGH
Frequency: 				LOW (Used only when a new doctor joins)
Cross-Reference: 			SRS-33, SRS-34, SRS-35

Use Case ID: 				UC-11
Use Case Name: 			Update Doctor Profile & Specializations
Use Case Prepared by: 		Fahad Aziz Dar
Use Case Updated by: 		Nabeel Afzal
Use Case Prepared On: 		6th May, 2026
Use Case Updated On: 		6th May, 2026
Use Case Description: 	This use case allows an Admin or the respective Doctor to modify existing profile details and add new qualifications or specializations.
Primary Actors: 			Admin, Doctor
Stakeholders & Interest:	Admin/Doctor: Wants to keep profile information accurate and up-to-date.
System: Needs to track update timestamps for audit purposes.
Pre-Conditions:	1. User (Admin or Doctor) is authenticated and logged in.
2. The target Doctor Profile already exists.
Main Success Scenario:
User Action	System Response
1. User selects "Update Profile" from the dashboard or directory.	
	2. System loads the existing doctor details into an editable form.
3. User modifies details (e.g., adds a new specialization) and clicks "Update".	
	4. System validates the updated input data.
	5. System logs the timestamp of the update for audit purposes.
	6. System reflects changes in real-time and displays "Profile Updated Successfully."
Post-Conditions: 	The doctor's profile is updated, and the system maintains a timestamp of the change.
Extension Points:
None.
Priority: 				MEDIUM
Frequency: 				LOW to MEDIUM
Cross-Reference: 			SRS-36, SRS-37, SRS-38

Use Case ID: 				UC-12
Use Case Name: 			Manage Doctor Availability & Duty Timings
Use Case Prepared by: 		Fahad Aziz Dar
Use Case Updated by: 		Nabeel Afzal
Use Case Prepared On: 		6th May, 2026
Use Case Updated On: 		6th May, 2026
Use Case Description: 	This use case describes how to configure a doctor’s weekly working days, shift timings, and mark specific dates as unavailable or on leave.
Primary Actors: 			Admin, Doctor
Stakeholders & Interest:	Admin/Doctor: Wants to ensure patients can only book appointments when the doctor is actually available.
Pre-Conditions:			1. User is logged in.
2. Doctor profile exists.
Main Success Scenario:
User Action	System Response
1. User accesses the "Manage Availability" section for a specific doctor.	
	2. System displays a calendar and weekly shift configuration interface.
3. User inputs weekly working days and sets shift timings (Start/End Time).	
4. User marks specific upcoming dates as "On Leave" and clicks "Save".	
	5. System checks for any overlapping shifts for the same doctor.
	6. System saves the schedule and blocks out the "On Leave" dates from future appointment bookings.
	7. System displays a success message.
Post-Conditions: 	The doctor's schedule is updated, and unavailable dates are blocked from patient bookings.
Extension Points:
5a. Overlapping Shifts Detected:
•	System detects that the entered shift timings conflict with an already assigned shift.
•	System aborts the save operation and displays an error: "Shift Overlap Detected."
Priority: 				HIGH
Frequency: 				MEDIUM
Cross-Reference: 			SRS-39, SRS-40, SRS-41

Use Case ID: 				UC-13
Use Case Name: 			Manage Appointment
Use Case Prepared by: 		Fahad Aziz Dar
Use Case Updated by: 		Nabeel Afzal
Use Case Prepared On: 		6th May, 2026
Use Case Updated On: 		6th May, 2026
Use Case Description: 	This use case allows the scheduling authority to book, reschedule, or cancel a patient's appointment based on the doctor’s real-time availability.
Primary Actors: 			Admin (Receptionist)
Stakeholders & Interest:	Admin/Reception: Wants to efficiently manage patient traffic.
Doctor: Needs an accurate list of daily appointments.
Pre-Conditions:			1. Doctor has configured availability.
2. Patient profile exists in the system.
 
Main Success Scenario:
User Action	System Response
1. User navigates to the "Appointments" module and selects "Book/Manage".	
	2. System displays available time slots based on doctor's duty timings.
3. User selects a time slot, assigns a patient, and clicks "Confirm".	
	4. System updates appointment status to "Confirmed".
5. User selects an existing appointment and clicks "Cancel" (Optional flow).	
	6. System changes status to "Cancelled" and immediately frees up the time slot for new bookings.
Post-Conditions: 	Appointment is successfully created, updated, or cancelled, and time slots are adjusted accordingly.
Extension Points:
None.
Priority: 				HIGH
Frequency: 				HIGH (Daily continuous use)
Cross-Reference: 			SRS-42, SRS-43, SRS-44

Use Case ID: 				UC-14
Use Case Name: 			View Assigned Patients
Use Case Prepared by: 		Fahad Aziz Dar
Use Case Updated by: 		Nabeel Afzal
Use Case Prepared On: 		6th May, 2026
Use Case Updated On: 		6th May, 2026
Use Case Description: 	This use case details how a doctor logs into their dashboard to view, filter, and search the list of patients assigned to them.
Primary Actors: 			Doctor
Stakeholders & Interest:	Doctor: Needs to know who they are treating today and what their current status is.
Pre-Conditions:			1. Doctor is logged into the system.
2. Appointments/Patients have been assigned to the doctor.
Main Success Scenario:
User Action	System Response
1. Doctor navigates to their specific dashboard.	
	2. System retrieves and displays a list of assigned patients for the current day.
	3. System displays Patient ID, Name, Appointment Time, and Current Status (Waiting, In-Checkup).
4. Doctor uses the search bar or date filter to look for a specific patient.	
	5. System updates the list to show filtered results (past or upcoming assignments).
Post-Conditions: 			Doctor successfully reviews their patient schedule.
Extension Points:
2a. No Patients Assigned:
•	System displays a message: "No patients assigned for the selected date."
Priority: 				HIGH
Frequency: 				HIGH (Daily continuous use)
Cross-Reference: 			SRS-45, SRS-46, SRS-47

Use Case ID: 				UC-15
Use Case Name: 			Track Doctor Workload
Use Case Prepared by: 		Fahad Aziz Dar
Use Case Updated by: 		Nabeel Afzal
Use Case Prepared On: 		6th May, 2026
Use Case Updated On: 		6th May, 2026
Use Case Description: 	This use case provides an analytics view for the Admin to monitor the total active appointments and operations per doctor, ensuring no doctor exceeds the maximum patient threshold.
Primary Actors: 			Admin
Stakeholders & Interest:	Admin: Wants to distribute workload evenly and avoid doctor burnout.
Pre-Conditions:			1. Admin is logged into the system.
2. System has active appointment and operation data.
Main Success Scenario:
User Action	System Response
1. Admin navigates to the "Workload Analytics" module.	
	2. System generates a view showing total active appointments and scheduled operations per doctor.
	3. System checks the workload against the predefined maximum threshold (e.g., 25 patients/day).
	4. System visually flags or generates a warning notification if any doctor exceeds the limit.
Post-Conditions: 	Admin successfully reviews workload analytics and receives warnings for overburdened doctors.
Extension Points:
None.
Priority: 				MEDIUM
Frequency: 				MEDIUM (Checked periodically during scheduling)
Cross-Reference: 			SRS-48, SRS-49


Use Case ID:				 UC-16
Use Case Name:			View Patient Dashboard
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On: 		6th May, 2026
Use Case Description:	This use case describes how a patient accesses their personalized dashboard to monitor upcoming surgical schedules, view recent medical reports, and check their current status in real-time across different devices.
Primary Actors:			Patient
Stakeholders & Interest:	Patient: Wants a single, easy-to-use interface to track their surgery status and access medical documents.
Medical Staff: Wants the patient to stay informed about their schedules without manual communication.
System: Must provide a responsive, real-time interface that updates dynamically to ensure data accuracy.
Pre-Conditions:	1) Patient must be logged into the Patient Portal (using credentials from.
2)System must be connected to the internet to fetch real-time updates.
Main Success Scenario:
User Action	System Response
1. Patient logs into the portal and lands on the Dashboard.	
	2. System retrieves the patient's data (Schedules, Reports, Status).
3. Patient views their Upcoming Schedule (Date, Time, OT Room).	
	4. System displays surgery details if an active schedule exists.
5. Patient checks the Recent Reports section.	
	6. System provides clickable links to view/download uploaded lab results or scans.
7. Patient observes their Current Status (e.g., Scheduled, Pre-Op, Completed).	
	8. System ensures the layout adjusts perfectly to the user's screen (Mobile/Tablet/PC).
	9. System dynamically updates the info (e.g., status change) without a page refresh.
Post-Conditions:	The patient is successfully informed of their clinical status and upcoming events via a responsive and dynamic interface.
Extension Points:
4a. No Active Schedules:
•	System detects that there are no upcoming or ongoing operations linked to the Patient ID.
•	System displays a clear message: "No active schedules".
9a. Real-time Update (WebSockets/Polling):
•	If the status is changed by a doctor in the backend, the system pushes the update to the dashboard immediately.
Priority:				HIGH
Frequency:	 High (Used by patients throughout their surgical journey)
Cross-Reference:			SRS-50, SRS-51, SRS-52


Use Case ID: 				UC-17
Use Case Name:			Track Current Status
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On:		6th May, 2026
Use Case Description:	This use case describes how patients and their attendants can monitor the real-time progress of a surgical procedure through various stages (such as Pre-Op, In Surgery, and Recovery) via a dynamic status tracker.
Primary Actors:			Patient, Attendant
Stakeholders & Interest:	Patient/Attendant: Wants real-time updates to reduce anxiety and stay informed about the surgery's progress.
OT Staff: Wants an automated way to communicate progress without manual phone calls or face-to-face updates.
System: Must ensure that status changes made in the OT are instantly reflected on the tracking screen.
Pre-Conditions:	1) The patient/attendant must be logged into the tracking portal using temporary credentials.
2)The surgery must be initiated by the OT staff.
Main Success Scenario:
User Action	System Response
1. Patient/Attendant opens the "Live Track" or "Current Status" page.	
	2. System retrieves the current state of the specific operation from the database.
3. User views the progress bar or status indicator.	
	4. System displays the active stage (e.g., Pre-Op, In Surgery, or Recovery Room).
	5. System listens for real-time updates from the OT backend.
6. (Internal) OT Staff updates the status in the OT module.	
	7. System automatically refreshes the tracking page for the user without manual reload.
	8. System displays the updated status and the time of the last update.
Post-Conditions:	The user is successfully updated on the surgery's real-time progress, ensuring transparency and reducing wait-time stress.
Extension Points:
4a. Operation Delayed:
•	System detects a significant delay beyond the scheduled time.
•	System displays a "Delayed" status or a custom message from the staff.
7a. Connection Lost:
•	System detects a loss of internet connection.
•	System displays a warning: "Live tracking paused. Reconnecting..."
Priority:				HIGH
Frequency:	Very Frequent (Triggered by every status    change in the OT)
Cross-Reference:			SRS-53, SRS-54


Use Case ID:				 UC-18
Use Case Name:			View Assigned Doctor
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On: 		6th May, 2026
Use Case Description:	This use case describes how a patient can view the professional profile of their assigned primary surgeon through the portal. This includes verifying the doctor's credentials and experience while maintaining the doctor's personal privacy.
Primary Actors:			Patient
Stakeholders & Interest:	Patient: Wants to know about the expertise and credentials of the surgeon performing their procedure to build trust.
Doctor: Wants their professional expertise highlighted while keeping personal contact details (like a private mobile number) secure.
System: Must ensure that only authorized professional data is displayed and private data remains hidden.
Pre-Conditions:			1) The Patient must be logged into the portal.
2)A Primary Surgeon must have been assigned to the patient’s operation record (UC-12).
Main Success Scenario:
User Action	System Response
1. Patient navigates to the "My Surgeon" or "Doctor Profile" section in the portal.	
	2. System identifies the Primary Surgeon linked to the patient's active operation record.
3. Patient clicks on the Doctor’s Name/Profile.	
	4. System retrieves the doctor’s professional details from the database.
	5. System displays the Doctor’s Full Name, Specialty, PMDC Number, and Overall Experience.
	6. System displays the official Hospital/Clinic contact details.
	7. System explicitly masks or hides the doctor's personal mobile number and private address.
Post-Conditions:	The patient successfully views the surgeon's professional background and verified credentials, leading to increased assurance and trust in the medical team.
Extension Points:
2a. No Doctor Assigned Yet:
•	System detects that a primary surgeon has not yet been assigned to the operation.
•	System displays a message: "Your surgical team is currently being finalized. Please check back later."
5a. Profile Incomplete:
•	System detects missing professional info (e.g., PMDC number not verified).
•	System displays only the available information and prompts the patient to contact the administration for full details.
Priority:				MEDIUM
Frequency:	Moderate (Usually viewed once or twice per surgery)
Cross-Reference:			SRS-55, SRS-56, SRS-57


Use Case ID:				UC-19
Use Case Name:			Download Operation Report
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On: 		6th May, 2026
Use Case Description:	This use case describes how a patient can securely download their discharge summary and operation reports in PDF format from the portal, provided the reports have been reviewed and approved by the concerned doctor.
Primary Actors:			Patient
Stakeholders & Interest:	Patient: Needs a digital copy of their medical documents for records or insurance purposes.
Doctor: Wants to ensure only finalized and approved reports are accessible to the patient.
System: Must ensure secure delivery of the file and provide visual feedback during the process.
Pre-Conditions:			1) Patient must be logged into the portal.
2) The operation status must be "Completed".
3) The report/discharge summary must be marked as "Approved" by the assigned doctor.
Main Success Scenario:
User Action	System Response
1. Patient navigates to the "My Reports" or "Downloads" section.	
	2. System retrieves a list of approved reports and discharge summaries.
3. Patient clicks on the "Download" icon/button for a specific report.	
	4. System verifies that the report has the "Approved" status flag.
	5. System generates the report in PDF format from the database.
	6. System displays a progress indicator to show the download status.
	7. System initiates the file download to the user's device.
	8. System displays a snackbar message: "Report Downloaded Successfully".
Post-Conditions:	The patient successfully obtains a secure PDF copy of their medical report on their local device.
Extension Points:
4a. Report Not Yet Approved:
•	System detects that the doctor has not yet finalized/approved the report.
•	The download button is disabled, and the system displays: "Report pending doctor's approval."
7a. Download Interrupted:
•	System detects a network failure during the PDF generation or download.
•	System displays an error: "Download failed. Please check your connection and try again."
Priority:				HIGH
Frequency:				Moderate (Once per surgery)
Cross-Reference:			SRS-58, SRS-59


Use Case ID:				UC-20
Use Case Name:			View Check-up History
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On: 		6th May, 2026
Use Case Description:	This use case describes how a patient can access a chronological record of all their previous medical appointments and check-ups. It allows the patient to search for specific visits and view in-depth details such as doctor’s clinical notes and prescribed medications.
Primary Actors:			Patient
Stakeholders & Interest:	Patient: Wants to track their medical progress, review previous prescriptions, and remember doctor advice.
Doctor: Interests lie in the patient having easy access to follow-up instructions and historical data for better health management.
System: Must maintain an organized, searchable log of all past interactions.
Pre-Conditions:			1) Patient must be logged into the portal.
2) Past check-up or appointment records must exist in the system database.
Main Success Scenario:
User Action	System Response
1. Patient navigates to the "Check-up History" or "Past Visits" section.	
	2. System retrieves all past appointment records and displays them in a chronological (date-wise) log.
3. Patient applies a Date Range filter or searches by a Specific Doctor Name.	
	4. System filters the list and displays the matching records.
5. Patient taps/clicks on a specific history record.	
	6. System fetches and displays the detailed view of that check-up.
	7. System shows the Doctor’s Notes, Prescriptions, and Diagnosis for that visit.
Post-Conditions:	The patient successfully reviews their past medical history and details of specific consultations.
Extension Points:
4a. No Records Found:
•	System detects no visits match the search criteria.
•	System displays: "No records found for the selected date or doctor."
6a. Data Missing:
•	If a specific record exists but the doctor hasn't finalized the notes.
•	System displays: "Detailed notes for this visit are pending."
7a. Prescription Download:
•	System provides an option to download the prescription as a PDF (similar to UC-20).
Priority:				MEDIUM
Frequency: 				Moderate
Cross-Reference:			SRS-60, SRS-61, SRS-62


Use Case ID:				 UC-21
Use Case Name:			Create Operation Record
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On:		6th May, 2026
Use Case Description:	This use case describes the process by which an Admin or a Lead Surgeon schedules and records a new surgical operation by selecting the patient, specifying the surgery type, date, and assigning an Operating Theater (OT) room.
Primary Actors:			Admin, Lead Surgeon
Stakeholders & Interest:	Lead Surgeon: Wants to ensure the operation is scheduled correctly with all necessary details.
Admin: Wants to manage OT room availability and maintain organized surgical records.
Patient: Interests lie in having their surgery accurately scheduled and tracked.
System: Needs to ensure all required information is captured and stored for tracking purposes.
Pre-Conditions:	The Admin or Lead Surgeon must be logged into the system.
The Patient must already be registered in the system (existing Patient ID).
OT Rooms must be defined in the system.
Main Success Scenario:
User Action	System Response
1. User navigates to the "Operations" or "OT Management" section.	
	2. System displays the "Create New Operation Record" form.
3. User selects a Patient from the registered list.	
	4. System retrieves and displays basic patient information for verification.
5. User enters the Surgery Type, selects the Date, and assigns an OT Room Number.	
6. User clicks the "Save Record" or "Create" button.	
	7. System validates that all mandatory fields (Patient, Surgery Type, Date, OT Room) are provided.
	8. System checks for OT room availability for the selected date.
	9. System saves the operation record securely in the database.
	10. System displays a snackbar message: “Operation Record Created Successfully.”
Post-Conditions:	 A new operation record is created and linked to the patient, and the OT room is marked as occupied/scheduled for that specific date.
Extension Points:
7a. Missing Mandatory Fields:
•	System highlights the missing information (e.g., Surgery Type or OT Room).
•	System prevents saving until all fields are filled.
8a. OT Room Conflict:
•	System detects that the selected OT room is already booked for the chosen date.
•	System displays an error: "OT Room already occupied for this date. Please select another room or date."
Priority:				HIGH
Frequency:	Moderate to High (Depends on surgical   volume)
Cross-Reference:			SRS-63, SRS-64


Use Case ID:				UC-22
Use Case Name:			Assign Surgical Team
Use Case Prepared by: 		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On:		6th May, 2026
Use Case Description:	This use case describes how the scheduling authority (Admin or Lead Surgeon) assigns a specialized surgical team—including a Primary Doctor, Anesthesiologist, and Nursing Staff—to an existing operation record while ensuring no staff member is double-booked.
Primary Actors:			Admin, Lead Surgeon (Scheduling Authority)
Stakeholders & Interest:	Surgical Staff (Doctors/Nurses): Want clear schedules without conflicting duties.
Lead Surgeon: Needs to ensure a qualified team is assigned for the procedure.
System: Must maintain staff schedules and prevent resource over-allocation.
Pre-Conditions:	1) The Operation Record must have been created.
2) All staff members (Doctors, Anesthesiologists, Nurses) must be registered and active in the system.
Main Success Scenario:
User Action	System Response
1. User selects an existing "Operation Record" from the schedule.	
	2. System displays the "Assign Team" interface for that specific operation.
3. User selects a Primary Doctor from the available list.	
	4. System checks the doctor's schedule for conflicts on the operation date/time.
	
5. User selects an Anesthesiologist.	
	6. System validates the anesthesiologist’s availability.
7. User selects the required Nursing Staff.	
	8. System validates the nurses' availability.
9. User clicks the "Confirm Team Assignment" button.	
	10. System links the staff members to the operation record and updates their individual schedules.
	11. System displays a success message: “Surgical Team Assigned Successfully.”
Post-Conditions:	The surgical team is successfully assigned to the operation, and all assigned members' schedules are updated to reflect their commitment to this procedure.
Extension Points:
4a, 6a, 8a. Staff Scheduling Conflict:
•	System detects that a selected staff member is already assigned to another operation at the same time.
•	System displays an alert: "Conflict Detected: [Staff Name] is already assigned to another procedure."
•	System prevents assignment until a different staff member is selected.
9a. Incomplete Team:
•	User attempts to save without assigning a mandatory role (e.g., anesthesiologist).
•	System prompts the user to complete all role assignments before proceeding.
Priority:				HIGH
Frequency:	High (Required for every scheduled operation)
Cross-Reference:			SRS-65, SRS-66

Use Case ID: 				UC-23
Use Case Name: 			Update Surgical Team
Use Case Prepared by: 		Fahad Aziz Dar
Use Case Updated by: 		Nabeel Afzal
Use Case Prepared On: 		6th May, 2026
Use Case Updated On: 		6th May, 2026
Use Case Description: 	This use case describes how the scheduling authority or Lead Surgeon modifies an already assigned surgical team before an operation begins. It includes validation of new staff availability, automated notifications to affected staff, and audit logging.
Primary Actors: 			Admin (Scheduling Authority), Lead Surgeon
Stakeholders & Interest:	Admin/Lead Surgeon: Wants the flexibility to adjust surgical teams in case of staff unavailability or emergencies.
Staff (Added/Removed): Needs to be immediately notified of any changes to their operation schedules.
System: Needs to prevent double-booking and maintain a secure audit log of all changes.
Pre-Conditions:			1. System must be in a running state.
2. User (Admin or Lead Surgeon) is securely logged in.
3. An operation record with an already assigned surgical team exists.
4. The scheduled operation has not yet started.
Main Success Scenario:
User Action	System Response
1. User navigates to the specific Operation Record and selects "Update Surgical Team".	
	2. System displays the currently assigned team (primary doctor, anaesthesiologist, nursing staff).
3. User modifies the team by removing existing staff and selecting new staff members, then clicks "Update".	
	4. System re-validates the availability of the newly selected staff members against existing operations and shifts.
	5. System successfully updates the surgical team in the database.
	6. System automatically sends a notification (Email/SMS/Push) to both the newly assigned and the removed staff members.
	7. System maintains a secure log recording the timestamp of the update and the user who made the changes.
	8. System displays a success message: "Surgical Team Updated Successfully."
Post-Conditions: 	The operation record is successfully updated with the new surgical team. All affected staff members are notified of the schedule change, and the action is securely logged for audit purposes.
Extension Points:
4a. Scheduling Conflict Detected:
•	System detects that a newly selected staff member is already assigned to another operation or is unavailable during the required time slot.
•	System aborts the update process.
•	System displays an error message: "Scheduling Conflict: Selected staff member is unavailable."
•	User is prompted to select a different staff member.
Priority: 				HIGH
Frequency: 	LOW to MEDIUM (Occurs mainly during staff emergencies or schedule adjustments)
Cross-Reference: 			SRS-67, SRS-68, SRS-69, SRS-70


Use Case ID:				UC-24
Use Case Name:			Record Operation Outcome
Use Case Prepared by: 		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On:		6th May, 2026
Use Case Description:	This use case describes how the assigned doctor logs the final results of a surgery, including the outcome, any complications encountered, and the current condition of the patient, effectively closing the operation record.
Primary Actors:			Assigned Doctor (Lead Surgeon)
Stakeholders & Interest:	Assigned Doctor: Wants to accurately document the procedure's success and any medical notes for post-op care.
Patient: Interests lie in having an accurate medical record of their surgery and condition.
Hospital Administration: Needs completed records for billing, statistics, and auditing.
System: Must ensure the operation status is updated correctly and data is saved for the patient’s history.
Pre-Conditions:	The operation must be in "Scheduled" or "In-Progress" status.
The user must be the assigned doctor for that specific operation.
The surgery must have been physically performed.
Main Success Scenario:
User Action	System Response
1. Doctor selects the specific operation from the "Ongoing" or "Pending Outcome" list.	
	2. System displays the "Operation Outcome" form.
3. Doctor enters the Surgical Outcome (e.g., Successful, Partially Successful).	
4. Doctor logs any complications encountered during the procedure.	
5. Doctor records the current Patient Condition (e.g., Stable, Critical).	
6. Doctor clicks the "Submit Outcome" button.	
	7. System validates that all necessary outcome fields are filled.
	8. System saves the post-operation details to the database.
	9. System updates the operation status to "Completed".
	10. System displays a success message: “Operation Outcome Recorded and Status Updated to Completed.”
Post-Conditions:	The operation record is finalized, the status is set to "Completed," and the details are permanently attached to the patient's medical history.
Extension Points:
7a. Incomplete Outcome Data:
•	System detects that the outcome or patient condition is missing.
•	System prevents submission and highlights the required fields.
9a. Data Integrity Check:
•	System ensures that once the status is "Completed," the record becomes read-only for standard users (to prevent unauthorized changes to medical results).
Priority:				HIGH
Frequency:				High (Required for every performed surgery)
Cross-Reference:			SRS-71, SRS-72


Use Case ID:				UC-25
Use Case Name:			Generate Automated Credentials
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On:		6th May, 2026
Use Case Description:	This use case describes how the system automatically creates temporary login credentials for a patient or their attendant once a surgery is scheduled. These credentials are sent securely via Email/SMS to allow them to track the operation's progress.
Primary Actors:			System (Automated)
Stakeholders & Interest:	Patient/Attendant: Wants to track the real-time status and updates of the scheduled surgery.
Admin/Hospital: Wants to provide transparency to the patient's family without manual data entry.
System: Needs to ensure credentials are generated uniquely and delivered through secure communication channels.
Pre-Conditions:	1) An operation record must be successfully created and scheduled 
2)The patient's profile must contain a valid email address or phone number.
Main Success Scenario:
User Action	System Response
1. (Trigger) Operation record is saved/scheduled in the system.	
	2. System automatically triggers the credential generation module.
	3. System creates a temporary Username and a secure random Password.
	4. System links these temporary credentials to the specific Patient ID and Operation ID.
	5. System identifies the preferred communication channel (Email or SMS) from the profile.
	6. System sends the temporary credentials and a login link to the Patient/Attendant.
	7. System logs the communication status (e.g., "Sent Successfully").
Post-Conditions:	The Patient/Attendant receives the login details, and the system is ready to authenticate them for operation tracking.
Extension Points:
3a. Duplicate Credential Check:
•	System ensures that the generated temporary username does not conflict with any existing user in the database.
6a. Delivery Failure:
•	System detects that the Email/SMS was not delivered (e.g., invalid number or server error).
•	System flags the error in the Admin dashboard for manual intervention.
6b. Security Policy:
•	System sets the temporary credentials to expire automatically after the operation is completed or after a set time (e.g., 48 hours).
Priority:				MEDIUM
Frequency:				High (Triggered every time a new surgery is scheduled)
Cross-Reference: 			SRS-73, SRS-74

Use Case ID:				UC-26
Use Case Name:			Upload Medical Reports
Use Case Prepared by: 		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On:		6th May, 2026
Use Case Description:	This use case describes how medical staff can upload pre-operative and post-operative laboratory results, scans, and other medical documents to a patient's record, ensuring they meet specific file type and size constraints.
Primary Actors:			Medical Staff (Doctor, Nurse, Lab Technician)
Stakeholders & Interest:	Medical Staff: Wants a centralized way to store and access clinical documents for surgery planning and review.
Patient: Needs their medical data to be securely stored and correctly linked to their profile.
System: Must enforce security policies, validate file formats, and manage storage efficiently.
Pre-Conditions:	1) Medical staff member must be logged into the system.
2)An existing Patient Record must be available to link the reports.
Main Success Scenario:
User Action	System Response
1. User navigates to the "Medical Reports" section of a specific patient.	
	2. System displays the "Upload Report" interface.
3. User selects the file (Lab result, Scan, or Document) from their device.	
	4. System validates the file type (PDF or JPG).
	5. System checks the file size (must be within 5MB/10MB limit).
6. User clicks the "Upload" button.	
	7. System securely uploads the file to cloud storage.
	8. System links the file URL to the patient's record in the database.
	9. System displays a success message: "Report Uploaded Successfully."
Post-Conditions:	The medical document is securely stored in the cloud and successfully linked to the patient's digital record for future reference.
Extension Points:
4a. Invalid File Format:
•	System detects a file type other than PDF or JPG (e.g., .exe or .docx).
•	System blocks the upload and displays the error message: "Invalid File".
5a. File Size Exceeded:
•	System detects the file size is greater than the allowed limit (5MB/10MB).
•	System blocks the upload and displays the error message: "Size Exceeded".
7a. Upload Interruption:
•	System detects a network failure during upload.
•	System prompts the user to "Retry Upload".
Priority:				HIGH
Frequency:				Very Frequent
Cross-Reference:			SRS-75, SRS-76, SRS-77, SRS-78
Use Case ID:				UC-27
Use Case Name:			View Operation History
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On: 		6th May, 2026
Use Case Description:	This use case describes how Doctors and Admins can access and browse through the historical records of past surgical operations. It allows them to find specific records using filters and efficiently navigate large amounts of data.
Primary Actors:			Admin, Doctor
Stakeholders & Interest:	Admin/Doctor: Needs to review past surgical cases for auditing, medical follow-ups, or performance tracking.
System: Must handle large datasets efficiently without slowing down and ensure data is presented accurately based on filters.
Pre-Conditions:	1) The user must be logged in with Admin or Doctor privileges.
2)Historical operation records must exist in the database.
Main Success Scenario:
User Action	System Response
1. User navigates to the "Operation History" or "Archives" section.	
	2. System retrieves the most recent operation records from the database.
3. User applies filters such as Date Range, Surgeon Name, or Patient ID.	
	4. System processes the filters and updates the list in real-time.
5. User scrolls down the list to view more records.	
	6. System applies Pagination or Infinite Scroll to load the next set of historical data seamlessly.
7. User clicks on a specific record to view full details.	
	8. System displays the complete operation summary, including team, outcome, and linked reports.
Post-Conditions:	The user successfully reviews the historical data without compromising system performance.
Extension Points:
4a. No Records Found:
•	System detects that no past operations match the selected filters (e.g., a specific date with no scheduled surgeries).
•	System displays: "No historical records found for the selected criteria."
6a. Data Load Failure:
•	System encounters an error while fetching the next page of results.
•	System displays a "Retry" button or an error snackbar: "Failed to load more records. Please try again."
Priority:				MEDIUM
Frequency:				Moderate (Used for reviews and reporting)
Cross-Reference: 			SRS-79, SRS-80

Use Case ID:				 UC-28
Use Case Name:			Add Medicine Prescription
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On:		6th May, 2026
Use Case Description:	This use case describes the process by which a doctor digitally prescribes medications to a patient. The system ensures all clinical details like dosage and frequency are captured before updating the patient's record and portal in real-time.
Primary Actors:			Doctor
Stakeholders & Interest:	Doctor: Wants a quick and error-free way to provide medicine instructions to the patient.
Patient: Needs clear, legible, and timely access to their prescription via the portal.
Pharmacist (Internal/External): Interests lie in receiving accurate drug and dosage information.
System: Must enforce data integrity by ensuring all mandatory fields are completed.
Pre-Conditions:			1) Doctor must be logged into the system.
2)An active patient session or check-up record must be open.
Main Success Scenario:
User Action	System Response
1. Doctor navigates to the "Prescription" or "Add Medicine" tab within the patient's record.	
	2. System displays the digital prescription form.
3. Doctor enters the Drug Name, Dosage (e.g., 500mg), and Frequency (e.g., Twice a day).	
	4. System may provide suggestions from a pre-defined medicine database.
5. Doctor clicks the "Submit Prescription" button.	
	6. System validates that all mandatory fields (Drug Name, Dosage, Frequency) are filled.
	7. System saves the prescription to the database and links it to the Patient ID.
	8. System displays a snackbar message: “Prescription Added Successfully”.
	9. System pushes a real-time update to the Patient's Portal.
Post-Conditions:	The prescription is successfully recorded in the system, and the patient can immediately view it on their dashboard.
Extension Points:
6a. Missing Mandatory Fields:
•	System detects an empty field (e.g., Frequency is missing).
•	System prevents submission and displays an error: "Please fill all mandatory fields to proceed."
7a. Drug Interaction Alert (Optional/Future Scope):
•	System checks if the new medicine conflicts with the patient's existing medication.
•	System displays a warning to the doctor.
9a. Portal Sync Failure:
•	System saves the data locally but notifies the doctor: "Prescription saved. Patient portal sync pending due to network issues."
Priority:				HIGH
Frequency:				Very High (Used in almost every consultation)
Cross-Reference:			SRS-81, SRS-82, SRS-83


Use Case ID:				UC-29
Use Case Name:			Update Medicine Dosage
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On:		6th May, 2026
Use Case Description:	This use case describes how a doctor can modify the dosage of an existing prescription based on a patient's recovery progress. It also ensures that a detailed audit trail is maintained for clinical transparency and accountability.
Primary Actors:			Doctor
Stakeholders & Interest:	Doctor: Wants to adjust treatment plans dynamically as the patient recovers.
Patient: Needs to receive the most accurate and safe dosage of medication.
Hospital Admin/Audit Team: Needs a clear history of medication changes to ensure medical record integrity and safety compliance.
System: Must capture the transition from old data to new data securely.
Pre-Conditions:			1) Doctor must be logged into the system.
2) An active prescription for the patient must already exist in the database.
Main Success Scenario:
User Action	System Response
1. Doctor navigates to the patient's "Current Medications" list.	
	2. System displays all active prescriptions with their current dosage details.
3. Doctor selects the "Edit" or "Update Dosage" option for a specific medicine.	
	4. System opens the update form, pre-filling the current dosage.
5. Doctor enters the New Dosage and optionally adds a reason for the change (e.g., "Improved Recovery").	
6. Doctor clicks the "Update" button.	
	7. System validates the input and captures the Old Dosage, New Dosage, and Current Timestamp.
	8. System updates the active prescription in the patient's record.
	9. System records the change in the Audit Log (Medical History).
	10. System displays a confirmation: "Dosage Updated and Audit Log Recorded."
Post-Conditions:	The patient's active medication reflect the new dosage, and the historical audit log is successfully updated with the change details.
Extension Points:
7a. Audit Log Failure:
•	If the system fails to write to the audit log, the dosage update is rolled back to prevent "orphan" changes.
•	System displays an error: "Internal Error: Could not record audit trail. Update cancelled."
9a. Patient Notification:
•	System sends an automated alert to the Patient's Dashboard/App to inform them that their dosage has been modified.
Priority:				HIGH
Frequency:	Moderate (Occurs during follow-ups or recovery reviews)
Cross-Reference:			SRS-84, SRS-85


Use Case ID:				UC-30
Use Case Name:			View Medication Schedule
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On:		6th May, 2026
Use Case Description:	This use case describes how a patient can view a clear, organized daily timetable of their prescribed medications within the portal. This helps the patient adhere to their treatment plan by showing what to take and when.
Primary Actors:			Patient
Stakeholders & Interest:	Patient: Wants a simple, easy-to-read schedule to ensure they don't miss any doses or take the wrong medication at the wrong time.
Doctor: Wants to ensure the patient follows the prescribed recovery plan accurately.
System: Must format complex prescription data into a user-friendly daily view.
Pre-Conditions:			1) Patient must be logged into the portal.
2)The doctor must have already added at least one active prescription.
Main Success Scenario:
User Action	System Response
1. Patient navigates to the "Medication Schedule" or "My Timetable" section.	
	2. System retrieves all active prescriptions for the patient.
3. User selects a specific day (default is "Today").	
	4. System formats the medications into a chronological timetable (e.g., Morning, Afternoon, Evening, Night).
	5. System displays the Drug Name, Dosage, and Special Instructions (e.g., "After meal").
	6. System highlights the next upcoming dose for the user's convenience.
Post-Conditions:	The patient is successfully presented with a clear daily plan for their medications, reducing the risk of dosage errors.
Extension Points:
4a. No Active Medications:
•	System detects that no medicines are currently prescribed.
•	System displays: "You have no active medications scheduled at this time."
6a. Medication Reminders (Optional):
•	System provides a "Set Reminder" toggle to alert the user's mobile device 15 minutes before the dose time.
8a. Expired Prescriptions:
•	System hides or moves medications to a "History" tab if the prescribed duration has ended.
Priority:				HIGH
Frequency:	Very High (Patients will check this multiple time a day)
Cross-Reference:			SRS-86


Use Case ID:				UC-31
Use Case Name:			Initiate Real-time Chat
Use Case Prepared by: 		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th  May, 2026
Use Case Updated On:		6th May, 2026
Use Case Description:	This use case describes how doctors and assigned medical staff (nurses, technicians) can initiate a secure, real-time instant messaging session to discuss a specific patient’s condition or coordinate Operating Theater (OT) schedules.
Primary Actors:		Doctor, Assigned Medical Staff (Nurses/OT Technicians)
Stakeholders & Interest:		Medical Staff: Need a quick way to communicate critical updates without leaving their posts.
Patient: Benefits from better coordination between team members.
IT/Security Dept: Interests lie in ensuring that all communications are encrypted and comply with healthcare data privacy standards.
System: Must ensure the chat environment is secure and restricted only to authorized personnel.
Pre-Conditions:		1) The user must be logged into the system with verified credentials.
2)The user must have "Staff" or "Doctor" access rights.
3)The specific Patient Record or OT Schedule must be accessible.
Main Success Scenario:
User Action	System Response
1. User navigates to a specific Patient Profile or an OT Schedule entry.	
	2. System displays a "Secure Chat" or "Consult" button.
3. User clicks the button and selects the staff member(s) to include in the chat.	
	4. System initiates a secure, end-to-end encrypted chat session.
5. User types and sends a message regarding the patient or schedule.	
	6. System delivers the message in real-time to the recipient(s).
7. User ends the conversation or closes the chat window.	
	8. System archives the chat log securely (if required for medical records) and restricts further unauthorized access.
Post-Conditions:	Real-time communication is established and concluded securely, with the exchange of critical information logged or handled according to privacy standards.
Extension Points:
4a. Unauthorized Access Attempt:
•	System detects a user trying to join a chat for a patient they are not assigned to.
•	System blocks access and displays: "Access Denied: You are not part of this patient’s care team."
6a. Network Instability:
•	System detects a drop in connection.
•	System displays a "Waiting for network..." status and queues messages for delivery once the connection is restored.
8a. Compliance Redaction:
•	System automatically flags and prevents the sharing of non-compliant data types (e.g., plain-text passwords) within the chat.
Priority:				HIGH
Frequency:				Very High (Crucial for OT coordination)
Cross-Reference:			SRS-87, SRS-88


Use Case ID:				 UC-33
Use Case Name:			View Chat History
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On: 		6th May, 2026
Use Case Description:	This use case describes how doctors and medical staff can access previously archived chat logs, search for specific information or files within those conversations, and track the delivery and read status of every message for clinical accountability.
Primary Actors:			Doctor, Assigned Medical Staff
Stakeholders & Interest:	Medical Staff: Need to recall previous instructions or coordination details regarding a patient.
Audit/Compliance Team: Interests lie in having an immutable record of clinical communication.
System: Must ensure large volumes of chat data are searchable and accessible without compromising security.
Pre-Conditions:	1) The user must be logged in and have been a participant in the original chat session.
2)Chat archives must exist in the secure database.
Main Success Scenario:
User Action	System Response
1. User navigates to the "Chat Archives" or "Recent Conversations" section.	
	2. System retrieves a list of archived chat sessions linked to the user.
3. User selects a specific chat log to view.	
	4. System displays the conversation history in chronological order.
5. User enters a keyword, date, or filename in the Search Bar.	
	6. System filters the messages and highlights the relevant keywords or shared files.
7. User scrolls through the messages.	
	8. System displays the Status (Sent, Delivered, Read) and the Exact Timestamp for each message.
Post-Conditions:	The user successfully retrieves and reviews the necessary historical information from the chat logs with full visibility of delivery details.
Extension Points:
2a. No History Found:
•	System detects no previous chats for the selected patient or staff member.
•	System displays: "No archived conversations found."
6a. Search Yields No Results:
•	System displays: "No matches found for '[Keyword]'. Try a different search term."
8a. Message Receipt Discrepancy:
•	If a message was sent but not delivered (due to recipient's offline status), the system clearly marks it as "Sent" only, providing clarity on communication gaps.
Priority:				MEDIUM
Frequency:				Moderate (Used for reference and tracking)
Cross-Reference:			SRS-89, SRS-90, SRS-71


Use Case ID:				UC-34
Use Case Name:			Manage Emergency Alerts
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On: 		6th May, 2026
Use Case Updated On:		6th May, 2026
Use Case Description:	This use case describes the process of triggering and responding to high-priority emergency alerts. It allows staff in critical areas (like OT or ICU) to summon immediate help, while ensuring the sender receives a confirmation once the alert is acknowledged by the response team.
Primary Actors:			Medical Staff (Sender), Surgical/ICU Team (Recipient)
Stakeholders & Interest:	Sender (Nurse/Doctor): Needs a fast, reliable way to call for backup during a medical crisis.
Response Team: Needs clear, immediate notification of an emergency to provide timely assistance.
Hospital Admin: Interests lie in monitoring emergency response times and ensuring patient safety protocols are met.
Patient: Their life and safety depend on the speed and efficiency of this alert system.
Pre-Conditions:			1) The user must be logged into the system.
2)The user must be in a section of the app that handles active patient care (e.g., OT Monitoring or ICU Dashboard).
Main Success Scenario:
User Action	System Response
1. User (Sender) taps the Emergency Button on the interface.	
	2. System identifies the user's location and the assigned response teams for that zone.
3. (Optional) User selects the type of emergency (e.g., Cardiac Arrest, Equipment Failure).	
	4. System broadcasts a High-Priority Alert (with distinct sound and visual) to all assigned team members.
	5. System displays "Alert Sent - Waiting for Acknowledgment" on the sender's screen.
6. Recipient (Response Team member) taps the "Acknowledge" button on their device.	
	7. System updates the status of the alert to "Attended".
	8. System notifies the sender: "Alert Acknowledged by [Staff Name]".
	9. System logs the exact time of the alert and the response for audit purposes.
Post-Conditions:	The emergency alert is successfully communicated and acknowledged, and the entire event is logged in the system's critical incident history.
Extension Points:
4a. No Response Team Online:
•	System detects that no assigned staff members are currently logged in or active.
•	System escalates the alert to the General Duty Doctor or Hospital Supervisor immediately.
6a. Delayed Acknowledgment:
•	If the alert is not acknowledged within a set timeframe (e.g., 60 seconds), the system repeats the high-priority sound at maximum volume and sends a secondary notification.
Priority:				CRITICAL
Frequency:				Low (Only during emergencies)
Cross-Reference:			SRS-92, SRS-93


Use Case ID:				UC-35
Use Case Name:	Send Account Credentials 
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On:		6th May, 2026
Use Case Description:	This use case describes how the system handles the secure onboarding of new users. It involves sending temporary credentials, enforcing a time-limited verification link, and requiring a mandatory password change upon the first login to ensure account security.
Primary Actors:		New User (Patient, Doctor, or Staff), System (Automated)
Stakeholders & Interest:	New User: Wants to access their account quickly and securely.
System Admin: Wants to ensure that only verified users can access the platform.
Security Team: Interests lie in enforcing password policies and link expiration to prevent unauthorized access.
Pre-Conditions:	1) A new user account has been successfully created by the Admin or via registration.
2)The user's contact information (Email/Phone) is valid.
Main Success Scenario:
User Action	System Response
1. (Trigger) New user registration is completed.	
	2. System generates a secure random temporary password and a unique verification link.
	3. System sends an automated Email and SMS containing these details.
	4. System sets a 24-hour expiration timer on the verification link.
5. User clicks the link and enters temporary credentials within 24 hours.	
	6. System authenticates the user and marks the account as "Verified".
	7. System immediately redirects the user to the "Change Password" screen.
8. User enters a new, strong password and confirms it.	
	9. System updates the password, clears the temporary status, and grants full access to the dashboard.
Post-Conditions:	The user account is verified, a personalized password is set, and the temporary credentials are invalidated.
Extension Points:
5a. Link Expired:
•	User clicks the link after 24 hours.
•	System displays: "Link Expired. Please request a new verification link."
8a. Password Strength Validation:
•	User enters a weak password.
•	System displays: "Password must be at least 8 characters long and include numbers/special characters."
9a. Mandatory Change Bypass Attempt:
•	User tries to navigate to the dashboard without changing the password.
•	System blocks the request and redirects them back to the "Change Password" screen.
Priority:				HIGH
Frequency:				High (Triggered for every new registration)
Cross-Reference: 			SRS-94, SRS-95, SRS-96
Use Case ID:				UC-36
Use Case Name:			Send Check-up Reminders 
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On:		6th May, 2026
Use Case Description:	This use case describes how the system automatically manages patient communication regarding upcoming appointments. It ensures patients receive timely reminders and are immediately notified of any changes or cancellations made by the medical staff.
Primary Actors:			System (Automated), Patient
Stakeholders & Interest:	Patient: Needs timely reminders to avoid missing appointments and immediate updates to save travel time if a schedule change.
Doctor: Wants to minimize "no-shows" and ensure the patient is informed if they have to reschedule due to emergencies.
Hospital Admin: Interests lie in efficient clinic flow and high patient satisfaction through proactive communication.
Pre-Conditions:	1) The patient must have a scheduled follow-up or check-up in the system.
2)The patient's contact details (Phone/Device Token) must be active and verified.
 
Main Success Scenario:
User Action	System Response
1. (Time Trigger) System detects an appointment scheduled in 24 hours.	
	2. System dispatches a Push Notification and SMS reminder with Doctor Name, Time, and Room Number.
3. (Time Trigger) System detects the same appointment is in 2 hours.	
	4. System sends a final "Priority Reminder" with the same details to the patient.
5. (Event Trigger) Doctor reschedules or cancels the appointment in the staff portal.	
	6. System identifies the change and halts any pending original reminders.
	7. System sends an immediate "Reschedule/Cancellation" alert to the patient via SMS and App.
	8. System updates the Patient Dashboard to reflect the new time or status.
Post-Conditions:	The patient is successfully informed of their appointment status, ensuring better attendance or awareness of schedule changes.
Extension Points:
2a. Delivery Failure:
•	System detects that the SMS or Push Notification failed to deliver.
•	System retries once and then logs the failure in the communication audit log.
7a. Immediate Action Required:
•	If the cancellation happens within 1 hour of the appointment, the system may flag the record for a manual call from the front desk.
8a. Acknowledgment:
•	System includes a "Confirm Attendance" button in the notification to update the doctor's daily queue.
Priority:				HIGH
Frequency:	Very High 
Cross-Reference:			SRS-97, SRS-98, SRS-99


Use Case ID:				UC-37
Use Case Name:			Push Notifications 
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On:		6th May, 2026
Use Case Description:	This use case describes how the system automatically sends real-time push notifications to patients and their attendants whenever there is a change in the surgical operation status. This ensures that stakeholders are instantly informed of progress without needing to manually refresh the app.
Primary Actors:			System (Automated), Patient/Attendant
Stakeholders & Interest:	Patient/Attendant: Needs immediate updates on the surgery's progress (e.g., when the patient moves to Recovery) to reduce anxiety and stay informed.
OT Staff: Wants to ensure that updates they make in the system are communicated to the family instantly.
System: Must ensure low latency (fast delivery) of notifications to maintain the "real-time" experience.
Pre-Conditions:	1) The Patient/Attendant must have the mobile application installed and notifications enabled.
2)An active operation must be linked to the user's account.
Main Success Scenario:
User Action	System Response
1. (Internal) OT Staff updates the operation status (e.g., from 'In Surgery' to 'Recovery').	
	2. System detects the status change in the database.
	3. System identifies all registered devices (tokens) linked to that specific patient/attendant.
	4. System triggers a Push Notification to the identified devices.
	5. System displays the notification on the user's device (e.g., "Status Update: Patient has been moved to the Recovery Room").
6. User taps the notification.	
	7. System opens the app and navigates directly to the Track Current Status page 
Post-Conditions:	The user receives an instant visual and audible alert about the surgery progress, ensuring they are always up-to-date.
Extension Points:
4a. Notification Service Offline:
•	If the push notification service (like Firebase) is unavailable, the system logs the failure and attempts to send an SMS as a fallback.
5a. User has Notifications Disabled:
•	System detects that the user has blocked notifications at the OS level.
•	System logs the attempt as "Sent but suppressed by user" and relies on the dashboard update .
Priority:				HIGH
Frequency:	Frequent (Every time a surgery stage changes)
Cross-Reference:			SRS-100,

Use Case ID:				UC-38
Use Case Name:			View Notification History 
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On:		6th May, 2026
Use Case Description:	This use case describes how users can access a centralized notification center to review all past alerts, manage unread messages via a badge counter, and organize their feed by marking notifications as read or clearing the history.
Primary Actors:			User (Patient, Doctor, or Staff)
Stakeholders & Interest:	User: Wants to ensure they haven't missed any critical updates and wants to keep their interface clean and organized.
System: Must track the read/unread state of every notification for each specific user to maintain an accurate badge count.
Pre-Conditions:			1) The user must be logged into the application.
2)The system must have generated at least one notification for the user.
Main Success Scenario:
User Action	System Response
1. User observes the Notification Icon on the dashboard.	
	2. System displays a red "Unread Badge" counter showing the number of new alerts.
3. User taps on the Notification Icon.	
	4. System opens the Notification Center and displays a chronological list of all alerts.
5. User taps on a specific "Unread" notification.	
	6. System marks that individual notification as "Read" and decrements the badge counter.
7. User selects the "Clear All" option.	
	8. System removes all notifications from the active feed or archives them, and resets the badge counter to zero.
Post-Conditions:	The notification feed is updated according to the user's actions, and the badge counter accurately reflects the remaining unread alerts.
Extension Points:
4a. Empty Notification Feed:
•	System detects no notifications exist for the user.
•	System displays a placeholder message: "You're all caught up! No new notifications."
6a. Open Related Module:
•	If the notification is about a status update, tapping it redirects the user to the Track Current Status page (UC-18).
8a. Undo "Clear All":
•	System provides a brief "Undo" snackbar if the user accidentally clears their entire history.
Priority:				MEDIUM
Frequency:	 High (Users check notifications multiple times per session)
Cross-Reference:			SRS-101, SRS-102, SRS-103


Use Case ID:				UC-39
Use Case Name:			Generate Operation Success Reports
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On: 		6th May, 2026
Use Case Updated On:		6th May, 2026
Use Case Description:	This use case describes how the Administrator can generate and view detailed analytical reports regarding surgical outcomes. It allows the Admin to filter data by dates and types and visualize complex statistics through interactive charts for better decision-making and hospital management.
Primary Actors:			Administrator
Stakeholders & Interest:	Administrator: Needs to monitor hospital performance, identify trends in success rates, and analyse complication frequencies.
Hospital Management: Wants data-driven insights to improve surgical protocols and resource allocation.
System: Must process large datasets and render them into easy-to-understand visual formats.
Pre-Conditions:	1) Administrator must be logged into the Admin Dashboard.
2)Historical data of completed operations must exist in the database.
Main Success Scenario:
User Action	System Response
1. Admin navigates to the "Analytics & Reports" section.	
	2. System displays the report generation interface.
3. Admin selects the Date Range (e.g., Last Month), Surgery Type, or Specific OT Room.	
	4. System queries the database based on the selected filters.
5. Admin clicks the "Generate Report" button.	
	6. System calculates total operations, success rates, and complication frequencies.
	7. System displays the data using Interactive Pie Charts (for success/failure ratio) and Bar Graphs (for surgery types).
8. Admin hovers over the graph elements to see exact numeric values.	
	9. System provides a "Export as PDF/Excel" option for the generated report.
Post-Conditions:	The Admin successfully analyses hospital performance through detailed visual reports, enabling informed administrative actions.
Extension Points:
4a. No Data for Selected Criteria:
•	System detects that no operations were recorded for the selected filter (e.g., a specific room in a specific week).
•	System displays: "No data available for the selected filters."
7a. Drill-down Analysis:
•	Admin clicks on a specific segment of the bar graph.
•	System displays a detailed list of cases contributing to that specific metric.
Priority:				HIGH
Frequency:				Periodic (Weekly/Monthly/Quarterly)
Cross-Reference:			SRS-104, SRS-105, SRS-106


Use Case ID:				UC-40
Use Case Name:			Generate Doctor Performance Report
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On: 		6th May, 2026
Use Case Description:	This use case describes how the system compiles various data points—including operation success rates, punctuality (scheduled vs. actual start time), and surgical efficiency—to generate a performance summary. It also ensures strict privacy where doctors can only see their own data while Admins can view all records.
Primary Actors:			Doctor, Administrator
Stakeholders & Interest:	Doctor: Wants to track their own professional efficiency, success rates, and surgical duration trends.
Administrator: Needs to evaluate staff performance, identify top-performing surgeons, and manage hospital efficiency.
System: Must maintain strict access control (Data Privacy) and calculate complex efficiency metrics accurately.
Pre-Conditions:			1) The user must be logged into the system.
2) The user must have either "Doctor" or "Admin" role.
3) Operation logs and time-tracking data must exist in the database.
Main Success Scenario:
User Action	System Response
1. User navigates to the "Performance Report" section.	
	2. System checks the User Role (Admin or Doctor).
3. If Admin: Admin selects a specific doctor from a list.
If Doctor: System automatically selects the logged-in doctor's ID.	
	4. System retrieves data on completed operations, patient outcomes, and timestamps.
5. User clicks "Generate Performance Summary".	
	6. System calculates Punctuality (delay in start times) and Efficiency Metrics (Average duration vs. Scheduled time).
	7. System displays the report with metrics like Success Rate, Total Surgeries, and Avg. Time Variance.
	8. System renders the data using visual charts for easy comparison.
Post-Conditions:	A secure and personalized performance report is generated and displayed to the authorized user.
Extension Points:
2a. Access Violation:
•	If a Doctor tries to access another doctor's report via a direct URL or ID change.
•	System blocks access and logs a "Security Warning: Unauthorized Access Attempt".
6a. Insufficient Data:
•	If a new doctor has not completed enough operations to generate a meaningful average.
•	System displays: "Insufficient data to calculate efficiency metrics yet."
7a. High Performance Recognition:
•	If a doctor’s success rate is above a certain threshold (e.g., 98%), the system adds a "High Performer" badge to the report.
Priority:				HIGH
Frequency: 				Monthly or Quarterly
Cross-Reference:			SRS-107, SRS-108, SRS-109


Use Case ID:				UC-41
Use Case Name: 			Patient Recovery Analytics
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On:		6th May, 2026
Use Case Description:	This use case describes how the system provides administrators with a high-level view of patient health trends. It involves tracking the average recovery time and the rate of readmission, allowing for data-driven analysis based on specific surgeries or patient age groups.
Primary Actors:			Administrator
Stakeholders & Interest:	Administrator: Wants to monitor the effectiveness of surgical procedures and hospital care quality.
Medical Researchers/HODs: Interested in identifying which age groups or procedures have higher readmission risks.
System: Must perform complex data aggregation and update visualizations in real-time as new data arrives.
Pre-Conditions:	1) Administrator must be logged in with analytical access rights.
2)The system must have data on patient discharge dates, follow-up statuses, and any subsequent readmissions.
Main Success Scenario:
User Action	System Response
1. Admin navigates to the "Patient Recovery Analytics" dashboard.	
	2. System retrieves aggregated data on recovery durations and readmission counts.
3. Admin applies filters for Specific Surgical Procedures (e.g., Appendectomy) or Age Demographics (e.g., 60+ years).	
	4. System dynamically re-calculates the trends for the selected criteria.
5. Admin views the generated Graphical Charts (e.g., Line graphs for recovery trends, Pie charts for readmission rates).	
	6. System displays a "Trend Indicator" showing if recovery times are improving or declining over time.
7. (Internal) Medical staff submits a new operation outcome or discharge report.	
	8. System automatically updates the dashboard charts in real-time to reflect the new data.
Post-Conditions:	The Administrator gains actionable insights into patient recovery patterns and potential areas for clinical improvement.
Extension Points:
4a. Insufficient Demographic Data:
•	If the selected age group has very few records, the system shows a warning: "Data sample size too small for accurate trend analysis."
6a. High Readmission Alert:
•	If the readmission rate for a specific procedure exceeds a pre-set threshold (e.g., 10%), the system highlights the chart in red to alert the Admin.
8a. Dashboard Sync:
•	System ensures that even if multiple admins are viewing the dashboard, the charts update simultaneously for everyone.

Priority:				MEDIUM
Frequency:	Monthly or on-demand for strategic meetings.
Cross-Reference:			SRS-110, SRS-111, SRS-112


Use Case ID:				UC-42
Use Case Name:			View and Print Summary 
Use Case Prepared by:		Fahad Aziz Dar
Use Case Updated by:		Nabeel Afzal
Use Case Prepared On:		6th May, 2026
Use Case Updated On:		6th May, 2026
Use Case Description:	This use case describes how authorized users (Admins and Doctors) can view summary reports and export them into professional, formatted PDF documents or raw data files (CSV/Excel). It ensures all printed material maintains the hospital's branding and official standards.
Primary Actors:			Administrator, Authorized Doctor
Stakeholders & Interest:	Administrator: Needs raw data (CSV/Excel) for financial planning and hospital-wide auditing.
Doctor: Needs formatted PDF summaries of operations for medical records or professional portfolios.
Hospital Management: Wants to ensure all external documents have consistent branding (Logo/Letterhead).
System: Must ensure the export process is secure and formatting is consistent across different devices.
Pre-Conditions:	1) User must be logged in with "Admin" or "Authorized Staff" privileges.
2)The relevant analytical data or operation logs must be available on the dashboard.
Main Success Scenario:
User Action	System Response
1. User navigates to the "Reports Summary" or "Analytics Dashboard".	
	2. System displays the current data summary on the screen.
3. User clicks on the "Export as PDF" or "Print" button.	
	4. System generates a preview and automatically attaches the Hospital Logo, Timestamp, and Letterhead.
5. User clicks on the "Export to CSV/Excel" (Admin only).	
	6. System extracts raw data into a spreadsheet format for financial analysis.
7. User selects the print destination or download path.	
	8. System finalizes the file generation and saves/prints the document.
	9. System logs the export event for security auditing.
Post-Conditions:	The user receives a professionally formatted document or raw data file, while the system keeps a record of the exported file.
Extension Points:
4a. Letterhead/Logo Missing:
•	If the official logo file is missing from the server, the system uses a default text-based header and alerts the Admin.
5a. Access Restriction:
•	If a non-admin user tries to access the CSV/Excel export, the system hides the button or displays: "Access Restricted: Raw data export is for Admin only."
8a. Print Failure:
•	If the printer is not responding, the system offers an "Save as PDF" alternative to ensure the user doesn't lose the report.

Priority:				HIGH
Frequency:				Moderate (End of shifts or monthly reviews)
Cross-Reference:			SRS-113, SRS-114, SRS-115

