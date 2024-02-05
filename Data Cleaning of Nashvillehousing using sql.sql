/*

Cleaning Data in Sql Queries

*/

select *
from PortfolioProject..NashvilleHousing


-----------------------------------------------------------------------------------------------------------------------
---Standardize Sale Date Formate frome datetime to date

Alter table NashvilleHousing
Alter column SaleDate Date

--After changing the Date format lets display it
select SaleDate
from PortfolioProject..NashvilleHousing

----------------------------------------------------------------------------------------------------------------------


---Populate Property Address Data

select *
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

--self joining the table to look the duplicate parcelid

select a.ParcelID, b.ParcelID, a.PropertyAddress, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null



--------------------------------------------------------------------------------------------------------------------------

---Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
from PortfolioProject..NashvilleHousing
--It will look into the propertyaddress and seperate the address from 1st value until (,) and then remove one value at the end that is(,) itself
--In second line we are seperating the vale after the comma and also removing the comma from it using (+1)
select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress)) as Address
from PortfolioProject..NashvilleHousing


ALTER TABLE PortfolioProject..NashvilleHousing
add PropertySplitAdress Nvarchar(255)

update PortfolioProject..NashvilleHousing
Set PropertySplitAdress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE PortfolioProject..NashvilleHousing
add PropertySplitCity Nvarchar(255)

update PortfolioProject..NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress))

select *
from PortfolioProject..NashvilleHousing






--Now we will seperate the OwnerAddress

select OwnerAddress
from PortfolioProject..NashvilleHousing


select
PARSENAME(Replace(OwnerAddress,',','.') , 3)
,PARSENAME(Replace(OwnerAddress,',','.') , 2)
,PARSENAME(Replace(OwnerAddress,',','.') , 1)
from PortfolioProject..NashvilleHousing



ALTER TABLE PortfolioProject..NashvilleHousing
add OwnerSplitAdress Nvarchar(255)

update PortfolioProject..NashvilleHousing
Set OwnerSplitAdress = PARSENAME(Replace(OwnerAddress,',','.') , 3)

ALTER TABLE PortfolioProject..NashvilleHousing
add OwnerSplitCity Nvarchar(255)

update PortfolioProject..NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.') , 2)

ALTER TABLE PortfolioProject..NashvilleHousing
add OwnerSplitState Nvarchar(255)

update PortfolioProject..NashvilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.') , 1)


select *
from PortfolioProject..NashvilleHousing




-------------------------------------------------------------------------------------------------------------------------------------



---Change Y and N to Yes and No in "Sold as Vacant" field

select dISTINCT(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant
,case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from PortfolioProject..NashvilleHousing



update PortfolioProject..NashvilleHousing
Set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end


select SoldAsVacant
from PortfolioProject..NashvilleHousing



--------------------------------------------------------------------------------------------------------------------------------------

---Remove Duplicates

WITH RowNumCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY ParcelID,
                            PropertyAddress,
                            SalePrice,
                            SaleDate,
                            LegalReference
               ORDER BY UniqueID
           ) AS row_num
    FROM PortfolioProject..NashvilleHousing
)
--DELETE
Select *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress



select *
from PortfolioProject..NashvilleHousing




-------------------------------------------------------------------------------------------------------------------------------------


---Delete Unused Columns


select*
from PortfolioProject..NashvilleHousing

alter table PortfolioProject..NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress

--------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------Finished--------------------------------------------------------------------------