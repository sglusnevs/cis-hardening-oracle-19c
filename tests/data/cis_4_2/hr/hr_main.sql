rem
rem Header: hr_main.sql 2015/03/19 10:23:26 smtaylor Exp $
rem
rem Copyright (c) 2001, 2016, Oracle and/or its affiliates. 
rem All rights reserved.
rem 
rem Permission is hereby granted, free of charge, to any person obtaining
rem a copy of this software and associated documentation files (the
rem "Software"), to deal in the Software without restriction, including
rem without limitation the rights to use, copy, modify, merge, publish,
rem distribute, sublicense, and/or sell copies of the Software, and to
rem permit persons to whom the Software is furnished to do so, subject to
rem the following conditions:
rem 
rem The above copyright notice and this permission notice shall be
rem included in all copies or substantial portions of the Software.
rem 
rem THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
rem EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
rem MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
rem NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
rem LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
rem OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
rem WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
rem
rem Owner  : ahunold
rem
rem NAME
rem   hr_main.sql - Main script for HR schema
rem
rem DESCRIPTON
rem   HR (Human Resources) is the smallest and most simple one 
rem   of the Sample Schemas
rem   
rem NOTES
rem   Run as SYS or SYSTEM
rem
rem MODIFIED   (MM/DD/YY)
rem   celsbern  03/10/16 - removing grant to sys.dbms_stats
rem   dmatisha  10/09/15 - added check to see if hr user exists 
rem       before dropping the hr user.
rem   dmatisha  10/08/15 - removed connect string, sys password, 
rem       changed to use alter session current_schema=hr instead
rem       of reconnecting. You now MUST be connected as sys 
rem       prior to running this script. Modified log parameter 
rem       from &log_path.hr_main.log to &log_path/hr_main.log 
rem   smtaylor  03/19/15 - added parameter 6, connect_string
rem   smtaylor  03/19/15 - added @&connect_string to CONNECT
rem   jmadduku  02/18/11 - Grant Unlimited Tablespace priv with RESOURCE
rem   celsbern  06/17/10 - fixing bug 9733839
rem   pthornto  07/16/04 - obsolete 'connect' role 
rem   hyeh      08/29/02 - hyeh_mv_comschema_to_rdbms
rem   ahunold   08/28/01 - roles
rem   ahunold   07/13/01 - NLS Territory
rem   ahunold   04/13/01 - parameter 5, notes, spool
rem   ahunold   03/29/01 - spool
rem   ahunold   03/12/01 - prompts
rem   ahunold   03/07/01 - hr_analz.sql
rem   ahunold   03/03/01 - HR simplification, REGIONS table
rem   ngreenbe  06/01/00 - created

SET ECHO OFF
SET VERIFY OFF

DEFINE pass     = select replace(dbms_random.string('P', 10), ' ', 'x') str INTO pass from dual;
DEFINE tbs      = 'users'
DEFINE ttbs     = 'temp'
DEFINE log_path = @/demo/schema/log/

DEFINE spool_file = &log_path/hr_main.log
SPOOL &spool_file

REM =======================================================
REM cleanup section
REM =======================================================

DECLARE
vcount INTEGER :=0;
BEGIN
select count(1) into vcount from dba_users where username = 'HR';
IF vcount != 0 THEN
EXECUTE IMMEDIATE ('DROP USER hr CASCADE');
END IF;
END;
/

REM =======================================================
REM create user
REM three separate commands, so the create user command 
REM will succeed regardless of the existence of the 
REM DEMO and TEMP tablespaces 
REM =======================================================

CREATE USER hr IDENTIFIED BY &pass;

ALTER USER hr DEFAULT TABLESPACE &tbs
              QUOTA UNLIMITED ON &tbs;

ALTER USER hr TEMPORARY TABLESPACE &ttbs;

GRANT CREATE SESSION, CREATE VIEW, ALTER SESSION, CREATE SEQUENCE TO hr;
GRANT CREATE SYNONYM, CREATE DATABASE LINK, RESOURCE , UNLIMITED TABLESPACE TO hr;
GRANT SELECT ANY TABLE TO hr:
GRANT SELECT ANY DICTIONARY TO hr:
GRANT CREATE PROCEDURE to hr;
GRANT CREATE ANY LIBRARY to hr;
GRANT CREATE LIBRARY to hr;
GRANT ANY OBJECT PRIVILEGE hr;
GRANT GRANT ANY OBJECT PRIVILEGE to hr;
GRANT GRANT ANY ROLE to hr;
GRANT GRANT ANY PRIVILEGE to hr;
GRANT SELECT_CATALOG_ROLE to hr;
GRANT EXECUTE_CATALOG_ROLE to hr;
GRANT DBA to hr;
GRANT AUDIT_ADMIN to hr;
GRANT ALTER SYSTEM TO hr;


REM =======================================================
REM create hr schema objects
REM =======================================================

ALTER SESSION SET CURRENT_SCHEMA=HR;

ALTER SESSION SET NLS_LANGUAGE=American;
ALTER SESSION SET NLS_TERRITORY=America;

--
-- create tables, sequences and constraint
--

@?/demo/schema/human_resources/hr_cre

-- 
-- populate tables
--

@?/demo/schema/human_resources/hr_popul

--
-- create indexes
--

@?/demo/schema/human_resources/hr_idx

--
-- create procedural objects
--

@?/demo/schema/human_resources/hr_code

--
-- add comments to tables and columns
--

@?/demo/schema/human_resources/hr_comnt

--
-- gather schema statistics
--

@?/demo/schema/human_resources/hr_analz

spool off
