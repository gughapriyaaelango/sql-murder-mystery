--SQL Murder mystery - https://mystery.knightlab.com/
/*
A crime has taken place and the detective needs your help. The detective gave you the crime scene report, but you somehow lost it. 
You vaguely remember that the crime was a ​murder​ that occurred sometime on ​Jan.15, 2018​ and that it took place in ​SQL City​. 
*/
--first identify the murder from crime_scene_report
select * from crime_scene_report
where date = 20180115 and type = "murder" and city = "SQL City"
--Result:
--Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave".

--search using address from person table
select * from person
where address_street_name like "Northwestern Dr"
and address_number in (select max(address_number) from person
where address_street_name like "Northwestern Dr");
--Result:
--Morty Schapiro of id - 14887

select * from person
where address_street_name like "Franklin Ave" and name like "Annabel%"
--Result:
--Annabel Miller of id - 16371

--Checking their facebook_event_checkin
select * from facebook_event_checkin
where person_id in (14887,16371)
--Result:
--On 15th Jan 2018, they were both in The Funky Grooves Tour
--event id - 4719

--Checking their interview
select * from interview
where person_id in (14887,16371)
--Morty: I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".
--Annabel: 	I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.

select g.person_id, g.name, g.membership_status,c.check_in_date from get_fit_now_member g
left join get_fit_now_check_in c on g.id = c.membership_id
left join person p on g.person_id = p.id
left join drivers_license l on p.license_id = l.id
where g.id like "48Z%" and g.membership_status = "gold" 
and c.check_in_date = 20180109 and l.plate_number like "%H42W%"
--Result: Jeremy Bowers - 67318
--Correct:
/*
Congrats, you found the murderer! But wait, there's more... If you think you're up for a challenge, try querying the interview transcript of the murderer to find the real villain behind this crime. If you feel especially confident in your SQL skills, try to complete this final step with no more than 2 queries. Use this same INSERT statement with your new suspect to check your answer.
*/

--Query the interview:
select * from interview
where person_id = 67318;
--Result:	I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.

--Query from the clues
select p.id,p.name,p.license_id, l.height,l.hair_color,l.gender,
l.car_make,l.car_model,f.event_name from person p
left join drivers_license l on l.id = p.license_id
left join facebook_event_checkin f on f.person_id = p.id
where l.height > 65 and l.height < 67 and 
l.hair_color = "red" and l.gender = "female" and l.car_make = "Tesla"
and l.car_model = "Model S"
and f.event_name like "SQL Symphony Concert" and f.date >= 20171201;

--Result: Miranda Priestly
--Congrats, you found the brains behind the murder! Everyone in SQL City hails you as the greatest SQL detective of all time. Time to break out the champagne!