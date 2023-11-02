-- Config Schema Creation
--create schema config;

drop table [config].[Pipeline_DeltaLoad]
drop table [config].[Pipelines_Config]
drop table [config].[PipelinesEmail_Config]
--- Pipelines_Config
CREATE TABLE config.Pipelines_Config (
 Id int NOT NULL identity Primary Key,
 SpecCode VARCHAR(100),
 SourceName VARCHAR(50) NOT NULL,
 TargetName VARCHAR(50) NOT NULL,
 SourceType VARCHAR(20) NOT NULL,
 TargetType VARCHAR(20) NOT NULL,
 WhereCondition VARCHAR(500),
 Operation VARCHAR(20) NOT NULL,
 FieldList VARCHAR(500),
 Directory VARCHAR(500) default '',
 TargetFileExtention VARCHAR(10) default '',
 IsEmailFunNeeded bit default 0
);




---  Pipeline_DeltaLoad
CREATE TABLE [config].[Pipeline_DeltaLoad] (
 [Id] INT IDENTITY (1, 1) NOT NULL,
 [SpecCodeId] INT NULL,
 [MinWindowStartValue] INT DEFAULT ((0)) NULL,
 [LastProcessedTimestamp] DATETIME2 (7) DEFAULT (getdate()) 
);

-- BO001.sql :Business Outcome 1 - Footboll Config
INSERT INTO config.Pipelines_Config
VALUES ('BO001', '[config].[BO001_Goalscorers]', 'BO001_Goalscorers', 'ASQL', 'SFTP', ' ', 'full', '*', 'sftp', 'csv',0);
INSERT INTO config.Pipelines_Config
VALUES ('BO001', '[config].[BO001_Results]', 'BO001_Results', 'ASQL', 'SFTP', ' ', 'full', 'date,home_team,away_team,home_score,away_score', 'sftp', 'csv',0);
INSERT INTO config.Pipelines_Config
VALUES ('BO001', '[config].[BO001_Shootouts]', 'BO001_Shootouts', 'ASQL', 'SFTP', ' ', 'full', '*', 'sftp', 'csv',0);
INSERT INTO config.Pipelines_Config
VALUES ('BO001', '[config].[BO001_History]', 'BO001_History', 'ASQL', 'ASQL', ' expireddate() ≤ (getdate()-90) ', 'delete', '*', '', '',0);


-- BO002.sql  :Business Outcome 2 - Cricket Config
INSERT INTO config.Pipelines_Config
VALUES ('BO002', 'config.BO002_Deliveries', 'BO002_Deliveries', 'ASQL', 'ABLB', '', 'full', '*','cricket-in' ,'csv',0);
INSERT INTO config.Pipelines_Config
VALUES ('BO002', 'config.BO002_Matches', 'BO002_Matches', 'ASQL', 'ABLB', '', 'full', 'season,team1,team2,date,match_number,venue,city,toss_winner,toss_decision,player_of_match,winner,winner_runs,winner_wickets','cricket-in','csv',0);
INSERT INTO config.Pipelines_Config
VALUES ('BO002', 'config.BO002_Pointstable', 'BO002_Pointstable', 'ASQL', 'ABLB', '', 'full', '*','cricket-in','csv',0);


-- BO003.sql  :Business Outcome 3 - Movie Config
 
INSERT INTO config.Pipelines_Config
VALUES('BO003', 'BO003_Movies', 'config.BO003_Movies', 'ABLB', 'ASQL', '', 'full', '*','movie-in', '',0);

--Delta Load for table2
DECLARE @last_Inserted_Spec_Code_Id INT;
INSERT INTO config.Pipelines_Config
VALUES('BO003', 'BO003_Ratings','stage.BO003_Ratings', 'ABLB', 'ASQL','table_id', 'delta', '*', 'movie-in','',0);
set @last_Inserted_Spec_Code_Id = (SELECT SCOPE_IDENTITY());

Insert into config.Pipeline_DeltaLoad(SpecCodeId) values (@last_Inserted_Spec_Code_Id)
set @last_Inserted_Spec_Code_Id=0

--Email Config

CREATE TABLE config.PipelinesEmail_Config (
 Id int NOT NULL identity Primary Key,
 SpecCode VARCHAR(20),
 ToEmail VARCHAR(100) NOT NULL,
 FrmEmail VARCHAR(50) NOT NULL,
 CcEmail VARCHAR(100) ,
 CustomizedMessage VARCHAR(1000) NOT NULL,
 IsAttachedMent bit default 0,
 Path  VARCHAR(100) NOT NULL
  );


INSERT INTO config.PipelinesEmail_Config
VALUES('BO003', 'meetalpa@gmail.com', 'meetalpa@gmail.com', '', 'BO003 has successfully run', 0, '');



