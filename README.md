# SYNTHEA-POWERED-PATIENT-DATA
# Introduction:
Synthea is an open-source patient simulator that generates synthetic medical records of realistic patients. These records can be used for various purposes, such as training machine learning models or conducting research on healthcare trends. In this project, we will be analyzing Synthea-powered patient data to gain insights into the demographic and health-related characteristics of the patients.
# Aim:
The aim of this project is to analyze the Synthea-generated patient data and provide insights into the demographic and health-related characteristics of the patients. The analysis will involve data cleaning, exploratory data analysis, and making recommendations based on the findings.
# Data Source
The dataset is located on data.world platform
https://data.world/sparklesquad/exercises-for-dataworld-sql-tutorial
# Questions
- Determine the total number of patients, patients immunized, the number of male and female patients, and patients with allergies?
- How many male and female patients have been immunized?
- Which vaccine has been administered the most number of times?
- What are the top five most common conditions among patients, and how are they distributed among different races?
- What is the distribution of patients per allergy type?
- What is the most commonly performed medical procedure?
- How are patients distributed by ethnicity?
-  What are the top five reasons for patient visits?
- Number of patients that have not been assigned a care plan?
- What are the most common medications prescribed, and what is the corresponding Condition?
- Determine the number of patients living outside of the United States.

# Dashboard
![PATIENT](https://user-images.githubusercontent.com/106782819/230750850-ee718f57-fad9-4d57-8772-2082a5f2810f.png)
# Analysis
```ruby
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

#Number of patients that have not been assigned a care plan?
SELECT Count(patients.PATIENT)
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
```
# Findings 

- The total number of patients in the dataset is 1462, out of which 1140 have been immunized, and 157 have allergies. The dataset has 741 male patients and 721 female patients.

- Among the patients who have been immunized, 573 are female and 567 are male.

- The most administered vaccine was Influenza seasonal injectable preservative-free with a total of 7247 administered doses.

- Acute bronchitis (disorder) is the most common condition among patients, and it is prevalent in white patients with 297 cases. The other four most common conditions among patients are Acute viral pharyngitis (disorder), Hypertension, Prediabetes, and Viral sinusitis (disorder).

- Patients have been distributed among different allergy types with Allergy to mould being the most prevalent allergy type with 85 patients. This is followed by Dander (animal) allergy, House dust mite allergy, and Allergy to grass pollen.

- Patients are distributed among different ethnicities, with Irish being the most common ethnicity with 306 patients. This is followed by Italian, English, and Puerto Rican.

- The top five reasons for patient visits are Outpatient Encounter, Encounter for symptom, Patient encounter procedure, Prenatal visit, and Outpatient procedure.

- 274 patients were not assigned a care plan.

- Penicillin V Potassium 250 MG is the most commonly prescribed medication, and it is prescribed for Viral sinusitis (disorder).

- No patients live outside the US.

# Recommendations
- The data shows that out of the 1462 patients, only 1140 have been immunized. This means that there is still a significant number of patients who have not been immunized, and it is important to increase awareness and education on the importance of immunization to prevent the spread of diseases.
- It is recommended that healthcare providers focus on preventive measures to reduce the incidence of viral sinusitis (disorder), as it is the most common condition among patients. Healthcare providers should also prioritize preventing acute viral pharyngitis (disorder), prediabetes,  acute bronchitis and  hypertension  as these are also prevalent conditions among patients.
- Although the number of patients with allergies is relatively low compared to the total number of patients in the dataset, it is still important to raise awareness about allergies and how to manage them. Healthcare providers can educate patients on how to identify allergy triggers and how to manage allergy symptoms.
- With patients from different ethnicities, healthcare providers should receive cultural competence training to understand the cultural backgrounds and beliefs of their patients. This will help to improve the quality of care and strengthen patient-provider relationships.
- The most common reason for patient visits is Outpatient Encounter, which indicates that outpatient care needs to be given more importance.
- Since all patients live in the US, healthcare providers should continue to monitor patients living in the US to prevent the spread of infectious diseases and prevent outbreaks.



