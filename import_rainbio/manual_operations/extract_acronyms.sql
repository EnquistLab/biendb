-- -------------------------------------------------------------------
-- Extract herbarium acronyms from RAINBIO dataset
-- & combine these will all other acronyms from BIEN rarity paper
-- -------------------------------------------------------------------

\c vegbien
set search_path to rainbio;

DROP TABLE IF EXISTS acronyms;
CREATE TABLE acronyms AS
SELECT DISTINCT 
acronym AS acronym_verbatim,
CAST(NULL AS text) AS acronym
FROM 
(
SELECT TRIM(unnest(string_to_array(dups, ','))) AS acronym
FROM rainbio_raw
) a
ORDER BY acronym
;

UPDATE acronyms
SET acronym=split_part(acronym_verbatim,' ',1)
;

UPDATE acronyms
SET acronym=
CASE
WHEN acronym LIKE '%BM' THEN 'BM'
WHEN acronym LIKE '%BR' THEN 'BR'
WHEN acronym LIKE '%FHO' THEN 'FHO'
WHEN acronym LIKE '%K' THEN 'K'
WHEN acronym LIKE '%leiden' THEN 'L'
WHEN acronym LIKE '%MO' THEN 'MO'
WHEN acronym LIKE '%P' THEN 'P'
WHEN acronym LIKE '%wag' THEN 'WAG'
WHEN acronym LIKE '%Wag' THEN 'WAG'
WHEN acronym LIKE '%WAG' THEN 'WAG'
ELSE acronym
END
WHERE acronym like ' %'
;

UPDATE acronyms
SET acronym=REPLACE(acronym,'!','')
;
UPDATE acronyms
SET acronym=REPLACE(acronym,'?','')
;
UPDATE acronyms
SET acronym=REPLACE(acronym,':','')
;
UPDATE acronyms
SET acronym=REPLACE(acronym,')','')
;
UPDATE acronyms
SET acronym=REPLACE(acronym,'(','')
;

DROP TABLE IF EXISTS acronyms_final;
CREATE TABLE acronyms_final AS
SELECT DISTINCT a.acronym
FROM acronyms a JOIN analytical_db.ih b
ON a.acronym=b.acronym
ORDER BY a.acronym
;

DROP TABLE IF EXISTS bien_rarity_acronyms;
CREATE TABLE bien_rarity_acronyms (
acronym text
);
INSERT INTO bien_rarity_acronyms (acronym)
VALUES
('A'),
('AAH'),
('AAS'),
('AAU'),
('ABH'),
('ACAD'),
('ACOR'),
('AD'),
('AFS'),
('AK'),
('AKPM'),
('ALCB'),
('ALTA'),
('ALU'),
('AMD'),
('AMES'),
('AMNH'),
('AMO'),
('ANGU'),
('ANSM'),
('ANSP'),
('AQP'),
('ARAN'),
('ARIZ'),
('AS'),
('ASDM'),
('ASU'),
('AUT'),
('AV'),
('AWH'),
('B'),
('BA'),
('BAA'),
('BAB'),
('BABY'),
('BACP'),
('BAF'),
('BAFC'),
('BAI'),
('BAJ'),
('BAL'),
('BARC'),
('BAS'),
('BBB'),
('BBS'),
('BC'),
('BCMEX'),
('BCN'),
('BCRU'),
('BEREA'),
('BESA'),
('BG'),
('BH'),
('BHCB'),
('BIO'),
('BISH'),
('BLA'),
('BM'),
('BOCH'),
('BOL'),
('BOLV'),
('BONN'),
('BOON'),
('BOTU'),
('BOUM'),
('BPI'),
('BR'),
('BREM'),
('BRI'),
('BRIT'),
('BRLU'),
('BRM'),
('BSB'),
('BUT'),
('C'),
('CALI'),
('CAN'),
('CANB'),
('CANU'),
('CAS'),
('CATA'),
('CATIE'),
('CAY'),
('CBM'),
('CDA'),
('CDBI'),
('CEN'),
('CEPEC'),
('CESJ'),
('CGE'),
('CGMS'),
('CHAM'),
('CHAPA'),
('CHAS'),
('CHR'),
('CHSC'),
('CIB'),
('CICY'),
('CIIDIR'),
('CIMI'),
('CINC'),
('CLEMS'),
('CLF'),
('CMM'),
('CMMEX'),
('CNPO'),
('CNS'),
('COA'),
('COAH'),
('COCA'),
('CODAGEM'),
('COFC'),
('COL'),
('COLO'),
('CONC'),
('CORD'),
('CP'),
('CPAP'),
('CPUN'),
('CR'),
('CRAI'),
('CRP'),
('CS'),
('CSU'),
('CSUSB'),
('CTES'),
('CTESN'),
('CU'),
('CUVC'),
('CUZ'),
('CVRD'),
('DAO'),
('DAV'),
('DBG'),
('DBN'),
('DES'),
('DLF'),
('DNA'),
('DPU'),
('DR'),
('DS'),
('DSM'),
('DUKE'),
('DUSS'),
('E'),
('EA'),
('EAC'),
('EAN'),
('EBUM'),
('ECON'),
('EIF'),
('EIU'),
('EMMA'),
('ENCB'),
('ER'),
('ERA'),
('ESA'),
('ETH'),
('F'),
('FAA'),
('FAU'),
('FAUC'),
('FB'),
('FCME'),
('FCO'),
('FCQ'),
('FEN'),
('FHO'),
('FI'),
('FLAS'),
('FLOR'),
('FM'),
('FR'),
('FRU'),
('FSU'),
('FTG'),
('FUEL'),
('FULD'),
('FURB'),
('G'),
('GAT'),
('GB'),
('GDA'),
('GENT'),
('GES'),
('GH'),
('GI'),
('GLM'),
('GMDRC'),
('GMNHJ'),
('GOET'),
('GRA'),
('GUA'),
('GZU'),
('H'),
('HA'),
('HAC'),
('HAL'),
('HAM'),
('HAMAB'),
('HAO'),
('HAS'),
('HASU'),
('HB'),
('HBG'),
('HBR'),
('HCIB'),
('HEID'),
('HGM'),
('HIB'),
('HIP'),
('HNT'),
('HO'),
('HPL'),
('HRCB'),
('HRP'),
('HSC'),
('HSS'),
('HU'),
('HUA'),
('HUAA'),
('HUAL'),
('HUAZ'),
('HUCP'),
('HUEFS'),
('HUEM'),
('HUFU'),
('HUJ'),
('HUSA'),
('HUT'),
('HXBH'),
('HYO'),
('IAA'),
('IAC'),
('IAN'),
('IB'),
('IBGE'),
('IBK'),
('IBSC'),
('IBUG'),
('ICEL'),
('ICESI'),
('ICN'),
('IEA'),
('IEB'),
('ILL'),
('ILLS'),
('IMSSM'),
('INB'),
('INEGI'),
('INIF'),
('INM'),
('INPA'),
('IPA'),
('IPRN'),
('IRVC'),
('ISC'),
('ISKW'),
('ISL'),
('ISTC'),
('ISU'),
('IZAC'),
('IZTA'),
('JACA'),
('JBAG'),
('JBGP'),
('JCT'),
('JE'),
('JEPS'),
('JOTR'),
('JROH'),
('JUA'),
('JYV'),
('K'),
('KIEL'),
('KMN'),
('KMNH'),
('KOELN'),
('KOR'),
('KPM'),
('KSC'),
('KSTC'),
('KSU'),
('KTU'),
('KU'),
('KUN'),
('KYO'),
('L'),
('LA'),
('LAGU'),
('LBG'),
('LD'),
('LE'),
('LEB'),
('LIL'),
('LINC'),
('LINN'),
('LISE'),
('LISI'),
('LISU'),
('LL'),
('LMS'),
('LOJA'),
('LOMA'),
('LP'),
('LPAG'),
('LPB'),
('LPD'),
('LPS'),
('LSU'),
('LSUM'),
('LTB'),
('LTR'),
('LW'),
('LYJB'),
('LZ'),
('M'),
('MA'),
('MACF'),
('MAF'),
('MAK'),
('MARS'),
('MARY'),
('MASS'),
('MB'),
('MBK'),
('MBM'),
('MBML'),
('MCNS'),
('MEL'),
('MELU'),
('MEN'),
('MERL'),
('MEXU'),
('MFA'),
('MFU'),
('MG'),
('MGC'),
('MICH'),
('MIL'),
('MIN'),
('MISSA'),
('MJG'),
('MMMN'),
('MNHM'),
('MNHN'),
('MO'),
('MOL'),
('MOR'),
('MPN'),
('MPU'),
('MPUC'),
('MSB'),
('MSC'),
('MSUN'),
('MT'),
('MTMG'),
('MU'),
('MUB'),
('MUR'),
('MVFA'),
('MVFQ'),
('MVJB'),
('MVM'),
('MW'),
('MY'),
('N'),
('NA'),
('NAC'),
('NAS'),
('NCU'),
('NE'),
('NH'),
('NHM'),
('NHMC'),
('NHT'),
('NLH'),
('NM'),
('NMB'),
('NMNL'),
('NMR'),
('NMSU'),
('NSPM'),
('NSW'),
('NT'),
('NU'),
('NUM'),
('NY'),
('NZFRI'),
('O'),
('OBI'),
('ODU'),
('OS'),
('OSA'),
('OSC'),
('OSH'),
('OULU'),
('OWU'),
('OXF'),
('P'),
('PACA'),
('PAMP'),
('PAR'),
('PASA'),
('PDD'),
('PE'),
('PEL'),
('PERTH'),
('PEUFR'),
('PFC'),
('PGM'),
('PH'),
('PKDC'),
('PLAT'),
('PMA'),
('POM'),
('PORT'),
('PR'),
('PRC'),
('PRE'),
('PSU'),
('PY'),
('QCA'),
('QCNE'),
('QFA'),
('QM'),
('QRS'),
('QUE'),
('R'),
('RAS'),
('RB'),
('RBR'),
('REG'),
('RELC'),
('RFA'),
('RIOC'),
('RM'),
('RNG'),
('RSA'),
('RYU'),
('S'),
('SACT'),
('SALA'),
('SAM'),
('SAN'),
('SANT'),
('SAPS'),
('SASK'),
('SAV'),
('SBBG'),
('SBT'),
('SCFS'),
('SD'),
('SDSU'),
('SEL'),
('SEV'),
('SF'),
('SFV'),
('SGO'),
('SI'),
('SIU'),
('SJRP'),
('SJSU'),
('SLPM'),
('SMDB'),
('SMF'),
('SNM'),
('SOM'),
('SP'),
('SPF'),
('SPSF'),
('SQF'),
('SRFA'),
('STL'),
('STU'),
('SUU'),
('SVG'),
('TAES'),
('TAI'),
('TAIF'),
('TALL'),
('TAM'),
('TAMU'),
('TAN'),
('TASH'),
('TEF'),
('TENN'),
('TEPB'),
('TEX'),
('TFC'),
('TI'),
('TKPM'),
('TNS'),
('TO'),
('TOYA'),
('TRA'),
('TRH'),
('TROM'),
('TRT'),
('TRTE'),
('TU'),
('TUB'),
('U'),
('UADY'),
('UAM'),
('UAMIZ'),
('UB'),
('UBC'),
('UC'),
('UCMM'),
('UCR'),
('UCS'),
('UCSB'),
('UCSC'),
('UEC'),
('UESC'),
('UFG'),
('UFMA'),
('UFMT'),
('UFP'),
('UFRJ'),
('UFRN'),
('UFS'),
('UGDA'),
('UH'),
('UI'),
('UJAT'),
('ULM'),
('ULS'),
('UME'),
('UMO'),
('UNA'),
('UNB'),
('UNCC'),
('UNEX'),
('UNITEC'),
('UNL'),
('UNM'),
('UNR'),
('UNSL'),
('UPCB'),
('UPEI'),
('UPNA'),
('UPS'),
('US'),
('USAS'),
('USF'),
('USJ'),
('USM'),
('USNC'),
('USP'),
('USZ'),
('UT'),
('UTC'),
('UTEP'),
('UU'),
('UVIC'),
('UWO'),
('V'),
('VAL'),
('VALD'),
('VDB'),
('VEN'),
('VIT'),
('VMSL'),
('VT'),
('W'),
('WAG'),
('WAT'),
('WELT'),
('WFU'),
('WII'),
('WIN'),
('WIS'),
('WMNH'),
('WOLL'),
('WS'),
('WTU'),
('WU'),
('XAL'),
('YAMA'),
('Z'),
('ZMT'),
('ZSS'),
('ZT')
;

INSERT INTO bien_rarity_acronyms (acronym)
SELECT acronym
FROM acronyms_final
;

DROP TABLE IF EXISTS bien_rarity_acronyms2;
CREATE TABLE bien_rarity_acronyms2 AS
SELECT DISTINCT acronym FROM bien_rarity_acronyms
ORDER BY acronym
;

DROP TABLE IF EXISTS bien_rarity_acronyms;
ALTER TABLE bien_rarity_acronyms2 
RENAME TO bien_rarity_acronyms;