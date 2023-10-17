CREATE OR REPLACE PACKAGE FETCH_VENDOR_SOA_DATE IS

  -- Author  : VASANTHA
  -- Created : 10/11/2012 12:57:36 PM
  -- Purpose : 
  TYPE VENDOR_SOA_DATE_CURSOR IS REF CURSOR;
  PROCEDURE FETCH_VENDOR_SOA_BYDATE(QILS_LOCATION_PK_IN IN VARCHAR2,
                                    LOCATION_PK_IN      IN VARCHAR2,
                                    FROM_DATE_IN        IN VARCHAR2,
                                    TODATE_IN           IN VARCHAR2,
                                    VENDOR_IN           IN VARCHAR2,
                                    VENDORTYPE_IN       IN VARCHAR2,
                                    CURRENCY_IN         IN NUMBER,
                                    USER_PK_IN          IN NUMBER,
                                    ADMIN_IN            IN VARCHAR2,
                                    SHIP_LINE_PK_IN     IN NUMBER,
                                    LINE_MST_FK_IN      IN NUMBER,
                                    GROUP_CUR           OUT VENDOR_SOA_DATE_CURSOR,
                                    LINE_CUR            OUT VENDOR_SOA_DATE_CURSOR,
                                    LOCATION_CUR        OUT VENDOR_SOA_DATE_CURSOR,
                                    VENDOR_CUR          OUT VENDOR_SOA_DATE_CURSOR,
                                    TRANS_CUR           OUT VENDOR_SOA_DATE_CURSOR /*,
                                                                        RETURN_VALUE   OUT CLOB*/);

  PROCEDURE FETCH_VENDOR_SOA_BYTRANS(COUNTRY_PK_IN  IN VARCHAR2,
                                     LOCATION_PK_IN IN VARCHAR2,
                                     FROM_DATE_IN   IN VARCHAR2,
                                     TODATE_IN      IN VARCHAR2,
                                     VENDOR_IN      IN VARCHAR2,
                                     VENDORTYPE_IN  IN VARCHAR2,
                                     CURRENCY_IN    IN NUMBER,
                                     USER_PK_IN     IN NUMBER,
                                     ADMIN_IN       IN VARCHAR2,
                                     SHIP_LINE_PK_IN     IN NUMBER,
                                     LINE_MST_FK_IN      IN NUMBER,
                                     GROUP_CUR      OUT VENDOR_SOA_DATE_CURSOR,
                                     LINE_CUR       OUT VENDOR_SOA_DATE_CURSOR,
                                     LOCATION_CUR   OUT VENDOR_SOA_DATE_CURSOR,
                                     VENDOR_CUR     OUT VENDOR_SOA_DATE_CURSOR,
                                     TRANS_CUR      OUT VENDOR_SOA_DATE_CURSOR);

  PROCEDURE FETCH_VENDORSOA_BYDATE_REPORT(QILS_LOCATION_PK_IN IN VARCHAR2,
                                           LOCATION_PK_IN      IN VARCHAR2,
                                           FROM_DATE_IN        IN VARCHAR2,
                                           TODATE_IN           IN VARCHAR2,
                                           VENDOR_IN           IN VARCHAR2,
                                           VENDORTYPE_IN       IN VARCHAR2,
                                           CURRENCY_IN         IN NUMBER,
                                           USER_PK_IN          IN NUMBER,
                                           ADMIN_IN            IN VARCHAR2,
                                           SHIP_LINE_PK_IN     IN NUMBER,
                                           LINE_MST_FK_IN      IN NUMBER,
                                           TRANS_CUR           OUT VENDOR_SOA_DATE_CURSOR);

  PROCEDURE FETCH_VENDOR_SOA_BYTRANS_REP(COUNTRY_PK_IN  IN VARCHAR2,
                                         LOCATION_PK_IN IN VARCHAR2,
                                         FROM_DATE_IN   IN VARCHAR2,
                                         TODATE_IN      IN VARCHAR2,
                                         VENDOR_IN      IN VARCHAR2,
                                         VENDORTYPE_IN  IN VARCHAR2,
                                         CURRENCY_IN    IN NUMBER,
                                         USER_PK_IN     IN NUMBER,
                                         ADMIN_IN       IN VARCHAR2,
                                         SHIP_LINE_PK_IN     IN NUMBER,
                                         LINE_MST_FK_IN      IN NUMBER,
                                         --RETURNVAL           OUT CLOB);
                                         TRANS_CUR      OUT VENDOR_SOA_DATE_CURSOR);

  PROCEDURE FETCH_VENDOR_SOA_BYDATE_REPORT(QILS_LOCATION_PK_IN IN VARCHAR2,
                                           LOCATION_PK_IN      IN VARCHAR2,
                                           FROM_DATE_IN        IN VARCHAR2,
                                           TODATE_IN           IN VARCHAR2,
                                           VENDOR_IN           IN VARCHAR2,
                                           VENDORTYPE_IN       IN VARCHAR2,
                                           CURRENCY_IN         IN NUMBER,
                                           USER_PK_IN          IN NUMBER,
                                           ADMIN_IN            IN VARCHAR2,
                                          -- SHIP_LINE_PK_IN     IN NUMBER,
                                          -- LINE_MST_FK_IN      IN NUMBER,
                                           TRANS_CUR           OUT VENDOR_SOA_DATE_CURSOR/*,
                                           RETURNVAL      OUT CLOB*/);
                                       

END FETCH_VENDOR_SOA_DATE;
/
CREATE OR REPLACE PACKAGE BODY FETCH_VENDOR_SOA_DATE IS

  -- Private type declarations
  PROCEDURE FETCH_VENDOR_SOA_BYDATE(QILS_LOCATION_PK_IN IN VARCHAR2,
                                    LOCATION_PK_IN      IN VARCHAR2,
                                    FROM_DATE_IN        IN VARCHAR2,
                                    TODATE_IN           IN VARCHAR2,
                                    VENDOR_IN           IN VARCHAR2,
                                    VENDORTYPE_IN       IN VARCHAR2,
                                    CURRENCY_IN         IN NUMBER,
                                    USER_PK_IN          IN NUMBER,
                                    ADMIN_IN            IN VARCHAR2,
                                    SHIP_LINE_PK_IN     IN NUMBER,
                                    LINE_MST_FK_IN      IN NUMBER,
                                    GROUP_CUR           OUT VENDOR_SOA_DATE_CURSOR,
                                    LINE_CUR            OUT VENDOR_SOA_DATE_CURSOR,
                                    LOCATION_CUR        OUT VENDOR_SOA_DATE_CURSOR,
                                    VENDOR_CUR          OUT VENDOR_SOA_DATE_CURSOR,
                                    TRANS_CUR           OUT VENDOR_SOA_DATE_CURSOR/* ,
                                                                        RETURN_VALUE   OUT CLOB*/) AS
    STRSTRING  VARCHAR2(32767);
    STRSTRING1 VARCHAR2(32767);
    STRSTRING2 VARCHAR2(32767);
    STRSTRING3 VARCHAR2(32767);

  BEGIN

    DELETE FROM TEMP_VENDOR_SOA_DATE;

    -- <<<<<<<< FOR INSERTING IN TEMP TABLE >>>>>>>-----
    STRSTRING := ' INSERT INTO TEMP_VENDOR_SOA_DATE (';
    STRSTRING := STRSTRING || ' SELECT DISTINCT LOCATION_MST_PK, ';
    STRSTRING := STRSTRING || ' LOCATION_NAME, ';
    STRSTRING := STRSTRING || ' VENDOR_MST_PK, ';
    STRSTRING := STRSTRING || ' VENDOR_ID, ';
    STRSTRING := STRSTRING || ' VENDOR_NAME, ';
    STRSTRING := STRSTRING || ' REF_DATE, ';
    STRSTRING := STRSTRING || ' TRANCACTION, ';
    STRSTRING := STRSTRING || ' DOC_REF_NO, ';
    STRSTRING := STRSTRING || ' DEBIT * GET_EX_RATE_NEW(' || CURRENCY_IN ||
                 ',CURRENCY_MST_FK,REF_DATE) DEBIT, ';
    STRSTRING := STRSTRING || ' NVL(CREDIT,0)*GET_EX_RATE_NEW(' ||
                 CURRENCY_IN || ',CURRENCY_MST_FK,REF_DATE) CREDIT, ';
    STRSTRING := STRSTRING || ' BALANCE, ';
    STRSTRING := STRSTRING || ' GROUPID, ';
    STRSTRING := STRSTRING || ' COUNTRY_MST_FK, ';
    STRSTRING := STRSTRING || ' VENDOR_TYPE_MST_FK, ';
    STRSTRING := STRSTRING || ' CURRENCY_MST_FK,';
    STRSTRING := STRSTRING || ' PK, ';
    STRSTRING := STRSTRING || ' 0 LIQUIDATION_REF_NO, ';
    STRSTRING := STRSTRING || ' LOCATION_MST_FK, ';
    STRSTRING := STRSTRING || ' CREATED_DATE,LINE_MST_FK,';
    STRSTRING := STRSTRING || ' CARRIER_ID,CARRIER_NAME,INVOICE_NO ';
    STRSTRING := STRSTRING || ' FROM VIEW_VENDOR_SOA_DATE  ';
    STRSTRING := STRSTRING || ' WHERE 1 =  1 ';

    IF LOCATION_PK_IN IS NULL THEN
      IF ADMIN_IN = 'Y' THEN
        STRSTRING := STRSTRING ||
                     ' AND LOCATION_MST_FK  IN (SELECT L.qils_LOCATION_MST_fK FROM LOCATION_MST_TBL L START WITH L.LOCATION_MST_PK IN (' ||
                     USER_PK_IN || ')';
        STRSTRING := STRSTRING ||
                     ' CONNECT BY PRIOR L.LOCATION_MST_PK = L.REPORTING_TO_FK) ';
        STRSTRING := STRSTRING ||
                     ' AND LOCATION_MST_PK  IN (SELECT L.LOCATION_MST_PK FROM LOCATION_MST_TBL L START WITH L.LOCATION_MST_PK IN (' ||
                     USER_PK_IN || ')';
        STRSTRING := STRSTRING ||
                     ' CONNECT BY PRIOR L.LOCATION_MST_PK = L.REPORTING_TO_FK) ';
      ELSE
        STRSTRING := STRSTRING || ' AND LOCATION_MST_PK IN ( ' ||
                     USER_PK_IN || ')';
        STRSTRING := STRSTRING ||
                     ' AND LOCATION_MST_FK IN (
                     (SELECT L.qils_LOCATION_MST_fK FROM LOCATION_MST_TBL L where L.LOCATION_MST_PK in (' ||
                     USER_PK_IN || ')))';

      END IF;
    ELSE
      STRSTRING := STRSTRING ||
                   ' AND LOCATION_MST_FK IN (
                  SELECT L.qils_LOCATION_MST_fK FROM LOCATION_MST_TBL L where L.LOCATION_MST_PK IN (' ||
                   LOCATION_PK_IN || '))';
      STRSTRING := STRSTRING || ' AND LOCATION_MST_PK IN ( ' ||
                   LOCATION_PK_IN || ')';
    END IF;

    IF QILS_LOCATION_PK_IN IS NOT NULL THEN
      STRSTRING := STRSTRING || ' AND LOCATION_MST_FK IN ( ' ||
                   QILS_LOCATION_PK_IN || ')';
    END IF;

    IF VENDOR_IN IS NOT NULL THEN
      STRSTRING := STRSTRING || ' AND VENDOR_MST_PK    IN ( ' || VENDOR_IN || ')';
    END IF;

    IF SHIP_LINE_PK_IN IS NOT NULL THEN
      IF SHIP_LINE_PK_IN >0 THEN
      STRSTRING := STRSTRING || ' AND LINE_MST_FK    IN ( ' || SHIP_LINE_PK_IN || ')';
      END IF;
    END IF;

    IF VENDORTYPE_IN IS NOT NULL THEN
      STRSTRING := STRSTRING ||
                   ' AND VENDOR_MST_PK  IN ( SELECT VENDOR_MST_FK FROM VENDOR_TYPE_TRN VTT WHERE VTT.VENDOR_TYPE_MST_FK IN (' ||
                   VENDORTYPE_IN || '))';
    END IF;

    STRSTRING := STRSTRING || ' )';
   -- RETURN_VALUE :=STRSTRING;
	 ----P_DEBUG('FETCH_VENDOR_SOA_DATE.FETCH_VENDOR_SOA_BYDATE-INS', STRSTRING);
 EXECUTE IMMEDIATE STRSTRING;
    COMMIT;
    --------------<<< INSERT END >>>>>>-------------

    ----GROUP CURSOR-------------------------
    STRSTRING := ' SELECT DISTINCT GROUPID FROM TEMP_VENDOR_SOA_DATE';
    STRSTRING := STRSTRING || ' WHERE TO_DATE(REF_DATE, ''dd/MM/yyyy'') >= TO_DATE(''' ||
                 FROM_DATE_IN ||
                 ''', ''dd/MM/yyyy'') AND TO_DATE(REF_DATE, ''dd/MM/yyyy'') <= TO_DATE(''' ||
                 TODATE_IN || ''', ''dd/MM/yyyy'') ';
    OPEN GROUP_CUR FOR STRSTRING;
    ----LINE CURSOR-------------------------
    STRSTRING := ' SELECT DISTINCT LINE_MST_FK, CARRIER_NAME, BALANCE, GROUPID FROM TEMP_VENDOR_SOA_DATE';
    STRSTRING := STRSTRING || ' WHERE TO_DATE(REF_DATE, ''dd/MM/yyyy'') >= TO_DATE(''' ||
                 FROM_DATE_IN ||
                 ''', ''dd/MM/yyyy'') AND TO_DATE(REF_DATE, ''dd/MM/yyyy'') <= TO_DATE(''' ||
                 TODATE_IN ||
                 ''', ''dd/MM/yyyy'') ORDER BY LINE_MST_FK';
    OPEN LINE_CUR FOR STRSTRING;
    ----LOCATION CURSOR-------------------------
    STRSTRING := ' SELECT DISTINCT LOCATION_MST_PK, LOCATION_NAME, BALANCE, GROUPID, LINE_MST_FK FROM TEMP_VENDOR_SOA_DATE';
    STRSTRING := STRSTRING || ' WHERE TO_DATE(REF_DATE, ''dd/MM/yyyy'') >= TO_DATE(''' ||
                 FROM_DATE_IN ||
                 ''', ''dd/MM/yyyy'') AND TO_DATE(REF_DATE, ''dd/MM/yyyy'') <= TO_DATE(''' ||
                 TODATE_IN ||
                 ''', ''dd/MM/yyyy'') ORDER BY LOCATION_MST_PK';
    OPEN LOCATION_CUR FOR STRSTRING;
    ----VENDOR CURSOR-------------------------
    STRSTRING := ' SELECT DISTINCT LOCATION_MST_PK,VENDOR_MST_PK,VENDOR_NAME, VENDOR_ID,
                                    BALANCE,LOCATION_MST_PK AGENT_FK , LINE_MST_FK FROM TEMP_VENDOR_SOA_DATE';
    STRSTRING := STRSTRING || ' WHERE TO_DATE(REF_DATE, ''dd/MM/yyyy'') >= TO_DATE(''' ||
                 FROM_DATE_IN ||
                 ''', ''dd/MM/yyyy'') AND TO_DATE(REF_DATE, ''dd/MM/yyyy'') <= TO_DATE(''' ||
                 TODATE_IN || ''', ''dd/MM/yyyy'')  ORDER BY VENDOR_MST_PK';
    OPEN VENDOR_CUR FOR STRSTRING;

    ----Transaction CURSOR-------------------------
    STRSTRING  := ' SELECT VENDOR_MST_PK,0 LOCATION_MST_PK,
                TO_DATE(REF_DATE, ''dd/MM/yyyy'') REF_DATE,
                TRANCACTION,DOC_REF_NO ,DEBIT,
                CREDIT,
                 BALANCE,PK, CREATED_DATE,AGENT_FK, LINE_MST_FK
                 from (';
    STRSTRING  := STRSTRING || ' SELECT DISTINCT VENDOR_MST_PK,0 LOCATION_MST_PK,
                TO_DATE(''' || FROM_DATE_IN ||
                  ''', ''dd/MM/yyyy'') REF_DATE,
                ''OPENING BALANCE'' TRANCACTION, '' '' DOC_REF_NO , SUM(nvl(DEBIT,0) - nvl(CREDIT,0)) DEBIT,
                  0 CREDIT,
                  SUM(nvl(DEBIT,0) - nvl(CREDIT,0)) BALANCE,0 PK, TO_DATE(''' ||
                  FROM_DATE_IN ||
                  ''', ''dd/MM/yyyy HH24:Mi:ss'') CREATED_DATE,AGENT_FK, LINE_MST_FK
                  from (select DISTINCT V.VENDOR_MST_PK,B.DEBIT,B.CREDIT,b.REF_DATE,A.LOCATION_MST_PK AGENT_FK,A.LINE_MST_FK FROM VENDOR_MST_TBL V,';
    STRSTRING1 := ' (SELECT DISTINCT VENDOR_MST_PK,LOCATION_MST_PK,LINE_MST_FK FROM TEMP_VENDOR_SOA_DATE';
    STRSTRING1 := STRSTRING1 || ' WHERE TO_DATE(REF_DATE, ''dd/MM/yyyy'') >= TO_DATE(''' ||
                  FROM_DATE_IN ||
                  ''', ''dd/MM/yyyy'') AND TO_DATE(REF_DATE, ''dd/MM/yyyy'') <= TO_DATE(''' ||
                  TODATE_IN || ''', ''dd/MM/yyyy''))A, ';
    STRSTRING2 := ' (SELECT DISTINCT * FROM TEMP_VENDOR_SOA_DATE';
    STRSTRING2 := STRSTRING2 || ' WHERE TO_DATE(REF_DATE, ''dd/MM/yyyy'') < TO_DATE(''' ||
                  FROM_DATE_IN || ''',''dd/MM/yyyy''))B ';
    STRSTRING3 := '  WHERE V.VENDOR_MST_PK = A.VENDOR_MST_PK
                            AND A.VENDOR_MST_PK = B.VENDOR_MST_PK(+))
                            GROUP BY VENDOR_MST_PK,AGENT_FK,LINE_MST_FK
                      UNION
                      SELECT DISTINCT VENDOR_MST_PK, LOCATION_MST_PK,REF_DATE,
                             TRANCACTION,DOC_REF_NO,
                             DEBIT, CREDIT, BALANCE,PK,CREATED_DATE,LOCATION_MST_PK AGENT_FK,LINE_MST_FK
                             FROM TEMP_VENDOR_SOA_DATE';
    STRSTRING3 := STRSTRING3 || ' WHERE TO_DATE(REF_DATE, ''dd/MM/yyyy'') >= TO_DATE(''' ||
                  FROM_DATE_IN ||
                  ''', ''dd/MM/yyyy'') AND TO_DATE(REF_DATE, ''dd/MM/yyyy'') <= TO_DATE(''' ||
                  TODATE_IN ||
                  ''', ''dd/MM/yyyy'')ORDER BY REF_DATE,LOCATION_MST_PK,created_date,TRANCACTION DESC) ORDER BY TO_DATE(REF_DATE),LOCATION_MST_PK,created_date,TRANcACTION DESC';
		--P_DEBUG('FETCH_VENDOR_SOA_DATE.FETCH_VENDOR_SOA_BYDATE-TRANS', STRSTRING || STRSTRING1 || STRSTRING2 || STRSTRING3);							
    OPEN TRANS_CUR FOR STRSTRING || STRSTRING1 || STRSTRING2 || STRSTRING3;

  END FETCH_VENDOR_SOA_BYDATE;

  PROCEDURE FETCH_VENDOR_SOA_BYTRANS(COUNTRY_PK_IN  IN VARCHAR2,
                                     LOCATION_PK_IN IN VARCHAR2,
                                     FROM_DATE_IN   IN VARCHAR2,
                                     TODATE_IN      IN VARCHAR2,
                                     VENDOR_IN      IN VARCHAR2,
                                     VENDORTYPE_IN  IN VARCHAR2,
                                     CURRENCY_IN    IN NUMBER,
                                     USER_PK_IN     IN NUMBER,
                                     ADMIN_IN       IN VARCHAR2,
                                     SHIP_LINE_PK_IN     IN NUMBER,
                                     LINE_MST_FK_IN      IN NUMBER,
                                     GROUP_CUR      OUT VENDOR_SOA_DATE_CURSOR,
                                     LINE_CUR       OUT VENDOR_SOA_DATE_CURSOR,
                                     LOCATION_CUR   OUT VENDOR_SOA_DATE_CURSOR,
                                     VENDOR_CUR     OUT VENDOR_SOA_DATE_CURSOR,
                                     TRANS_CUR      OUT VENDOR_SOA_DATE_CURSOR) AS
    STRSTRING  VARCHAR2(32767);
    STRSTRING1 VARCHAR2(32767);
    STRSTRING2 VARCHAR2(32767);
    STRSTRING3 VARCHAR2(32767);

  BEGIN

    DELETE FROM TEMP_VENDOR_SOA_DATE;

    -- <<<<<<<< FOR INSERTING IN TEMP TABLE >>>>>>>-----
    STRSTRING := ' INSERT INTO TEMP_VENDOR_SOA_DATE (';
    STRSTRING := STRSTRING || ' SELECT DISTINCT LOCATION_MST_PK, ';
    STRSTRING := STRSTRING || ' LOCATION_NAME, ';
    STRSTRING := STRSTRING || ' VENDOR_MST_PK, ';
    STRSTRING := STRSTRING || ' VENDOR_ID, ';
    STRSTRING := STRSTRING || ' VENDOR_NAME, ';
    STRSTRING := STRSTRING || ' REF_DATE, ';
    STRSTRING := STRSTRING || ' TRANCACTION, ';
    STRSTRING := STRSTRING || ' DOC_REF_NO, ';
    STRSTRING := STRSTRING || ' SUM(DEBIT*GET_EX_RATE_NEW(' || CURRENCY_IN ||
                 ',CURRENCY_MST_FK,REF_DATE)) DEBIT, ';
    STRSTRING := STRSTRING || ' SUM(NVL(CREDIT,0)*GET_EX_RATE_NEW(' ||
                 CURRENCY_IN || ',CURRENCY_MST_FK,REF_DATE)) CREDIT, ';
    STRSTRING := STRSTRING || ' BALANCE, ';
    STRSTRING := STRSTRING || ' GROUPID, ';
    STRSTRING := STRSTRING || ' COUNTRY_MST_FK, ';
    STRSTRING := STRSTRING || ' VENDOR_TYPE_MST_FK, ';
    STRSTRING := STRSTRING || ' CURRENCY_MST_FK, ';
    STRSTRING := STRSTRING || ' DA_VOUCHER_HDR_PK PK, ';
    STRSTRING := STRSTRING || ' LIQUIDATION_REF_NO, ';
    STRSTRING := STRSTRING || ' LOCATION_MST_FK, ';
    STRSTRING := STRSTRING || ' CREATED_DATE,LINE_MST_FK ,';
    STRSTRING := STRSTRING || ' CARRIER_ID,CARRIER_NAME,invoice_no ';--,'' '' ritik
    STRSTRING := STRSTRING || ' FROM VIEW_VENDOR_SOA_TRANS  ';
    STRSTRING := STRSTRING || ' WHERE 1 =  1 ';

    IF LOCATION_PK_IN IS NULL THEN
      IF ADMIN_IN = 'Y' THEN
        STRSTRING := STRSTRING ||
                     ' AND LOCATION_MST_FK  IN (SELECT L.qils_LOCATION_MST_fK FROM LOCATION_MST_TBL L START WITH L.LOCATION_MST_PK IN (' ||
                     USER_PK_IN || ')';
        STRSTRING := STRSTRING ||
                     ' CONNECT BY PRIOR L.LOCATION_MST_PK = L.REPORTING_TO_FK) ';
        STRSTRING := STRSTRING ||
                     ' AND LOCATION_MST_PK  IN (SELECT L.LOCATION_MST_PK FROM LOCATION_MST_TBL L START WITH L.LOCATION_MST_PK IN (' ||
                     USER_PK_IN || ')';
        STRSTRING := STRSTRING ||
                     ' CONNECT BY PRIOR L.LOCATION_MST_PK = L.REPORTING_TO_FK) ';
      ELSE
        STRSTRING := STRSTRING || ' AND LOCATION_MST_PK IN ( ' ||
                     USER_PK_IN || ')';
        STRSTRING := STRSTRING ||
                     ' AND LOCATION_MST_FK IN (
                    (SELECT L.qils_LOCATION_MST_fK FROM LOCATION_MST_TBL L where L.LOCATION_MST_PK in (' ||
                     USER_PK_IN || ')))';

      END IF;
    ELSE
      STRSTRING := STRSTRING ||
                   ' AND LOCATION_MST_FK IN (
      (SELECT L.qils_LOCATION_MST_fK FROM LOCATION_MST_TBL L where L.LOCATION_MST_PK in (' ||
                   LOCATION_PK_IN || ')))';

    END IF;

    IF COUNTRY_PK_IN IS NOT NULL THEN
      STRSTRING := STRSTRING || ' AND COUNTRY_MST_FK IN ( ' ||
                   COUNTRY_PK_IN || ')';
    END IF;

    IF VENDOR_IN IS NOT NULL THEN
      STRSTRING := STRSTRING || ' AND VENDOR_MST_PK    IN ( ' || VENDOR_IN || ')';
    END IF;

    IF SHIP_LINE_PK_IN IS NOT NULL THEN
     IF SHIP_LINE_PK_IN >0 THEN
      STRSTRING := STRSTRING || ' AND LINE_MST_FK    IN ( ' || SHIP_LINE_PK_IN || ')';
      END IF;
    END IF;

    IF VENDORTYPE_IN IS NOT NULL THEN
      STRSTRING := STRSTRING || ' AND VENDOR_TYPE_MST_FK  IN ( ' ||
                   VENDORTYPE_IN || ')';
    END IF;

    STRSTRING := STRSTRING || ' GROUP BY LOCATION_MST_PK, LOCATION_NAME, ';
    STRSTRING := STRSTRING || ' VENDOR_MST_PK, ';
    STRSTRING := STRSTRING || ' VENDOR_ID, ';
    STRSTRING := STRSTRING || ' VENDOR_NAME, ';
    STRSTRING := STRSTRING || ' REF_DATE, ';
    STRSTRING := STRSTRING || ' TRANCACTION, ';
    STRSTRING := STRSTRING || ' DOC_REF_NO, ';
    STRSTRING := STRSTRING || ' BALANCE, ';
    STRSTRING := STRSTRING || ' GROUPID, ';
    STRSTRING := STRSTRING || ' COUNTRY_MST_FK, ';
    STRSTRING := STRSTRING || ' VENDOR_TYPE_MST_FK, ';
    STRSTRING := STRSTRING || ' DA_VOUCHER_HDR_PK, ';
    STRSTRING := STRSTRING || ' LIQUIDATION_REF_NO, ';
    STRSTRING := STRSTRING || ' LOCATION_MST_FK, ';
    STRSTRING := STRSTRING || ' CURRENCY_MST_FK, ';
    STRSTRING := STRSTRING || ' CREATED_DATE,LINE_MST_FK ,';
    STRSTRING := STRSTRING || ' CARRIER_ID,CARRIER_NAME,invoice_no )';

    --P_DEBUG('FETCH_VENDOR_SOA_DATE.FETCH_VENDOR_SOA_BYTRANS-INS', STRSTRING);
		
    EXECUTE IMMEDIATE STRSTRING;
    COMMIT;
    --------------<<< INSERT END >>>>>>-------------

    ----GROUP CURSOR-------------------------

    STRSTRING := ' SELECT DISTINCT GROUPID FROM TEMP_VENDOR_SOA_DATE';
    STRSTRING := STRSTRING || ' WHERE TO_DATE(REF_DATE, ''dd/MM/yyyy'') >= TO_DATE(''' ||
                 FROM_DATE_IN ||
                 ''', ''dd/MM/yyyy'') AND TO_DATE(REF_DATE, ''dd/MM/yyyy'') <= TO_DATE(''' ||
                 TODATE_IN || ''', ''dd/MM/yyyy'') ';
		--P_DEBUG('FETCH_VENDOR_SOA_DATE.FETCH_VENDOR_SOA_BYTRANS-GRP', STRSTRING);
    OPEN GROUP_CUR FOR STRSTRING;
   ----LINE CURSOR-------------------------
    STRSTRING := ' SELECT DISTINCT LINE_MST_FK, CARRIER_NAME, BALANCE, GROUPID FROM TEMP_VENDOR_SOA_DATE';
    STRSTRING := STRSTRING || ' WHERE TO_DATE(REF_DATE, ''dd/MM/yyyy'') >= TO_DATE(''' ||
                 FROM_DATE_IN ||
                 ''', ''dd/MM/yyyy'') AND TO_DATE(REF_DATE, ''dd/MM/yyyy'') <= TO_DATE(''' ||
                 TODATE_IN ||
                 ''', ''dd/MM/yyyy'') ORDER BY LINE_MST_FK';
		--P_DEBUG('FETCH_VENDOR_SOA_DATE.FETCH_VENDOR_SOA_BYTRANS-LINE', STRSTRING);
    OPEN LINE_CUR FOR STRSTRING;

    ----LOCATION CURSOR-------------------------
    STRSTRING := ' SELECT DISTINCT LOCATION_MST_PK, LOCATION_NAME, BALANCE, GROUPID, LINE_MST_FK FROM TEMP_VENDOR_SOA_DATE';
    STRSTRING := STRSTRING || ' WHERE TO_DATE(REF_DATE, ''dd/MM/yyyy'') >= TO_DATE(''' ||
                 FROM_DATE_IN ||
                 ''', ''dd/MM/yyyy'') AND TO_DATE(REF_DATE, ''dd/MM/yyyy'') <= TO_DATE(''' ||
                 TODATE_IN ||
                 ''', ''dd/MM/yyyy'') ORDER BY LOCATION_MST_PK';
		--P_DEBUG('FETCH_VENDOR_SOA_DATE.FETCH_VENDOR_SOA_BYTRANS-LOC', STRSTRING);
    OPEN LOCATION_CUR FOR STRSTRING;

    ----VENDOR CURSOR-------------------------
    STRSTRING := ' SELECT DISTINCT LOCATION_MST_PK,VENDOR_MST_PK,VENDOR_NAME, VENDOR_ID,
                                    BALANCE,LOCATION_MST_PK AGENT_FK, LINE_MST_FK FROM TEMP_VENDOR_SOA_DATE';
    STRSTRING := STRSTRING || ' WHERE TO_DATE(REF_DATE, ''dd/MM/yyyy'') >= TO_DATE(''' ||
                 FROM_DATE_IN ||
                 ''', ''dd/MM/yyyy'') AND TO_DATE(REF_DATE, ''dd/MM/yyyy'') <= TO_DATE(''' ||
                 TODATE_IN || ''', ''dd/MM/yyyy'') ORDER BY VENDOR_MST_PK';
		--P_DEBUG('FETCH_VENDOR_SOA_DATE.FETCH_VENDOR_SOA_BYTRANS-VEND', STRSTRING);
    OPEN VENDOR_CUR FOR STRSTRING;

    ----Transaction CURSOR-------------------------
     STRSTRING  := ' SELECT VENDOR_MST_PK,0 LOCATION_MST_PK,
                TO_DATE(REF_DATE, ''dd/MM/yyyy'') REF_DATE,
                 DOC_REF_NO ,
                 DEBIT,liquidation_ref_no,CREDIT,
                 BALANCE,
                 OUTSTANDING,PK,AGENT_FK, LINE_MST_FK
                 from (';
    STRSTRING  := STRSTRING || ' SELECT DISTINCT VENDOR_MST_PK,0 LOCATION_MST_PK,
                TO_DATE(''' || FROM_DATE_IN ||
                  ''', ''dd/MM/yyyy'') REF_DATE,
               ''OPENING BALANCE'' DOC_REF_NO ,
                 SUM(NVL(DEBIT,0) -NVL(CREDIT,0)) DEBIT,'' '' liquidation_ref_no, 0  CREDIT,
               SUM(NVL(DEBIT,0) -NVL(CREDIT,0)) BALANCE,
                 SUM(NVL(DEBIT,0) -NVL(CREDIT,0))OUTSTANDING,0 PK, AGENT_FK, LINE_MST_FK
                 from (select DISTINCT V.VENDOR_MST_PK,B.DEBIT,B.CREDIT,b.REF_DATE,A.LOCATION_MST_PK AGENT_FK,A.LINE_MST_FK FROM VENDOR_MST_TBL V,';
    STRSTRING1 := ' (SELECT DISTINCT VENDOR_MST_PK,LOCATION_MST_PK,REF_DATE,'''' PROCESS,
                 DOC_REF_NO,DEBIT,liquidation_ref_no,CREDIT,BALANCE,0 OUTSTANDING,PK,LOCATION_MST_FK, LINE_MST_FK FROM TEMP_VENDOR_SOA_DATE';
    STRSTRING1 := STRSTRING1 || ' WHERE TO_DATE(REF_DATE, ''dd/MM/yyyy'') >= TO_DATE(''' ||
                  FROM_DATE_IN ||
                  ''', ''dd/MM/yyyy'') AND TO_DATE(REF_DATE, ''dd/MM/yyyy'') <= TO_DATE(''' ||
                  TODATE_IN || ''', ''dd/MM/yyyy''))A, ';
    STRSTRING2 := ' (SELECT DISTINCT VENDOR_MST_PK,LOCATION_MST_PK,REF_DATE,TRANCACTION,
                DOC_REF_NO,DEBIT,liquidation_ref_no,CREDIT,BALANCE,0 OUTSTANDING,PK,LOCATION_MST_PK AGENT_FK FROM TEMP_VENDOR_SOA_DATE';
    STRSTRING2 := STRSTRING2 || ' WHERE TO_DATE(REF_DATE, ''dd/MM/yyyy'') < TO_DATE(''' ||
                  FROM_DATE_IN || ''',''dd/MM/yyyy''))B ';
    STRSTRING3 := '  WHERE V.VENDOR_MST_PK = A.VENDOR_MST_PK
                            AND A.VENDOR_MST_PK = B.VENDOR_MST_PK(+))
                            GROUP BY VENDOR_MST_PK,AGENT_FK,LINE_MST_FK
                      UNION
                      SELECT DISTINCT VENDOR_MST_PK,LOCATION_MST_PK,REF_DATE,
                 DOC_REF_NO,DEBIT,liquidation_ref_no,CREDIT,BALANCE,0 OUTSTANDING,PK,LOCATION_MST_PK AGENT_FK, LINE_MST_FK
                             FROM TEMP_VENDOR_SOA_DATE';
    STRSTRING3 := STRSTRING3 || ' WHERE TO_DATE(REF_DATE, ''dd/MM/yyyy'') >= TO_DATE(''' ||
                  FROM_DATE_IN ||
                  ''', ''dd/MM/yyyy'') AND TO_DATE(REF_DATE, ''dd/MM/yyyy'') <= TO_DATE(''' ||
                  TODATE_IN ||
                  ''', ''dd/MM/yyyy'') ORDER BY REF_DATE,LOCATION_MST_PK) ORDER BY TO_DATE(REF_DATE),LOCATION_MST_PK';
									
		--P_DEBUG('FETCH_VENDOR_SOA_DATE.FETCH_VENDOR_SOA_BYTRANS-TRANS', STRSTRING || STRSTRING1 || STRSTRING2 || STRSTRING3);							
    OPEN TRANS_CUR FOR STRSTRING || STRSTRING1 || STRSTRING2 || STRSTRING3;

  END FETCH_VENDOR_SOA_BYTRANS;

  PROCEDURE FETCH_VENDORSOA_BYDATE_REPORT(QILS_LOCATION_PK_IN IN VARCHAR2,
                                           LOCATION_PK_IN      IN VARCHAR2,
                                           FROM_DATE_IN        IN VARCHAR2,
                                           TODATE_IN           IN VARCHAR2,
                                           VENDOR_IN           IN VARCHAR2,
                                           VENDORTYPE_IN       IN VARCHAR2,
                                           CURRENCY_IN         IN NUMBER,
                                           USER_PK_IN          IN NUMBER,
                                           ADMIN_IN            IN VARCHAR2,
                                           SHIP_LINE_PK_IN     IN NUMBER,
                                           LINE_MST_FK_IN      IN NUMBER,
                                           TRANS_CUR           OUT VENDOR_SOA_DATE_CURSOR) AS
    STRSTRING  VARCHAR2(32767);
    STRSTRING1 VARCHAR2(32767);
    STRSTRING2 VARCHAR2(32767);
    STRSTRING3 VARCHAR2(32767);

  BEGIN

    DELETE FROM TEMP_VENDOR_SOA_DATE;

    STRSTRING := ' INSERT INTO TEMP_VENDOR_SOA_DATE (';
    STRSTRING := STRSTRING || ' SELECT DISTINCT LOCATION_MST_PK, ';
    STRSTRING := STRSTRING || ' LOCATION_NAME, ';
    STRSTRING := STRSTRING || ' VENDOR_MST_PK, ';
    STRSTRING := STRSTRING || ' VENDOR_ID, ';
    STRSTRING := STRSTRING || ' VENDOR_NAME, ';
    STRSTRING := STRSTRING || ' REF_DATE, ';
    STRSTRING := STRSTRING || ' TRANCACTION, ';
    STRSTRING := STRSTRING || ' DOC_REF_NO, ';
    STRSTRING := STRSTRING || ' DEBIT * GET_EX_RATE_NEW(' || CURRENCY_IN ||
                 ',CURRENCY_MST_FK,REF_DATE) DEBIT, ';
    STRSTRING := STRSTRING || ' NVL(CREDIT,0)*GET_EX_RATE_NEW(' ||
                 CURRENCY_IN || ',CURRENCY_MST_FK,REF_DATE) CREDIT, ';
    STRSTRING := STRSTRING || ' BALANCE, ';
    STRSTRING := STRSTRING || ' GROUPID, ';
    STRSTRING := STRSTRING || ' COUNTRY_MST_FK, ';
    STRSTRING := STRSTRING || ' VENDOR_TYPE_MST_FK, ';
    STRSTRING := STRSTRING || ' CURRENCY_MST_FK,';
    STRSTRING := STRSTRING || ' PK, ';
    STRSTRING := STRSTRING || ' 0 LIQUIDATION_REF_NO, ';
    STRSTRING := STRSTRING || ' LOCATION_MST_FK, ';
    STRSTRING := STRSTRING || ' CREATED_DATE,LINE_MST_FK ,';
    STRSTRING := STRSTRING || ' CARRIER_ID,CARRIER_NAME,INVOICE_NO ';
    STRSTRING := STRSTRING || ' FROM VIEW_VENDOR_SOA_DATE  ';
    STRSTRING := STRSTRING || ' WHERE 1 =  1 ';

    IF LOCATION_PK_IN IS NULL AND USER_PK_IN IS NOT NULL THEN
      IF ADMIN_IN = 'Y' THEN
        STRSTRING := STRSTRING ||
                     ' AND LOCATION_MST_FK  IN (SELECT L.QILS_LOCATION_MST_FK FROM LOCATION_MST_TBL L START WITH L.LOCATION_MST_PK IN (' ||
                     USER_PK_IN || ')';
        STRSTRING := STRSTRING ||
                     ' CONNECT BY PRIOR L.LOCATION_MST_PK = L.REPORTING_TO_FK) ';
        STRSTRING := STRSTRING ||
                     ' AND LOCATION_MST_PK  IN (SELECT L.LOCATION_MST_PK FROM LOCATION_MST_TBL L START WITH L.LOCATION_MST_PK IN (' ||
                     USER_PK_IN || ')';
        STRSTRING := STRSTRING ||
                     ' CONNECT BY PRIOR L.LOCATION_MST_PK = L.REPORTING_TO_FK) ';
      ELSE
        STRSTRING := STRSTRING ||
                     ' AND LOCATION_MST_FK IN (
                     (SELECT L.QILS_LOCATION_MST_FK FROM LOCATION_MST_TBL L WHERE L.LOCATION_MST_PK IN (' ||
                     USER_PK_IN || '))';
        STRSTRING := STRSTRING || ' AND LOCATION_MST_PK IN ( ' ||
                     USER_PK_IN || '))';
      END IF;
    ELSE
      STRSTRING := STRSTRING ||
                   ' AND LOCATION_MST_FK IN (
                   (SELECT L.QILS_LOCATION_MST_FK FROM LOCATION_MST_TBL L WHERE L.LOCATION_MST_PK IN (' ||
                   LOCATION_PK_IN || ')))';
     /* STRSTRING := STRSTRING || ' AND LOCATION_MST_PK IN ( ' ||
                   LOCATION_PK_IN || ')';*/
    END IF;

    IF QILS_LOCATION_PK_IN IS NOT NULL THEN
      STRSTRING := STRSTRING || ' AND LOCATION_MST_FK IN ( ' ||
                   QILS_LOCATION_PK_IN || ')';
    END IF;

    IF VENDOR_IN IS NOT NULL THEN
      STRSTRING := STRSTRING || ' AND VENDOR_MST_PK    IN ( ' || VENDOR_IN || ')';
    END IF;

     IF SHIP_LINE_PK_IN IS NOT NULL THEN
     IF SHIP_LINE_PK_IN >0 THEN
      STRSTRING := STRSTRING || ' AND LINE_MST_FK    IN ( ' || SHIP_LINE_PK_IN || ')';
      END IF;
    END IF;

    IF VENDORTYPE_IN IS NOT NULL THEN
      STRSTRING := STRSTRING ||
                   ' AND VENDOR_MST_PK  IN ( SELECT VENDOR_MST_FK FROM VENDOR_TYPE_TRN VTT WHERE VTT.VENDOR_TYPE_MST_FK IN (' ||
                   VENDORTYPE_IN || '))';
    END IF;

    STRSTRING := STRSTRING || ' )';

    EXECUTE IMMEDIATE STRSTRING;
    COMMIT;
    --------------<<< INSERT END >>>>>>-------------

    ----Transaction CURSOR-------------------------
    STRSTRING  := ' SELECT DISTINCT VENDOR_MST_PK, LOCATION_MST_PK,
                TO_DATE(''' || FROM_DATE_IN ||
                  ''', ''dd/MM/yyyy'') REF_DATE,
                ''OPENING BALANCE'' OPENING_BALANCE, '''' DOC_REF_NO , SUM(nvl(DEBIT,0) - nvl(CREDIT,0)) DEBIT,
                0 CREDIT,
                  SUM(nvl(DEBIT,0) - nvl(CREDIT,0)) BALANCE, LOCATION_NAME, VENDOR_NAME,TO_DATE(''' ||
                  FROM_DATE_IN ||
                  ''', ''dd/MM/yyyy HH24:Mi:ss'') created_date,LINE_MST_FK,CARRIER_NAME CARRIER_ID
                  from (select DISTINCT V.VENDOR_MST_PK,B.DEBIT,B.CREDIT,b.REF_DATE,A.LOCATION_MST_PK,A.LOCATION_NAME,V.VENDOR_NAME,A.LINE_MST_FK,A.CARRIER_NAME FROM VENDOR_MST_TBL V,';
    STRSTRING1 := ' (SELECT DISTINCT VENDOR_MST_PK,LOCATION_MST_PK,LOCATION_NAME,LINE_MST_FK,CARRIER_NAME FROM TEMP_VENDOR_SOA_DATE';
    STRSTRING1 := STRSTRING1 || ' WHERE TO_DATE(REF_DATE, ''dd/MM/yyyy'') >= TO_DATE(''' ||
                  FROM_DATE_IN ||
                  ''', ''dd/MM/yyyy'') AND TO_DATE(REF_DATE, ''dd/MM/yyyy'') <= TO_DATE(''' ||
                  TODATE_IN || ''', ''dd/MM/yyyy''))A, ';
    STRSTRING2 := ' (SELECT DISTINCT * FROM TEMP_VENDOR_SOA_DATE';
    STRSTRING2 := STRSTRING2 || ' WHERE TO_DATE(REF_DATE, ''dd/MM/yyyy'') < TO_DATE(''' ||
                  FROM_DATE_IN || ''',''dd/MM/yyyy''))B ';
    STRSTRING3 := '  WHERE V.VENDOR_MST_PK = A.VENDOR_MST_PK
                            AND A.VENDOR_MST_PK = B.VENDOR_MST_PK(+))
                            GROUP BY VENDOR_MST_PK ,LOCATION_MST_PK,LOCATION_NAME,VENDOR_NAME,LINE_MST_FK,CARRIER_NAME
                      UNION
                      SELECT DISTINCT VENDOR_MST_PK, LOCATION_MST_PK,REF_DATE,
                             TRANCACTION OPENING_BALANCE,DOC_REF_NO,
                             DEBIT, CREDIT, BALANCE, LOCATION_NAME, VENDOR_NAME,created_date,LINE_MST_FK,CARRIER_NAME
                             FROM TEMP_VENDOR_SOA_DATE';
    STRSTRING3 := STRSTRING3 || ' WHERE TO_DATE(REF_DATE, ''dd/MM/yyyy'') >= TO_DATE(''' ||
                  FROM_DATE_IN ||
                  ''', ''dd/MM/yyyy'') AND TO_DATE(REF_DATE, ''dd/MM/yyyy'') <= TO_DATE(''' ||
                  TODATE_IN ||
                  ''', ''dd/MM/yyyy'')       ORDER BY LOCATION_MST_PK,VENDOR_MST_PK,REF_DATE,created_date,OPENING_BALANCE DESC ';
    OPEN TRANS_CUR FOR STRSTRING || STRSTRING1 || STRSTRING2 || STRSTRING3;

  END FETCH_VENDORSOA_BYDATE_REPORT;

  PROCEDURE FETCH_VENDOR_SOA_BYTRANS_REP(COUNTRY_PK_IN  IN VARCHAR2,
                                         LOCATION_PK_IN IN VARCHAR2,
                                         FROM_DATE_IN   IN VARCHAR2,
                                         TODATE_IN      IN VARCHAR2,
                                         VENDOR_IN      IN VARCHAR2,
                                         VENDORTYPE_IN  IN VARCHAR2,
                                         CURRENCY_IN    IN NUMBER,
                                         USER_PK_IN     IN NUMBER,
                                         ADMIN_IN       IN VARCHAR2,
                                         SHIP_LINE_PK_IN     IN NUMBER,
                                         LINE_MST_FK_IN      IN NUMBER,
                                         --RETURNVAL OUT CLOB) AS
                                         TRANS_CUR      OUT VENDOR_SOA_DATE_CURSOR) AS
    STRSTRING  VARCHAR2(32767);
    STRSTRING1 VARCHAR2(32767);
    STRSTRING2 VARCHAR2(32767);
    STRSTRING3 VARCHAR2(32767);

  BEGIN
    DELETE FROM TEMP_VENDOR_SOA_DATE;

    -- <<<<<<<< FOR INSERTING IN TEMP TABLE >>>>>>>-----
    STRSTRING := ' INSERT INTO TEMP_VENDOR_SOA_DATE (';
    STRSTRING := STRSTRING || ' SELECT DISTINCT LOCATION_MST_PK, ';
    STRSTRING := STRSTRING || ' LOCATION_NAME, ';
    STRSTRING := STRSTRING || ' VENDOR_MST_PK, ';
    STRSTRING := STRSTRING || ' VENDOR_ID, ';
    STRSTRING := STRSTRING || ' VENDOR_NAME, ';
    STRSTRING := STRSTRING || ' REF_DATE, ';
    STRSTRING := STRSTRING || ' TRANCACTION, ';
    STRSTRING := STRSTRING || ' DOC_REF_NO, ';
    STRSTRING := STRSTRING || ' SUM(DEBIT*GET_EX_RATE_NEW(' || CURRENCY_IN ||
                 ',CURRENCY_MST_FK,REF_DATE)) DEBIT, ';
    STRSTRING := STRSTRING || ' SUM(NVL(CREDIT,0)*GET_EX_RATE_NEW(' ||
                 CURRENCY_IN || ',CURRENCY_MST_FK,REF_DATE)) CREDIT, ';
    STRSTRING := STRSTRING || ' BALANCE, ';
    STRSTRING := STRSTRING || ' GROUPID, ';
    STRSTRING := STRSTRING || ' COUNTRY_MST_FK, ';
    STRSTRING := STRSTRING || ' VENDOR_TYPE_MST_FK, ';
    STRSTRING := STRSTRING || ' CURRENCY_MST_FK, ';
    STRSTRING := STRSTRING || ' DA_VOUCHER_HDR_PK PK, ';
    STRSTRING := STRSTRING || ' LIQUIDATION_REF_NO, ';
    STRSTRING := STRSTRING || ' LOCATION_MST_FK, ';
    STRSTRING := STRSTRING || ' CREATED_DATE,LINE_MST_FK,';
    STRSTRING := STRSTRING || ' CARRIER_ID,CARRIER_NAME,'' '' ';
    STRSTRING := STRSTRING || ' FROM VIEW_VENDOR_SOA_TRANS  ';
    STRSTRING := STRSTRING || ' WHERE 1 =  1 ';

    IF LOCATION_PK_IN IS NULL THEN
      IF ADMIN_IN = 'Y' THEN
        STRSTRING := STRSTRING ||
                     ' AND LOCATION_MST_FK  IN (SELECT L.QILS_LOCATION_MST_FK FROM LOCATION_MST_TBL L START WITH L.LOCATION_MST_PK IN (' ||
                     USER_PK_IN || ')';
        STRSTRING := STRSTRING ||
                     ' CONNECT BY PRIOR L.LOCATION_MST_PK = L.REPORTING_TO_FK) ';
        STRSTRING := STRSTRING ||
                     ' AND LOCATION_MST_PK  IN (SELECT L.LOCATION_MST_PK FROM LOCATION_MST_TBL L START WITH L.LOCATION_MST_PK IN (' ||
                     USER_PK_IN || ')';
        STRSTRING := STRSTRING ||
                     ' CONNECT BY PRIOR L.LOCATION_MST_PK = L.REPORTING_TO_FK) ';
      ELSE
        STRSTRING := STRSTRING ||
                     ' AND LOCATION_MST_FK IN (
                     (SELECT L.QILS_LOCATION_MST_FK FROM LOCATION_MST_TBL L WHERE L.LOCATION_MST_PK IN (' ||
                     USER_PK_IN || ')))';
        STRSTRING := STRSTRING || ' AND LOCATION_MST_PK IN ( ' ||
                     USER_PK_IN || ')';
      END IF;
    ELSE
      STRSTRING := STRSTRING ||
                   ' AND LOCATION_MST_FK IN (
                   (SELECT L.QILS_LOCATION_MST_FK FROM LOCATION_MST_TBL L WHERE L.LOCATION_MST_PK IN (' ||
                   LOCATION_PK_IN || ')))';
    /*  STRSTRING := STRSTRING || ' AND LOCATION_MST_PK IN ( ' ||
                   LOCATION_PK_IN || ')';*/
    END IF;

    IF COUNTRY_PK_IN IS NOT NULL THEN
      STRSTRING := STRSTRING || ' AND COUNTRY_MST_FK IN ( ' ||
                   COUNTRY_PK_IN || ')';
    END IF;

    IF VENDOR_IN IS NOT NULL THEN
      STRSTRING := STRSTRING || ' AND VENDOR_MST_PK    IN ( ' || VENDOR_IN || ')';
    END IF;

    IF SHIP_LINE_PK_IN IS NOT NULL THEN
     IF SHIP_LINE_PK_IN >0 THEN
      STRSTRING := STRSTRING || ' AND LINE_MST_FK    IN ( ' || SHIP_LINE_PK_IN || ')';
      END IF;
    END IF;

    IF VENDORTYPE_IN IS NOT NULL THEN
      STRSTRING := STRSTRING || ' AND VENDOR_TYPE_MST_FK  IN ( ' ||
                   VENDORTYPE_IN || ')';
    END IF;

    STRSTRING := STRSTRING || ' GROUP BY LOCATION_MST_PK, LOCATION_NAME, ';
    STRSTRING := STRSTRING || ' VENDOR_MST_PK, ';
    STRSTRING := STRSTRING || ' VENDOR_ID, ';
    STRSTRING := STRSTRING || ' VENDOR_NAME, ';
    STRSTRING := STRSTRING || ' REF_DATE, ';
    STRSTRING := STRSTRING || ' TRANCACTION, ';
    STRSTRING := STRSTRING || ' DOC_REF_NO, ';
    STRSTRING := STRSTRING || ' BALANCE, ';
    STRSTRING := STRSTRING || ' GROUPID, ';
    STRSTRING := STRSTRING || ' COUNTRY_MST_FK, ';
    STRSTRING := STRSTRING || ' VENDOR_TYPE_MST_FK, ';
    STRSTRING := STRSTRING || ' DA_VOUCHER_HDR_PK, ';
    STRSTRING := STRSTRING || ' LIQUIDATION_REF_NO, ';
    STRSTRING := STRSTRING || ' LOCATION_MST_FK, ';
    STRSTRING := STRSTRING || ' CURRENCY_MST_FK, ';
    STRSTRING := STRSTRING || ' CREATED_DATE,LINE_MST_FK,';
    STRSTRING := STRSTRING || ' CARRIER_ID,CARRIER_NAME )';

    EXECUTE IMMEDIATE STRSTRING;
    COMMIT;
    --------------<<< INSERT END >>>>>>-------------

    ----Transaction CURSOR-------------------------
    STRSTRING  := ' SELECT VENDOR_MST_PK,
                    LOCATION_MST_PK,
                    REF_DATE,
                    DOC_REF_NO,
                    DEBIT,
                    liquidation_ref_no,
                    CREDIT,
                    SUM(NVL(DEBIT,0) - NVL(CREDIT,0)) OVER (PARTITION BY VENDOR_MST_PK ORDER BY VENDOR_MST_PK,CREATED_DT,CARRIER_ID DESC) BALANCE,
                    SUM(NVL(DEBIT,0) - NVL(CREDIT,0)) OVER (PARTITION BY VENDOR_MST_PK ORDER BY VENDOR_MST_PK,CREATED_DT,CARRIER_ID DESC) OUTSTANDING,
                    LOCATION_NAME,
                    VENDOR_NAME,
                    LINE_MST_FK,
                    CARRIER_ID,
                    CREATED_DT 
    FROM(
    SELECT DISTINCT VENDOR_MST_PK,LOCATION_MST_PK,
                TO_DATE(''' || FROM_DATE_IN ||
                  ''', ''dd/MM/yyyy'') REF_DATE,
               '''' DOC_REF_NO ,
                SUM(NVL(DEBIT,0)) DEBIT,'' '' liquidation_ref_no, SUM(NVL(CREDIT,0)) CREDIT,
                 SUM(NVL(DEBIT,0) -NVL(CREDIT,0)) BALANCE,
                 SUM(NVL(DEBIT,0) -NVL(CREDIT,0)) OUTSTANDING,LOCATION_NAME, VENDOR_NAME,LINE_MST_FK,''OPENING BALANCE'' CARRIER_ID,
                 TO_DATE(''01/01/1111'', ''dd/MM/yyyy'') CREATED_DT
                 from (select DISTINCT V.VENDOR_MST_PK,B.DEBIT,B.CREDIT,b.REF_DATE,a.VENDOR_NAME,a.LOCATION_MST_PK,a.LOCATION_NAME,a.LINE_MST_FK,a.TRANCACTION FROM VENDOR_MST_TBL V,';
    STRSTRING1 := ' (SELECT DISTINCT VENDOR_MST_PK,LOCATION_MST_PK,REF_DATE,'''' PROCESS,TRANCACTION,
                 DOC_REF_NO,DEBIT,liquidation_ref_no,CREDIT,BALANCE,0 OUTSTANDING,LOCATION_NAME,VENDOR_NAME,LINE_MST_FK,CARRIER_NAME FROM TEMP_VENDOR_SOA_DATE';
    STRSTRING1 := STRSTRING1 || ' WHERE TO_DATE(REF_DATE, ''dd/MM/yyyy'') >= TO_DATE(''' ||
                  FROM_DATE_IN ||
                  ''', ''dd/MM/yyyy'') AND TO_DATE(REF_DATE, ''dd/MM/yyyy'') <= TO_DATE(''' ||
                  TODATE_IN || ''', ''dd/MM/yyyy''))A, ';
    STRSTRING2 := ' (SELECT DISTINCT VENDOR_MST_PK,LOCATION_MST_PK,REF_DATE,TRANCACTION,
                DOC_REF_NO,DEBIT,liquidation_ref_no,CREDIT,BALANCE,0 OUTSTANDING,PK FROM TEMP_VENDOR_SOA_DATE';
    STRSTRING2 := STRSTRING2 || ' WHERE TO_DATE(REF_DATE, ''dd/MM/yyyy'') < TO_DATE(''' ||
                  FROM_DATE_IN || ''',''dd/MM/yyyy''))B ';
    STRSTRING3 := '  WHERE V.VENDOR_MST_PK = A.VENDOR_MST_PK
                            AND A.VENDOR_MST_PK = B.VENDOR_MST_PK(+))
                            GROUP BY VENDOR_MST_PK ,LOCATION_MST_PK,LOCATION_NAME, VENDOR_NAME,LINE_MST_FK,TRANCACTION
                      UNION
                      SELECT DISTINCT VENDOR_MST_PK,LOCATION_MST_PK,REF_DATE,
                 DOC_REF_NO,DEBIT,liquidation_ref_no,CREDIT,BALANCE,0 OUTSTANDING,LOCATION_NAME, VENDOR_NAME
                         ,LINE_MST_FK,TRANCACTION,CREATED_DATE CREATED_DT    FROM TEMP_VENDOR_SOA_DATE';
    STRSTRING3 := STRSTRING3 || ' WHERE TO_DATE(REF_DATE, ''dd/MM/yyyy'') >= TO_DATE(''' ||
                  FROM_DATE_IN ||
                  ''', ''dd/MM/yyyy'') AND TO_DATE(REF_DATE, ''dd/MM/yyyy'') <= TO_DATE(''' ||
                  TODATE_IN ||
                  ''', ''dd/MM/yyyy''))       ORDER BY VENDOR_MST_PK,CREATED_DT DESC,CARRIER_ID ';

    OPEN TRANS_CUR FOR STRSTRING || STRSTRING1 || STRSTRING2 || STRSTRING3;
    --RETURNVAL := STRSTRING || STRSTRING1 || STRSTRING2 || STRSTRING3;

  END FETCH_VENDOR_SOA_BYTRANS_REP;

  PROCEDURE FETCH_VENDOR_SOA_BYDATE_REPORT(QILS_LOCATION_PK_IN IN VARCHAR2,
                                           LOCATION_PK_IN      IN VARCHAR2,
                                           FROM_DATE_IN        IN VARCHAR2,
                                           TODATE_IN           IN VARCHAR2,
                                           VENDOR_IN           IN VARCHAR2,
                                           VENDORTYPE_IN       IN VARCHAR2,
                                           CURRENCY_IN         IN NUMBER,
                                           USER_PK_IN          IN NUMBER,
                                           ADMIN_IN            IN VARCHAR2,
                                          -- SHIP_LINE_PK_IN     IN NUMBER,
                                          -- LINE_MST_FK_IN      IN NUMBER,
                                           TRANS_CUR           OUT VENDOR_SOA_DATE_CURSOR/*,
                                           RETURNVAL      OUT CLOB*/) AS
    STRSTRING  VARCHAR2(32767);
    STRSTRING1 VARCHAR2(32767);
    STRSTRING2 VARCHAR2(32767);
    STRSTRING3 VARCHAR2(32767);

  BEGIN

    DELETE FROM TEMP_VENDOR_SOA_DATE;

    STRSTRING := ' INSERT INTO TEMP_VENDOR_SOA_DATE (';
    STRSTRING := STRSTRING || ' SELECT DISTINCT LOCATION_MST_PK, ';
    STRSTRING := STRSTRING || ' LOCATION_NAME, ';
    STRSTRING := STRSTRING || ' VENDOR_MST_PK, ';
    STRSTRING := STRSTRING || ' VENDOR_ID, ';
    STRSTRING := STRSTRING || ' VENDOR_NAME, ';
    STRSTRING := STRSTRING || ' REF_DATE, ';
    STRSTRING := STRSTRING || ' TRANCACTION, ';
    STRSTRING := STRSTRING || ' DOC_REF_NO, ';
    STRSTRING := STRSTRING || ' DEBIT * GET_EX_BUYRATE(' || CURRENCY_IN ||
                 ',CURRENCY_MST_FK,REF_DATE) DEBIT, ';
    STRSTRING := STRSTRING || ' NVL(CREDIT,0)*GET_EX_BUYRATE(' ||
                 CURRENCY_IN || ',CURRENCY_MST_FK,REF_DATE) CREDIT, ';
    STRSTRING := STRSTRING || ' BALANCE, ';
    STRSTRING := STRSTRING || ' GROUPID, ';
    STRSTRING := STRSTRING || ' COUNTRY_MST_FK, ';
    STRSTRING := STRSTRING || ' VENDOR_TYPE_MST_FK, ';
    STRSTRING := STRSTRING || ' CURRENCY_MST_FK,';
    STRSTRING := STRSTRING || ' PK, ';
    STRSTRING := STRSTRING || ' 0 LIQUIDATION_REF_NO, ';
    STRSTRING := STRSTRING || ' LOCATION_MST_FK, ';
    STRSTRING := STRSTRING || ' CREATED_DATE,LINE_MST_FK,';
    STRSTRING := STRSTRING || ' CARRIER_ID,CARRIER_NAME,INVOICE_NO ';
    STRSTRING := STRSTRING || ' FROM VIEW_VENDOR_SOA_DATE  ';
    STRSTRING := STRSTRING || ' WHERE 1 =  1 ';

    IF LOCATION_PK_IN IS NULL THEN
      IF ADMIN_IN = 'Y' THEN
        STRSTRING := STRSTRING ||
                     ' AND LOCATION_MST_FK  IN (SELECT L.QILS_LOCATION_MST_FK FROM LOCATION_MST_TBL L START WITH L.LOCATION_MST_PK IN (' ||
                     USER_PK_IN || ')';
        STRSTRING := STRSTRING ||
                     ' CONNECT BY PRIOR L.LOCATION_MST_PK = L.REPORTING_TO_FK) ';
        STRSTRING := STRSTRING ||
                     ' AND LOCATION_MST_PK  IN (SELECT L.LOCATION_MST_PK FROM LOCATION_MST_TBL L START WITH L.LOCATION_MST_PK IN (' ||
                     USER_PK_IN || ')';
        STRSTRING := STRSTRING ||
                     ' CONNECT BY PRIOR L.LOCATION_MST_PK = L.REPORTING_TO_FK) ';
      ELSE
        STRSTRING := STRSTRING ||
                     ' AND LOCATION_MST_FK IN
                     (SELECT L.QILS_LOCATION_MST_FK FROM LOCATION_MST_TBL L WHERE L.LOCATION_MST_PK IN (' ||
                     USER_PK_IN || '))';
        STRSTRING := STRSTRING || ' AND LOCATION_MST_PK IN ( ' ||
                     USER_PK_IN || ')';
      END IF;
    ELSE
      STRSTRING := STRSTRING ||
                   ' AND LOCATION_MST_FK IN
                   (SELECT L.QILS_LOCATION_MST_FK FROM LOCATION_MST_TBL L WHERE L.LOCATION_MST_PK IN (' ||
                   LOCATION_PK_IN || '))';
      STRSTRING := STRSTRING || ' AND LOCATION_MST_PK IN ( ' ||
                   LOCATION_PK_IN || ')';
    END IF;

    IF QILS_LOCATION_PK_IN IS NOT NULL THEN
      STRSTRING := STRSTRING || ' AND LOCATION_MST_FK IN ( ' ||
                   QILS_LOCATION_PK_IN || ')';
    END IF;

    IF VENDOR_IN IS NOT NULL THEN
      STRSTRING := STRSTRING || ' AND VENDOR_MST_PK    IN ( ' || VENDOR_IN || ')';
    END IF;

    IF VENDORTYPE_IN IS NOT NULL THEN
      STRSTRING := STRSTRING ||
                   ' AND VENDOR_MST_PK  IN ( SELECT VENDOR_MST_FK FROM VENDOR_TYPE_TRN VTT WHERE VTT.VENDOR_TYPE_MST_FK IN (' ||
                   VENDORTYPE_IN || '))';
    END IF;

    STRSTRING := STRSTRING || ' )';

    EXECUTE IMMEDIATE STRSTRING;
    COMMIT;
    --------------<<< INSERT END >>>>>>-------------

    ----Transaction CURSOR-------------------------
    STRSTRING  := ' SELECT DISTINCT VENDOR_MST_PK, LOCATION_MST_PK,
                '' '' AS VENDOR_ID,VENDOR_NAME,'' '' AS LOCATION_ID,
                LOCATION_NAME,
                TO_DATE(''' || FROM_DATE_IN ||
                  ''', ''dd/MM/yyyy'') REF_DATE,
                ''OPENING BALANCE'' OPENING_BALANCE, '''' DOC_REF_NO , SUM(nvl(DEBIT,0) - nvl(CREDIT,0)) DEBIT,
                0 CREDIT,
                  SUM(nvl(DEBIT,0) - nvl(CREDIT,0)) BALANCE,  TO_DATE(''' ||
                  FROM_DATE_IN ||
                  ''', ''dd/MM/yyyy HH24:Mi:ss'') created_date,'' '' INVOICE_NO
                  from (select DISTINCT V.VENDOR_MST_PK,B.DEBIT,B.CREDIT,b.REF_DATE,A.LOCATION_MST_PK,A.LOCATION_NAME,V.VENDOR_NAME FROM VENDOR_MST_TBL V,';
    STRSTRING1 := ' (SELECT DISTINCT VENDOR_MST_PK,LOCATION_MST_PK,LOCATION_NAME FROM TEMP_VENDOR_SOA_DATE';
    STRSTRING1 := STRSTRING1 ||
                  ' WHERE TO_DATE(REF_DATE, ''dd/MM/yyyy'') >= TO_DATE(''' ||
                  FROM_DATE_IN ||
                  ''', ''dd/MM/yyyy'') AND TO_DATE(REF_DATE, ''dd/MM/yyyy'') <= TO_DATE(''' ||
                  TODATE_IN || ''', ''dd/MM/yyyy''))A, ';
    STRSTRING2 := ' (SELECT DISTINCT * FROM TEMP_VENDOR_SOA_DATE';
    STRSTRING2 := STRSTRING2 ||
                  ' WHERE TO_DATE(REF_DATE, ''dd/MM/yyyy'') < TO_DATE(''' ||
                  FROM_DATE_IN || ''',''dd/MM/yyyy''))B ';
    STRSTRING3 := '  WHERE V.VENDOR_MST_PK = A.VENDOR_MST_PK
                            AND A.VENDOR_MST_PK = B.VENDOR_MST_PK(+))
                            GROUP BY VENDOR_MST_PK ,LOCATION_MST_PK,LOCATION_NAME,VENDOR_NAME
                      UNION
                      SELECT DISTINCT VENDOR_MST_PK, LOCATION_MST_PK,
                      '' '' AS VENDOR_ID,VENDOR_NAME,'' '' AS LOCATION_ID,
                      LOCATION_NAME,REF_DATE,
                             TRANCACTION OPENING_BALANCE,DOC_REF_NO,
                             DEBIT, CREDIT, BALANCE,  created_date,INVOICE_NO
                             FROM TEMP_VENDOR_SOA_DATE';
    STRSTRING3 := STRSTRING3 ||
                  ' WHERE TO_DATE(REF_DATE, ''dd/MM/yyyy'') >= TO_DATE(''' ||
                  FROM_DATE_IN ||
                  ''', ''dd/MM/yyyy'') AND TO_DATE(REF_DATE, ''dd/MM/yyyy'') <= TO_DATE(''' ||
                  TODATE_IN ||
                  ''', ''dd/MM/yyyy'')       ORDER BY LOCATION_MST_PK,VENDOR_MST_PK,REF_DATE,created_date,OPENING_BALANCE DESC ';
   OPEN TRANS_CUR FOR STRSTRING || STRSTRING1 || STRSTRING2 || STRSTRING3;

 --RETURNVAL :=STRSTRING || STRSTRING1 || STRSTRING2 || STRSTRING3;

  END FETCH_VENDOR_SOA_BYDATE_REPORT;


END FETCH_VENDOR_SOA_DATE;
/
