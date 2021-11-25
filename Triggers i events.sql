CREATE DATABASE IF NOT EXISTS F1; 
USE F1;


SET GLOBAL event_scheduler = ON;

DELIMITER &&
DROP TRIGGER IF EXISTS f1.trigger_laptimes&&
CREATE TRIGGER trigger_laptimes AFTER INSERT ON laptimes 
FOR EACH ROW 
BEGIN 
	INSERT INTO f1olap.PartialResultsOlap(raceId, driverId, lap, position, lapTime, lapMilliseconds) 
	VALUES (CAST(NEW.raceId AS unsigned), CAST(NEW.driverId AS unsigned), CAST(NEW.lap AS unsigned), CAST(NEW.position AS unsigned), NEW.time, CAST(NEW.milliseconds AS unsigned)); 
END&&
DELIMITER ;

DELIMITER &&&
DROP TRIGGER IF EXISTS f1.trigger_pitstops&&&
CREATE TRIGGER trigger_pitstops AFTER INSERT ON pitstops 
FOR EACH ROW 
BEGIN 
	IF EXISTS (SELECT f1olap.PartialResultsOlap.raceId FROM f1olap.PartialResultsOlap WHERE f1olap.PartialResultsOlap.driverId = CAST(NEW.driverId AS unsigned) AND f1olap.PartialResultsOlap.raceId = CAST(NEW.raceId AS unsigned) AND f1olap.PartialResultsOlap.lap = CAST(NEW.lap AS unsigned)) THEN
		UPDATE f1olap.PartialResultsOlap 
		SET stop = NEW.stop, pitstopTime = CONVERT(NEW.time, TIME), pitstopDuration = NEW.duration, pitstopMilliseconds = CAST(NEW.milliseconds AS unsigned)
		WHERE f1olap.PartialResultsOlap.driverId = CAST(NEW.driverId AS unsigned) AND f1olap.PartialResultsOlap.raceId = CAST(NEW.raceId AS unsigned) AND f1olap.PartialResultsOlap.lap = CAST(NEW.lap AS unsigned);
	else
		INSERT INTO f1olap.PartialResultsOlap(raceId, driverId, stop, lap, pitstopTime, pitstopDuration, pitstopMilliseconds) 
		VALUES (CAST(NEW.raceId AS unsigned), CAST(NEW.driverId AS unsigned), CAST(NEW.stop AS unsigned), CAST(NEW.lap AS unsigned), CONVERT(NEW.time, TIME), NEW.duration, CAST(NEW.milliseconds AS unsigned)); 
	END IF;
END&&&
DELIMITER ;


DELIMITER %%%%%%%%%
DROP TRIGGER IF EXISTS f1.trigger_drivers%%%%%%%%%
CREATE TRIGGER trigger_drivers AFTER INSERT ON drivers 
FOR EACH ROW 
BEGIN 
	IF EXISTS (SELECT f1olap.FinalResultsOlap.driverId FROM f1olap.FinalResultsOlap WHERE f1olap.FinalResultsOlap.driverId = CAST(NEW.driverId AS unsigned)) THEN
		UPDATE f1olap.FinalResultsOlap 
		SET driverRef = NEW.driverRef, driverNumber = CAST(NEW.number AS unsigned), driverCode = NEW.code, driverForename = NEW.forename, driverSurname = NEW.surname, driverDob = CAST(NEW.dob AS DATE), driverNationality = NEW.nationality, driverUrl = NEW.url
		WHERE f1olap.FinalResultsOlap.driverId = CAST(NEW.driverId AS unsigned);
	else
		INSERT INTO f1olap.FinalResultsOlap(driverId, driverRef, driverNumber, driverCode, driverForename, driverSurname, driverDob, driverNationality, driverUrl) 
		VALUES (CAST(NEW.driverId AS unsigned), NEW.driverRef, CAST(NEW.number AS unsigned), NEW.code, NEW.forename, NEW.surname, CAST(NEW.dob AS DATE), NEW.nationality, NEW.url); 
	END IF;
END%%%%%%%%%
DELIMITER ;


DELIMITER %%%%%%%%
DROP TRIGGER IF EXISTS f1.trigger_constructors%%%%%%%%
CREATE TRIGGER trigger_constructors AFTER INSERT ON constructors 
FOR EACH ROW 
BEGIN 
	IF EXISTS (SELECT f1olap.FinalResultsOlap.constructorId FROM f1olap.FinalResultsOlap WHERE f1olap.FinalResultsOlap.constructorId = CAST(NEW.constructorId AS unsigned)) THEN
		UPDATE f1olap.FinalResultsOlap 
		SET constructorRef = NEW.constructorRef, constructorName = NEW.name, constructorNationality = NEW.nationality, constructorUrl = NEW.url
		WHERE f1olap.FinalResultsOlap.constructorId = CAST(NEW.constructorId AS unsigned);
	else
		INSERT INTO f1olap.FinalResultsOlap(constructorId, constructorRef, constructorName, constructorNationality, constructorUrl) 
		VALUES (CAST(NEW.constructorId AS unsigned), NEW.constructorRef, NEW.name, NEW.nationality, NEW.url); 
	END IF;
END%%%%%%%%
DELIMITER ;



DELIMITER %%%%%%%
DROP TRIGGER IF EXISTS f1.trigger_constructorResults%%%%%%%
CREATE TRIGGER trigger_constructorResults AFTER INSERT ON constructorResults 
FOR EACH ROW 
BEGIN 
	IF EXISTS (SELECT f1olap.FinalResultsOlap.raceId FROM f1olap.FinalResultsOlap WHERE f1olap.FinalResultsOlap.raceId = CAST(NEW.raceId AS unsigned) AND f1olap.FinalResultsOlap.constructorId = CAST(NEW.constructorId AS unsigned)) THEN
		UPDATE f1olap.FinalResultsOlap 
		SET constructorResultsId = CAST(NEW.constructorResultsId AS unsigned), constructorResultsPoints = CAST(NEW.points AS DECIMAL(10,5)), constructorResultsStatus = NEW.status
		WHERE f1olap.FinalResultsOlap.raceId = CAST(NEW.raceId AS unsigned) AND f1olap.FinalResultsOlap.constructorId = CAST(NEW.constructorId AS unsigned);
	else
		INSERT INTO f1olap.FinalResultsOlap(constructorResultsId, raceId, constructorId, constructorResultsPoints, constructorResultsStatus) 
		VALUES (CAST(NEW.constructorResultsId AS unsigned), CAST(NEW.raceId AS unsigned), CAST(NEW.constructorId AS unsigned), CAST(NEW.points AS DECIMAL(10,5)), constructorResultsStatus = NEW.status); 
	END IF;
END%%%%%%%
DELIMITER ;

DELIMITER %%%%%%
DROP TRIGGER IF EXISTS f1.trigger_qualifying%%%%%%
CREATE TRIGGER trigger_qualifying AFTER INSERT ON qualifying 
FOR EACH ROW 
BEGIN 
	IF EXISTS (SELECT f1olap.FinalResultsOlap.driverId FROM f1olap.FinalResultsOlap WHERE f1olap.FinalResultsOlap.driverId = CAST(NEW.driverId AS unsigned) AND f1olap.FinalResultsOlap.raceId = CAST(NEW.raceId AS unsigned) AND f1olap.FinalResultsOlap.constructorId = CAST(NEW.constructorId AS unsigned)) THEN
		UPDATE f1olap.FinalResultsOlap 
		SET qualifyId = CAST(NEW.qualifyId AS unsigned), qualifyNumber = CAST(NEW.number AS unsigned), qualifyPosition = CAST(NEW.position AS unsigned), q1 = CONVERT(NEW.q1, TIME), q2 = CONVERT(NEW.q2, TIME), q3 = CONVERT(NEW.q3, TIME)
		WHERE f1olap.FinalResultsOlap.driverId = CAST(NEW.driverId AS unsigned) AND f1olap.FinalResultsOlap.raceId = CAST(NEW.raceId AS unsigned) AND f1olap.FinalResultsOlap.constructorId = CAST(NEW.constructorId AS unsigned);
	else
		INSERT INTO f1olap.FinalResultsOlap(qualifyId, driverId, raceId, constructorId, qualifyNumber, qualifyPosition, q1, q2, q3) 
		VALUES (CAST(NEW.qualifyId AS unsigned), CAST(NEW.driverId AS unsigned), CAST(NEW.raceId AS unsigned), CAST(NEW.constructorId AS unsigned), CAST(NEW.number AS unsigned), CAST(NEW.position AS unsigned), CONVERT(NEW.q1, TIME), CONVERT(NEW.q2, TIME), CONVERT(NEW.q3, TIME)); 
	END IF;
END%%%%%%
DELIMITER ;


DELIMITER %%%%
DROP TRIGGER IF EXISTS f1.trigger_constructorStandings%%%%
CREATE TRIGGER trigger_constructorStandings AFTER INSERT ON constructorStandings 
FOR EACH ROW 
BEGIN 
	IF EXISTS (SELECT f1olap.FinalResultsOlap.constructorId FROM f1olap.FinalResultsOlap WHERE f1olap.FinalResultsOlap.constructorId = CAST(NEW.constructorId AS unsigned) AND f1olap.FinalResultsOlap.raceId = CAST(NEW.raceId AS unsigned)) THEN
		UPDATE f1olap.FinalResultsOlap 
		SET constructorStandingsId = CAST(NEW.constructorStandingsId AS unsigned), constructorStandingsPoints = CAST(NEW.points AS DECIMAL(10,5)), constructorStandingsPosition = CAST(NEW.position AS unsigned), constructorStandingsPositionText = NEW.positionText, constructorStandingsWins = CAST(NEW.wins AS unsigned)
		WHERE f1olap.FinalResultsOlap.constructorId = CAST(NEW.constructorId AS unsigned) AND f1olap.FinalResultsOlap.raceId = CAST(NEW.raceId AS unsigned);
	else
		INSERT INTO f1olap.FinalResultsOlap(constructorStandingsId, constructorId, raceId, constructorStandingsPoints, constructorStandingsPosition, constructorStandingsPositionText, constructorStandingsWins) 
		VALUES (CAST(NEW.constructorStandingsId AS unsigned), CAST(NEW.constructorId AS unsigned), CAST(NEW.raceId AS unsigned), CAST(NEW.points AS DECIMAL(10,5)), CAST(NEW.position AS unsigned), NEW.positionText, CAST(NEW.wins AS unsigned)); 
	END IF;
END%%%%
DELIMITER ;


DELIMITER %%%%%
DROP TRIGGER IF EXISTS f1.trigger_driverStandings%%%%%
CREATE TRIGGER trigger_driverStandings AFTER INSERT ON driverStandings 
FOR EACH ROW 
BEGIN 
	IF EXISTS (SELECT f1olap.FinalResultsOlap.driverId FROM f1olap.FinalResultsOlap WHERE f1olap.FinalResultsOlap.driverId = CAST(NEW.driverId AS unsigned) AND f1olap.FinalResultsOlap.raceId = CAST(NEW.raceId AS unsigned)) THEN
		UPDATE f1olap.FinalResultsOlap 
		SET driverStandingsId = CAST(NEW.driverStandingsId AS unsigned), driverStandingsPoints = CAST(NEW.points AS DECIMAL(10,5)), driverStandingsPosition = CAST(NEW.position AS unsigned), driverStandingsPositionText = NEW.positionText, driverStandingsWins = CAST(NEW.wins AS unsigned)
		WHERE f1olap.FinalResultsOlap.driverId = CAST(NEW.driverId AS unsigned) AND f1olap.FinalResultsOlap.raceId = CAST(NEW.raceId AS unsigned);
	else
		INSERT INTO f1olap.FinalResultsOlap(driverStandingsId, driverId, raceId, driverStandingsPoints, driverStandingsPosition, driverStandingsPositionText, driverStandingsWins) 
		VALUES (CAST(NEW.driverStandingsId AS unsigned), CAST(NEW.driverId AS unsigned), CAST(NEW.raceId AS unsigned), CAST(NEW.points AS DECIMAL(10,5)), CAST(NEW.position AS unsigned), NEW.positionText, CAST(NEW.wins AS unsigned)); 
	END IF;
END%%%%%
DELIMITER ;


DELIMITER %%
DROP TRIGGER IF EXISTS f1.trigger_results%%
CREATE TRIGGER trigger_results AFTER INSERT ON results 
FOR EACH ROW 
BEGIN 
	INSERT INTO f1olap.FinalResultsOlap(resultId, raceId, driverId, constructorId, resultNumber, resultGrid, resultPosition, resultPositionText, resultPositionOrder, resultPoints, resultLaps, resultTime, resultMilliseconds, resultFastestLap, resultRank, resultFastestLapTime, resultFastestLapSpeed, resultStatusId) 
	VALUES (CAST(NEW.resultId AS unsigned), CAST(NEW.raceId AS unsigned), CAST(NEW.driverId AS unsigned), CAST(NEW.constructorId AS unsigned), CAST(NEW.number AS unsigned), CAST(NEW.grid AS unsigned), CAST(NEW.position AS unsigned), NEW.positionText, CAST(NEW.positionOrder AS unsigned), CAST(NEW.points AS DECIMAL(10,5)), CAST(NEW.laps AS unsigned), NEW.time, CAST(NEW.milliseconds AS unsigned), CAST(NEW.fastestLap AS unsigned), CAST(NEW.rank AS unsigned), CONVERT(NEW.fastestLapTime, TIME), CAST(NEW.fastestLapSpeed AS DECIMAL(10,5)), CAST(NEW.statusId AS unsigned)); 
END%%
DELIMITER ;


DELIMITER %%%
DROP TRIGGER IF EXISTS f1.trigger_status%%%
CREATE TRIGGER trigger_status AFTER INSERT ON status 
FOR EACH ROW 
BEGIN 
	IF EXISTS (SELECT f1olap.FinalResultsOlap.resultStatusId FROM f1olap.FinalResultsOlap WHERE f1olap.FinalResultsOlap.resultStatusId = CAST(NEW.statusId AS unsigned)) THEN
		UPDATE f1olap.FinalResultsOlap 
		SET status = NEW.status
		WHERE resultStatusId = CAST(NEW.statusId AS unsigned);
	else
		INSERT INTO f1olap.FinalResultsOlap(resultStatusId, status) 
		VALUES (CAST(NEW.statusId AS unsigned), status); 
	END IF;
END%%%
DELIMITER ;


DROP TABLE IF EXISTS log CASCADE;
CREATE TABLE log(
  comment VARCHAR(255),
  time timestamp NULL
);


DELIMITER $$
DROP PROCEDURE IF EXISTS fesinsert $$
CREATE PROCEDURE fesinsert ()
BEGIN 
	If (SELECT COUNT(DISTINCT co.circuitId) FROM f1Olap.CircuitsOlap AS co) = (SELECT COUNT(circuitId) FROM f1.circuits) THEN 
		INSERT INTO log(time, comment) VALUES(NOW(), 'importacio circuitsolap perfecte');
	ELSE
		INSERT INTO log(time, comment) VALUES(NOW(), 'importacio circuitsolap malament');
	END IF;
    If (SELECT COUNT(DISTINCT p.driverId) FROM f1Olap.finalresultsolap AS p) >= (SELECT COUNT(DISTINCT CAST(d.driverId AS unsigned)) FROM f1.driverStandings AS d) THEN 
		INSERT INTO log(time, comment) VALUES(NOW(), 'importacio finalresultsolap perfecte');
	ELSE
		INSERT INTO log(time, comment) VALUES(NOW(), 'importacio finalresultsolap malament');
	END IF;
    If (SELECT COUNT(p.driverId) FROM f1Olap.partialresultsolap AS p WHERE p.stop IS NOT NULL) = (SELECT COUNT(CAST(d.driverId AS unsigned)) FROM f1.pitstops AS d) THEN 
		INSERT INTO log(time, comment) VALUES(NOW(), 'importacio partialresultsolap perfecte');
	ELSE
		INSERT INTO log(time, comment) VALUES(NOW(), 'importacio partialresultsolap malament');
	END IF;
END$$
DELIMITER ;


DELIMITER $$
DROP EVENT IF EXISTS comprovaCircuits $$
CREATE EVENT IF NOT EXISTS comprovaCircuits
ON SCHEDULE EVERY 5 second
DO BEGIN
		CALL fesinsert();
END$$
DELIMITER ;

DELIMITER $$$$$
DROP PROCEDURE IF EXISTS importa_seasons$$$$$
CREATE PROCEDURE importa_seasons (IN url VARCHAR(255), IN year VARCHAR(255))
BEGIN 
	IF EXISTS (SELECT f1olap.CircuitsOlap.circuitId FROM f1olap.CircuitsOlap WHERE f1olap.CircuitsOlap.raceYear = CAST(year AS unsigned)) THEN
		UPDATE f1olap.CircuitsOlap 
		SET seasonUrl = url
		WHERE raceYear = CAST(year AS unsigned);
	else
		INSERT INTO f1olap.CircuitsOlap(raceYear, raceUrl) 
		VALUES (CAST(year AS unsigned), url); 
	END IF;
END$$$$$
DELIMITER ;
    


DELIMITER $$
DROP TRIGGER IF EXISTS f1.trigger_races$$
CREATE TRIGGER trigger_races AFTER INSERT ON races 
FOR EACH ROW 
BEGIN 
	INSERT INTO f1olap.CircuitsOlap(raceId, circuitId, raceYear, raceRound, raceName, raceDate, raceTime, raceUrl) 
	VALUES (CAST(NEW.raceId AS unsigned), CAST(NEW.circuitId AS unsigned), NEW.year, NEW.round, NEW.name, CAST(NEW.date AS DATE), CONVERT(NEW.time, TIME), NEW.url); 
END$$
DELIMITER ;


DELIMITER $$$
DROP TRIGGER IF EXISTS f1.trigger_circuits$$$
CREATE TRIGGER trigger_circuits AFTER INSERT ON circuits
FOR EACH ROW 
BEGIN 
	IF EXISTS (SELECT f1olap.CircuitsOlap.circuitId FROM f1olap.CircuitsOlap WHERE f1olap.CircuitsOlap.circuitId = CAST(NEW.circuitId AS unsigned)) THEN
		UPDATE f1olap.CircuitsOlap 
		SET circuitRef = NEW.circuitRef, circuitName = NEW.name, circuitLocation = NEW.location, circuitCountry = NEW.country, circuitLat = CAST(NEW.lat AS DECIMAL(10,4)), circuitLng = CAST(NEW.lng AS DECIMAL(10,5)), circuitAlt = CAST(NEW.alt AS DECIMAL(10,5)), circuitUrl = NEW.url
		WHERE circuitId = CAST(NEW.circuitId AS unsigned);
	else
		INSERT INTO f1olap.CircuitsOlap(circuitId, circuitRef, circuitName, circuitLocation, circuitCountry, circuitLat, circuitLng, circuitAlt, circuitUrl, raceTime) 
		VALUES (CAST(NEW.circuitId AS unsigned), NEW.circuitRef, NEW.name, NEW.location, NEW.country, CAST(NEW.lat AS DECIMAL(10,4)), CAST(NEW.lng AS DECIMAL(10,5)), CAST(NEW.alt AS DECIMAL(10,5)), NEW.url, NULL); 
	END IF;
		
END$$$
DELIMITER ;


DELIMITER $$$$
DROP TRIGGER IF EXISTS f1.trigger_seasons$$$$
CREATE TRIGGER trigger_seasons AFTER INSERT ON seasons
FOR EACH ROW 
BEGIN 
	CALL importa_seasons(NEW.url, NEW.year);
    
END$$$$
DELIMITER ;