/*

Data Cleaning on SQL (Nashville_housing_data)

*/
-------------------------------------------------------------------------------------------------------------------------------------------------------
Select *
From Nashville_Housing_Data

-------------------------------------------------------------------------------------------------------------------------------------------------------
-- Standardizing Date Format

Select Saledate, Convert (Date,Saledate)
From Nashville_Housing_Data

Update Nashville_Housing_Data
Set Saledate =  Convert (Date,Saledate)

--Saledate is not updating.

Alter Table Nashville_Housing_Data
Add Saledateconverted date;


Update Nashville_Housing_Data
Set Saledateconverted =  Convert (Date,Saledate)

----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Populating Property Address

Select *
From Nashville_Housing_Data
Order by ParcelID

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, Isnull (a.Propertyaddress,b.PropertyAddress)
From Nashville_Housing_Data a
Join Nashville_Housing_Data b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null	

Update a
Set Propertyaddress = Isnull (a.Propertyaddress,b.PropertyAddress)
From Nashville_Housing_Data a
Join Nashville_Housing_Data b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null	

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Seperating Address into Individual Columns (Address, City, State)

Select PropertyAddress
From Nashville_Housing_Data

Select 
Substring (PropertyAddress, 1 , Charindex (',' , Propertyaddress) -1) as address
, SUBSTRING (Propertyaddress, charindex (',',PropertyAddress) +1 ,len(propertyaddress)) as Address
From Nashville_Housing_Data


Alter Table Nashville_Housing_Data
Add Propertyaddress_1 Nvarchar (255);

Update Nashville_Housing_Data
Set Propertyaddress_1 =  Substring (PropertyAddress, 1 , Charindex (',' , Propertyaddress) -1)


Alter Table Nashville_Housing_Data
Add Propertyaddress_city Nvarchar (255);


Update Nashville_Housing_Data
Set Propertyaddress_city =  SUBSTRING (Propertyaddress, charindex (',',PropertyAddress) +1 ,len(propertyaddress))


Select Owneraddress
From Nashville_Housing_Data

Select 
PARSENAME(REPLACE(Owneraddress,',','.'), 3)
,PARSENAME(REPLACE(Owneraddress,',','.'), 2)
,PARSENAME(REPLACE(Owneraddress,',','.'), 1)

From Nashville_Housing_Data


Alter Table Nashville_Housing_Data
Add Owneraddress_1 Nvarchar (255);


Update Nashville_Housing_Data
Set Owneraddress_1 = PARSENAME(REPLACE(Owneraddress,',','.'), 3) 


Alter Table Nashville_Housing_Data
Add Owneraddress_city Nvarchar (255);


Update Nashville_Housing_Data
Set Owneraddress_city = PARSENAME(REPLACE(Owneraddress,',','.'), 2)



Alter Table Nashville_Housing_Data
Add Owneraddress_state Nvarchar (255);


Update Nashville_Housing_Data
Set Owneraddress_state = PARSENAME(REPLACE(Owneraddress,',','.'), 1)


-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Change Y and N to 'Yes' and 'No' in (sold as Vacant) column


Select Distinct SoldAsVacant, count (soldasvacant)
from Nashville_Housing_Data
group by soldasvacant
order by soldasvacant


Select SoldAsVacant
,Case When SoldAsVacant = 'Y' Then 'Yes'
      When SoldAsVacant = 'N' Then 'No'
	  Else SoldAsVacant
	  end
from Nashville_Housing_Data

Update Nashville_Housing_Data
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
      When SoldAsVacant = 'N' Then 'No'
	  Else SoldAsVacant
	  end


-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Removing Duplicates Rows


With Duplicate_row_num1 As (
Select *,
  Row_number () Over(
  Partition by Parcelid,
			   Propertyaddress,
			   Saledate,	
			   Saleprice,
			   Legalreference
			   order by Uniqueid
			      ) Duplicate_row_num

from Nashville_Housing_Data
)
Delete 
from Duplicate_row_num1
Where Duplicate_row_num = 2



-----------------------------------------------------------------------------------------------------------------------------------------------------------


Select * 
from Nashville_Housing_Data

Alter Table Nashville_Housing_Data
Drop column Propertyaddress,Saledate,Owneraddress,TaxDistrict
------------------------------------------------------------------------------------------------------------------------------------------------------------