CREATE DATABASE IF NOT EXISTS F1; 
USE F1;



DROP TABLE IF EXISTS circuits CASCADE;
CREATE TABLE circuits(
  circuitId VARCHAR(255),
  circuitRef VARCHAR(255),
  name VARCHAR(255),
  location VARCHAR(255),
  country VARCHAR(255),
  lat VARCHAR(255),
  lng VARCHAR(255),
  alt VARCHAR(255),
  url VARCHAR(255)
);

DROP TABLE IF EXISTS races CASCADE;
CREATE TABLE races(
  raceId VARCHAR(255),
  year VARCHAR(255),
  round VARCHAR(255),
  circuitId VARCHAR(255),
  name VARCHAR(255),
  date VARCHAR(255),
  time VARCHAR(255),
  url VARCHAR(255)
);

DROP TABLE IF EXISTS seasons CASCADE;
CREATE TABLE seasons(
  year VARCHAR(255),
  url VARCHAR(255)
);

DROP TABLE IF EXISTS results CASCADE;
CREATE TABLE results(
  resultId VARCHAR(255),
  raceId VARCHAR(255),
  driverId VARCHAR(255),
  constructorId VARCHAR(255),
  number VARCHAR(255),
  grid VARCHAR(255),
  position VARCHAR(255),
  positionText VARCHAR(255),
  positionOrder VARCHAR(255),
  points VARCHAR(255),
  laps VARCHAR(255),
  time VARCHAR(255),
  milliseconds VARCHAR(255),
  fastestLap VARCHAR(255),
  rank VARCHAR(255),
  fastestLapTime VARCHAR(255),
  fastestLapSpeed VARCHAR(255),
  statusId VARCHAR(255)
);

DROP TABLE IF EXISTS status CASCADE;
CREATE TABLE status(
  statusId VARCHAR(255),
  status VARCHAR(255)
);

DROP TABLE IF EXISTS constructorStandings CASCADE;
CREATE TABLE constructorStandings(
  constructorStandingsId VARCHAR(255),
  raceId VARCHAR(255),
  constructorId VARCHAR(255),
  points VARCHAR(255),
  position VARCHAR(255),
  positionText VARCHAR(255),
  wins VARCHAR(255)
);

DROP TABLE IF EXISTS driverStandings CASCADE;
CREATE TABLE driverStandings(
  driverStandingsId VARCHAR(255),
  raceId VARCHAR(255),
  driverId VARCHAR(255),
  points VARCHAR(255),
  position VARCHAR(255),
  positionText VARCHAR(255),
  wins VARCHAR(255)
);


DROP TABLE IF EXISTS qualifying CASCADE;
CREATE TABLE qualifying(
  qualifyId VARCHAR(255),
  raceId VARCHAR(255),
  driverId VARCHAR(255),
  constructorId VARCHAR(255),
  number VARCHAR(255),
  position VARCHAR(255),
  q1 VARCHAR(255),
  q2 VARCHAR(255),
  q3 VARCHAR(255)
);

DROP TABLE IF EXISTS drivers CASCADE;
CREATE TABLE drivers(
  driverId VARCHAR(255),
  driverRef VARCHAR(255),
  number VARCHAR(255),
  code VARCHAR(255),
  forename VARCHAR(255),
  surname VARCHAR(255),
  dob VARCHAR(255),
  nationality VARCHAR(255),
  url VARCHAR(255)
);

DROP TABLE IF EXISTS constructors CASCADE;
CREATE TABLE constructors(
  constructorId VARCHAR(255),
  constructorRef VARCHAR(255),
  name VARCHAR(255),
  nationality VARCHAR(255),
  url VARCHAR(255)
);

DROP TABLE IF EXISTS constructorResults CASCADE;
CREATE TABLE constructorResults(
  constructorResultsId VARCHAR(255),
  raceId VARCHAR(255),
  constructorId VARCHAR(255),
  points VARCHAR(255),
  status VARCHAR(255)
);


DROP TABLE IF EXISTS laptimes CASCADE;
CREATE TABLE laptimes(
  raceId VARCHAR(255),
  driverId VARCHAR(255),
  lap VARCHAR(255),
  position VARCHAR(255),
  time VARCHAR(255),
  milliseconds VARCHAR(255)
);

DROP TABLE IF EXISTS pitstops CASCADE;
CREATE TABLE pitstops(
  raceId VARCHAR(255),
  driverId VARCHAR(255),
  stop VARCHAR(255),
  lap VARCHAR(255),
  time VARCHAR(255),
  duration VARCHAR(255),
  milliseconds VARCHAR(255)
);
