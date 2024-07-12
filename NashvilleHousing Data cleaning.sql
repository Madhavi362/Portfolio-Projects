/*

Cleaning Data in SQL Queries

*/


select * 
from Portfolio_DA..NashvilleHousing

-- Standardize Date Format

select SaleDate, convert(Date,SaleDate)
from Portfolio_DA..NashvilleHousing;


Alter table Portfolio_DA..NashvilleHousing
add SalesDateC Date;

update NashvilleHousing
set SalesDateC = convert(Date,SaleDate)


-- Populate Property Address data



select PropertyAddress 
from Portfolio_DA..NashvilleHousing
where PropertyAddress is NUll 
order by UniqueID 

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from Portfolio_DA..NashvilleHousing a
JOIN Portfolio_DA..NashvilleHousing b
	on a.ParcelID =b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a 
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Portfolio_DA..NashvilleHousing a
JOIN Portfolio_DA..NashvilleHousing b
	on a.ParcelID =b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, City, State)


select PropertyAddress 
from Portfolio_DA..NashvilleHousing
--where PropertyAddress is NUll 
--order by UniqueID 


select
SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1)
from Portfolio_DA..NashvilleHousing



select 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))as Address
from Portfolio_DA..NashvilleHousing



Alter table NashvilleHousing
Add PropertySplitAddress nvarchar(255)


Update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1)



Alter table NashvilleHousing
Add PropertySplitCity nvarchar(255)


Update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))



select OwnerAddress 
from Portfolio_DA..NashvilleHousing



select 
PARSENAME(OwnerAddress,1)
from Portfolio_DA..NashvilleHousing



select 
PARSENAME(Replace(OwnerAddress, ',','.'),3),
PARSENAME(Replace(OwnerAddress, ',','.'),2),
PARSENAME(Replace(OwnerAddress, ',','.'),1)
from Portfolio_DA..NashvilleHousing



Alter table NashvilleHousing
Add OwnerSplitAddress nvarchar(255)


Update NashvilleHousing
set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',','.'),3)


Alter table NashvilleHousing
Add OwnerSplitState nvarchar(255)


Update NashvilleHousing
set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',','.'),2)



Alter table NashvilleHousing
Add OwnerSplitCity nvarchar(255)


Update NashvilleHousing
set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',','.'),1)


-- Change Y and N to Yes and No in "Sold as Vacant" field


select Distinct (SoldAsVacant), count(SoldAsVacant)
from Portfolio_DA..NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 End
from Portfolio_DA..NashvilleHousing




update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
				   when SoldAsVacant = 'N' then 'No'
				   else SoldAsVacant
				   End



-- Remove Duplicates



With RowNumCTE as
(
select *,
Row_number() Over(
partition by ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				order by 
						UniqueID)row_num
from Portfolio_DA..NashvilleHousing						
)
delete from RowNumCTE
where row_num > 1
--order by PropertyAddress



select * from Portfolio_DA..NashvilleHousing

Alter table NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress,SaleDate




