--서브쿼리: SELECT절 안에 SELECT가 들어가는 유형
--단일행 서브쿼리-SELECT한 서브쿼리 결과가 1행인 서브쿼리
--서브쿼리 문법은 반드시 ()로 묶어줍니다. 연산자보다 오른쪽에 위치함

--낸시보다 급여 많이 받는 사원은 누구냐
--1.낸시급여 확인 2. 낸시보다 급여 큰 사람 찾음
SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME='Nancy';

SELECT *
FROM EMPLOYEES
WHERE SALARY>=(SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME='Nancy');


--직원아이디 103인 사람과 동일한 직무를 가진 사람
SELECT FIRST_NAME FROM EMPLOYEES WHERE JOB_ID=(SELECT JOB_ID FROM EMPLOYEES WHERE EMPLOYEE_ID=103);

--스티븐킹이랑 동일한 부서를 가진 사람들 
SELECT FIRST_NAME FROM EMPLOYEES WHERE DEPARTMENT_ID=(SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE FIRST_NAME='Steven' AND LAST_NAME='King');

--주의할점
--1.비교할 컬럼은 정확히 1개여야 함
--2.여러행이 나오는 경우라면, = 비교를 하지 못하고 다중행 서브쿼리에서 사용하는 연산자를 써야 함
SELECT *
FROM EMPLOYEES
WHERE OB_ID=(SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE FIRST_NAME='Steven');
--------------------------------------------------------------------------------
--다중행 서브쿼리 IN, ANY, ALL
--IN-정확히 일치하는 데이터만
--ANY-최소값보다 큰 OR 최대값보다 작은
--ALL-최대값보다 큰 OR 최소값보다 작은

--데이비드의 급여
SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME='David';
--4800보다 큰 사람들
SELECT *
FROM EMPLOYEES
WHERE SALARY >= ANY(SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME='David');
--9500보다 작은 사람들
SELECT *
FROM EMPLOYEES
WHERE SALARY <= ANY(SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME='David');
--9500보다 큰 사람들
SELECT *
FROM EMPLOYEES
WHERE SALARY >= ALL(SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME='David');
--4800보다 작은 사람들
SELECT *
FROM EMPLOYEES
WHERE SALARY <= ALL(SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME='David');

--정확히 일치하는 데이터 IN
SELECT *
FROM EMPLOYEES
WHERE SALARY IN (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME='David'); -- 행이 여러개라 IN 대신 = 쓰면 안 됨
--------------------------------------------------------------------------------
--스칼라 쿼리(서브쿼리절이 select구문에 들어간 형태)
--left join을 대체할 수 있음(조인된 테이블의 1개의 컬럼을 가져올 때 유리함)
SELECT FIRST_NAME,
       D.DEPARTMENT_NAME
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID=D.DEPARTMENT_ID;
-스칼라쿼리는 LEFT JOIN 대체
SELECT FIRST_NAME,
       (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID=E.DEPARTMENT_ID)AS DEPARTMENT_NAME
FROM EMPLOYEES E;

--스칼라쿼리는 다른 테이블의 1개의 컬럼만 가지고 올 때, 좀 더 유리하게 사용할 수 있음
--각 직원의 부서명, 직무이름 가지고 올거임
SELECT FIRST_NAME,
       (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID=E.DEPARTMENT_ID) AS D_NAME,
       (SELECT JOB_TITLE FROM JOBS J WHERE E.JOB_ID=J.JOB_ID) AS J_TITLE
FROM EMPLOYEES E;

--테이블 엘리어스
SELECT E.*,
       (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID=E.DEPARTMENT_ID) AS D_NAME,
       (SELECT JOB_TITLE FROM JOBS J WHERE E.JOB_ID=J.JOB_ID) AS J_TITLE
FROM EMPLOYEES E;
--------------------------------------------------------------------------------
--인라인뷰 (FROM에 들어가는 서브쿼리)
--인라인뷰에서 만든 가상 컬럼들에 대해서 연속적으로 조회해 나갈 때 사용함
SELECT *
FROM EMPLOYEES;

--ROWNUM는 조회된 순서에 번호가 붙음, ORDER 되면서 순서가 뒤바뀜
SELECT ROWNUM,
       FIRST_NAME,
       SALARY
FROM EMPLOYEES
ORDER BY SALARY DESC;
-인라인뷰로 순서 해결하기
SELECT ROWNUM, FIRST_NAME, SALARY
FROM (
    SELECT FIRST_NAME,
           SALARY
    FROM EMPLOYEES
ORDER BY SALARY DESC)
WHERE ROWNUM>=11 AND ROWNUM<=20; (로우넘은 순서붙이기라서 1번부터만 조회가 가능함)
-ROWNUM을 인라인뷰로 가상컬럼화 시키고, 재조회
SELECT *
FROM(
    SELECT ROWNUM AS RN, FIRST_NAME, SALARY
    FROM (
        SELECT FIRST_NAME,
            SALARY
        FROM EMPLOYEES
    ORDER BY SALARY DESC)
)
WHERE RN>=11 AND RN<=20;
--인라인뷰의 다양한 예시
--근속년수, 년월일, COMMISSION NULL처리
SELECT A.*
FROM(
        SELECT FIRST_NAME || ' '|| LAST_NAME AS 이름,
               TRUNC((SYSDATE-HIRE_DATE)/365) AS 근속년수,
               TO_CHAR(HIRE_DATE, 'YYYY"년"MM"월"DD"일"') AS 입사일,
               NVL(COMMISSION_PCT,0) AS 커미션
        FROM EMPLOYEES
        ORDER BY 근속년수 DESC
) A
WHERE MOD(근속년수,5)=0;






