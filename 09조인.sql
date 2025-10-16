SELECT * FROM INFO;
SELECT * FROM AUTH;

--INNER JOIN: 연결할 데이터가 없으면 나오지 않음
SELECT *
FROM INFO
INNER JOIN AUTH
ON INFO.AUTH_ID=AUTH.AUTH_ID;

--테이블 엘리어스
SELECT *
FROM INFO I
JOIN AUTH A
ON I.AUTH_ID=A.AUTH_ID;
--SELECT구문의 선택
SELECT ID,
       TITLE,
       I.AUTH_ID,  --동일한 컬럼명이 있는 경우에는 참조테이블(I.)을 지칭해야 합니다
       NAME
FROM INFO I
INNER JOIN AUTH A
ON I.AUTH_ID=A.AUTH_ID;

--USING ON구문을 쓸 수도 있음 -양측 테이블에 동일한 키 이름으로 연결할 때 가능
SELECT *
FROM INFO I
JOIN AUTH A
USING (AUTH_ID);
--------------------------------------------------------------------------------
--LEFT JOIN: 왼쪽 테이블은 다나옴, 붙을 수 없는 값은 NULL로 처리/OUTER 생략 가능
SELECT *
FROM INFO I
LEFT OUTER JOIN AUTH A
ON I.AUTH_ID=A.AUTH_ID;

--RIGHT JOIN: 오른쪽 테이블은 다나옴, 붙을 수 없는 값은 NULL로 처리
SELECT * 
FROM INFO I
RIGHT OUTER JOIN AUTH A
ON I.AUTH_ID=A.AUTH_ID;

--------------------------------------------------------------------------------
--FULL OUTER JOIN : 양측 테이블 다 나옴
SELECT *
FROM INFO I
FULL OUTER JOIN AUTH A
ON I.AUTH_ID=A.AUTH_ID;
--------------------------------------------------------------------------------
--CROSS JOIN: 잘못된 조인의 형태(카티시안 프로덕트)
SELECT *
FROM INFO
CROSS JOIN AUTH;
--------------------------------------------------------------------------------
SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;
SELECT * FROM LOCATIONS;
--조인은 여러번 붙을 수 있음
SELECT *
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
LEFT JOIN LOCATIONS L
ON D.LOCATION_ID=L.LOCATION_ID;
--------------------------------------------------------------------------------
--오라클에서 사용하는 오라클 조인문법
--테이블을 FROM절에 , 로 적음
--WHERE에서 조인 조건을 적음
--INNER JOIN
SELECT *
FROM INFO I, AUTH A
WHERE I.AUTH_ID=A.AUTH_ID;
--LEFT JOIN
SELECT *
FROM INFO I, AUTH A
WHERE I.AUTH_ID=A.AUTH_ID(+);
--RIGHT JOIN
SELECT *
FROM INFO I, AUTH A
WHERE I.AUTH_ID(+)=A.AUTH_ID;
--FULL OUTER JOIN은 오라클에서 없음!
--CROSS JOIN
SELECT *
FROM INFO I, AUTH A;

--------------------------------------------------------------------------------
--SELF JOIN
--문제 10. 
--join을 이용해서 사원의 이름과 그 사원의 매니저 이름을 출력하세요
--힌트) EMPLOYEES 테이블과 EMPLOYEES 테이블을 조인하세요.
SELECT E.FIRST_NAME AS 사원명,
       E2.FIRST_NAME AS 매니저명
FROM EMPLOYEES E
LEFT JOIN EMPLOYEES E2
ON E.MANAGER_ID=E2.EMPLOYEE_ID;
--------------------------------------------------------------------------------

--문제 11. 
--EMPLOYEES 테이블에서 left join하여 관리자(매니저)와, 매니저의 이름, 매니저의 급여 까지 출력하세요
--조건) 매니저 아이디가 없는 사람은 배제하고 급여는 역순으로 출력하세요
SELECT E.FRIST_NAME AS 사원명, E.SALARY AS 사원급여, E2.FIRST_NAME,E2.SALARY
FROM EMPLOYEES E
LEFT JOIN EMPLOYEES E2
ON E.MANAGER_ID=E2.EMPLOYEE_ID 
WHERE E2.FIRST_NAME IS NOT NULL
ORDER BY E2.SALARY DESC;
--------------------------------------------------------------------------------
--NON EQUALS JOIN
--두 테이블을 조인할 때 = 연산자 대신, >,>=,<>,BETWEEN AND 등을 이용해서 조인하는 방법
--보통 키 관계가 없는 컬럼들을 붙여서 쓸 때 사용할 수 있습니다
--크로스 조인을 기반으로 동작함
SELECT *
FROM EMPLOYEES E
CROSS JOIN JOBS;
--MIN_SALARY의 한 행에 대해서 SALARY가 큰 사람들을 모두 출력
SELECT *
FROM EMPLOYEES E
JOIN JOBS J
ON E.SALARY>=J.MIN_SALARY;

SELECT * 
FROM EMPLOYEES E
JOIN JOBS J
ON E.SALARY>= J.MIN_SALARY AND E.SALARY<=J.MAX_SALARY;













