DROP DATABASE IF EXISTS f1olap;
CREATE DATABASE f1olap;
USE f1olap;


DROP TABLE IF EXISTS CircuitsOlap CASCADE;
CREATE TABLE CircuitsOlap(
  -- circuits
  circuitId int,
  circuitRef VARCHAR(255),
  circuitName VARCHAR(255),
  circuitLocation VARCHAR(255),
  circuitCountry VARCHAR(255),
  circuitLat double,
  circuitLng double,
  circuitAlt double,
  circuitUrl VARCHAR(255),
  -- races
  raceId int,
  raceYear int,
  raceRound int,
  raceName VARCHAR(255),
  raceDate DATE,
  raceTime time NULL,
  raceUrl VARCHAR(255),
  -- seasons
  seasonUrl VARCHAR(255)
);

-- HI HA UNA FILA DE RACEID BUIDA, NO PUC POSAR EL PK, PER AIXO FAIG EL UPDATE
UPDATE CircuitsOlap 
SET CircuitsOlap.raceId = 1053
WHERE CircuitsOlap.circuitId = 72;
		

ALTER TABLE CircuitsOlap
  ADD CONSTRAINT circuits_pk
    PRIMARY KEY (raceId);


DROP TABLE IF EXISTS FinalResultsOlap CASCADE;
CREATE TABLE FinalResultsOlap(
  -- qualifying
  qualifyId int,
  raceId int,
  driverId int,
  constructorId int,
  qualifyNumber int,
  qualifyPosition int,
  q1 VARCHAR(255),
  q2 VARCHAR(255),
  q3 VARCHAR(255),
  -- constructorResults
  constructorResultsId int,
  constructorResultsPoints int,
  constructorResultsStatus VARCHAR(255),
  -- driverstandings
  driverStandingsId int,
  driverStandingsPoints int,
  driverStandingsPosition int,
  driverStandingsPositionText VARCHAR(255),
  driverStandingsWins int,
  -- constructortandings
  constructorStandingsId int,
  constructorStandingsPoints int,
  constructorStandingsPosition int,
  constructorStandingsPositionText VARCHAR(255),
  constructorStandingsWins int,
  -- results
  resultId int,
  resultGrid int,
  resultNumber int,
  resultPosition int,
  resultPositionText VARCHAR(255),
  resultPositionOrder int,
  resultPoints float,
  resultLaps int,
  resultTime VARCHAR(255),
  resultMilliseconds int,
  resultFastestLap int,
  resultRank int,
  resultFastestLapTime VARCHAR(255),
  resultFastestLapSpeed float,
  resultStatusId int,
  status VARCHAR(255),
  driverRef VARCHAR(255),
  driverNumber int,
  driverCode VARCHAR(255),
  driverForename VARCHAR(255),
  driverSurname VARCHAR(255),
  driverDob DATE,
  driverNationality VARCHAR(255),
  driverUrl VARCHAR(255),
  -- constructors
  constructorRef VARCHAR(255),
  constructorName VARCHAR(255),
  constructorNationality VARCHAR(255),
  constructorUrl VARCHAR(255)
);


ALTER TABLE FinalResultsOlap MODIFY q1 TIME;
ALTER TABLE FinalResultsOlap MODIFY q2 TIME;
ALTER TABLE FinalResultsOlap MODIFY q3 TIME;

DROP TABLE IF EXISTS PartialResultsOlap CASCADE;
CREATE TABLE PartialResultsOlap(
  -- laptimes
  raceId int,
  driverId int,
  lap int,
  position int,
  lapTime VARCHAR(255),
  lapMilliseconds int,
  -- pitstops
  stop int,
  pitstopTime TIME,
  pitstopDuration double,
  pitstopMilliseconds int
);

ALTER TABLE PartialResultsOlap MODIFY pitstopDuration VARCHAR(255);

  

  


