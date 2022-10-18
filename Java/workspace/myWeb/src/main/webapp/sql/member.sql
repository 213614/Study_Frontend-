-- member.sql

-- 회원 테이블 (테이블 설계 = 업무 분석이 끝났다는 뜻)
-- ① 회원 등급 : 업무 분석
A1 : 관리자				 : 최대 권한(=웹마스터), 의사 결정권자들 
B1 : 중간 관리자 			 
C1 : 우수 사용자 
D1 : 일반 사용자 (Default)  
E1 : 비회원				 : 비회원 구매 시 활용 
F1 : 탈퇴한 회원			 : DB에서 회원정보를 삭제(DELETE)하지 않고 등급을 F1으로 변경만 한다(UPDATE)
 ↑ : 등급 내에서 또 등급을 나눌때 사용하기 위해 숫자를 붙인다 (A1-A2-A3-···.)

-- ② 테이블 생성
 CREATE TABLE member (
    id       VARCHAR(10)  NOT NULL, 			-- 아이디, 중복 안됨.
    passwd   VARCHAR(10)  NOT NULL, 			-- 패스워드
    mname    VARCHAR(20)  NOT NULL, 			-- 성명
    tel      VARCHAR(14)  NULL,     			-- 전화번호
	email    VARCHAR(50)  NOT NULL  UNIQUE, 	-- 전자우편 주소, 중복 안됨
    zipcode  VARCHAR(7)   NULL,     			-- 우편번호, 12345
    address1 VARCHAR(255) NULL,     			-- 주소 1
    address2 VARCHAR(255) NULL,     			-- 주소 2(나머지주소)
    job      VARCHAR(20)  NOT NULL, 			-- 직업
    mlevel   CHAR(2)      NOT NULL, 			-- 회원 등급, A1, B1, C1, D1, E1, F1
    mdate    DATE         NOT NULL, 			-- 가입일    
    PRIMARY KEY (id)
);

--→ zipcode, address1·2 는 카카오 맵 오픈소스 이용
--→ id : PK : NULL값 절대 허용하지 않음
--→ email : UNIQUE : 딱 한번은 NULL값 허용
--→ mdate는 sysdate로 사용해도 됨
--→ CHAR : 고정형 문자열
--→ VARCHAR : 가변형 문자열	

commit; 

-- 행추가
insert into member(id, passwd, mname, tel, email, zipcode, address1, address2, job, mlevel, mdate)
values('webmaster', '12341234', '웹마스터', '123-4567', 'webmaster@itwill.com'
     , '12345', '서울시 강남구 역삼동', '삼원타워4층', 'A02', 'A1', sysdate );
     
insert into member(id, passwd, mname, tel, email, zipcode, address1, address2, job, mlevel, mdate)
values('itwill', '12341234', '웹마스터', '123-4567', 'itwill@itwill.com'
     , '12345', '서울시 강남구 역삼동', '삼원타워4층', 'A02', 'D1', sysdate );
     
insert into member(id, passwd, mname, tel, email, zipcode, address1, address2, job, mlevel, mdate)
values('user1', '12341234', '웹마스터', '123-4567', 'user1@soldesk.com'
     , '12345', '서울시 종로구 관철동', '코아빌딩8층', 'A02', 'F1', sysdate );

-------------------------------------------------------------------------------

-- 로그인
SELECT 
FROM member
WHERE id = ? AND passwd = ? ;
-- 어떤걸 보여줄지(select)는 업무 분석에 따라 다르다
-- mlevel(회원등급)별로 프론트 페이지를 다르게 보여줄 수 있음


-- ex. 아이디와 비밀번호 일치시 회원 등급을 가져옴
--→ 비회원과 탈퇴한 회원은 로그인이 되면 안된다 (회원정보가 존재하지않습니다 메세지 띄우기) = in조건절로 등급조건도 추가
SELECT mlevel
FROM member
WHERE id = 'webmaster' AND passwd = '12341234' AND mlevel IN ('A1','B1','C1','D1') ;
-- A1

SELECT mlevel
FROM member
WHERE id = 'itwill' AND passwd = '12341234' AND mlevel IN ('A1','B1','C1','D1') ;
-- D1

SELECT mlevel
FROM member
WHERE id = 'user1' AND passwd = '12341234' AND mlevel IN ('A1','B1','C1','D1') ;
-- 선택된 레코드가 없습니다. (= 'user1'은 탈퇴한 회원=F1등급이니까)

-------------------------------------------------------------------------------

-- 아이디 중복 확인
-- 무엇을 조회하느냐 중요 일반적으로 count(*)를 많이한다 
--→ id는 PK라 count(*) = 1라면 이미 아이디가 존재한다는 뜻 
SELECT COUNT(id) AS cnt
FROM member
WHERE id = ?;

-- 이메일 중복 확인도 똑같음
SELECT COUNT(email) AS cnt
FROM member
WHERE email = ?;

-- 회원가입 
INSERT INTO member (id, passwd, mname, tel, email, zipcode, address1, address2, job, mlevel, mdate) 
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'D1', sysdate);














