--                                                Hospital Management System Analysis

-- create database
create database HospitalManagementSystem

-- selecting the database
use HospitalManagementSystem

-- Importing all the required files

select * from Patient
select * from Doctor
select * from Medical_History
select * from Appointment


/*  Q1. Appointments per doctor with rank (most to least busy)  */

-- Only be considering the appointment count

select d.DoctorID,
		count(a.PatientID) as appointment_count,
		sum(case when Status='Completed' then 1 else 0 end)as Completed_Status,
		sum(case when Status='Cancelled' then 1 else 0 end)as Cancelled_Status,
		dense_rank() over(order by count(a.PatientID) desc) as 'Rank'
from Doctor d 
left join 
Appointment a
on d.DoctorID=a.DoctorID
group by d.DoctorID
order by 2 desc

-- _______________________________________________________________________________________________________________________________________

/*  Q2. Peak booking hours (by start time hour)  */

select hour,count(AppointmentID) as 'appointment_count' from
(select AppointmentID,Date,datepart(HOUR,Date) as hour from Appointment) as sub_query
group by hour
order by 2 desc

-- _______________________________________________________________________________________________________________________________________

/*  Q3. Which doctor has the most appointments?  */

-- Considering only the overall appointment

select top 1 DoctorID,count(AppointmentID) as Appointment_count
from Appointment
group by DoctorID
order by 2 desc

-- _______________________________________________________________________________________________________________________________________

/*  Q4. How many patients does each doctor treat? */

-- Only for completed,Patient that get treated by doctor
select d.DoctorID,COUNT(distinct a.PatientID) as Patient_Count
from Doctor d 
left join 
(select * from Appointment where Status='Completed') a
on d.DoctorID=a.DoctorID
group by d.DoctorID

-- From appointment
select d.DoctorID,COUNT(distinct a.PatientID) as Patient_Count
from Doctor d 
left join
Appointment a
on d.DoctorID=a.DoctorID
group by d.DoctorID
order by 2 desc

-- _______________________________________________________________________________________________________________________________________

/*  Q5. Doctor–patient pairs with most interactions (top 10)  */

-- Analyzed from appointment
select top 10 DoctorID,PatientID,count(*) as 'Interaction_Count'
from Appointment
group by DoctorID,PatientID
order by 3 desc

-- also Getting treated by doctor
select top 10 DoctorID,PatientID,count(*) as 'Interaction_Count'
from Appointment
where Status='Completed'
group by DoctorID,PatientID
order by 3 desc

-- _______________________________________________________________________________________________________________________________________

/*  Q6. First and most recent visit per patient (with total visits)  */

select p.PatientID,
		count(a.AppointmentID) as total_visit,
		min(Date) as First_visit,
		max(Date) as Recent_visit  
from Patient p
left join Appointment a
on p.PatientID=a.PatientID
group by p.PatientID
order by 2 desc

-- _______________________________________________________________________________________________________________________________________

