
CREATE TABLE stoperation_accounttype (
       accounttype_id       INTEGER NOT NULL,
       standartoperation_id INTEGER NOT NULL
);

CREATE UNIQUE INDEX XPKstoperation_accounttype ON stoperation_accounttype
(
       standartoperation_id,
       accounttype_id
);


ALTER TABLE stoperation_accounttype
       ADD PRIMARY KEY (standartoperation_id, accounttype_id);


ALTER TABLE stoperation_accounttype
       ADD FOREIGN KEY (standartoperation_id)
                             REFERENCES standartoperation;


ALTER TABLE stoperation_accounttype
       ADD FOREIGN KEY (accounttype_id)
                             REFERENCES accounttype;


