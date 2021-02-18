USE [AdventureWorksLT2019]
GO
/****** Object:  View [dbo].[CustomerView]    Script Date: 2/17/2021 6:21:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CustomerView]
AS
SELECT        SalesLT.Customer.Title, SalesLT.Customer.FirstName, SalesLT.Customer.MiddleName, SalesLT.Customer.LastName, SalesLT.Customer.Suffix, SalesLT.Customer.CompanyName, SalesLT.Customer.SalesPerson, 
                         SalesLT.Customer.EmailAddress, SalesLT.Customer.CustomerID, SalesLT.Address.AddressLine1, SalesLT.Address.AddressID, SalesLT.Address.AddressLine2, SalesLT.Address.City, SalesLT.Address.StateProvince, 
                         SalesLT.Address.CountryRegion, SalesLT.Address.PostalCode, SalesLT.Address.ModifiedDate, SalesLT.CustomerAddress.CustomerID AS CustomerIDAddress, SalesLT.CustomerAddress.AddressID AS Customer_AddressID, 
                         SalesLT.CustomerAddress.AddressType, SalesLT.CustomerAddress.ModifiedDate AS CustomerAddressModDate, SalesLT.Customer.ModifiedDate AS CustomerModifyDate, SalesLT.Customer.Phone
FROM            SalesLT.Address INNER JOIN
                         SalesLT.CustomerAddress ON SalesLT.Address.AddressID = SalesLT.CustomerAddress.AddressID INNER JOIN
                         SalesLT.Customer ON SalesLT.CustomerAddress.CustomerID = SalesLT.Customer.CustomerID
GO
/****** Object:  View [dbo].[ProductSummaryView]    Script Date: 2/17/2021 6:21:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ProductSummaryView]
AS
SELECT        SalesLT.ProductModelProductDescription.Culture, SalesLT.ProductModel.Name, SalesLT.Product.ProductNumber, SalesLT.Product.Color, SalesLT.Product.StandardCost, SalesLT.Product.ListPrice, SalesLT.Product.Size, 
                         SalesLT.Product.Weight, SalesLT.Product.SellStartDate, SalesLT.Product.SellEndDate, SalesLT.Product.DiscontinuedDate, SalesLT.Product.ModifiedDate, SalesLT.ProductCategory.Name AS CategoryName, 
                         SalesLT.ProductDescription.Description
FROM            SalesLT.ProductModelProductDescription INNER JOIN
                         SalesLT.ProductModel ON SalesLT.ProductModelProductDescription.ProductModelID = SalesLT.ProductModel.ProductModelID INNER JOIN
                         SalesLT.Product ON SalesLT.ProductModel.ProductModelID = SalesLT.Product.ProductModelID INNER JOIN
                         SalesLT.ProductCategory ON SalesLT.Product.ProductCategoryID = SalesLT.ProductCategory.ProductCategoryID INNER JOIN
                         SalesLT.ProductDescription ON SalesLT.ProductModelProductDescription.ProductDescriptionID = SalesLT.ProductDescription.ProductDescriptionID
GO
/****** Object:  StoredProcedure [dbo].[AddCustomerAddress]    Script Date: 2/17/2021 6:21:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[AddCustomerAddress]
	@CustomerID int,
	@AddID int, 
	@AddressType nvarchar(50)

as

insert into SalesLT.CustomerAddress (CustomerID,AddressID,AddressType,ModifiedDate)
	values (@CustomerID, @AddID, @AddressType, GETDATE())
GO
/****** Object:  StoredProcedure [dbo].[AddNewCustomer]    Script Date: 2/17/2021 6:21:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AddNewCustomer]
	@Title nvarchar(50),
	@FirstName nvarchar(50),
	@middleName nvarchar(50),
	@lastName nvarchar(50),
	@suffix nvarchar(50),
	@companyName nvarchar(50),
	@salesPerson Nvarchar(50),
	@emailAddress nvarchar,
	@phone nvarchar(50),
	@PasswordHash nvarchar(50),
	@passwordSalt Nvarchar(50)
AS
BEGIN
	insert into SalesLT.Customer (NameStyle, Title, FirstName, MiddleName,LastName,Suffix,CompanyName,SalesPerson,EmailAddress, phone, PasswordHash,PasswordSalt)
	values(0, @Title, @FirstName,@middleName,@lastName, @suffix, @companyName, @salesPerson, @emailAddress,@phone, @passwordHash, @PasswordHash )
	
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteCustomer]    Script Date: 2/17/2021 6:21:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteCustomer]
	@ID INT
AS
begin

alter table [SalesLT].[CustomerAddress] with check add constraint[deleteConstraint] foreign key([customerID])
references [SalesLT].[Customer] ([CustomerID])
on delete cascade
	DELETE FROM [SalesLT].[Customer]
	where [SalesLT].[Customer].CustomerID = @ID
	delete from [SalesLT].[CustomerAddress]
	where [SalesLT].[CustomerAddress].CustomerID = @ID
	delete from [SalesLT].[SalesOrderHeader]
	where [SalesLT].[SalesOrderHeader].CustomerID = @ID

Alter Table [SalesLT].[CustomerAddress] drop constraint [deleteConstraint]
end
	
GO
/****** Object:  StoredProcedure [dbo].[GetCustomerSummary]    Script Date: 2/17/2021 6:21:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCustomerSummary]
AS
BEGIN

SELECT        
			SalesLT.Customer.CustomerID, SalesLT.Customer.Title, SalesLT.Customer.FirstName, 
			SalesLT.Customer.MiddleName, SalesLT.Customer.LastName, SalesLT.Customer.Suffix, 
			SalesLT.Customer.CompanyName, SalesLT.Customer.SalesPerson, 
            SalesLT.Customer.EmailAddress, SalesLT.Customer.Phone, 
			SalesLT.Customer.ModifiedDate as [Last Customer Update], 
			SalesLT.Customer.PasswordHash, SalesLT.Customer.PasswordSalt,
			SalesLT.Customer.rowguid as [CustRowguid],
			SalesLT.Address.AddressID,SalesLT.Address.AddressLine1, 
			SalesLT.Address.AddressLine2, SalesLT.Address.City, SalesLT.Address.StateProvince, 
			SalesLT.Address.CountryRegion, SalesLT.Address.PostalCode, SalesLT.Address.ModifiedDate as [Last Address Update],
			SalesLT.CustomerAddress.AddressType, SalesLT.CustomerAddress.ModifiedDate as [Last AddressType Update]
FROM           
			SalesLT.Address INNER JOIN
            SalesLT.CustomerAddress ON SalesLT.Address.AddressID = SalesLT.CustomerAddress.AddressID INNER JOIN
            SalesLT.Customer ON SalesLT.CustomerAddress.CustomerID = SalesLT.Customer.CustomerID
	ORDER BY SalesLT.Customer.CustomerID

END
GO
/****** Object:  StoredProcedure [dbo].[GetProductSummary]    Script Date: 2/17/2021 6:21:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetProductSummary]
AS
BEGIN 
	select 
	[ProductSummaryView].[CategoryName], [ProductSummaryView].[Color], [ProductSummaryView].[CategoryName],
	[ProductSummaryView].[Culture],[ProductSummaryView].[DiscontinuedDate],[ProductSummaryView].[ListPrice],
	[ProductSummaryView].[Description],[ProductSummaryView].[Name],[ProductSummaryView].[ProductNumber],
	[ProductSummaryView].[SellEndDate],[ProductSummaryView].[SellStartDate], [ProductSummaryView].[Size],
	[ProductSummaryView].[StandardCost] , [ProductSummaryView].[Weight]
	
	from [dbo].[ProductSummaryView]

	where [ProductSummaryView].Culture = 'en'
	order by [ProductSummaryView].[Name]
END
GO
/****** Object:  StoredProcedure [dbo].[InsertAddress]    Script Date: 2/17/2021 6:21:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InsertAddress]
 @addressLine1 NVARCHAR(50),
 @addressLine2 NVARCHAR(50),
 @city NVARCHAR(50),
 @stateProvince NVARCHAR(50),
 @countryRegion NVARCHAR(50),
 @postalCode NVARCHAR(50),
 @ModifiedDate NVARCHAR(50)
 as
 insert into SalesLT.Address (AddressLine1, AddressLine2, City, StateProvince, CountryRegion, PostalCode, ModifiedDate)
	values(@addressLine1, @addressLine2, @city, @stateProvince, @countryRegion, @postalCode, GETDATE())

GO
/****** Object:  StoredProcedure [dbo].[PopulateData]    Script Date: 2/17/2021 6:21:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PopulateData]
	@ID int
AS
BEGIN
	SELECT        
			CustomerView.CustomerID, CustomerView.Title, CustomerView.FirstName, 
			CustomerView.MiddleName, CustomerView.LastName, CustomerView.Suffix, 
			CustomerView.CompanyName, CustomerView.SalesPerson, 
            CustomerView.EmailAddress, CustomerView.Phone, 
			CustomerView.ModifiedDate as [Last Customer Update], 
			CustomerView.PasswordHash, CustomerView.PasswordSalt,
			CustomerView.rowguid as [CustRowguid],
			CustomerView.AddressID,CustomerView.AddressLine1, 
			CustomerView.AddressLine2, CustomerView.City, CustomerView.StateProvince, 
			CustomerView.CountryRegion, CustomerView.PostalCode, CustomerView.ModifiedDate as [Last Address Update],
			CustomerView.AddressType, CustomerView.ModifiedDate as [Last AddressType Update]
	from 
	CustomerView
	where CustomerID = @ID
	
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateCustomer]    Script Date: 2/17/2021 6:21:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[UpdateCustomer]
	@ID int,
	@addyType nvarchar(50),
	@Address1 nvarchar(50),
	@Address2 nvarchar(50),
	@City nvarchar(50),
	@State nvarchar(50),
	@Country nvarchar(50),
	@PostalCode nvarchar(50),
	@Title nvarchar(50),
	@FirstName nvarchar(50),
	@Middle nvarchar(50),
	@LastName nvarchar(50),
	@CompanyName nvarchar(50),
	@SalesPerson nvarchar(50),
	@Email nvarchar(50),
	@Phone nvarchar(50),
	@Suffix nvarchar(50)


AS
	declare @AddressID int
BEGIN
	
	update [SalesLT].[CustomerAddress] set [AddressType] = @addyType

	from [SalesLT].[CustomerAddress]
	where [SalesLT].CustomerAddress.CustomerID = @ID  

	update [SalesLT].[Address] set [AddressLine1] = @Address1,
								   [AddressLine2] = @Address2,
								   [City] = @City,
								   [StateProvince] =@State,
								   [CountryRegion] =@Country,
								   [PostalCode]= @PostalCode
	from [SalesLT].[Customer]
	where CustomerID = @ID 
	set @AddressID = (select [AddressID] from SalesLT.CustomerAddress where [CustomerID] = @ID)							   
	update [SalesLT].[Customer] set	
									[Title] = @Title,
									[Suffix] = @Suffix,
									[FirstName] = @FirstName,
									[MiddleName] = @Middle,
									[LastName] = @LastName,
									[CompanyName] = @CompanyName,
									[SalesPerson] = @SalesPerson,
									[EmailAddress] = @Email,
									[Phone] = @Phone
	from [SalesLT].[Address]
	where [SalesLT].Address.AddressID = @AddressID
	
END


GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Address (SalesLT)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 233
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CustomerAddress (SalesLT)"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 218
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Customer (SalesLT)"
            Begin Extent = 
               Top = 6
               Left = 454
               Bottom = 250
               Right = 627
            End
            DisplayFlags = 280
            TopColumn = 3
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 2190
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'CustomerView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'CustomerView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ProductModelProductDescription (SalesLT)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 240
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "ProductModel (SalesLT)"
            Begin Extent = 
               Top = 6
               Left = 278
               Bottom = 136
               Right = 468
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "Product (SalesLT)"
            Begin Extent = 
               Top = 6
               Left = 506
               Bottom = 279
               Right = 734
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ProductCategory (SalesLT)"
            Begin Extent = 
               Top = 6
               Left = 772
               Bottom = 136
               Right = 996
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "ProductDescription (SalesLT)"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 240
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 16
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Widt' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ProductSummaryView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'h = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ProductSummaryView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ProductSummaryView'
GO
