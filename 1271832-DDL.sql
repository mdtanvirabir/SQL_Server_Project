--All DDL List


--1. 3NF Create DATABASE


USE MASTER
GO
If DB_ID('LibaryDB') is not null
DROP DATABASE LibaryDB
GO
CREATE DATABASE LibaryDB
ON(
	Name='LibaryDB_Data_1',
	FileName='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\LibaryDB_Data_1.mdf',
	Size=25mb,
	MaxSize=100mb,
	FileGrowth=5%
)

Log ON(
	Name='LibaryDB_Log_1',
	FileName='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\LibaryDB_Log_1.ldf',
	Size=2mb,
	MaxSize=50mb,
	FileGrowth=1mb
)

--2. Create Table Writer
USE LibaryDB
GO
CREATE TABLE Writer
(
	WriterID int primary key nonclustered not null,
	WriterFirstName varchar(20) not null,
	WriterLastName varchar(20) not null
)

-- 11.  CLUSTERED INDEX And NONCLUSTERED INDEX

CREATE CLUSTERED INDEX IX_WriterFirstName
ON Writer(WriterFirstName)


--2. Create Table Member

GO
CREATE TABLE Member
(
	MemberId int primary key not null,
	MemberFirstName varchar(15) not null,
	MemberLastName varchar(15) not null
)



--2. Create Table Book

CREATE TABLE Book
(
	BookID int primary key not null,
	BookName varchar(20) not null,
	WriterID int references Writer(WriterID),
	GenreName varchar(15) not null
)

--2. Create Table Issue

CREATE TABLE Issue
(
	IssueNo varchar(10) not null,
	MemberId int references Member(MemberId),
	BookID int references Book(BookID) not null,
	IssueDate smalldatetime not null,
	ReturnDate smalldatetime null
)
GO

--6.  DELETE COLUMN

ALTER TABLE Writter_Genere_Book
DROP COLUMN BookName


--5.  DELETE TABLE

DROP TABLE Writter_Genere_Book



--9.  View  all the information in a meaning full order

USE LibaryDB
GO
CREATE VIEW vw_LibraryDetails
AS
SELECT i.BookID,b.BookName,w.WriterFirstName+ ''+w.WriterLastName AS "Writer",i.IssueNo,b.GenreName,i.IssueDate,i.ReturnDate,m.MemberFirstName+ ' '+m.MemberLastName AS "Issued to"
FROM Issue i
JOIN Member m ON m.MemberId=i.MemberId
JOIN Book b ON b.BookID=i.BookID
JOIN Writer w ON w.WriterID=b.WriterID

--Justify
SELECT * FROM vw_LibraryDetails


--9. View WITH ENCRYPTION

USE LibaryDB
GO
CREATE VIEW vw_LibraryDetailsWith_ENCRYPTION
WITH ENCRYPTION
AS
SELECT i.BookID,b.BookName,w.WriterFirstName+ ''+w.WriterLastName AS "Writer",i.IssueNo,b.GenreName,i.IssueDate,i.ReturnDate,m.MemberFirstName+ ' '+m.MemberLastName AS "Issued to"
FROM Issue i
JOIN Member m ON m.MemberId=i.MemberId
JOIN Book b ON b.BookID=i.BookID
JOIN Writer w ON w.WriterID=b.WriterID

--Justify
SELECT * FROM vw_LibraryDetailsWith_ENCRYPTION


--9. View WITH SCHEMABINDING+VIEW


USE LibaryDB
GO
CREATE VIEW vw_LibraryDetailsWith_SCHEMABINDING
WITH SCHEMABINDING
AS
SELECT i.BookID,b.BookName,w.WriterFirstName+ ''+w.WriterLastName AS "Writer",i.IssueNo,b.GenreName,i.IssueDate,i.ReturnDate,m.MemberFirstName+ ' '+m.MemberLastName AS "Issued to"
FROM Issue i
JOIN Member m ON m.MemberId=i.MemberId
JOIN Book b ON b.BookID=i.BookID
JOIN Writer w ON w.WriterID=b.WriterID

--Justify
SELECT * FROM vw_LibraryDetailsWith_SCHEMABINDING


--10. Procedures Transtion

USE LibaryDB
GO
CREATE Proc InsertUpdateDeleteOutputErrorTransation
@Processtype varchar(25),
@MemberFirstName varchar(20),
@MemberLastName varchar(25),
@ProcessCount int OUTPUT
AS
BEGIN
BEGIN TRY
BEGIN TRAN
--Select
if @Processtype='SELECT'
BEGIN
SELECT * FROM Member
END
--Insert
if @Processtype='Insert'
BEGIN
INSERT INTO Member VALUES (@MemberLastName)
END
--Update
if @Processtype='Update'
BEGIN
UPDATE Member SET MemberLastName=@MemberLastName WHERE MemberLastName=@MemberLastName
END
--Delete
if @Processtype='Delete'
BEGIN
DELETE Member WHERE MemberLastName=@MemberLastName
END
--Output
if @ProcessCount='Count'
BEGIN
SELECT @ProcessCount=COUNT(*) FROM Member
END
COMMIT TRAN
END TRY
BEGIN CATCH
SELECT ERROR_LINE() AS ErrorLine,
ERROR_MESSAGE() AS ErrorMsg,
ERROR_NUMBER() AS ErrorNo,
ERROR_SEVERITY() AS ErSERVRITYe,
ERROR_STATE() AS ErState
ROLLBACK TRAN
END CATCH
END


--14. Trigger

CREATE Trigger Tr_tr_Book_t
ON Book
FOR DELETE
AS
    BEGIN
	       DECLARE @BookID INT ,@BookName varchar(30)
		   SELECT @BookID, @BookName FROM inserted

		   UPDATE Book
		   SET @BookName='Hamlet'
		   WHERE BookID=@BookID
		   END
GO
---TEST--
DELETE FROM Book
WHERE BookID=432
GO




--12. Sclar Funcation

USE LibaryDB
GO
CREATE FUNCTION fnWithBookID
(@BookName varchar(20))
RETURNS int
WITH ENCRYPTION
BEGIN
RETURN(SElECT BookID FROM dbo.Book WHERE BookName=@BookName)
END


--12. Table Funcation

USE LibaryDB
GO
CREATE FUNCTION fnWithMemberIdInfo(@BookID int)
RETURNS TABLE
AS
RETURN
SELECT m.MemberFirstName+''+m.MemberLastName As MemberName,b.BookName, b.GenreName FROM Issue s
JOIN Member m ON m.MemberId=s.MemberId
JOIN Book b ON b.BookID=s.BookID
WHERE b.BookID=@BookID













