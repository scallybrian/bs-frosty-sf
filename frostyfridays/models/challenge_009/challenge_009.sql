
-- Create Tag
use role sysadmin;
create or replace tag frosty.challenges.mask_name
    allowed_values 'mask_first', 'mask_last';

-- Set tag on columns with different values for first/last name fields
alter table data_to_be_masked modify 
column first_name set tag mask_name = 'mask_first',
column last_name set tag mask_name = 'mask_last';

-- Create masking policy
create or replace masking policy tokenise_name as (val string) returns string ->
  case
  
    when system$get_tag_on_current_column('mask_name') = 'mask_first'
    and is_role_in_session('FOO1') or is_role_in_session('FOO2') 
    then val
    
    when system$get_tag_on_current_column('mask_name') = 'mask_last'
    and is_role_in_session('FOO2')
    then val
    
    else '***********'
  end;

-- Apply masking policy to target fields
alter table data_to_be_masked modify 
column first_name set masking policy tokenise_name,
column last_name set masking policy tokenise_name;
             
-- Attempt to query
use role sysadmin;
select * from data_to_be_masked;

use role foo1;
select * from data_to_be_masked;

use role foo2;
select * from data_to_be_masked;

