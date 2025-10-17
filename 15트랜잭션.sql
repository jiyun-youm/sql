--트랜잭션 (작업의 논리적인 단위)
--DML문에서 트랜잭션을 수행할 수 있음
--DCL, DDL문은 자동으로 COMMIT이 적용됨

--오토커밋의 상태
SHOW AUTOCOMMIT;
SET AUTOCOMMIT ON; --오토커밋 활성화
SET AUTOCOMMIT OFF;--오토커밋비활성화

--------------------------------------------------------------------------------
--SAVEPOINT 트랜잭션의 시점을 기록할 수 있음 (많이 쓰이진 않음)
SELECT * FROM DEPTS;

DELETE FROM DEPTS WHERE DEPARTMENT_ID=10;
SAVEPOINT DEL10;

DELETE FROM DEPTS WHERE DEPARTMENT_ID=20;
SAVEPOINT DEL20;

DELETE FROM DEPTS WHERE DEPARTMENT_ID=30;

ROLLBACK TO DEL20; --20번 삭제 후 로 롤백됨
SELECT * FROM DEPTS;
ROLLBACK TO DEL10; --10번 삭제 후 로 롤백됨
ROLLBACK; --마지막 커밋 시점으로 이동