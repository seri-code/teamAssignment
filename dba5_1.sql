PLANNER : 노**, 오*, 전**, 홍**
DEVELOPER
1~3 홍**
4~6 오*
7~8 전**
9~10 노**

/* 1~3 칼럼 구조
-------------------------------------------------------------------------------------------------
판매자코드   |판매자이름|상품코드     |상품이름 |판매가격 |판매개수    |매출(판매가격*판매개수) |판매일자
-------------------------------------------------------------------------------------------------
*/

 /* 1. 특정 판매자의 판매정보 리스트 조회 */
 SELECT  OD.OD_SASECODE AS "SCODE",
        SE.SE_NAME AS "SNAME",
        OD.OD_SAGOCODE AS "GCODE",
        GO.GO_NAME AS "GNAME",
        SA.SA_PRICE AS "PRICE",
        OD.OD_QUANTITY AS "QUNANTITY",
        SA.SA_PRICE * OD.OD_QUANTITY AS "AMOUNT",
        OD.OD_ORDATE AS "DATE"
 FROM OD INNER JOIN SA ON OD.OD_SASECODE = SA.SA_SECODE AND OD.OD_SAGOCODE = SA.SA_GOCODE
        INNER JOIN GO ON SA.SA_GOCODE = GO.GO_CODE
        INNER JOIN SE ON SA.SA_SECODE = SE.SE_CODE
 WHERE SE.SE_NAME='COMPANY_1';

 /* 2. 특정 판매자의 특정 판매정보 조회 */
SELECT  OD.OD_SASECODE AS "SCODE",
        SE.SE_NAME AS "SNAME",
        OD.OD_SAGOCODE AS "GCODE",
        GO.GO_NAME AS "GNAME",
        SA.SA_PRICE AS "PRICE",
        OD.OD_QUANTITY AS "QUNANTITY",
        SA.SA_PRICE * OD.OD_QUANTITY AS "AMOUNT",
        OD.OD_ORDATE AS "DATE"
FROM OD INNER JOIN SA ON OD.OD_SASECODE = SA.SA_SECODE AND OD.OD_SAGOCODE = SA.SA_GOCODE
        INNER JOIN GO ON SA.SA_GOCODE = GO.GO_CODE
        INNER JOIN SE ON SA.SA_SECODE = SE.SE_CODE
WHERE SE.SE_NAME='COMPANY_2' AND GO.GO_NAME='고구마깡';

 /* 3. 특정 상품의 판매정보 조회 */
 SELECT  OD.OD_SASECODE AS "SCODE",
        SE.SE_NAME AS "SNAME",
        OD.OD_SAGOCODE AS "GCODE",
        GO.GO_NAME AS "GNAME",
        SA.SA_PRICE AS "PRICE",
        OD.OD_QUANTITY AS "QUNANTITY",
        SA.SA_PRICE * OD.OD_QUANTITY AS "AMOUNT",
        OD.OD_ORDATE AS "DATE"
 FROM OD INNER JOIN SA ON OD.OD_SASECODE = SA.SA_SECODE AND OD.OD_SAGOCODE = SA.SA_GOCODE
        INNER JOIN GO ON SA.SA_GOCODE = GO.GO_CODE
        INNER JOIN SE ON SA.SA_SECODE = SE.SE_CODE
 WHERE GO.GO_NAME='새우깡';

 /* 4+5. 모든 판매자의 판매정보 조회 (실적유무 무관) */
 칼럼구조
 --------------------------------------------
 판매자코드 판매자이름 상품코드 상품이름 판매수량 판매액
 -------------------------------------------------
 SELECT SA.SA_SECODE AS "SCODE",
        SE.SE_NAME AS "SNAME",
        SA.SA_GOCODE AS "GCODE",
        GO.GO_NAME AS "GNAME",
        COALESCE(SUM(OD.OD_QUANTITY),0) AS "TOT",
        COALESCE(SUM(OD.OD_QUANTITY * SA.SA_PRICE), 0) AS "AMOUNT"
 FROM SA LEFT OUTER JOIN OD ON SA.SA_SECODE = OD.OD_SASECODE AND SA.SA_GOCODE = OD.OD_SAGOCODE
         INNER JOIN SE ON SA.SA_SECODE = SE.SE_CODE
         INNER JOIN GO ON SA.SA_GOCODE = GO.GO_CODE
 GROUP BY SA.SA_SECODE, SA.SA_GOCODE, SE.SE_NAME, GO.GO_NAME;

 /* 6. 판매실적이 있는 판매자 정보 조회 */
 칼럼구조
 ------------------
 판매자코드 판매자이름
 -------------------
 SELECT SE.SE_CODE, SE.SE_NAME
 FROM SE INNER JOIN SA ON SE.SE_CODE = SA.SA_SECODE
         INNER JOIN OD ON SA.SA_SECODE = OD.OD_SASECODE AND SA.SA_GOCODE = OD.OD_SAGOCODE
 GROUP BY SE.SE_CODE, SE.SE_NAME;
 
 /*
 7~8 칼럼구조
 ----------------------------------------------------
 구매자ID 구매자이름 상품코드 상품이름 구매개수 구매액 구매일자
 ------------------------------------------------------
 */
 
 /* 7. 특정 구매자의 구매 정보 조회 */
 -- MM6의 구매기록
 SELECT od_ormmid as "MID",
        mm_name as "MNAME",
        od_sagocode as "GCODE",
        go_name as "GNAME",
        sa_price as "PRICE",
        od_quantity as "QUANTITY",
        sa.sa_price * od.od_quantity as "AMOUNT",
        od_ordate as "DATE"
 FROM OD INNER JOIN "OR" ON OD.OD_ORMMID = "OR".OR_MMID AND OD.OD_ORDATE = "OR".OR_DATE 
         INNER JOIN MM ON "OR".OR_MMID = MM.MM_ID -- MM_NAME 데이터를 얻기 위해 MM과 결합하는 이너조인을 쓰고, OD와 MM의 공통된 컬럼명 MMID를 썼습니다.
         INNER JOIN SA ON OD.OD_SASECODE = SA.SA_SECODE and OD.OD_SAGOCODE = SA.SA_GOCODE
         INNER JOIN GO ON SA.SA_GOCODE = GO.GO_CODE -- GO_NAME 데이터를 얻기 위해 GO와 결합하는 이너조인을 쓰고, OD와 GO의 공통된 컬럼명 GOCODE를 썼습니다.
        -- SA_PRICE 데이터를 얻기 위해 SA와 결합하는 이너조인을 쓰고, OD와 SA의 공통된 컬럼명 SECODE를 썼습니다. 
        -- *추가로, OD에는 PK가 OD.OD_SASECODE 말고도 OD.OD_SAGOCODE 가 또 있기 때문에 둘을 AND로 연결시켜 줘야 정확한 데이터 값이 나옵니다.
 WHERE OD_ORMMID = 'MM6'
 GROUP BY od_ormmid, mm_name, od_sagocode, go_name, sa_price, od_quantity, od_ordate; --중복 제거를 위해 group by 사용(3개 행 인출)
 
 /* 8. 특정 구매자의 특정 구매 상세 정보 조회 */
 -- MM1이 1001번 상품을 구매한 기록
 SELECT od_ormmid as "MID",
        mm_name as "MNAME",
        od_sagocode as "GCODE",
        go_name as "GNAME",
        sa_price as "PRICE",
        od_quantity as "QUANTITY",
        sa.sa_price * od.od_quantity as "AMOUNT",
        od_ordate as "DATE"
FROM OD INNER JOIN "OR" ON OD.OD_ORMMID = "OR".OR_MMID AND OD.OD_ORDATE = "OR".OR_DATE 
         INNER JOIN MM ON "OR".OR_MMID = MM.MM_ID -- MM_NAME 데이터를 얻기 위해 MM과 결합하는 이너조인을 쓰고, OD와 MM의 공통된 컬럼명 MMID를 썼습니다.
         INNER JOIN SA ON OD.OD_SASECODE = SA.SA_SECODE and OD.OD_SAGOCODE = SA.SA_GOCODE
         INNER JOIN GO ON SA.SA_GOCODE = GO.GO_CODE
WHERE OD_ORMMID = 'MM1' and OD_SAGOCODE = '1001' 
GROUP BY od_ormmid, mm_name, od_sagocode, go_name, sa_price, od_quantity, od_ordate;
 
 /* 9. 특정 구매자의 반품정보 조회 */
 칼럼 구조
 ----------------------------------
 구매자ID 구매자이름 구매일자
 -----------------------------------
 
 -- MM2의 반품기록
 SELECT "OR".OR_MMID AS "MID",
        MM.MM_NAME AS "MNAME",
        "OR".OR_DATE AS "DATE"
 FROM   "OR" INNER JOIN MM ON "OR".OR_MMID=MM.MM_ID
 WHERE  OR_MMID='MM2'AND OR_STATE='R';
 
 /* 10. 특정 구매자의 특정 반품 상세 정보 조회 */
 칼럼 구조
 ----------------------------------------
 구매자ID 구매자이름 상품코드 상품가격 구매개수
 ----------------------------------------
 
 -- MM2가 1004번 상품을 구매 후 반품한 기록
  SELECT OD.OD_ORMMID AS "MID",
        MM.MM_NAME AS "MNAME",
        GO.GO_NAME AS "GCODE",
        SA.SA_PRICE AS "PRICE",
        OD.OD_QUANTITY AS "QUANTITY"
 FROM   OD INNER JOIN "OR" ON OD.OD_ORMMID = "OR".OR_MMID AND OD.OD_ORDATE = "OR".OR_DATE
           INNER JOIN MM ON "OR".OR_MMID = MM.MM_ID
           INNER JOIN SA ON OD.OD_SASECODE = SA.SA_SECODE AND OD.OD_SAGOCODE = SA.SA_GOCODE
           INNER JOIN GO ON SA.SA_GOCODE = GO.GO_CODE
 WHERE  OD_ORMMID='MM2' AND OD_SAGOCODE='1004' AND OD_STATE='R';
