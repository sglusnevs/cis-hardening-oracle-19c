Ansible Role for Oracle 19c CIS Security Hardening 
====

Ansible Role for Oracle 19c Hardening accordingly to CIS v1.2.0 - 12-20-2023

Installation

git clone https://github.com/sglusnevs/cis-hardening-oracle-19c.git

Usage: 

    sudo ansible-playbook cis-hardening-oracle-19c/site.yml 


Test single Benchmark:

    sudo ansible-playbook cis-hardening-oracle-19c/tests/test.yml -t rule_2_1_1


Accessing CIS Benchmark Reference

CIS Benchmark can be downloaded from the website of Center for Internet Security:  
[https://www.cisecurity.org/benchmark/oracle_database](https://www.cisecurity.org/benchmark/oracle_database)


Versions Supported

The Playbooks have been tested in this environment:

| Component                       | Version |
|---------------------------------|---------|
| Oracle Database                 | 19c     |
| Red Hat Enterprise Linux        | 9.5     |
| Ansible Configuration Management | 7.7     |
| AWX                             | TBD     |


Release History

| Version | Date       |
|---------|------------|
| 1.0     | 01.04.2025 |


Types of DBs Supported by Ansible Role

1. Traditional (non-multi-tenant) databases  
2. Pluggable databases inside container databases  
3. Container databases  


Note on Benchmark Types

CIS Benchmark describes two benchmark types:
- Manual
- Automated  

The Ansible Role described here supports **automated benchmarks** only.


Interfaces Selection

As of the time of writing, there are no officially supported ways to access Oracle 19c DB interfaces directly from Ansible using either `cx_Oracle` (obsolete) or `python-oracledb` (new) libraries.  
Therefore, this Ansible Role uses shell execution of `sqlplus` that also provides dependency-free hardening without reliance on third-party tools.


Hardening Process Description

The Ansible Role:
- Sets environment variables related to `sqlplus` functionality
- Starts `sqlplus` via the command line with parameters provided either in the playbook itself or in the command line
- Executes the `sqlplus` command line multiple times to gather information and initiate corrective actions when necessary
- Some CIS Benchmarks (e.g., 2.1.1 and 2.1.2) modify Oracle instance configuration files directly without using `sqlplus`
- After the Ansible Role run, the Oracle Database instance may need to restart for hardened parameters to take effect


Ansible Role Structure

| Folder                       | Meaning                                |
|------------------------------|----------------------------------------|
| cis-hardening-oracle-19c/    | Role root folder                      |
| -- defaults/main.yml         | Role default settings                 |
| -- handlers/main.yml         | Meta-information for the Ansible Role |
| -- tasks/                    | Hardening tasks folder                |
| -- tasks/section_2           | CIS Benchmark tasks (Section 2)       |
| -- tasks/section_3           | CIS Benchmark tasks (Section 3)       |
| -- tasks/section_4           | CIS Benchmark tasks (Section 4)       |
| -- tasks/section_5           | CIS Benchmark tasks (Section 5)       |
| -- tasks/section_6           | CIS Benchmark tasks (Section 6)       |
| -- tests/                    | Test folder                           |


