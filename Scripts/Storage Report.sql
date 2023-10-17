SELECT *
FROM   (SELECT STGMONTH,
               SLNR,
               CONTAINER_PK,
               CNTRNR,
               CNTRTYPE,
               TEUS,
               PROCESS,
               VES_VOY,
               DEPOT,
               DATE_IN,
               IN_TIME,
               DATE_OUT,
               OUT_TIME,
               FREE_DAYS,
               CHARGEABLE_DAYS,
               CHARG_DAYS,
               CURR,
               AMT
        FROM   (SELECT Q.STGMONTH,
                       0 SLNR,
                       0 CONTAINER_PK,
                       '' CNTRNR,
                       '' CNTRTYPE,
                       SUM(Q.TEUS) TEUS,
                       '' PROCESS,
                       '' VES_VOY,
                       '' DEPOT,
                       Q.STGMONTH STGMON,
                       TO_DATE(NULL) DATE_IN,
                       '' IN_TIME,
                       TO_DATE(NULL) DATE_OUT,
                       '' OUT_TIME,
                       0 FREE_DAYS,
                       SUM(Q.CHARGEABLE_DAYS) CHARGEABLE_DAYS,
                       '' CHARG_DAYS,
                       '' CURR,
                       SUM(Q.AMT) AMT,
                       Q.SORTDT
                
                FROM   (SELECT S.BOOKING_CONTAINER_TRN_FK CONTAINER_PK,
                               S.CONTAINER_NO             CNTRNR,
                               S.CONTAINER_TYPE_MST_ID    CNTRTYPE,
                               S.TEUS,
                               S.STGMONTH,
                               S.EXP_IMP_FLAG             PROCESS,
                               /*   (VMT.VESSEL_ID || '-' || CSH.VOYAGE_NO) VES_VOY,*/
                               (VMT.VESSEL_NAME || '-' || CSH.VOYAGE_NO) VES_VOY,
                               CASE
                                 WHEN S.PORT_DEPOT_FLAG = 1 THEN
                                  (SELECT P.PORT_NAME FROM PORT_MST_TBL P WHERE P.PORT_MST_PK = S.PORT_DEPOT_MST_FK)
                                 ELSE
                                  (SELECT D.DEPOT_NAME FROM DEPOT_MST_TBL D WHERE D.DEPOT_MST_PK = S.PORT_DEPOT_MST_FK)
                               END DEPOT,
                               TO_DATE(S.PRE_MOVE_CODE_DT, DATEFORMAT) DATE_IN,
                               TO_CHAR(S.PRE_MOVE_CODE_DT, 'MON') || '-' || TO_CHAR(S.PRE_MOVE_CODE_DT, 'YY') AS MON,
                               S.PRE_MOVE_CODE_TIME IN_TIME,
                               TO_DATE(S.CUR_MOVE_CODE_DT, DATEFORMAT) DATE_OUT,
                               S.CUR_MOVE_CODE_TIME OUT_TIME,
                               S.FREE_DAYS FREE_DAYS,
                               S.CHARGEABLE_DAYS,
                               CASE
                                 WHEN S.PORT_DEPOT_FLAG = 1 THEN
                                  STORAGE_REPORT_DTL_PKG.FETCH_CHARGEABLE_CALCULATION(S.PORT_DEPOT_MST_FK,
                                                                                      NULL,
                                                                                      S.CUR_MOVE_CODE_DT,
                                                                                      CASE
                                                                                        WHEN S.EXP_IMP_FLAG = 'Import' THEN
                                                                                         2
                                                                                        ELSE
                                                                                         1
                                                                                      END,
                                                                                      S.CONTAINER_TYPE_MST_FK,
                                                                                      S.CHARGEABLE_DAYS,
                                                                                      S.FREE_DAYS,
                                                                                      12)
                                 ELSE
                                  ''
                               END CHARGES,
                               CTM.CURRENCY_ID CURR,
                               CASE
                                 WHEN S.PORT_DEPOT_FLAG = 1 THEN
                                  NVL(STORAGE_REPORT_DTL_PKG.FETCH_CHARGEABLE_AMT(S.PORT_DEPOT_MST_FK,
                                                                                  NULL,
                                                                                  TO_DATE(S.CUR_MOVE_CODE_DT, DATEFORMAT),
                                                                                  CASE
                                                                                    WHEN S.EXP_IMP_FLAG = 'Import' THEN
                                                                                     2
                                                                                    ELSE
                                                                                     1
                                                                                  END,
                                                                                  S.CONTAINER_TYPE_MST_FK,
                                                                                  S.CHARGEABLE_DAYS,
                                                                                  12),
                                      0)
                                 ELSE
                                  0
                               END AMT,
                               TO_DATE('01/' || TO_CHAR(S.PRE_MOVE_CODE_DT, 'MM/YYYY'), DATEFORMAT) AS SORTDT
                        FROM   STORAGE_REPORT_TEMP_TBL S,
                               COMMERCIAL_SCHEDULE_TRN CST,
                               COMMERCIAL_SCHEDULE_HDR CSH,
                               VESSEL_MST_TBL          VMT,
                               CURRENCY_TYPE_MST_TBL   CTM,
                               BOOKING_CONTAINERS_TRN  BCT,
                               BOOKING_ROUTING_TRN     BRT,
                               CONTAINER_TYPE_MST_TBL  CTMT
                        WHERE  S.BOOKING_CONTAINER_TRN_FK = BCT.BOOKING_CONTAINERS_PK
                               AND S.CONTAINER_TYPE_MST_FK = CTMT.CONTAINER_TYPE_MST_PK
                               AND CSH.COMMERCIAL_SCHEDULE_HDR_PK = CST.COMMERCIAL_SCHEDULE_HDR_FK
                               AND VMT.VESSEL_MST_PK = CSH.VESSEL_MST_FK
                               AND CST.COMMERCIAL_SCHEDULE_TRN_PK = BRT.ARRIVAL_VOYAGE_FK
                               AND BCT.BOOKING_TRN_FK = BRT.BOOKING_TRN_FK
                               AND CTM.CURRENCY_MST_PK = 12) Q
                GROUP  BY Q.STGMONTH,
                          Q.SORTDT
                
                UNION
                SELECT '' AS STGMONTH,
                       F.*
                FROM   (SELECT ROWNUM SLNR,
                               Q.*
                        FROM   (SELECT S.BOOKING_CONTAINER_TRN_FK CONTAINER_PK,
                                       S.CONTAINER_NO CNTRNR,
                                       S.CONTAINER_TYPE_MST_ID CNTRTYPE,
                                       CTMT.TEU_FACTOR TEUS,
                                       S.EXP_IMP_FLAG PROCESS,
                                       (VMT.VESSEL_NAME || '-' || CSH.VOYAGE_NO) VES_VOY,
                                       CASE
                                         WHEN S.PORT_DEPOT_FLAG = 1 THEN
                                          (SELECT P.PORT_NAME FROM PORT_MST_TBL P WHERE P.PORT_MST_PK = S.PORT_DEPOT_MST_FK)
                                         ELSE
                                          (SELECT D.DEPOT_NAME
                                           FROM   DEPOT_MST_TBL D
                                           WHERE  D.DEPOT_MST_PK = S.PORT_DEPOT_MST_FK)
                                       END DEPOT,
                                       TO_CHAR(S.PRE_MOVE_CODE_DT, 'MON') || '-' || TO_CHAR(S.PRE_MOVE_CODE_DT, 'YY') AS MON,
                                       TO_DATE(S.PRE_MOVE_CODE_DT, DATEFORMAT) DATE_IN,
                                       
                                       S.PRE_MOVE_CODE_TIME IN_TIME,
                                       TO_DATE(S.CUR_MOVE_CODE_DT, DATEFORMAT) DATE_OUT,
                                       S.CUR_MOVE_CODE_TIME OUT_TIME,
                                       S.FREE_DAYS FREE_DAYS,
                                       S.CHARGEABLE_DAYS CHARG_DAYS,
                                       CASE
                                         WHEN S.PORT_DEPOT_FLAG = 1 THEN
                                          STORAGE_REPORT_DTL_PKG.FETCH_CHARGEABLE_CALCULATION(S.PORT_DEPOT_MST_FK,
                                                                                              NULL,
                                                                                              S.CUR_MOVE_CODE_DT,
                                                                                              CASE
                                                                                                WHEN S.EXP_IMP_FLAG = 'Import' THEN
                                                                                                 2
                                                                                                ELSE
                                                                                                 1
                                                                                              END,
                                                                                              S.CONTAINER_TYPE_MST_FK,
                                                                                              S.CHARGEABLE_DAYS,
                                                                                              S.FREE_DAYS,
                                                                                              12)
                                         ELSE
                                          ''
                                       END CHARGES,
                                       CTM.CURRENCY_ID CURR,
                                       CASE
                                         WHEN S.PORT_DEPOT_FLAG = 1 THEN
                                          NVL(STORAGE_REPORT_DTL_PKG.FETCH_CHARGEABLE_AMT(S.PORT_DEPOT_MST_FK,
                                                                                          NULL,
                                                                                          TO_DATE(S.CUR_MOVE_CODE_DT,
                                                                                                  DATEFORMAT),
                                                                                          CASE
                                                                                            WHEN S.EXP_IMP_FLAG = 'Import' THEN
                                                                                             2
                                                                                            ELSE
                                                                                             1
                                                                                          END,
                                                                                          S.CONTAINER_TYPE_MST_FK,
                                                                                          S.CHARGEABLE_DAYS,
                                                                                          12),
                                              0)
                                         ELSE
                                          0
                                       END AMT,
                                       TO_DATE('01/' || TO_CHAR(S.PRE_MOVE_CODE_DT, 'MM/YYYY'), DATEFORMAT) AS SORTDT
                                FROM   STORAGE_REPORT_TEMP_TBL S,
                                       COMMERCIAL_SCHEDULE_TRN CST,
                                       COMMERCIAL_SCHEDULE_HDR CSH,
                                       VESSEL_MST_TBL          VMT,
                                       CURRENCY_TYPE_MST_TBL   CTM,
                                       BOOKING_CONTAINERS_TRN  BCT,
                                       BOOKING_ROUTING_TRN     BRT,
                                       CONTAINER_TYPE_MST_TBL  CTMT
                                WHERE  S.BOOKING_CONTAINER_TRN_FK = BCT.BOOKING_CONTAINERS_PK
                                       AND S.CONTAINER_TYPE_MST_FK = CTMT.CONTAINER_TYPE_MST_PK
                                       AND CSH.COMMERCIAL_SCHEDULE_HDR_PK = CST.COMMERCIAL_SCHEDULE_HDR_FK
                                       AND VMT.VESSEL_MST_PK = CSH.VESSEL_MST_FK
                                       AND CST.COMMERCIAL_SCHEDULE_TRN_PK = BRT.ARRIVAL_VOYAGE_FK
                                       AND BCT.BOOKING_TRN_FK = BRT.BOOKING_TRN_FK
                                       AND CTM.CURRENCY_MST_PK = 12
                                ORDER  BY TO_DATE(S.CUR_MOVE_CODE_DT, DATEFORMAT) DESC) Q) F) T
        ORDER  BY T.SORTDT)
