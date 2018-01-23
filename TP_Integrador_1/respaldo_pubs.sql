--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.10
-- Dumped by pg_dump version 9.5.10

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: authors; Type: TABLE; Schema: public; Owner: matyas
--

CREATE TABLE authors (
    au_id character varying(11) NOT NULL,
    au_lname character varying(40) NOT NULL,
    au_fname character varying(20) NOT NULL,
    phone character(12) DEFAULT 'UNKNOWN'::bpchar NOT NULL,
    address character varying(40),
    city character varying(20),
    state character(2),
    zip character(5),
    contract smallint
);


ALTER TABLE authors OWNER TO matyas;

--
-- Name: discounts; Type: TABLE; Schema: public; Owner: matyas
--

CREATE TABLE discounts (
    discounttype character varying(40) NOT NULL,
    stor_id character(4),
    lowqty smallint,
    highqty smallint,
    discount numeric(4,2) NOT NULL
);


ALTER TABLE discounts OWNER TO matyas;

--
-- Name: employee; Type: TABLE; Schema: public; Owner: matyas
--

CREATE TABLE employee (
    emp_id character(9) NOT NULL,
    fname character varying(20) NOT NULL,
    minit character(1),
    lname character varying(30) NOT NULL,
    job_id smallint DEFAULT 1 NOT NULL,
    job_lvl smallint DEFAULT 10,
    pub_id character(4) DEFAULT '9952'::bpchar NOT NULL,
    hire_date date DEFAULT ('now'::text)::date NOT NULL
);


ALTER TABLE employee OWNER TO matyas;

--
-- Name: jobs; Type: TABLE; Schema: public; Owner: matyas
--

CREATE TABLE jobs (
    job_id integer NOT NULL,
    job_desc character varying(50) DEFAULT 'New Position - title not formalized yet'::character varying NOT NULL,
    min_lvl smallint NOT NULL,
    max_lvl smallint NOT NULL,
    CONSTRAINT jobs_max_lvl_check CHECK ((max_lvl <= 250)),
    CONSTRAINT jobs_min_lvl_check CHECK ((min_lvl >= 10))
);


ALTER TABLE jobs OWNER TO matyas;

--
-- Name: jobs_job_id_seq; Type: SEQUENCE; Schema: public; Owner: matyas
--

CREATE SEQUENCE jobs_job_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE jobs_job_id_seq OWNER TO matyas;

--
-- Name: jobs_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: matyas
--

ALTER SEQUENCE jobs_job_id_seq OWNED BY jobs.job_id;


--
-- Name: publishers; Type: TABLE; Schema: public; Owner: matyas
--

CREATE TABLE publishers (
    pub_id character(4) NOT NULL,
    pub_name character varying(40),
    city character varying(20),
    state character(2),
    country character varying(30) DEFAULT 'USA'::character varying
);


ALTER TABLE publishers OWNER TO matyas;

--
-- Name: roysched; Type: TABLE; Schema: public; Owner: matyas
--

CREATE TABLE roysched (
    title_id character varying(6) NOT NULL,
    lorange integer,
    hirange integer,
    royalty integer
);


ALTER TABLE roysched OWNER TO matyas;

--
-- Name: sales; Type: TABLE; Schema: public; Owner: matyas
--

CREATE TABLE sales (
    stor_id character(4) NOT NULL,
    ord_num character varying(20) NOT NULL,
    ord_date date NOT NULL,
    qty smallint NOT NULL,
    payterms character varying(12) NOT NULL,
    title_id character varying(6) NOT NULL
);


ALTER TABLE sales OWNER TO matyas;

--
-- Name: stores; Type: TABLE; Schema: public; Owner: matyas
--

CREATE TABLE stores (
    stor_id character(4) NOT NULL,
    stor_name character varying(40),
    stor_address character varying(40),
    city character varying(20),
    state character(2),
    zip character(5)
);


ALTER TABLE stores OWNER TO matyas;

--
-- Name: titleauthor; Type: TABLE; Schema: public; Owner: matyas
--

CREATE TABLE titleauthor (
    au_id character varying(11) NOT NULL,
    title_id character varying(6) NOT NULL,
    au_ord smallint,
    royaltyper integer
);


ALTER TABLE titleauthor OWNER TO matyas;

--
-- Name: titles; Type: TABLE; Schema: public; Owner: matyas
--

CREATE TABLE titles (
    title_id character varying(6) NOT NULL,
    title character varying(80) NOT NULL,
    type character(12) DEFAULT 'UNDECIDED'::bpchar NOT NULL,
    pub_id character(4),
    price numeric(10,2),
    advance numeric(10,2),
    royalty integer,
    ytd_sales integer,
    notes character varying(200),
    pubdate date DEFAULT ('now'::text)::date NOT NULL
);


ALTER TABLE titles OWNER TO matyas;

--
-- Name: job_id; Type: DEFAULT; Schema: public; Owner: matyas
--

ALTER TABLE ONLY jobs ALTER COLUMN job_id SET DEFAULT nextval('jobs_job_id_seq'::regclass);


--
-- Data for Name: authors; Type: TABLE DATA; Schema: public; Owner: matyas
--

COPY authors (au_id, au_lname, au_fname, phone, address, city, state, zip, contract) FROM stdin;
409-56-7008	Bennet	Abraham	415 658-9932	6223 Bateman St.	Berkeley	CA	94705	1
213-46-8915	Green	Marjorie	415 986-7020	309 63rd St. #411	Oakland	CA	94618	1
238-95-7766	Carson	Cheryl	415 548-7723	589 Darwin Ln.	Berkeley	CA	94705	1
998-72-3567	Ringer	Albert	801 826-0752	67 Seventh Av.	Salt Lake City	UT	84152	1
899-46-2035	Ringer	Anne	801 826-0752	67 Seventh Av.	Salt Lake City	UT	84152	1
722-51-5454	DeFrance	Michel	219 547-9982	3 Balding Pl.	Gary	IN	46403	1
807-91-6654	Panteley	Sylvia	301 946-8853	1956 Arlington Pl.	Rockville	MD	20853	1
893-72-1158	McBadden	Heather	707 448-4982	301 Putnam	Vacaville	CA	95688	0
724-08-9931	Stringer	Dirk	415 843-2991	5420 Telegraph Av.	Oakland	CA	94609	0
274-80-9391	Straight	Dean	415 834-2919	5420 College Av.	Oakland	CA	94609	1
756-30-7391	Karsen	Livia	415 534-9219	5720 McAuley St.	Oakland	CA	94609	1
724-80-9391	MacFeather	Stearns	415 354-7128	44 Upland Hts.	Oakland	CA	94612	1
427-17-2319	Dull	Ann	415 836-7128	3410 Blonde St.	Palo Alto	CA	94301	1
672-71-3249	Yokomoto	Akiko	415 935-4228	3 Silver Ct.	Walnut Creek	CA	94595	1
267-41-2394	O'Leary	Michael	408 286-2428	22 Cleveland Av. #14	San Jose	CA	95128	1
472-27-2349	Gringlesby	Burt	707 938-6445	PO Box 792	Covelo	CA	95428	3
527-72-3246	Greene	Morningstar	615 297-2723	22 Graybar House Rd.	Nashville	TN	37215	0
172-32-1176	White	Johnson	408 496-7223	10932 Bigge Rd.	Menlo Park	CA	94025	1
712-45-1867	del Castillo	Innes	615 996-8275	2286 Cram Pl. #86	Ann Arbor	MI	48105	1
846-92-7186	Hunter	Sheryl	415 836-7128	3410 Blonde St.	Palo Alto	CA	94301	1
486-29-1786	Locksley	Charlene	415 585-4620	18 Broadway Av.	San Francisco	CA	94130	1
648-92-1872	Blotchet-Halls	Reginald	503 745-6402	55 Hillsdale Bl.	Corvallis	OR	97330	1
341-22-1782	Smith	Meander	913 843-0462	10 Mississippi Dr.	Lawrence	KS	66044	0
\.


--
-- Data for Name: discounts; Type: TABLE DATA; Schema: public; Owner: matyas
--

COPY discounts (discounttype, stor_id, lowqty, highqty, discount) FROM stdin;
Initial Customer	\N	\N	\N	10.50
Volume Discount	\N	100	1000	6.70
Customer Discount	8042	\N	\N	5.00
\.


--
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: matyas
--

COPY employee (emp_id, fname, minit, lname, job_id, job_lvl, pub_id, hire_date) FROM stdin;
PTC11962M	Philip	T	Cramer	2	215	9952	1989-11-11
AMD15433F	Ann	M	Devon	3	200	9952	1991-07-16
F-C16315M	Francisco	 	Chang	4	227	9952	1990-11-03
LAL21447M	Laurence	A	Lebihan	5	175	0736	1990-06-03
PXH22250M	Paul	X	Henriot	5	159	0877	1993-08-19
SKO22412M	Sven	K	Ottlieb	5	150	1389	1991-04-05
RBM23061F	Rita	B	Muller	5	198	1622	1993-10-09
MJP25939M	Maria	J	Pontes	5	246	1756	1989-03-01
JYL26161F	Janine	Y	Labrune	5	172	9901	1991-05-26
CFH28514M	Carlos	F	Hernadez	5	211	9999	1989-04-21
VPA30890F	Victoria	P	Ashworth	6	140	0877	1990-09-13
L-B31947F	Lesley	 	Brown	7	120	0877	1991-02-13
ARD36773F	Anabela	R	Domingues	8	100	0877	1993-01-27
M-R38834F	Martine	 	Rance	9	75	0877	1992-02-05
PHF38899M	Peter	H	Franken	10	75	0877	1992-05-17
DBT39435M	Daniel	B	Tonini	11	75	0877	1990-01-01
H-B39728F	Helen	 	Bennett	12	35	0877	1989-09-21
PMA42628M	Paolo	M	Accorti	13	35	0877	1992-08-27
ENL44273F	Elizabeth	N	Lincoln	14	35	0877	1990-07-24
MGK44605M	Matti	G	Karttunen	6	220	0736	1994-05-01
PDI47470M	Palle	D	Ibsen	7	195	0736	1993-05-09
MMS49649F	Mary	M	Saveley	8	175	0736	1993-06-29
GHT50241M	Gary	H	Thomas	9	170	0736	1988-08-09
MFS52347M	Martin	F	Sommer	10	165	0736	1990-04-13
R-M53550M	Roland	 	Mendel	11	150	0736	1991-09-05
HAS54740M	Howard	A	Snyder	12	100	0736	1988-11-19
TPO55093M	Timothy	P	O'Rourke	13	100	0736	1988-06-19
KFJ64308F	Karin	F	Josephs	14	100	0736	1992-10-17
DWR65030M	Diego	W	Roel	6	192	1389	1991-12-16
M-L67958F	Maria	 	Larsson	7	135	1389	1992-03-27
PSP68661F	Paula	S	Parente	8	125	1389	1994-01-19
MAS70474F	Margaret	A	Smith	9	78	1389	1988-09-29
A-C71970F	Aria	 	Cruz	10	87	1389	1991-10-26
MAP77183M	Miguel	A	Paolino	11	112	1389	1992-12-07
Y-L77953M	Yoshi	 	Latimer	12	32	1389	1989-06-11
CGS88322F	Carine	G	Schmitt	13	64	1389	1992-07-07
PSA89086M	Pedro	S	Afonso	14	89	1389	1990-12-24
A-R89858F	Annette	 	Roulet	6	152	9999	1990-02-21
HAN90777M	Helvetius	A	Nagy	7	120	9999	1993-03-19
M-P91209M	Manuel	 	Pereira	8	101	9999	1989-01-09
KJJ92907F	Karla	J	Jablonski	9	170	9999	1994-03-11
POK93028M	Pirkko	O	Koskitalo	10	80	9999	1993-11-29
PCM98509F	Patricia	C	McKenna	11	150	9999	1989-08-01
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: matyas
--

COPY jobs (job_id, job_desc, min_lvl, max_lvl) FROM stdin;
1	New Hire - Job not specified	10	10
2	Chief Executive Officer	200	250
3	Business Operations Manager	175	225
4	Chief Financial Officier	175	250
5	Publisher	150	250
6	Managing Editor	140	225
7	Marketing Manager	120	200
8	Public Relations Manager	100	175
9	Acquisitions Manager	75	175
10	Productions Manager	75	165
11	Operations Manager	75	150
12	Editor	25	100
13	sales Representative	25	100
14	Designer	25	100
\.


--
-- Name: jobs_job_id_seq; Type: SEQUENCE SET; Schema: public; Owner: matyas
--

SELECT setval('jobs_job_id_seq', 14, true);


--
-- Data for Name: publishers; Type: TABLE DATA; Schema: public; Owner: matyas
--

COPY publishers (pub_id, pub_name, city, state, country) FROM stdin;
0736	New Moon Books	Boston	MA	USA
0877	Binnet & Hardley	Washington	DC	USA
1389	Algodata Infosystems	Berkeley	CA	USA
1622	Five Lakes Publishing	Chicago	IL	USA
1756	Ramona publishers	Dallas	TX	USA
9952	Scootney Books	New York	NY	USA
9901	GGG&G	Munchen	\N	Germany
9999	Lucerne Publishing	Paris	\N	France
\.


--
-- Data for Name: roysched; Type: TABLE DATA; Schema: public; Owner: matyas
--

COPY roysched (title_id, lorange, hirange, royalty) FROM stdin;
BU1032	0	5000	10
BU1032	5001	50000	12
PC1035	0	2000	10
PC1035	2001	3000	12
PC1035	3001	4000	14
PC1035	4001	10000	16
PC1035	10001	50000	18
BU2075	0	1000	10
BU2075	1001	3000	12
BU2075	3001	5000	14
BU2075	5001	7000	16
BU2075	7001	10000	18
BU2075	10001	12000	20
BU2075	12001	14000	22
BU2075	14001	50000	24
PS2091	0	1000	10
PS2091	1001	5000	12
PS2091	5001	10000	14
PS2091	10001	50000	16
PS2106	0	2000	10
PS2106	2001	5000	12
PS2106	5001	10000	14
PS2106	10001	50000	16
MC3021	0	1000	10
MC3021	1001	2000	12
MC3021	2001	4000	14
MC3021	4001	6000	16
MC3021	6001	8000	18
MC3021	8001	10000	20
MC3021	10001	12000	22
MC3021	12001	50000	24
TC3218	0	2000	10
TC3218	2001	4000	12
TC3218	4001	6000	14
TC3218	6001	8000	16
TC3218	8001	10000	18
TC3218	10001	12000	20
TC3218	12001	14000	22
TC3218	14001	50000	24
PC8888	0	5000	10
PC8888	5001	10000	12
PC8888	10001	15000	14
PC8888	15001	50000	16
PS7777	0	5000	10
PS7777	5001	50000	12
PS3333	0	5000	10
PS3333	5001	10000	12
PS3333	10001	15000	14
PS3333	15001	50000	16
BU1111	0	4000	10
BU1111	4001	8000	12
BU1111	8001	10000	14
BU1111	12001	16000	16
BU1111	16001	20000	18
BU1111	20001	24000	20
BU1111	24001	28000	22
BU1111	28001	50000	24
MC2222	0	2000	10
MC2222	2001	4000	12
MC2222	4001	8000	14
MC2222	8001	12000	16
MC2222	12001	20000	18
MC2222	20001	50000	20
TC7777	0	5000	10
TC7777	5001	15000	12
TC7777	15001	50000	14
TC4203	0	2000	10
TC4203	2001	8000	12
TC4203	8001	16000	14
TC4203	16001	24000	16
TC4203	24001	32000	18
TC4203	32001	40000	20
TC4203	40001	50000	22
BU7832	0	5000	10
BU7832	5001	10000	12
BU7832	10001	15000	14
BU7832	15001	20000	16
BU7832	20001	25000	18
BU7832	25001	30000	20
BU7832	30001	35000	22
BU7832	35001	50000	24
PS1372	0	10000	10
PS1372	10001	20000	12
PS1372	20001	30000	14
PS1372	30001	40000	16
PS1372	40001	50000	18
\.


--
-- Data for Name: sales; Type: TABLE DATA; Schema: public; Owner: matyas
--

COPY sales (stor_id, ord_num, ord_date, qty, payterms, title_id) FROM stdin;
7067	D4482	1994-09-14	10	Net 60	PS2091
7131	N914008	1994-09-14	20	Net 30	PS2091
7131	N914014	1994-09-14	25	Net 30	MC3021
8042	423LL19922	1994-09-14	15	ON invoice	MC3021
8042	423LL19930	1994-09-14	10	ON invoice	BU1032
6380	722a	1994-09-13	3	Net 60	PS2091
6380	6871	1994-09-14	5	Net 60	BU1032
8042	P723	1993-03-11	25	Net 30	BU1111
7896	X999	1993-02-21	35	ON invoice	BU2075
7896	QQ2299	1993-10-28	15	Net 60	BU7832
7896	TQ456	1993-12-12	10	Net 60	MC2222
8042	QA879.1	1993-05-22	30	Net 30	PC1035
7066	A2976	1993-05-24	50	Net 30	PC8888
7131	P3087a	1993-05-29	20	Net 60	PS1372
7131	P3087a	1993-05-29	25	Net 60	PS2106
7131	P3087a	1993-05-29	15	Net 60	PS3333
7131	P3087a	1993-05-29	25	Net 60	PS7777
7067	P2121	1992-06-15	40	Net 30	TC3218
7067	P2121	1992-06-15	20	Net 30	TC4203
7067	P2121	1992-06-15	20	Net 30	TC7777
\.


--
-- Data for Name: stores; Type: TABLE DATA; Schema: public; Owner: matyas
--

COPY stores (stor_id, stor_name, stor_address, city, state, zip) FROM stdin;
7066	Barnum's	567 Pasadena Ave.	Tustin	CA	92789
7067	News & Brews	577 First St.	Los Gatos	CA	96745
7131	Doc-U-Mat: Quality Laundry and Books	24-A Avogadro Way	Remulade	WA	98014
8042	Bookbeat	679 Carson St.	Portland	OR	89076
6380	Eric the Read Books	788 Catamaugus Ave.	Seattle	WA	98056
7896	Fricative Bookshop	89 Madison St.	Fremont	CA	90019
\.


--
-- Data for Name: titleauthor; Type: TABLE DATA; Schema: public; Owner: matyas
--

COPY titleauthor (au_id, title_id, au_ord, royaltyper) FROM stdin;
409-56-7008	BU1032	1	60
486-29-1786	PS7777	1	100
486-29-1786	PC9999	1	100
712-45-1867	MC2222	1	100
172-32-1176	PS3333	1	100
213-46-8915	BU1032	2	40
238-95-7766	PC1035	1	100
213-46-8915	BU2075	1	100
998-72-3567	PS2091	1	50
899-46-2035	PS2091	2	50
998-72-3567	PS2106	1	100
722-51-5454	MC3021	1	75
899-46-2035	MC3021	2	25
807-91-6654	TC3218	1	100
274-80-9391	BU7832	1	100
427-17-2319	PC8888	1	50
846-92-7186	PC8888	2	50
756-30-7391	PS1372	1	75
724-80-9391	PS1372	2	25
724-80-9391	BU1111	1	60
267-41-2394	BU1111	2	40
672-71-3249	TC7777	1	40
267-41-2394	TC7777	2	30
472-27-2349	TC7777	3	30
648-92-1872	TC4203	1	100
\.


--
-- Data for Name: titles; Type: TABLE DATA; Schema: public; Owner: matyas
--

COPY titles (title_id, title, type, pub_id, price, advance, royalty, ytd_sales, notes, pubdate) FROM stdin;
PC1035	But Is It User Friendly?	popular_comp	1389	22.95	7000.00	16	8780	A survey of software for the naive user, focusing on the 'friendliness' of each.	1991-06-30
PC8888	Secrets of Silicon Valley	popular_comp	1389	20.00	8000.00	10	4095	Muckraking reporting on the world's largest computer hardware and software manufacturers.	1994-06-12
BU1032	The Busy Executive's Database Guide	business    	1389	19.99	5000.00	10	4095	An overview of available database systems with emphasis on common business applications. Illustrated.	1991-06-12
PS7777	Emotional Security: A New Algorithm	psychology  	0736	7.99	4000.00	10	3336	Protecting yourself and your loved ones from undue emotional stress in the modern world. Use of computer and nutritional aids emphasized.	1991-06-12
PS3333	Prolonged Data Deprivation: Four Case Studies	psychology  	0736	19.99	2000.00	10	4072	What happens when the data runs dry?  Searching evaluations of information-shortage effects.	1991-06-12
BU1111	Cooking with Computers: Surreptitious Balance Sheets	business    	1389	11.95	5000.00	10	3876	Helpful hints on how to use your electronic resources to the best advantage.	1991-06-09
MC2222	Silicon Valley Gastronomic Treats	mod_cook    	0877	19.99	0.00	12	2032	Favorite recipes for quick, easy, and elegant meals.	1991-06-09
TC7777	Sushi, Anyone?	trad_cook   	0877	14.99	8000.00	10	4095	Detailed instructions on how to make authentic Japanese sushi in your spare time.	1991-06-12
TC4203	Fifty Years in Buckingham Palace Kitchens	trad_cook   	0877	11.95	4000.00	14	15096	More anecdotes from the Queen's favorite cook describing life among English royalty. Recipes, techniques, tender vignettes.	1991-06-12
BU2075	You Can Combat Computer Stress!	business    	0736	2.99	10125.00	24	18722	The latest medical and psychological techniques for living with the electronic office. Easy-to-understand explanations.	1991-06-30
PS2091	Is Anger the Enemy?	psychology  	0736	10.95	2275.00	12	2045	Carefully researched study of the effects of strong emotions on the body. Metabolic charts included.	1991-06-15
PS2106	Life Without Fear	psychology  	0736	7.00	6000.00	10	111	New exercise, meditation, and nutritional techniques that can reduce the shock of daily interactions. Popular audience. Sample menus included, exercise video available separately.	1991-10-05
MC3021	The Gourmet Microwave	mod_cook    	0877	2.99	15000.00	24	22246	Traditional French gourmet recipes adapted for modern microwave cooking.	1991-06-18
TC3218	Onions, Leeks, and Garlic: Cooking Secrets of the Mediterranean	trad_cook   	0877	20.95	7000.00	10	375	Profusely illustrated in color, this makes a wonderful gift book for a cuisine-oriented friend.	1991-10-21
MC3026	The Psychology of Computer Cooking	UNDECIDED   	0877	\N	\N	\N	\N	\N	2018-01-22
BU7832	Straight Talk About Computers	business    	1389	19.99	5000.00	10	4095	Annotated analysis of what computers can do for you: a no-hype guide for the critical user.	1991-06-22
PS1372	Computer Phobic AND Non-Phobic Individuals: Behavior Variations	psychology  	0877	21.59	7000.00	10	375	A must for the specialist, this book examines the difference between those who hate and fear computers and those who don't.	1991-10-21
PC9999	Net Etiquette	popular_comp	1389	\N	\N	\N	\N	A must-read for computer conferencing.	2018-01-22
\.


--
-- Name: pk_emp_id; Type: CONSTRAINT; Schema: public; Owner: matyas
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT pk_emp_id PRIMARY KEY (emp_id);


--
-- Name: upk_jobsid; Type: CONSTRAINT; Schema: public; Owner: matyas
--

ALTER TABLE ONLY jobs
    ADD CONSTRAINT upk_jobsid PRIMARY KEY (job_id);


--
-- Name: upk_storeid; Type: CONSTRAINT; Schema: public; Owner: matyas
--

ALTER TABLE ONLY stores
    ADD CONSTRAINT upk_storeid PRIMARY KEY (stor_id);


--
-- Name: upkcl_auidind; Type: CONSTRAINT; Schema: public; Owner: matyas
--

ALTER TABLE ONLY authors
    ADD CONSTRAINT upkcl_auidind PRIMARY KEY (au_id);


--
-- Name: upkcl_pubind; Type: CONSTRAINT; Schema: public; Owner: matyas
--

ALTER TABLE ONLY publishers
    ADD CONSTRAINT upkcl_pubind PRIMARY KEY (pub_id);


--
-- Name: upkcl_sales; Type: CONSTRAINT; Schema: public; Owner: matyas
--

ALTER TABLE ONLY sales
    ADD CONSTRAINT upkcl_sales PRIMARY KEY (stor_id, ord_num, title_id);


--
-- Name: upkcl_taind; Type: CONSTRAINT; Schema: public; Owner: matyas
--

ALTER TABLE ONLY titleauthor
    ADD CONSTRAINT upkcl_taind PRIMARY KEY (au_id, title_id);


--
-- Name: upkcl_titleidind; Type: CONSTRAINT; Schema: public; Owner: matyas
--

ALTER TABLE ONLY titles
    ADD CONSTRAINT upkcl_titleidind PRIMARY KEY (title_id);


--
-- Name: authors_fk; Type: FK CONSTRAINT; Schema: public; Owner: matyas
--

ALTER TABLE ONLY titleauthor
    ADD CONSTRAINT authors_fk FOREIGN KEY (au_id) REFERENCES authors(au_id);


--
-- Name: jobs2_fk; Type: FK CONSTRAINT; Schema: public; Owner: matyas
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT jobs2_fk FOREIGN KEY (job_id) REFERENCES jobs(job_id);


--
-- Name: pub_id2_fk; Type: FK CONSTRAINT; Schema: public; Owner: matyas
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT pub_id2_fk FOREIGN KEY (pub_id) REFERENCES publishers(pub_id);


--
-- Name: publisher_fk; Type: FK CONSTRAINT; Schema: public; Owner: matyas
--

ALTER TABLE ONLY titles
    ADD CONSTRAINT publisher_fk FOREIGN KEY (pub_id) REFERENCES publishers(pub_id);


--
-- Name: store2_fk; Type: FK CONSTRAINT; Schema: public; Owner: matyas
--

ALTER TABLE ONLY discounts
    ADD CONSTRAINT store2_fk FOREIGN KEY (stor_id) REFERENCES stores(stor_id);


--
-- Name: store_fk; Type: FK CONSTRAINT; Schema: public; Owner: matyas
--

ALTER TABLE ONLY sales
    ADD CONSTRAINT store_fk FOREIGN KEY (stor_id) REFERENCES stores(stor_id);


--
-- Name: title2_fk; Type: FK CONSTRAINT; Schema: public; Owner: matyas
--

ALTER TABLE ONLY roysched
    ADD CONSTRAINT title2_fk FOREIGN KEY (title_id) REFERENCES titles(title_id);


--
-- Name: title_fk; Type: FK CONSTRAINT; Schema: public; Owner: matyas
--

ALTER TABLE ONLY sales
    ADD CONSTRAINT title_fk FOREIGN KEY (title_id) REFERENCES titles(title_id);


--
-- Name: titles_fk; Type: FK CONSTRAINT; Schema: public; Owner: matyas
--

ALTER TABLE ONLY titleauthor
    ADD CONSTRAINT titles_fk FOREIGN KEY (title_id) REFERENCES titles(title_id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

