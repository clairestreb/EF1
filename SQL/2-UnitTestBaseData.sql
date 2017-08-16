-- Add data to SQL Server tables if it doesn't already exist

-- delete the temporary stored procedure if it already exists
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[procTempInsert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[procTempInsert]
GO

PRINT 'Site'
GO

CREATE PROCEDURE [dbo].[procTempInsert]
    @Name nvarchar(128),
	@AccountNumber nvarchar(128),
	@Comments nvarchar(max)
AS
IF (SELECT COUNT(*) FROM Site WHERE Name = @Name) = 0  
BEGIN
    INSERT INTO [Site] ([Name], [AccountNumber], [Comments]) VALUES (@Name, @AccountNumber, @Comments)
END
GO

EXECUTE [dbo].[procTempInsert] 'Site1', '12345', 'Site 1 Description'
EXECUTE [dbo].[procTempInsert] 'Site2', '',      'Site 2 Description'

drop procedure [dbo].[procTempInsert]
GO


PRINT 'User'
GO

CREATE PROCEDURE [dbo].[procTempInsert]
	@Name nvarchar (128),
	@LastName nvarchar (128),
	@MiddleInitials nvarchar (16),
	@FirstName nvarchar (64),
	@Email nvarchar (255),
	@UserState tinyint
AS
IF (SELECT COUNT(*) FROM [User] WHERE Name = @Name) = 0
BEGIN
    INSERT INTO [User] ([Name], [LastName], [MiddleInitials], [FirstName], [Email], [UserState])
      VALUES (@Name, @LastName, @MiddleInitials, @FirstName, @Email, @UserState)
END
GO

EXECUTE [dbo].[procTempInsert] 'User1',  'User1',  NULL, 'Contractor',   'user1@somewhere.com', 1
EXECUTE [dbo].[procTempInsert] 'Demo1',  'Demo1',  NULL, 'Employee',  '',                    1
EXECUTE [dbo].[procTempInsert] 'Admin1', 'Admin1', NULL, 'SuperUser', NULL,                  1

drop procedure [dbo].[procTempInsert]
GO


PRINT 'Employee'
GO

CREATE PROCEDURE [dbo].[procTempInsert]
	@UserName nvarchar (128),
	@EmpType nvarchar (3)
AS
IF (SELECT COUNT(*) FROM [Employee] e INNER JOIN [User] u ON u.Id = e.UserId WHERE u.Name = @UserName) = 0
BEGIN
	DECLARE @UserId INT
	SET @UserId = (SELECT Id FROM [User] WHERE [Name] = @UserName)
	INSERT INTO [Employee] ([UserId], [EmpType])
		VALUES (@UserId, @EmpType)
END
GO

EXECUTE [dbo].[procTempInsert] 'EmpNonUser',  'CON'
EXECUTE [dbo].[procTempInsert] 'User1',       'CON'
EXECUTE [dbo].[procTempInsert] 'Demo1',       'FTE'
EXECUTE [dbo].[procTempInsert] 'Admin1',      'FTE'

drop procedure [dbo].[procTempInsert]
GO
