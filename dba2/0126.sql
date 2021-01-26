/* SPRING MVC PROJECT 
    ITEM : MULTIPLEX RESERVATION SYTEM
    NEEDS______
    1. 상영관 개수의 동적 처리
    2. 각 상영관 좌석 수의 동적처리
    3. 좌석의 동적 배치
    4. WEB을 이용한 예약처리
    5. WEB을 이용한 영화관 관리
    6. 연령별 요금의 동적처리
*/
/* MULTIPLEX TABLESPACE CREATION :: SYS */
-- CREATION
CREATE TABLESPACE MULTIPLEX
DATAFILE 'D:\Spring\database\TS\MULTIPLEX_01.ORA'
SIZE 10M AUTOEXTEND ON NEXT 5M MAXSIZE 100M;

-- TABLESPACE CHECK VIEW :: SYS
  CREATE OR REPLACE VIEW TSINFO
  AS
  SELECT TS.TABLESPACE_NAME AS "TABLESPACE",
         TS.STATUS AS "TS_STATUS",
         TS.CONTENTS AS "TYPE",
         DF.FILE_NAME AS "FILE_NAME",
         DF.BYTES /(1024*1024) || 'M' AS "SIZE",
         DF.STATUS AS "DF_STATUS",
         FS.BYTES /(1024*1024) || 'M' AS "AVAILABLE"         
  FROM DBA_TABLESPACES TS INNER JOIN DBA_DATA_FILES DF ON TS.TABLESPACE_NAME = DF.TABLESPACE_NAME
                          INNER JOIN DBA_FREE_SPACE FS ON TS.TABLESPACE_NAME = FS.TABLESPACE_NAME;
  -->> GRANT
  GRANT ALL ON SYS.TSINFO TO ADM;
  CREATE PUBLIC SYNONYM TSINFO FOR SYS.TSINFO;
  
/* TEAM DBA CREATION : SYS */
-- CREATION
CREATE USER ADM IDENTIFIED BY "5678"
DEFAULT TABLESPACE MULTIPLEX
TEMPORARY TABLESPACE TEMP
QUOTA UNLIMITED ON MULTIPLEX;

-- PRIVILEAGE
GRANT DBA TO ADM;

-- USER CHECK VIEW :: SYS
CREATE OR REPLACE VIEW USERINFO
AS
SELECT USERNAME AS "USERNAME", 
       ACCOUNT_STATUS AS "STATUS",  
       DEFAULT_TABLESPACE AS "TABLESPACE",
       GRANTED_ROLE AS "ROLE"
FROM DBA_USERS DU INNER JOIN DBA_ROLE_PRIVS RP ON DU.USERNAME = RP.GRANTEE;
   
  -->> GRANT :: SYS
  GRANT ALL ON SYS.USERINFO TO ADM;
  CREATE PUBLIC SYNONYM USERINFO FOR SYS.USERINFO;
       
-- USER CHECK :: DBA
SELECT * FROM USERINFO WHERE USERNAME='ADM';
-- TABLESPACE CHECK :: DBA
SELECT * FROM TSINFO WHERE TABLESPACE = 'MULTIPLEX';

/* TEAM DEV CREATION : TEAM DBA */
-- CREATION
CREATE USER DEVELOPER IDENTIFIED BY "5678"
DEFAULT TABLESPACE MULTIPLEX
TEMPORARY TABLESPACE TEMP
QUOTA UNLIMITED ON MULTIPLEX;
-- GRANT
GRANT CONNECT, RESOURCE TO DEVELOPER;


/*  TABLE DESIGN 
    PART 1. KEY ENTITY
            -1. CUSTOMER(ST)
                : ST_ID(PK)[NV10], ST_NAME[NV5], ST_PASSWORD[NV10], ST_PHONE[NC11]
 */               
 CREATE TABLE DBA2.CUSTOMER(
 ST_ID  NVARCHAR2(10),
 ST_NAME NVARCHAR2(5),
 ST_PASSWORD NVARCHAR2(10),
 ST_PHONE NCHAR(11)
 )TABLESPACE MULTIPLEX;
 
 INSERT INTO ST (ST_ID,ST_NAME,ST_PASSWORD,ST_PHONE)
 VALUES('fox','***','1234','7894321650');
 
 commit;
 
 select * from st;
 
 SELECT * FROM CUSTOMER;
 
 ALTER TABLE DBA2.CUSTOMER
 ADD CONSTRAINT ST_ID_PK PRIMARY KEY(ST_ID);

 ALTER TABLE DBA2.CUSTOMER 
 MODIFY ST_NAME NOT NULL
 MODIFY ST_PASSWORD NOT NULL
 MODIFY ST_PHONE NOT NULL;
 
 
 
 CREATE PUBLIC SYNONYM ST FOR DBA2.CUSTOMER;
 
 GRANT SELECT,INSERT,UPDATE ON DBA2.CUSTOMER TO YJ,SOL,PHO,FOX;
 
 COMMIT;
 
 SELECT * FROM DBA2.CUSTOMER;
 SELECT * FROM ST;
                
                
                
 /*               
            -2. THEATER(TH)
                : TH_CODE(PK)[NC1], TH_NAME[NV10], TH_ADDR[NV50]
            */
            CREATE TABLE DBA2.THEATER (
            TH_CODE NCHAR(1),
            TH_NAME NVARCHAR2(10),
            TH_ADDR NVARCHAR2(50)
            )TABLESPACE MULTIPLEX;
            
             INSERT INTO th (TH_CODE,TH_NAME,TH_ADDR)
            VALUES('1','ICIA극장','인천시 미추홀구 학익동');
            
            DROP TABLE THEATER;
            
            ALTER TABLE DBA2.theater 
            ADD CONSTRAINT TH_CODE_PK PRIMARY KEY (TH_CODE);
               ALTER TABLE DBA2.THEATER 
               MODIFY TH_NAME NOT NULL
               MODIFY TH_ADDR NOT NULL;
            
            
            CREATE PUBLIC SYNONYM TH FOR DBA2.THEATER;
            
            GRANT SELECT,INSERT,UPDATE ON DBA2.THEATER TO YJ,SOL,PHO,FOX;
 
 COMMIT;
 
 SELECT * FROM DBA2.CUSTOMER;
 SELECT * FROM ST;
            
            
            
            /*
            -3. MOVIE(MV)
                : MV_CODE(PK)[NC8], MV_NAME[NV20], MV_GRADE[NC1], MV_STATUS[NC1], MV_IMAGE[NV21], MV_COMMENTS[NV50 NULL]
             */
          CREATE TABLE DBA2.MOVIE (
            MV_CODE NCHAR(8),
            MV_NAME NVARCHAR2(10),
            MV_GRADE NCHAR(1),
            MV_STATUS NCHAR(1),
            MV_IMAGE    NVARCHAR2(21),
            MV_COMMENTS NVARCHAR2(50)
            )TABLESPACE MULTIPLEX;
              
INSERT INTO mv(MV_CODE,MV_NAME,MV_GRADE,MV_STATUS,MV_IMAGE,MV_COMMENTS)
VALUES('21012702','말할수없는비밀','Y','I','21012702L.jpg','감미로운 음악과함께 당신의 마음에 슬픔과 사랑의 선율을 전한다');

INSERT INTO mv(MV_CODE,MV_NAME,MV_GRADE,MV_STATUS,MV_IMAGE,MV_COMMENTS)
VALUES('21012201','극한직업','Y','I','21033101L.jpg','수원왕갈비통닭의 탄생비화 극한직업!');

INSERT INTO mv(MV_CODE,MV_NAME,MV_GRADE,MV_STATUS,MV_IMAGE,MV_COMMENTS)
VALUES('21012003','테넷','Y','I','21082603L.jpg','당신에게 줄 건 단 한 단어 ‘테넷’ 이해하지 말고 느껴라!');

INSERT INTO mv(MV_CODE,MV_NAME,MV_GRADE,MV_STATUS,MV_IMAGE,MV_COMMENTS)
VALUES('21011404','나이브스아웃','Y','I','21011404L.jpg','베스트셀러 미스터리 작가가 85세 생일의 다음 날 숨진 채 가정부에 의해 발견 되는데');


commit;


select * from mv;

rollback;

/* 20191001.jpg
20211002

연월일장르
21100201

코미디 1
로맨스 2 
액션 3
스릴러 4 
애니메이션 5
드라마 6 
다큐 7 
사극 8

전체 A
12세 C
15세 Y
19세 R

상영중 I
예정 P
종료 E

*/             
             
             
        ALTER TABLE DBA2.MOVIE
        ADD CONSTRAINT MV_CODE_PK   PRIMARY KEY(MV_CODE);
       ALTER TABLE DBA2.MOVIE
        MODIFY MV_NAME NOT NULL
        MODIFY MV_GRADE NOT NULL
        MODIFY MV_STATUS NOT NULL
        MODIFY MV_IMAGE NOT NULL;    
        
        CREATE PUBLIC SYNONYM MV FOR DBA2.MOVIE;
        
        GRANT SELECT,INSERT,UPDATE ON DBA2.MOVIE TO YJ,SOL,PHO,FOX;
             
            update dba2.movie set mv_image='' where mv_name='';
             /*                                                                   
                
    PART2. MAIN ENTITY
            2-1. SCREEN(SC)
                : SC_THCODE(FK, PK)[NC1], SC_NUMBER(PK)[NC2], SC_SEATS[N3], SC_COLS[N2], SC_ROWS[N2]
           */
CREATE TABLE DBA2.SCREEN(
    SC_THCODE NCHAR(1) NOT NULL,
    SC_NUMBER NCHAR(2) NOT NULL,
    SC_SEAT NCHAR(3) NOT NULL,
    SC_COLS NCHAR(2) NOT NULL,
    SC_ROWS NCHAR(2) NOT NULL
)TABLESPACE MULTIPLEX;
 
 INSERT INTO sc (SC_THCODE,SC_NUMBER,SC_SEAT,SC_COLS,SC_ROWS)
 VALUES('1','2','100','10','10');
 
 commit;

select * from sc;

commit;
ALTER TABLE DBA2.SCREEN 
ADD CONSTRAINT SC_THCODE_SC_NUMBER_PK 
PRIMARY KEY (SC_THCODE, SC_NUMBER);

ALTER TABLE DBA2.SCREEN
ADD CONSTRAINT SC_THCODE_FK
FOREIGN KEY (SC_THCODE) REFERENCES DBA2.THEATER(TH_CODE); 

GRANT SELECT,UPDATE,INSERT ON DBA2.SCREEN TO SOL,YJ,PHO,FOX;

CREATE PUBLIC SYNONYM SC FOR DBA2.SCREEN;
           
           
           /*
            2-1-1. INACTIVE SEAT(IS)
                : IS_SCTHCODE(+FK, PK)[NC1], SC_NUMBER(+FK, PK)[NC2], IS_SEAT(PK)[N3], IS_TYPE[NC1]
            */
CREATE TABLE DBA2.INACTIVESEAT(
    IS_SCTHCODE NCHAR(1) NOT NULL,
    IS_NUMBER NCHAR(2) NOT NULL,
    IS_SEAT NCHAR(3) NOT NULL,
    IS_TYPE NCHAR(1) NOT NULL
)TABLESPACE MULTIPLEX;

ALTER TABLE DBA2.INACTIVESEAT
ADD CONSTRAINT IS_SCTHCODE_NUMBER_PK 
PRIMARY KEY (IS_SCTHCODE,IS_NUMBER,IS_SEAT);


ALTER TABLE DBA2.INACTIVESEAT
ADD CONSTRAINT IS_SCTHCODE_NUMBER_FK
FOREIGN KEY (IS_SCTHCODE,IS_NUMBER)
REFERENCES DBA2.SCREEN(SC_THCODE, SC_NUMBER);

GRANT SELECT,INSERT,UPDATE ON DBA2.INACTIVESEAT TO YJ,SOL,PHO,FOX; 
           
CREATE PUBLIC SYNONYM "IS" FOR DBA2.INACTIVESEAT; 
            
            
            
            /*
            3-1. SCREENING MOVIE(SI)
                : SI_MVCODE(FK, PK)[NC8], SI_SCTHCODE(+FK, PK)[NC1], SI_SCNUMBER(+FK, PK)[NC2], 
                  SI_DATETIME(PK)[DATE]
             */     
CREATE TABLE DBA2.SCREENINGMOVIE(
    SI_MVCODE NCHAR(8) NOT NULL,
    SI_SCTHCODE NCHAR(1) NOT NULL,
    SI_SCNUMBER NCHAR(2) NOT NULL,
    SI_DATETIME DATE NOT NULL
)TABLESPACE MULTIPLEX;
                
ALTER TABLE DBA2.screeningmovie       
ADD CONSTRAINT SI_MVCO_SCTHCO_SCNUM_DATE_PK
PRIMARY KEY (SI_MVCODE,SI_SCTHCODE,SI_SCNUMBER,SI_DATETIME);

ALTER TABLE DBA2.screeningmovie
ADD CONSTRAINT SI_MVCODE_FK
FOREIGN KEY (SI_MVCODE)
REFERENCES MOVIE(MV_CODE);

ALTER TABLE DBA2.screeningmovie
ADD CONSTRAINT SI_SCTHCODE_SCNUMBER_FK
FOREIGN KEY (SI_SCTHCODE,SI_SCNUMBER)
REFERENCES DBA2.SCREEN(SC_THCODE,SC_NUMBER);
                  
GRANT SELECT,UPDATE,INSERT ON DBA2.SCREENINGMOVIE TO SOL,YJ,PHO,FOX;        

CREATE PUBLIC SYNONYM SI FOR DBA2.SCREENINGMOVIE;

SELECT * FROM SI;

COMMIT;
                  
             /*     
             -3. RESERVATION(RV)
                : RV_CODE(PK)[NC14], RV_SIMVCODE(+FK)[NC8], RV_SISCTHCODE(+FK)[NC1], RV_SISCNUMBER(+FK)[NC2], 
                  (YYYYMMDDNNNNNN)
                  RV_SIDATETIME(+FK)[DATE]
             */     
CREATE TABLE DBA2.RESERVATION(
    RV_CODE NCHAR(14) NOT NULL,
    RV_SIMVCODE NCHAR(8) NOT NULL,
    RV_SISCTHCODE NCHAR(1) NOT NULL,
    RV_SISCNUMNER NCHAR(2) NOT NULL,
    RV_SIDATIME DATE NOT NULL
)TABLESPACE MULTIPLEX;

ALTER TABLE DBA2.RESERVATION
ADD CONSTRAINT RV_CODE_PK
PRIMARY KEY(RV_CODE);

ALTER TABLE DBA2.RESERVATION
ADD CONSTRAINT RV_MVCO_THCO_NUM_DATE_FK
FOREIGN KEY(RV_SIMVCODE,RV_SISCTHCODE,RV_SISCNUMNER,RV_SIDATIME)
REFERENCES DBA2.SCREENINGMOVIE(SI_MVCODE,SI_SCTHCODE,SI_SCNUMBER,SI_DATETIME);
               
GRANT SELECT,UPDATE,INSERT ON DBA2.RESERVATION TO SOL,YJ,PHO,FOX;  

CREATE PUBLIC SYNONYM RV FOR DBA2.RESERVATION;
                  
                  
                  
                  
        /*
    PART3. ACTION ENTITY
             -1. RESERVATION DETAIL(RD)
                : RD_RVCODE(FK, PK)[NC14], RD_SEAT(PK)[N3], RD_TYPE[NC1]
*/

CREATE TABLE DBA2.RESERVATIONDETAIL(
RD_RVCODE NCHAR(14) NOT NULL,
RD_SEAT NCHAR(3) NOT NULL,
RD_TYPE NCHAR(3) NOT NULL
)TABLESPACE MULTIPLEX;

ALTER TABLE DBA2.RESERVATIONDETAIL
ADD CONSTRAINT RD_RVCODE_SEAT_PK
PRIMARY KEY (RD_RVCODE,RD_SEAT);

ALTER TABLE DBA2.RESERVATIONDETAIL
ADD CONSTRAINT RD_RVCODE_FK
FOREIGN KEY(RD_RVCODE)
REFERENCES DBA2.RESERVATION(RV_CODE);

GRANT SELECT,UPDATE,INSERT ON DBA2.RESERVATIONDETAIL TO YJ,SOL,PHO,FOX;

CREATE PUBLIC SYNONYM RD FOR DBA2.RESERVATIONDETAIL;




COMMIT;


