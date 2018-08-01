function limpar_schema_oracle {
    param([string]$schema,[string]$instancia,[string]$user,[string]$pwd)
    $script=@"
SET FEEDBACK OFF ECHO OFF PAGESIZE 0;
set lines 155;

select   'ALTER TABLE '||OWNER||'."'||TABLE_NAME||'" DROP CONSTRAINT "'||CONSTRAINT_NAME||'";'
from     dba_constraints
where    owner in ('${schema}')
and      constraint_type = 'R';

select   DISTINCT 'DROP SEQUENCE '||SEQUENCE_OWNER||'."'||SEQUENCE_NAME||'";'
from     dba_sequences
where    sequence_owner in ('${schema}');
 
select   DISTINCT 'DROP '||TYPE||' '||OWNER||'."'||NAME||'";'
from     dba_source
where    owner in ('${schema}');
 
select   'TRUNCATE TABLE '||OWNER||'.'||TABLE_NAME||';' LIMPAR_TABELAS
from     dba_tables
where    owner in ('${schema}');

select   'DROP VIEW '||OWNER||'."'|| VIEW_NAME||'";'
from     dba_views
where    owner in ('${schema}');
 
select   'DROP TABLE '||OWNER||'."'||TABLE_NAME||'" PURGE;'
from     dba_tables
where    owner in ('${schema}');
 
select   'DROP SYNONYM '||OWNER||'."'||SYNONYM_NAME||'";'
from     dba_synonyms
where    owner in ('${schema}');
 
select   'DROP TYPE '||OWNER||'."'||TYPE_NAME||'";'
from     dba_types
where    owner in ('${schema}');
 
select   'DROP MATERIALIZED VIEW '||OWNER||'."'||MVIEW_NAME||'";'
from     dba_mviews
where    owner in ('${schema}');

select 'DROP OPERATOR ' || owner || '.' || operator_name || ' force;' 
from dba_operators
where owner in ('${schema}');
 
SELECT 'PURGE TABLE ' || OWNER || '."' || ORIGINAL_NAME  || '";'
FROM dba_recyclebin 
WHERE owner in ('${schema}');

select 'DROP INDEXTYPE sde.st_spatial_index FORCE;' from dual;	
--excluir type
select DISTINCT 'DROP '||TYPE||' '||OWNER||'.'||NAME||' force;' EXCLUIR_TYPES
from     dba_source where    owner in ('${schema}') and type='TYPE';

"@
    $global:txt =@{}
    $global:txt = $script | sqlplus -s ${user}/${pwd}@${instancia}
    $txt | sqlplus -s ${user}/${pwd}@${instancia}
}

#limpar_schema_oracle -schema "teste" -instancia "teste" -user user1 -pwd teste2
