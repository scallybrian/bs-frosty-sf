with 
l1 as (
    select word, url, definition, definition[0]:meanings as meanings from week16
),
l2 as (
    select 
        word, 
        url, 
        m.value.partOfspeech part_of_speech,
        m.value:synonyms general_synonyms,
        m.value:antonyms general_antonyms,
        d.value:definition definition,
        d.value:example example_if_applicable,
        d.value:synonyms definitional_synonyms
        d.value:antonyms definitional_antonyms,
    from l1,
    lateral flatten(input => meanings, outer => TRUE) m,
    lateral flatten(input => m.value:definitions, outer => TRUE) d
)
select count(word), count(distinct word) from l2
;