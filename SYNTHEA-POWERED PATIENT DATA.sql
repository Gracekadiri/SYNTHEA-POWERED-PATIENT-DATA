#Count the total number of patients, immunized patients, patients with allergies, and male and female patients 
SELECT COUNT(DISTINCT patients.PATIENT) AS "Total Patients",
       COUNT(DISTINCT immunizations.PATIENT) AS "Immunized Patients",
       COUNT(DISTINCT allergies.PATIENT) AS "Patients with Allergies",
       COUNT(DISTINCT CASE WHEN patients.gender = 'M' THEN patients.patient END) AS "Male Patients",
       COUNT(DISTINCT CASE WHEN patients.gender = 'F' THEN patients.patient END) AS "Female Patients"
FROM patients
LEFT OUTER JOIN immunizations ON immunizations.patient = patients.patient
LEFT JOIN allergies ON patients.patient = allergies.patient;

#Count the number of male and female patients who have been immunized:
SELECT patients.gender, COUNT(DISTINCT immunizations.patient) AS "Immunized Patients"
FROM immunizations
JOIN patients ON immunizations.patient = patients.patient
GROUP BY patients.gender;

#What vaccine was administered to patients the most number of times:
SELECT description, COUNT(*) AS "Total Administered"
FROM immunizations
GROUP BY description
ORDER BY COUNT(*) DESC;


#Top five most common conditions among patients and their distribution among different races:
WITH top_conditions AS (
  SELECT code, description, COUNT(*) AS "Total Patients"
  FROM conditions
  GROUP BY code, description
  ORDER BY COUNT(*) DESC
  LIMIT 5
)
SELECT tc.description AS "Condition", 
       r.race, 
       COUNT(DISTINCT c.patient) AS "Patients"
FROM top_conditions tc
JOIN conditions c ON tc.code = c.code AND tc.description = c.description
JOIN patients p ON c.patient = p.patient
JOIN (
  SELECT DISTINCT patient, race
  FROM patients
) r ON p.patient = r.patient
GROUP BY tc.description, r.race
ORDER BY tc.description, r.race desc;

#Distribution of patients per allergy type:
SELECT description AS "Allergy Type", COUNT(DISTINCT patient) AS "Patients"
FROM allergies
GROUP BY description
ORDER BY Patients DESC;

#Most commonly performed medical procedure:
SELECT description AS "Procedure", COUNT(*) AS "Total Performed"
FROM procedures
GROUP BY description
ORDER BY COUNT(*) DESC
LIMIT 1;

#Patients distributed by ethnicity:
SELECT ethnicity, COUNT(DISTINCT patient) AS "Patients"
FROM patients
GROUP BY ethnicity
ORDER BY COUNT(*) DESC;

#Top five reasons for patients visits:
SELECT description AS "Reason for Visit", COUNT(*) AS "Total Visits"
FROM encounters
GROUP BY description
ORDER BY COUNT(*) DESC
LIMIT 5;

#Which patients have not been assigned a care plan?
SELECT patients.first, patients.last, careplans.description
FROM patients 
LEFT JOIN careplans
ON patients.patient = careplans.patient
WHERE careplans.patient IS NULL;

#What are the most common medications prescribed, and what is the corresponding Condition?
SELECT medications.DESCRIPTION AS MEDICATION, count(medications.DESCRIPTION) AS FREQUENCY, conditions.DESCRIPTION AS CONDITIONS 
FROM medications
LEFT OUTER JOIN conditions
ON medications.patient = conditions.patient
GROUP BY medications.DESCRIPTION, conditions.DESCRIPTION
ORDER BY FREQUENCY desc;

# Find patients who live outside US
SELECT address FROM patients
WHERE address NOT LIKE '%us%'









