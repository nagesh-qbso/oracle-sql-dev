-- Create table
create table TARIFF_TRN
(
  TARIFF_PK                NUMBER(10) not null,
  TLI_CODE                 VARCHAR2(20),
  POL_FK                   NUMBER(10) not null,
  POD_FK                   NUMBER(10) not null,
  SERVICE_MST_FK           NUMBER(10),
  CARRIER_MST_FK           NUMBER(10),
  POL_TERMINAL             NUMBER(10),
  POD_TERMINAL             NUMBER(10),
  COMMODITY_GROUP_MST_FK   NUMBER(10) not null,
  COMMODITY_MST_FK         NUMBER(10),
  FREIGHT_ELEMENT_MST_FK   NUMBER(10) not null,
  PERCENTAGE_AMOUNT        NUMBER(1) default 1 not null,
  CURRENCY_MST_FK          NUMBER(10),
  CONTAINTER_TYPE_MST_FK   NUMBER(10),
  RATE                     NUMBER(14,2),
  EFFECTIVE_FROM           DATE not null,
  EFFECTIVE_TO             DATE,
  CONTAINER_STATUS         NUMBER(1) not null,
  PORT_GROUP               NUMBER(1) default 0,
  PORT_GROUP_POL_FK        NUMBER(10),
  PORT_GROUP_POD_FK        NUMBER(10),
  ITEM_TYPE                NUMBER(10) default 1 not null,
  TARIFF_BASIS             NUMBER(1) default 0,
  PROCESS_TYPE             NUMBER(1) default 0,
  CNTR_APPLICABLE          NUMBER(1) default 0,
  CHARGE_TYPE              NUMBER(10) default 1,
  CREATED_BY_FK            NUMBER(10) not null,
  CREATED_DT               DATE default SYSDATE not null,
  LAST_MODIFIED_BY_FK      NUMBER(10),
  LAST_MODIFIED_DT         DATE,
  VERSION_NO               NUMBER(4) default 0 not null,
  BUSINESS_MODEL           NUMBER default 4,
  STANDARD_FREIGHT_RATE_FK NUMBER(10),
  STANDARD_FREIGHT_CODE    VARCHAR2(20),
  POT_FK                   NUMBER(10),
  POT_TERMINAL             NUMBER(10),
  CARGO_TYPE_MST_FK        NUMBER(10),
  PKG_TYPE_MST_FK          NUMBER(10),
  UOM_FK                   NUMBER(10),
  SHIPPING_TERMS_FK        NUMBER(10),
  APPROVAL_STATUS          NUMBER(1) default 1,
  APPROVED_BY_FK           NUMBER(10),
  APPROVAL_DATE            DATE,
  APPROVAL_REMARK          VARCHAR2(200)
)
tablespace QMIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 512K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 
comment on column TARIFF_TRN.CARRIER_MST_FK
  is 'Reference to LINE';
comment on column TARIFF_TRN.PERCENTAGE_AMOUNT
  is '1-Amount,2-Percentage';
comment on column TARIFF_TRN.CONTAINER_STATUS
  is '1- EMPTY , 2- FULL , 3- TS EMPTY, 4- TS FULL';
comment on column TARIFF_TRN.PORT_GROUP
  is '0-Trade/Sector, 1-Port Group';
comment on column TARIFF_TRN.ITEM_TYPE
  is '2-Credit, 1-Debit';
comment on column TARIFF_TRN.TARIFF_BASIS
  is '0-Unit,1-BL';
comment on column TARIFF_TRN.PROCESS_TYPE
  is '0-Both,1-Import,2-Export';
comment on column TARIFF_TRN.CNTR_APPLICABLE
  is '0-Both,1-COC,2-SOC';
comment on column TARIFF_TRN.CHARGE_TYPE
  is '1-Tariff, 2-Local Charges';
comment on column TARIFF_TRN.APPROVAL_STATUS
  is '1 for pending, 2 for approved';
-- Create/Recreate primary, unique and foreign key constraints 
alter table TARIFF_TRN
  add constraint PK_TARIFF_TRN primary key (TARIFF_PK)
  using index 
  tablespace QMIA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 128K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table TARIFF_TRN
  add constraint FK12_CURRENCY_TYPE_MST_TBL foreign key (CURRENCY_MST_FK)
  references CURRENCY_TYPE_MST_TBL (CURRENCY_MST_PK);
alter table TARIFF_TRN
  add constraint FK7_CARRIER_MST_TBL foreign key (CARRIER_MST_FK)
  references CARRIER_MST_TBL (CARRIER_MST_PK);
-- Create/Recreate check constraints 
alter table TARIFF_TRN
  add constraint CK1_TARIFF_TRN
  check (CONTAINER_STATUS IN (1,2,3,4));
-- Create/Recreate indexes 
create index IDX_TARIFFTRN_EFFFROM on TARIFF_TRN (EFFECTIVE_FROM)
  tablespace QMIA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index IDX_TARIFFTRN_EFFTO on TARIFF_TRN (EFFECTIVE_TO)
  tablespace QMIA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index IDX_TARIFFTRN_FNEFFFROM on TARIFF_TRN (TO_DATE(TO_CHAR(EFFECTIVE_FROM,'dd/MM/yyyy'),'DD/MM/YYYY'))
  tablespace QMIA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index IDX_TARIFFTRN_FNEFFTO on TARIFF_TRN (TO_DATE(TO_CHAR(EFFECTIVE_TO,'dd/MM/yyyy'),'DD/MM/YYYY'))
  tablespace QMIA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index IDX_TARIFFTRN_FRIELMFK on TARIFF_TRN (FREIGHT_ELEMENT_MST_FK)
  tablespace QMIA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
