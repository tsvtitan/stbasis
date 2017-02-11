insert into ap_region_street
select distinct(p.ap_region_id),
       p.ap_street_id
from ap_premises p
join ap_region r on r.ap_region_id=p.ap_region_id
join ap_street s on s.ap_street_id=p.ap_street_id
