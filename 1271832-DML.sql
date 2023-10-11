--All DML List

-- 1. INSERT INTO 3NF Database INSERT INTO 3NF Database Writer Table Value

INSERT INTO Writer VALUES
(1, 'George', 'Orwell'),
(2, 'Ted', 'Simon'),
(3, 'William', 'Shakespeare'),
(4, 'Jane', 'Austen'),
(5, 'Wilfred', 'Thesiger'),
(6, 'Samuel', 'Beckett')


--15/16. Transaction/ ERROR Handling INSERT INTO 3NF Database Member  Value


Begin try
Begin tran
INSERT INTO Member VALUES
(101, 'Alex','Wilson'),
(102, 'Emily','Brown'),
(103, 'Tanvir','Abir')
Commit tran
END TRY
BEGIN CATCH
rollback tran
SELECT ERROR_MESSAGE() AS meg, ERROR_NUMBER() as errorNumber,
ERROR_SEVERITY() AS severity, ERROR_STATE() AS State
END CATCH

--1. INSERT INTO 3NF Database Book  Value


INSERT INTO Book VALUES
(121, 'AnimalFirm', 1, 'Fiction'),
(233, 'JupiterTravels', 2, 'Travel'),
(432, 'Hamlet', 3, 'Drama'),
(123, 'Pride&Prejudice', 4, 'Fiction'),
(424, 'ArabianSands', 5, 'Travel'),
(400, 'WaitingforGodot', 6, 'Drama')

--1. INSERT INTO 3NF Database Issue  Value

INSERT INTO Issue values
('OR001',101,121,'1-1-2021','2-4-2021'),
('OR002',101,233,'1-20-2021','2-2-2021'),
('OR003',101,432,'1-10-2021','2-2-2021'),
('OR004',102,123,'1-15-2021','1-31-2021'),
('OR005',102,424,'1-10-2021','1-27-2021'),
('OR006',101,121,'1-1-2021','2-2-2015')


 --3.  DELETE QUERY

DELETE FROM Member WHERE MemberId=103
GO
	SELECT * FROM Member

--4.  UPDATE QUERY

UPDATE Member
 SET MemberFirstName='Tanvir'
 WHERE MemberId=103
 GO
	 SELECT * FROM Member


--7. Join Query Using Group By and Having

SELECT i.BookID,b.BookName,w.WriterFirstName+ ''+w.WriterLastName AS "Writer"
FROM Issue i
JOIN Member m ON m.MemberId=i.MemberId
JOIN Book b ON b.BookID=i.BookID
JOIN Writer w ON w.WriterID=b.WriterID
group by i.BookID,b.BookName,w.WriterFirstName,w.WriterLastName
having i.BookID=121



--8. Sub-Query all the information of Issued To Alex Wilson

SELECT b.BookID AS "Book ID", b.BookName AS "Book Name", w.WriterFirstName AS "Writer First Name", w.WriterLastName AS "Writer Last Name", i.IssueNo AS "Issue No", b.GenreName AS "Genre Name", i.IssueDate AS "Issue Date", i.ReturnDate AS "Return Date", m.MemberFirstName AS "Member First Name", m.MemberLastName AS "Member Last Name",  m.MemberFirstName FROM Issue i
JOIN Book b ON b.BookID=i.BookID
JOIN Member m ON m.MemberId=i.MemberId
JOIN Writer w ON w.WriterID=b.WriterID
WHERE m.MemberId in
(SELECT MemberId FROM Member WHERE MemberFirstName='Alex' and MemberLastName='Wilson')


--10. Calling - InsertUpdateDeleteOutputErrorTransation
USE LibaryDB
GO
InsertUpdateDeleteOutputErrorTransation '','','',''
InsertUpdateDeleteOutputErrorTransation 'Insert','GG','AA',''
InsertUpdateDeleteOutputErrorTransation 'Update','GG','BB',''
InsertUpdateDeleteOutputErrorTransation 'Delete','GG','',''

DECLARE @ProcessCount int
EXEC InsertUpdateDeleteOutputErrorTransation 'Count','','',@ProcessCount OUTPUT
PRINT @ProcessCount


--11. Clustered And NonClustered Index

--Justify

EXEC sp_helpindex Writer


--12. sclar funcation and Table funcation

SELECT * FROM  dbo.fnWithMemberIdInfo(432)

SELECT  dbo.fnWithBookID('Hamlet') AS BookID


--17.  CTE

USE LibaryDB
GO
With Cte_Author_Gerere_WiseBook
AS
(SELECT BookName,w.WriterFirstName+' ' +w.WriterLastName as Writer,b.GenreName FROM Book b
JOIN Writer w on w.WriterID=w.WriterID)

SELECT * FROM Cte_Author_Gerere_WiseBook

--18.  Case

USE LibaryDB
GO
SELECT IssueNo, Convert(varchar,IssueDate,101),convert(varchar,ReturnDate,101),
CASE
	WHEN DATEDIFF(day,IssueDate,ReturnDate)>16 
	Then 'Ok'
	When DATEDIFF(day,IssueDate,ReturnDate)<=16
	Then ' Not Ok'
	End as status  
FROm Issue

--19. Cursor


USE LibaryDB
GO
DECLARE @MemberId int
DECLARE @MemberFirstName varchar(15)
DECLARE @MemberLastName varchar(15)
DEclare @MemberCount int
set @MemberCount=0
DECLARE Member_count CURSOR
FOR SELECT * FROm Member
OPEN Member_count
FETCH NEXT FROM Member_count into @MemberId,@MemberFirstName,@MemberLastName;
While @@FETCH_STATUS<>-1
BEGIN
update Member set MemberLastName=@MemberLastName+ 'ted'
SET @MemberCount=@MemberCount+1
FETCH NEXT FROM Member_count into @MemberId,@MemberFirstName,@MemberLastName;
END
Close Member_count
DEALLOCATE Member_count
PRINT CONVERT(VARCHAR,@MemberCount)+' Rows In total'

--21. Merge

USE LibaryDB
GO
CREATE TABLE Writter_Genere_Book
(
	BookName Varchar(20) not null,
	WriterName Varchar(20) not null,
	GenereName varchar(20) not null
)
Merge INTO Writter_Genere_book wr
USING
(SELECT b.BookName AS Book,w.WriterFirstName+' '+w.WriterLastName AS Writer,b.GenreName AS Genere FROM Book b
JOIN Writer w on w.WriterID=b.WriterID) AS bk
ON bk.book=wr.bookName
WHEN Matched THEN 
UPDATE SET wr.bookname=bk.book,wr.WriterName=bk.Writer,wr.generename=bk.genere
WHEN NOT Matched THEN
INSERT (BookName,WriterName,Generename) VALUES (bk.book,bk.Writer,bk.genere);

DROP TABLE Writter_Genere_book

--20. Convert, Cast, IIF, CHOOSE, ISNULL, COALESCE, Ranking Function Other Function

SELECT CAST (GETDATE() AS DATE) AS DATE

SELECT CONVERT(TIME,GETDATE() )'TIME'

SELECT IssueNo,
isnull(IssueNo,'0.00') as NewIssueNo_issNull,
Coalesce(IssueNo,'0.00') as NewIssueNo_Coalesce
FROM Issue

--Ranking function

SELECT BookID,
		COUNT(IssueNo) OVER (ORDER BY IssueNo)'IssueNocount',
		Rank() OVER (ORDER BY IssueNo)'Rank',
		DENSE_RANK() OVER (ORDER BY IssueNo)'Dens rank',
		NTILE(1)OVER (ORDER BY IssueNo)'Ntile(1)'
from Issue

--With Ties

 SELECT TOP 3 WITH ties BookName, BookID FROM Book
 ORDER BY BookID

--FETCH

SELECT * FROM Book
ORDER BY BookID
OFFSET 3 Rows

--Date Function

select getdate() AS CurrentDate
select datediff(dd,'1995-06-11',getdate()) AS 'Day'
select datediff(mm,'1995-06-11',getdate()) AS 'Month'
select datediff(yy,'1995-06-11',getdate()) AS 'Year'
select MONTH(getdate()) CurrentMonth

---ROLLUP operator
select BookID ,count(MemberId) as 'Member ID'
from Issue
group by BookID
with rollup
go
