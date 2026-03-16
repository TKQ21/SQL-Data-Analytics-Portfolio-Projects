create database INDIA_ELECTION_RESULTS;
use INDIA_ELECTION_RESULTS;

#################################################################3 DATA CLEANING #################################################################
##################################### STATES #############################################3
describe states;

ALTER TABLE states
CHANGE `State ID` state_id VARCHAR(5);

ALTER TABLE states
CHANGE `State` state VARCHAR(100);


ALTER TABLE states
MODIFY State ID to state_id VARCHAR(5);


ALTER TABLE states
MODIFY state VARCHAR(100);


################################### PARTY WISE RESULTS ########################################################


select * from partywise_results;

describe partywise_results;

ALTER TABLE partywise_results CHANGE `Party_id` party_id  int;

ALTER TABLE partywise_results
MODIFY party VARCHAR(150);



################################### STATE WISE RESULTS ##################
select * from statewise_results;
DESCRIBE statewise_results;

ALTER TABLE statewise_results
CHANGE `State ID` state_id VARCHAR(5);

ALTER TABLE statewise_results
CHANGE `Parliament Constituency` parliament_constituency VARCHAR(100);

ALTER TABLE statewise_results
CHANGE `Leading Candidate` leading_candidate VARCHAR(100);

ALTER TABLE statewise_results
CHANGE `Trailing Candidate` trailing_candidate VARCHAR(100);


ALTER TABLE statewise_results
MODIFY constituency VARCHAR(100);


ALTER TABLE statewise_results
MODIFY status VARCHAR(50);


ALTER TABLE statewise_results
MODIFY state VARCHAR(100);


################################################# CONSTITUENCYWISE RESULTS #######################################

select * from constituencywise_results;

DESCRIBE constituencywise_results;

ALTER TABLE constituencywise_results
CHANGE `S.No` S_No INT;

ALTER TABLE constituencywise_results
CHANGE `Party ID` party_id INT;

ALTER TABLE constituencywise_results
CHANGE `Parliament Constituency` parliament_constituency VARCHAR(100);


ALTER TABLE constituencywise_results
CHANGE `Constituency Name` constituency_name VARCHAR(100);

ALTER TABLE constituencywise_results
CHANGE `Constituency ID` constituency_id VARCHAR(50);


ALTER TABLE constituencywise_results
CHANGE `Winning Candidate` winning_candidate VARCHAR(100);

ALTER TABLE constituencywise_results
CHANGE `Total Votes` total_votes INT;


############################################### CONSTITUENCY WISE DETAILS #############################################

select * from constituencywise_details;

DESCRIBE constituencywise_details;

ALTER TABLE constituencywise_details
CHANGE `S.N.` S_No INT;

ALTER TABLE constituencywise_details
CHANGE `EVM Votes` evm_votes INT;

ALTER TABLE constituencywise_details
CHANGE `Postal Votes` postal_votes INT;

ALTER TABLE constituencywise_details
CHANGE `Total Votes` total_votes INT;

ALTER TABLE constituencywise_details
CHANGE `% of Votes` vote_percent DECIMAL(5,2);

ALTER TABLE constituencywise_details
CHANGE `Constituency ID` constituency_id varchar(10);

ALTER TABLE constituencywise_details
MODIFY candidate VARCHAR(100);

ALTER TABLE constituencywise_details
MODIFY party VARCHAR(150);

####################################################################### QUERIES ###################################################################
# TOTAL SEATS 

select distinct count(parliament_constituency) as TOTAL_SEATS from constituencywise_results;

# WHAT ARE THE TOTAL NO OF SEATS AVAILABLE FOR ELECTION IN EACH STATE ?
SELECT s.state AS state_name,
COUNT(cr.constituency_id) AS total_seats_available
FROM constituencywise_results cr
JOIN statewise_results sr 
ON cr.parliament_constituency = sr.parliament_constituency
JOIN states s
ON sr.state_id = s.state_id
GROUP BY s.state
ORDER BY s.state;

# WHAT ARE THE TOTAL SEATS WON BY NDA ALLIANZ ?

SELECT 
    SUM(CASE 
            WHEN party IN (
                'Bharatiya Janata Party - BJP', 
                'Telugu Desam - TDP', 
				'Janata Dal  (United) - JD(U)',
                'Shiv Sena - SHS', 
                'AJSU Party - AJSUP', 
                'Apna Dal (Soneylal) - ADAL', 
                'Asom Gana Parishad - AGP',
                'Hindustani Awam Morcha (Secular) - HAMS', 
                'Janasena Party - JnP', 
				'Janata Dal  (Secular) - JD(S)',
                'Lok Janshakti Party(Ram Vilas) - LJPRV', 
                'Nationalist Congress Party - NCP',
                'Rashtriya Lok Dal - RLD', 
                'Sikkim Krantikari Morcha - SKM'
            ) THEN Won
            ELSE 0 
        END) AS NDA_Total_Seats_Won
FROM 
    partywise_results;


# WHAT ARE THE SEATS WON BY NDA ALLIANZ PARTIES ?

SELECT 
    party as Party_Name,
    won as Seats_Won
FROM 
    partywise_results
WHERE 
    party IN (
        'Bharatiya Janata Party - BJP', 
        'Telugu Desam - TDP', 
		'Janata Dal  (United) - JD(U)',
        'Shiv Sena - SHS', 
        'AJSU Party - AJSUP', 
        'Apna Dal (Soneylal) - ADAL', 
        'Asom Gana Parishad - AGP',
        'Hindustani Awam Morcha (Secular) - HAMS', 
        'Janasena Party - JnP', 
		'Janata Dal  (Secular) - JD(S)',
        'Lok Janshakti Party(Ram Vilas) - LJPRV', 
        'Nationalist Congress Party - NCP',
        'Rashtriya Lok Dal - RLD', 
        'Sikkim Krantikari Morcha - SKM'
    )
ORDER BY Seats_Won DESC;

# WHAT ARE TOTAL SEATS WON BY INDIA ALLIANZ ?

SELECT 
    SUM(CASE 
            WHEN party IN (
                'Indian National Congress - INC',
                'Aam Aadmi Party - AAAP',
                'All India Trinamool Congress - AITC',
                'Bharat Adivasi Party - BHRTADVSIP',
                'Communist Party of India  (Marxist) - CPI(M)',
                'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
                'Communist Party of India - CPI',
                'Dravida Munnetra Kazhagam - DMK',
                'Indian Union Muslim League - IUML',
                'Nat`Jammu & Kashmir National Conference - JKN',
                'Jharkhand Mukti Morcha - JMM',
                'Jammu & Kashmir National Conference - JKN',
                'Kerala Congress - KEC',
                'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
                'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
                'Rashtriya Janata Dal - RJD',
                'Rashtriya Loktantrik Party - RLTP',
                'Revolutionary Socialist Party - RSP',
                'Samajwadi Party - SP',
                'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
                'Viduthalai Chiruthaigal Katchi - VCK'
            ) THEN Won
            ELSE 0 
        END) AS INDIA_Total_Seats_Won
FROM 
    partywise_results;
    
# WHAT ARE SEATS WON BY INDIA ALLIANZ PARTIES ?

SELECT 
    party as Party_Name,
    won as Seats_Won
FROM 
    partywise_results
WHERE 
    party IN (
        'Indian National Congress - INC',
                'Aam Aadmi Party - AAAP',
                'All India Trinamool Congress - AITC',
                'Bharat Adivasi Party - BHRTADVSIP',
                'Communist Party of India  (Marxist) - CPI(M)',
                'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
                'Communist Party of India - CPI',
                'Dravida Munnetra Kazhagam - DMK',
                'Indian Union Muslim League - IUML',
                'Nat`Jammu & Kashmir National Conference - JKN',
                'Jharkhand Mukti Morcha - JMM',
                'Jammu & Kashmir National Conference - JKN',
                'Kerala Congress - KEC',
                'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
                'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
                'Rashtriya Janata Dal - RJD',
                'Rashtriya Loktantrik Party - RLTP',
                'Revolutionary Socialist Party - RSP',
                'Samajwadi Party - SP',
                'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
                'Viduthalai Chiruthaigal Katchi - VCK'
    )
ORDER BY Seats_Won DESC;

# ADD NEW COLUMN FIELD IN TABLE PARTYWISE_RESULTS TO GET THE PARTY ALLIANZ AS NDA, INDIA AND OTHER

ALTER TABLE partywise_results
ADD party_alliance VARCHAR(50);

# I.N.D.I.A Allianz
UPDATE partywise_results
SET party_alliance = 'I.N.D.I.A'
WHERE party IN (
    'Indian National Congress - INC',
    'Aam Aadmi Party - AAAP',
    'All India Trinamool Congress - AITC',
    'Bharat Adivasi Party - BHRTADVSIP',
    'Communist Party of India  (Marxist) - CPI(M)',
    'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
    'Communist Party of India - CPI',
    'Dravida Munnetra Kazhagam - DMK',	
    'Indian Union Muslim League - IUML',
    'Jammu & Kashmir National Conference - JKN',
    'Jharkhand Mukti Morcha - JMM',
    'Kerala Congress - KEC',
    'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
    'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
    'Rashtriya Janata Dal - RJD',
    'Rashtriya Loktantrik Party - RLTP',
    'Revolutionary Socialist Party - RSP',
    'Samajwadi Party - SP',
    'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
    'Viduthalai Chiruthaigal Katchi - VCK'
);
# NDA Allianz
UPDATE partywise_results
SET party_alliance = 'NDA'
WHERE party IN (
    'Bharatiya Janata Party - BJP',
    'Telugu Desam - TDP',
    'Janata Dal  (United) - JD(U)',
    'Shiv Sena - SHS',
    'AJSU Party - AJSUP',
    'Apna Dal (Soneylal) - ADAL',
    'Asom Gana Parishad - AGP',
    'Hindustani Awam Morcha (Secular) - HAMS',
    'Janasena Party - JnP',
    'Janata Dal  (Secular) - JD(S)',
    'Lok Janshakti Party(Ram Vilas) - LJPRV',
    'Nationalist Congress Party - NCP',
    'Rashtriya Lok Dal - RLD',
    'Sikkim Krantikari Morcha - SKM'
);
# OTHER
UPDATE partywise_results
SET party_alliance = 'OTHER'
WHERE party_alliance IS NULL;

## FOR CHECK RESULT
SELECT party_alliance, SUM(won)
FROM partywise_results
GROUP BY party_alliance;

# WHICH PARTY ALLIANCE (NDA, INDIA AND OTHER) WON THE MOST SEATS ACROSS ALL STATES ?

SELECT 
    p.party_alliance,
    COUNT(cr.constituency_id) AS seats_won
FROM constituencywise_results cr
JOIN partywise_results p 
ON cr.party_id = p.party_id
GROUP BY p.party_alliance
ORDER BY seats_won DESC;

# WINNING CANDIDATE'S NAME, THEIR PARTY NAME, TOTAL VOTES, AND THE MARGIN OF VICTORY FOR A SPECIFIC STATE AND CONSTITUENCY ?

SELECT 
    cr.winning_candidate,
    p.party,
    p.party_alliance,
    cr.total_votes,
    cr.margin,
    cr.constituency_name,
    s.state
FROM constituencywise_results cr
JOIN partywise_results p 
    ON cr.party_id = p.party_id
JOIN statewise_results sr 
    ON cr.parliament_constituency = sr.parliament_constituency
JOIN states s 
    ON sr.state_id = s.state_id
WHERE s.state = 'Uttar Pradesh' 
AND cr.constituency_name = 'AMETHI';

# DISTRIBUTION OF EVM VOTES VS POSTAL VOTES FOR CANDIDATES IN A SPECIFIC CONSTITUENCY ?

SELECT 
    cd.candidate,
    cd.party,
    cd.evm_votes,
    cd.postal_votes,
    cd.total_votes,
    cr.constituency_name
FROM constituencywise_details cd
JOIN constituencywise_results cr 
    ON cd.constituency_id = cr.constituency_id
WHERE cr.constituency_name = 'MATHURA'
ORDER BY cd.total_votes DESC;

# PARTIES THAT WON THE MOST SEATS IN A SPECIFIC STATE ?

SELECT 
    p.party,
    COUNT(cr.constituency_id) AS seats_won
FROM constituencywise_results cr
JOIN partywise_results p 
    ON cr.party_id = p.party_id
JOIN statewise_results sr 
    ON cr.parliament_constituency = sr.parliament_constituency
JOIN states s 
    ON sr.state_id = s.state_id
WHERE s.state = 'Andhra Pradesh'
GROUP BY p.party
ORDER BY seats_won DESC;

# TOTAL SEATS WON BY EACH PARTY ALLIANCE IN EACH STATE (INDIA ELECTIONS 2024) ?

SELECT 
    s.state AS state_name,
    SUM(CASE WHEN p.party_alliance = 'NDA' THEN 1 ELSE 0 END) AS nda_seats_won,
    SUM(CASE WHEN p.party_alliance = 'I.N.D.I.A' THEN 1 ELSE 0 END) AS india_seats_won,
    SUM(CASE WHEN p.party_alliance = 'OTHER' THEN 1 ELSE 0 END) AS other_seats_won
FROM constituencywise_results cr
JOIN partywise_results p 
    ON cr.party_id = p.party_id
JOIN statewise_results sr 
    ON cr.parliament_constituency = sr.parliament_constituency
JOIN states s 
    ON sr.state_id = s.state_id
GROUP BY s.state
ORDER BY s.state;

# CANDIDATE WITH THE HIGHEST EVM VOTES IN EACH CONSTITUENCY (TOP 10) ?

SELECT 
    cr.constituency_name,
    cd.constituency_id,
    cd.candidate,
    cd.evm_votes
FROM constituencywise_details cd
JOIN constituencywise_results cr 
    ON cd.constituency_id = cr.constituency_id
WHERE cd.evm_votes = (
        SELECT MAX(cd1.evm_votes)
        FROM constituencywise_details cd1
        WHERE cd1.constituency_id = cd.constituency_id
)
ORDER BY cd.evm_votes DESC
LIMIT 10;

# WINNING AND RUNNER-UP CANDIDATES IN EACH CONSTITUENCY OF A SPECIFIC STATE ?
 
WITH ranked_candidates AS (
    SELECT 
        cd.constituency_id,
        cd.candidate,
        cd.party,
        cd.evm_votes,
        cd.postal_votes,
        cd.evm_votes + cd.postal_votes AS total_votes,
        ROW_NUMBER() OVER (
            PARTITION BY cd.constituency_id 
            ORDER BY cd.evm_votes + cd.postal_votes DESC
        ) AS vote_rank
    FROM constituencywise_details cd
    JOIN constituencywise_results cr 
        ON cd.constituency_id = cr.constituency_id
    JOIN statewise_results sr 
        ON cr.parliament_constituency = sr.parliament_constituency
    JOIN states s 
        ON sr.state_id = s.state_id
    WHERE s.state = 'Maharashtra'
)

SELECT 
    cr.constituency_name,
    MAX(CASE WHEN rc.vote_rank = 1 THEN rc.candidate END) AS winning_candidate,
    MAX(CASE WHEN rc.vote_rank = 2 THEN rc.candidate END) AS runnerup_candidate
FROM ranked_candidates rc
JOIN constituencywise_results cr 
    ON rc.constituency_id = cr.constituency_id
GROUP BY cr.constituency_name
ORDER BY cr.constituency_name;