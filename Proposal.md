OT Procedures & Tracking App

Federal Urdu University 
of Arts, Science & Technology

Develop By 

Fahad Aziz Dar (GL)
Nabeel Afzal
BS (CS) in Software System
Supervised By
Ms. Irum Shahzadi

 Project Coordinator
Mr. Khawaja Tahir

Department of Computer Science
Federal Urdu University of Arts, Science & Technology, Islamabad
SESSION [2023-2027] 

A Project Presented to

Federal Urdu University of Arts, Science & Technology, Islamabad

In Partial Fulfilment of the Requirement for the Degree



Bachelor of Computer Science
(Software Systems)

By
Fahad Aziz Dar
Nabeel Afzal

8th March, 2026
(Federal Urdu University of Arts, Science & Technology, Islamabad)
 
 

Table of Contents
CHAPTER # 1: PROPOSAL	5
Revision History	6
1.1 Introduction:	7
1.2 Problem Statement:	7
1.3 Proposed System:	7
1.4 Benefits of Proposed System:	8
1.5 Scope:	8
1.6 Survey Analysis:	9
1.7 Modules & Sub Modules	10
1.7.1 Security Management	10
1.7.2 Profile Management	10
1.7.3 Doctor Management	11
1.7.4 Patient Portal Management	11
1.7.5 Operation & Clinical Reporting	11
1.7.6 Medication Management	11
1.7.7 Communication Management	11
1.7.8 Notifications Management	12
1.7.9 Reports & Analytics Management	12
1.8 Primary Actors:	12
1.9 Tools and Technologies:	12
1.9.1 Front-End Tools:	12
1.9.2 Back-End Tools:	12
1.9.3 Deployment:	13
1.9.4 Technique:	13
1.10 System Design Approach:	13
1.11 Process Model Used:	13
1.12 Modelling Techniques / Tools Used:	13
1.13 Limitations:	13
1.14 References:	13
Appendix	14




CHAPTER # 1: PROPOSAL
 


Revision History
Version	Description	Author	Date
1.0	Initial Project Proposal for OT Procedures & Tracking App.	Fahad Aziz Dar (GL)
Nabeel Afzal	8th March 2026



 
1.1 Introduction:
In the contemporary healthcare landscape, the transition from the Operating Theatre (OT) to post-operative care often suffers from a significant "communication void" that leads to information asymmetry and patient anxiety. OT-Procedures & Tracking App is a specialized mHealth solution architectured to bridge this gap by digitalizing surgical reporting and automating the entire patient onboarding lifecycle. By leveraging real-time data synchronization via cloud infrastructure, the system ensures that once a surgery is officially marked as successful, the patient is seamlessly integrated into a secure digital ecosystem for longitudinal recovery tracking. This automated orchestration triggers the instant generation of clinical credentials, providing the patient with a centralized dashboard for monitoring medication adherence, room assignments, and facilitating direct real-time consultation with their surgical team. Consequently, the project transforms fragmented clinical workflows into a unified, transparent journey that significantly optimizes the post-surgical recovery experience through advanced technological integration.
1.2 Problem Statement:
Current hospital workflows are significantly hindered by fragmented manual reporting and delayed communication, leading to critical inefficiencies in patient care. A primary concern is information asymmetry, where patients and their families remain uninformed due to a lack of real-time updates regarding surgical outcomes and recovery steps. These issues are compounded by administrative bottlenecks, as the manual generation of patient IDs and recovery portals is both time-consuming and highly susceptible to human error. Furthermore, upon discharge, many patients experience post-operative isolation, struggling with medication compliance and lacking immediate digital access to their surgical team for urgent queries. This situation is worsened by data fragmentation, where vital surgical records and medication schedules are confined to physical files, making longitudinal health tracking nearly impossible for both clinicians and patients. Consequently, there is an urgent need for an integrated digital system to bridge these gaps, ensure data integrity, and enhance the overall continuity of post-surgical care.
1.3 Proposed System:
The proposed system is a comprehensive cross-platform mobile application designed to seamlessly orchestrate the entire post-surgical patient journey. Upon the surgeon marking an operation as "Successful," the system triggers an automated onboarding workflow, instantly generating secure credentials for the patient and eliminating time-consuming manual processes. This transition directs the patient to a unified recovery portal, a centralized, user-friendly dashboard where they can monitor their recovery status, access room assignments, and review surgical summaries in real-time. To ensure ongoing care and compliance, the platform incorporates a digital prescription and chat module, providing patients with a direct, secure communication line to their surgical team alongside an integrated medication management system to guarantee high adherence to post-operative protocols. By digitizing these essential interactions, the solution effectively bridges the gap between clinical efficiency and patient support, fostering better long-term health outcomes.
1.4 Benefits of Proposed System:
●	Operational Efficiency: Reduces the clinical staff's workload through automated credential generation and digital reporting.
●	Enhanced Patient Experience: Provides transparency and empowerment to the patient through the Patient Portal.
●	Improved Clinical Outcomes: Real-time medication reminders and direct chat reduce the risk of post-operative complications.
●	Data Integrity: Secure, cloud-based storage ensures that medical history is immutable and easily accessible for analytics.
1.5 Scope:
The scope of this project encompasses the end-to-end development of a sophisticated, multi-role mobile application tailored specifically for Doctors, Patients, and Administrators, ensuring a customized user experience for each stakeholder. At its core, the system features a robust automated notification and credentialing engine that eliminates manual entry by instantly generating secure access for patients following a successful surgery. To ensure professional and portable medical documentation, the application integrates a secure PDF generation module that converts surgical reports into standardized, shareable formats. Communication is further enhanced through a high-performance, real-time messaging architecture, providing a direct line for clinical support and post-operative guidance. It is important to note that while the system offers an intensive focus on surgical tracking and recovery management, it is purposefully streamlined to exclude broader administrative functions such as comprehensive hospital financial accounting or complex insurance processing, thereby maintaining its focus on clinical outcomes.

1.6 Survey Analysis:
Major Modules	Trinity Health MyChart 	Practo (Local/Regional)	Marham (Health Portal)	Proposed App
Multi-Role Authentication (Doctor/Patient/Admin)	☑	☑	☑	☑
Patient & Profile	☑	☑	☑	☑
  Automated Credentialing (OT to Mobile)	❌	❌	❌	☑
Real-time Surgical Tracking	❌	❌	❌	☑
Post-Op Recovery Dashboard (Room/Status)	☑	❌	❌	☑
Automated PDF Surgical Reports	☑	☑	☑	☑
Real-time Clinical Messaging	❌	☑	☑	☑
Medication Management Module	☑	❌	❌	☑
Automated Notifications Engine	☑	☑	☑	☑
Post-Surgical Feedback/Ratings	❌	☑	☑	☑
1.7 Modules & Sub Modules
1.7.1 Security Management 
•	Process SignIn
•	Process SignUp
•	Forgot Password
•	Change Account Password
•	Manage Role Permissions
1.7.2 Profile Management
•	Manage Staff Profile
•	Manage Patient Profile
•	View User Profiles
•	Manage Account Status
1.7.3 Doctor Management 
•	Add Doctor Profile & Specializations
•	Update Doctor Profile & Specializations
•	Manage Doctor Availability & Duty Timings
•	Manage Appointment
•	View Assigned Patients
•	Track Doctor Workload
1.7.4 Patient Portal Management 
•	View Patient Dashboard
•	Track Current Status
•	View Assigned Doctor
•	Download Operation Report
•	View Check-up History
1.7.5 Operation & Clinical Reporting 
•	Create Operation Record
•	Assign Surgical Team
•	Update Surgical Team
•	Record Operation Outcome
•	Generate Automated Credentials 
•	Upload Medical Reports
•	View Operation History
1.7.6 Medication Management 
•	Add Medicine Prescription
•	Update Medicine Dosage
•	View Medication Schedule
1.7.7 Communication Management 
•	Initiate Real-time Chat
•	View Chat History
•	Manage Emergency Alerts
1.7.8 Notifications Management 
•	Send Account Credentials
•	Send Checkup Reminders
•	Push Notifications
•	View Notification History
1.7.9 Reports & Analytics Management 
•	Generate Operation Success Reports
•	Doctor Performance Report
•	Patient Recovery Analytics
•	View and Print Summary
1.8 Primary Actors:
●	System Administrator
●	Medical Professional (Doctor/Surgeon)
●	Patient
1.9 Tools and Technologies:
1.9.1 Front-End Tools:
●	Material Design Widgets
●	Flutter Web
●	Flutter Provider (for State Management)
●	HTTP Package (for API Integration)
●	Responsive UI with Media Query and Flexbox Layouts Flutter (Dart Framework)
1.9.2 Back-End Tools:
●	Firebase (Authentication, Fire store Database, Cloud Functions)
●	Cloudinary (for advanced image/file storage)
●	RESTful APIs (custom endpoints for admin functionalities)
1.9.3 Deployment:
●	Testing Environment: Local & Firebase Hosting
1.9.4 Technique:
●	Cross-Platform Mobile & Web Application
●	(Single codebase developed using Flutter for Android, Web)
1.10 System Design Approach:
●	System design approach We will use MVVM (Model, View, View Model) approach for better performance of our project.
1.11 Process Model Used:
●	RUP (Rational Unified Process)
1.12 Modelling Techniques / Tools Used:
●	UML (Unified Model Language)
1.13 Limitations:
●	Internet Dependency: The system requires active connectivity for real-time chat and data syncing.
●	Hardware Integration: Currently limited to manual data entry rather than direct integration with OT biometric monitors.
●	Regulatory Compliance: Full-scale deployment would require strict adherence to local data privacy laws (e.g., HIPAA-like standards).
1.14 References:
●	World Health Organization (WHO) - Global Strategy on Digital Health.
●	Flutter Documentation - Building robust healthcare UI/UX.
●	Firebase Documentation - Scalable NoSQL architectures for real-time apps.
●	ERAS Society. (2023). Protocols for Enhanced Recovery After Surgery. Retrieved fromhttps://erassociety.org/
●	HHS. (2024). HIPAA Privacy & Security Standards for Healthcare Data. Retrieved from: https://www.hhs.gov/hipaa/index.html


 
