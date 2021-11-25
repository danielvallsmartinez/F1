USE f1olap;

##2
     
SELECT f.driverNationality, AVG(p.pitstopDuration) FROM PartialResultsOlap AS p JOIN FinalResultsOlap AS f ON f.driverId = p.driverId WHERE f.constructorId = (
	SELECT f1.constructorId FROM FinalResultsOlap AS f1 JOIN PartialResultsOlap AS p1 ON f1.driverId = p1.driverId GROUP BY f1.constructorId HAVING AVG(p1.pitstopDuration) < (
		SELECT AVG(p2.pitstopDuration) FROM PartialResultsOlap AS p2 JOIN FinalResultsOlap AS f2 ON f2.driverId = p2.driverId WHERE f1.constructorId <> f2.constructorId GROUP BY f2.constructorId ORDER BY AVG(p2.pitstopDuration) ASC LIMIT 1)) GROUP BY f.driverId;
        
SELECT f.driverNationality, AVG(p.pitstopDuration) FROM PartialResultsOlap AS p JOIN FinalResultsOlap AS f ON f.driverId = p.driverId GROUP BY f.driverId HAVING f.driverId = 7;
SELECT * From PartialResultsOlap WHERE pitstopDuration is not NULL;