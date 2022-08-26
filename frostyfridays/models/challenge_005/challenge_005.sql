{{ config(
    pre_hook = 
"""create or replace function timesthree(i number)
returns number
language python
runtime_version = '3.8'
handler = 'timesthree'
as
$$ 
def timesthree(i):
    return i*3
$$;"""
) }}

select timesthree(1) as test