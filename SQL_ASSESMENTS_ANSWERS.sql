CREATE DATABASE HEALTHCARE;
USE HEALTHCARE;

CREATE TABLE PATIENTS(PatientID INT NOT NULL PRIMARY KEY,
					  Name VARCHAR(45),
                      DOB DATE,
                      Gender CHAR(1)
);

CREATE TABLE DOCTORS(DoctorID INT NOT NULL PRIMARY KEY,
					 Name VARCHAR(45),
                     Department VARCHAR(25)
);

CREATE TABLE APPOINTMENTS(AppID INT NOT NULL PRIMARY KEY,
                          PatientID INT,
                          DoctorID INT,
                          App_Date DATE,
                          FOREIGN KEY(DoctorID) REFERENCES DOCTORS(DoctorID),
                          FOREIGN KEY(PatientID) REFERENCES PATIENTS(PatientID)
);

CREATE TABLE PRESCRIPTIONS(PresID INT NOT NULL PRIMARY KEY,
						   AppID INT,
                           Medicine VARCHAR(45),
                           Dosage_mg INT,
                           FOREIGN KEY(AppID) REFERENCES APPOINTMENTS(AppID)
);

INSERT INTO patients VALUES
(1, 'Alice Smith', '1990-05-12', 'F'),
(2, 'Bob Johnson', '1985-03-22', 'M'),
(3, 'Carol White', '1978-11-02', 'F'),
(4, 'David Brown', '1995-07-19', 'M'),
(5, 'Eva Green', '2000-01-30', 'F');

INSERT INTO doctors VALUES
(1, 'Dr. Adams', 'Cardiology'),
(2, 'Dr. Baker', 'Neurology'),
(3, 'Dr. Clark', 'Orthopedics'),
(4, 'Dr. Davis', 'General Medicine');

INSERT INTO appointments VALUES
(1, 1, 1, '2025-01-05'),
(2, 1, 2, '2025-02-10'),
(3, 1, 3, '2025-03-15'),
(4, 2, 1, '2025-01-20'),
(5, 2, 4, '2025-02-18'),
(6, 3, 2, '2025-01-25'),
(7, 3, 2, '2025-02-25'),
(8, 3, 2, '2025-03-25'),
(9, 4, 3, '2025-03-01'),
(10, 4, 4, '2025-03-20'),
(11, 5, 4, '2025-02-05'),
(12, 5, 4, '2025-03-05');

INSERT INTO prescriptions VALUES
(1, 1, 'Paracetamol', 500),
(2, 1, 'Aspirin', 100),
(3, 2, 'Paracetamol', 650),
(4, 2, 'Ibuprofen', 400),
(5, 3, 'Paracetamol', 500),
(6, 3, 'Vitamin D', 1000),
(7, 4, 'Paracetamol', 500),
(8, 4, 'Statin', 20),
(9, 5, 'Ibuprofen', 400),
(10, 5, 'Paracetamol', 650),
(11, 6, 'Paracetamol', 500),
(12, 6, 'Aspirin', 75),
(13, 7, 'Paracetamol', 500),
(14, 7, 'Ibuprofen', 200),
(15, 8, 'Paracetamol', 650),
(16, 9, 'Calcium', 500),
(17, 9, 'Vitamin D', 1000),
(18, 10, 'Paracetamol', 500),
(19, 11, 'Paracetamol', 650),
(20, 12, 'Paracetamol', 500);

SELECT * FROM DOCTORS;
SELECT * FROM PATIENTS;
SELECT * FROM APPOINTMENTS;
SELECT * FROM PRESCRIPTIONS;

#assesment answers

#ANS1
SELECT D.DoctorID,D.Name,count(A.AppID) AS Appointmnet_count
FROM DOCTORS AS D
LEFT JOIN APPOINTMENTS AS A
ON A.DoctorID = D.DoctorID
WHERE App_Date >= CURDATE() - INTERVAL 30 DAY
group by D.DoctorID,D.Name
order by Appointmnet_count desc;

#ANS2
SELECT d.department, COUNT(DISTINCT a.patientid) AS patient_count
FROM doctors d
JOIN appointments a ON d.doctorid = a.doctorid
GROUP BY d.department;

#ANS3
SELECT medicine, COUNT(*) AS prescription_count
FROM prescriptions
GROUP BY medicine
ORDER BY prescription_count DESC
LIMIT 1;

#ANS4
SELECT p.patientid, p.name
FROM patients p
JOIN appointments a ON p.patientid = a.patientid
JOIN doctors d ON a.doctorid = d.doctorid
GROUP BY p.patientid, p.name
HAVING COUNT(DISTINCT d.department) > 2;

#ANS5
SELECT 
    AVG(appointment_count) AS avg_appointments_per_patient
FROM (
    SELECT patientid, COUNT(*) AS appointment_count
    FROM appointments
    GROUP BY patientid
)SUB;

#ANS6 List doctors who have prescribed more than 5 different medicines.
SELECT d.doctorid, d.name
FROM doctors d
JOIN appointments a ON d.doctorid = a.doctorid
JOIN prescriptions p ON a.appid = p.appid
GROUP BY d.doctorid, d.name
HAVING COUNT(DISTINCT p.medicine) > 5;

#ANS7
SELECT dosage_mg, COUNT(*) AS frequency
FROM prescriptions
WHERE medicine = 'Paracetamol'
GROUP BY dosage_mg
ORDER BY frequency DESC
LIMIT 3;

#ANS8
SELECT patientid,
       AVG(app_date - prev_app_date) AS avg_days_between_appointments
FROM (
    SELECT patientid,
           app_date,
           LAG(app_date) OVER (PARTITION BY patientid ORDER BY app_date) AS prev_app_date
    FROM appointments
) sub
WHERE prev_app_date IS NOT NULL
GROUP BY patientid;

#ANS9
SELECT patientid
FROM appointments
GROUP BY patientid
HAVING COUNT(DISTINCT YEAR(app_date), MONTH(app_date)) >= 3;

#ANS10
SELECT d.department, COUNT(DISTINCT a.patientid) AS unique_patients
FROM doctors d
JOIN appointments a ON d.doctorid = a.doctorid
GROUP BY d.department
ORDER BY unique_patients DESC
LIMIT 1;