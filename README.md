# DocDoc - Medical Consultation Management System

A comprehensive Java-based web application for managing medical consultations, patient queues, and specialist expertise requests. The system handles three main user roles: nurses (Infirmiers), general practitioners (Médecins Généralistes), and specialists (Médecins Spécialistes).

## Project Overview

DocDoc streamlines the medical consultation workflow by:
- Managing patient registration and vital signs tracking
- Organizing a FIFO patient queue system
- Facilitating consultation requests and expertise consultations
- Calculating consultation costs with technical procedures and specialist fees
- Managing specialist availability through 30-minute time slots

## Architecture

### Tech Stack
- **Backend**: Java 17+, Jakarta EE, Servlet API
- **Database**: JPA/Hibernate ORM
- **Frontend**: JSP, Tailwind CSS, Font Awesome Icons
- **Server**: Apache Tomcat 10+
- **Build**: Maven

### Project Structure
```
src/main/java/com/docdoc/docdoc/
├── model/               # Entity classes (Patient, Consultation, etc.)
├── repository/          # Data access layer (CRUD operations)
├── service/             # Business logic layer
├── servlet/
│   ├── infirmier/       # Nurse servlets
│   ├── generaliste/     # General practitioner servlets
│   └── specialiste/     # Specialist servlets
└── util/                # Utilities (CSRF, Auth, etc.)

src/main/webapp/
└── WEB-INF/views/
    ├── infirmier/       # Nurse JSP pages
    ├── generaliste/     # GP JSP pages
    └── specialiste/     # Specialist JSP pages
```

## Core Features

### US1: Nurse - Register Patient & Vital Signs
- Register new patients with demographic information
- Record initial vital signs (blood pressure, heart rate, temperature, etc.)
- Automatically add patient to consultation queue

**Key Classes**: `CreerConsultationServlet`, `PatientService`, `Patient.java`

### US2: Queue Management (FIFO)
- Patients automatically enter queue when vital signs are recorded
- Queue ordered by arrival time (earliest first)
- Automatic removal from queue after consultation completes
- Real-time status updates

**Key Classes**: `PatientRepository`, `Patient.enAttente`

### US3: GP - Request Specialist Expertise
- Select specialist by specialty
- **Stream API filtering**: Filter specialists by specialty and tariff (sorted ascending)
- Choose from available time slots (30-minute intervals)
- Submit medical question and supplementary data

**Key Classes**: `ConsultationGeneralisteService`, `DemanderExpertiseServlet`

### US4: Total Cost Calculation
- **Lambda/Stream API**: `mapToDouble(ActeTechnique::getTarif).sum()`
- Calculates: Consultation (150 DH) + Technical Acts + Specialist Expertise
- Real-time cost display on consultation detail page

**Key Classes**: `ConsultationGeneralisteService.calculerCoutTotal()`

### US5: Specialist - Configure Profile
- Set consultation tariff (per expertise)
- Select medical specialty
- Fixed consultation duration: 30 minutes

**Key Classes**: `ProfilSpecialisteServlet`, `ExpertiseSpecialisteService`

### US6: Manage Time Slots
- Predefined 30-minute slots (09:00 - 12:00)
- 6 slots per day: 09:00-09:30, 09:30-10:00, 10:00-10:30, etc.
- Auto-mark as unavailable when reserved
- Auto-archive past slots
- Release on cancellation

**Key Classes**: `CreneauxSpecialisteServlet`, `Creneau.java`

### US7: View Expertise Requests
- **Stream API Filtering**: Filter by status (EN_ATTENTE, TERMINEE) AND priority (URGENTE, NORMALE, NON_URGENTE)
- Sorted by priority (urgent first), then by date
- Display patient details and medical question
- Real-time statistics

**Key Classes**: `DemandesExpertiseServlet`, `ExpertiseSpecialisteService.getDemandesExpertiseFiltrées()`

### US8: Answer Expertise Request
- Input medical opinion (required)
- Input recommendations (optional)
- Mark as completed (TERMINEE)
- Auto-calculate revenue from completed expertises

**Key Classes**: `RepondreExpertiseServlet`, `DemandeExpertise.repondre()`

## Servlet Endpoints

### Nurse (Infirmier)
- `GET/POST /infirmier/dashboard` - Dashboard
- `GET/POST /infirmier/consultation/enregistrer` - Register patient
- `GET/POST /infirmier/patient/signes-vitaux` - Add vital signs
- `GET /infirmier/liste-patients` - Patient list
- `GET/POST /infirmier/patient/detail` - Patient detail
- `POST /infirmier/patient/retirer-attente` - Remove from queue

### GP (Médecin Généraliste)
- `GET/POST /generaliste/dashboard` - Dashboard
- `GET/POST /generaliste/consultation/creer` - Create consultation
- `GET/POST /generaliste/consultation/demander-expertise` - Request expertise
- `GET /generaliste/consultation/detail` - Consultation detail
- `POST /generaliste/consultation/ajouter-acte` - Add technical act
- `POST /generaliste/consultation/close` - Close consultation
- `GET /generaliste/api/specialistes-par-specialite` - AJAX: Load specialists
- `GET /generaliste/api/creneaux-disponibles` - AJAX: Load available slots

### Specialist (Médecin Spécialiste)
- `GET/POST /specialiste/dashboard` - Dashboard
- `GET/POST /specialiste/profil` - Configure profile (US5)
- `GET/POST /specialiste/creneaux` - Manage time slots (US6)
- `GET /specialiste/demandes-expertise` - View requests (US7)
- `GET/POST /specialiste/repondre-expertise` - Answer request (US8)

## Setting Up the Project

### Prerequisites
- Java 17+
- Maven 3.8+
- Apache Tomcat 10+
- PostgreSQL/MySQL database

### Installation

1. **Clone and build**
```bash
git clone <repository>
cd docdoc
mvn clean install
```

2. **Configure database**
   Create `src/main/resources/persistence.xml`:
```xml
<persistence-unit name="docdoc-pu">
    <properties>
        <property name="jakarta.persistence.jdbc.url" value="jdbc:mysql://localhost:3306/docdoc"/>
        <property name="jakarta.persistence.jdbc.user" value="root"/>
        <property name="jakarta.persistence.jdbc.password" value="password"/>
        <property name="hibernate.dialect" value="org.hibernate.dialect.MySQL8Dialect"/>
    </properties>
</persistence-unit>
```

3. **Deploy to Tomcat**
```bash
mvn clean package
# Copy target/docdoc.war to CATALINA_HOME/webapps/
```

4. **Access application**
- Navigate to `http://localhost:8080/docdoc`
- Login with nurse/GP/specialist credentials

## Testing the Workflow

### Complete User Flow
1. **Nurse registers patient** → Patient enters queue
2. **GP creates consultation** → Selects waiting patient
3. **GP requests expertise** → Selects specialist and time slot
4. **GP adds technical acts** → Calculates total cost (Lambda/Stream)
5. **Specialist answers** → Provides medical opinion
6. **GP closes consultation** → Adds diagnosis and treatment
7. **Patient removed from queue** → Automatically

## Future Enhancements

- Email notifications for appointment confirmations
- SMS reminders for scheduled consultations
- Doctor performance analytics
- Patient medical history export (PDF)
- Multi-language support
- Mobile app integration
- Real-time availability updates
- Prescription management
- Payment processing integration
