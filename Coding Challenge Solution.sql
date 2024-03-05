create database Crime;
use Crime;

/*TABLE CREATION*/
create table Crime(
CrimeId int primary key,
IncidentType varchar(255),
IncidentDate date,
Location varchar(255),
Description text,
Status Varchar(20)
);

create table Victim(
VictimID int primary key,
CrimeId int,
Name varchar(255),
ContactInfo varchar(255),
Injuries varchar(255),
Foreign key (CrimeId) references Crime(CrimeId)
);

create table Suspect(
SuspectId int primary key,
CrimeId int,
Name varchar(255),
Description text,
CriminalHistory text,
foreign key(CrimeId) references Crime(CrimeId)
);

/* Inserting Data*/

insert into Crime values (1,'Robbery','2023-09-15','123 Main St, Cityville','Armed Robbery at a convenience store','Open'),
(2,'Homicide','2023-09-20','456 Elm St, Townsville','Investigation into a murder case','Under Investigation'),
(3,'Theft','2023-09-10','789 Oak St, Villagetown','Shoplifting incident at a mall','Closed');

/*VictimID,CrimeId,Name,ContactInfo,Injuries */

insert into Victim values (1,1,'John Doe','johndoe@example.com','Minor Injuries'),
(2,2,'Jane Smith','janesmith@example.com','Deceased'),
(3,3,'Alice Johnson','alicejohnson@example.com','None');

insert into Suspect values (1,1,'Robber 1','Armed and masked robber','Previous robbery convitions'),
(2,2,'Unknown','Investigation Ongoing',NULL),
(3,3,'Suspect 1','Shoplifting suspect','Prior shoplifting arrests');

-- Table Updation
alter table Victim add (VictimAge int);
alter table Suspect add (SuspectAge int);

update Victim set VictimAge=42 where VictimId=1;
update Victim set VictimAge=32 where VictimId=2;
update Victim set VictimAge=35 where VictimId=3;

update Suspect set SuspectAge=27 where SuspectId=1;
update Suspect set SuspectAge=NULL where SuspectId=2;
update Suspect set SuspectAge=30 where SuspectId=3;

-- Viewing Table
select * from Crime;
select * from Victim;
select * from Suspect;

-- Coding Challenges
/* 1. Query to select all open incidents*/
select * from crime where Status='Open';

/* 2.Query to find the total number of incidents*/
select count(*) as TotalIncidents from Crime;

/* 3. Query to list all unique incident types*/
select distinct IncidentType from Crime;

/* 4. Query to retrieve incidents between 2023-09-01 and 2023-09-10 */
select * from Crime where IncidentDate between '2023-09-01' and '2023-09-10';

-- 5. Query to list persons involved in incidents in descending order of age
(select C.CrimeID,V.Name as Name,V.VictimAge as Age from Crime C join Victim V 
on C.CrimeId=V.CrimeId union select C.CrimeID,S.Name as Name,S.SuspectAge as Age from Crime C join Suspect S
on C.CrimeId=S.SuspectID) order by Age desc;

-- 6. Query to find the average age of persons involved in incidents
select avg(age) from(select V.VictimAge as age from Victim V union select S.SuspectAge as age from Suspect S) as AvgAge;

/* 7. Query to list incident types and their counts, only for open cases*/
select IncidentType,count(*) as IncidentTypeCount from Crime where Status='Open' group by IncidentType;

/* 8. Query to find persons with names containing 'Doe'*/
select * from Victim where Name like '%Doe';

/* 9. Query to retrieve the names of persons involved in open cases and closed cases.*/
select V.Name,'Victim' as PersonType,'Open' as CaseStatus from Victim V join Crime C on V.CrimeId=C.CrimeId where C.Status='Open'
union select S.Name,'Suspect' as PersonType,'Open' as CaseStatus from Suspect S join Crime C on S.CrimeId=C.CrimeID where C.Status='Open'
union
select V.Name,'Victim' as PersonType,'Closed' as CaseStatus from Victim V join Crime C on V.CrimeId=C.CrimeID where C.Status='Closed'
union select S.Name,'Suspect' as PersonType,'Cloesed' as CaseStatus from Suspect S join Crime C on 
S.CrimeId=C.CrimeId where C.Status='Closed';

-- 10. Query to list incident types where there are persons aged 30 or 35 involved
select distinct C.IncidentType from Crime C join(select CrimeId from Victim where VictimAge between 30 and 35
union select CrimeId from Suspect where SuspectAge between 30 and 35 ) as PersonAge on C.CrimeId = PersonAge.CrimeId;

/* 11. Query to find persons involved in incidents of the same type as 'Robbery'*/
select Name,'Robbery' as IncidentType from (
select V.Name from Victim V join Crime C on V.CrimeId=C.CrimeId where C.IncidentType='Robbery' union 
select S.Name from Suspect S join Crime C on S.CrimeID=C.CrimeId where C.IncidentType='Robbery') as PersonsInvolved;

/* 12. Query to list incident types with more than one open case*/
select IncidentType, count(Status) as Count from Crime where Status='Open' group by IncidentType;

/* 13. Query to list all incidents with suspects whose names also appear as victims in other incidents*/
select * from Crime C join Suspect S on C.CrimeId = S.CrimeId
join Victim V on S.Name = V.Name AND S.CrimeId != V.CrimeId;

/* 14. Query to retrieve all incidents along with victim and suspect details*/
select C.CrimeID,C.IncidentType,C.IncidentDate,V.VictimId,V.Name as VictimName,v.ContactInfo,
V.Injuries,S.SuspectId,S.Name as SuspectName,S.Description,S.CriminalHistory
from Crime C left join Victim V on C.CrimeID=V.CrimeID left join Suspect S on C.CrimeId=S.CrimeID;

/* 15. Query to incidents where the suspect is older than any victim*/
select * from (select C.CrimeId,C.IncidentType,C.IncidentDate from Crime C join Victim V on C.CrimeId=V.CrimeId 
join Suspect S on S.CrimeId=C.CrimeId where S.SuspectAge>V.VictimAge) as Age;

-- 16. Query to find suspects involved in multiple incidents
select SuspectId, Name, count(distinct CrimeId) as NumIncidents from Suspect
group by SuspectId, Name having count(distinct CrimeId) > 1;


-- 17. Query to list incidents with no suspects involved
select C.CrimeId,C.IncidentType,C.IncidentDate from Crime C join Suspect S on C.CrimeId=S.CrimeId
where S.Name='Unknown';

/* 18. Query to list all cases where at least one incident is of type 'Homicide' and all other incidents are of type 
'Robbery' */
(select * from Crime where IncidentType='Homicide' union
select * from Crime where IncidentType='Robbery') order by CrimeId;

/*19. Query to Retrieve a list of all incidents and the associated suspects, showing suspects for each incident, or 
'No Suspect' if there are none */
select C.CrimeId,C.IncidentType,C.IncidentType,C.Location,C.Description,S.SuspectId,
if(S.Name!='Unknown',S.Name,'No Suspect') as SuspectName from Crime C left join Suspect S on C.CrimeId=S.CrimeId;

/*20. Query to list all suspects who have been involved in incidents with incident types 'Robbery' or 'Assault */
select distinct * from Suspect S join Crime C on S.CrimeId = C.CrimeId
where C.IncidentType = 'Robbery' or C.IncidentType = 'Assault';

