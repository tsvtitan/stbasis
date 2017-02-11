update pms_premises p
set p.pms_city_region_id=(select rc.pms_city_region_id
from pms_regions_correspond  rc where rc.pms_region_id=p.pms_region_id)


CREATE INDEX PMS_PREMISES_ADVERTISMENT_IDX1 ON PMS_PREMISES_ADVERTISMENT (PMS_PREMISES_ID);
CREATE INDEX PMS_PREMISES_ADVERTISMENT_IDX2 ON PMS_PREMISES_ADVERTISMENT (PMS_AGENT_ID);
