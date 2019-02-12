<#
	.NAME
		Get-FileSizes
	.DESCRIPTION
		A module that can be called to be used to find folder or file sizes.
	.EXAMPLE
		Get-FileSizes -FilePath C:\$env:USERNAME\Downloads\

		13.36GB
	.EXAMPLE
		Get-FileSizes -FilePath C:\AppLauncher\ -FullList

		1.30MB
		C:\AppLauncher\AppLauncher.exe -- 263.00KB
		C:\AppLauncher\AppLauncher.exe.config -- 0.33KB
		C:\AppLauncher\AppLauncher.pdb -- 53.50KB
		C:\AppLauncher\CIM 7.1 Latest Build -- 155.00KB
		C:\AppLauncher\Instructions on Updating the App Launcher.docx -- 858.17KB
	.EXAMPLE
	  Get-FileSizes

		16.66KB
#>

function Get-FileSizes
{
	param
	(
		[string]$FilePath,
		[switch]$FullList
	)

	$items = (Get-ChildItem -Path $FilePath -Recurse | Measure-Object -Property Length -Sum)
	if ($items.Sum -ge 1000000000)
	{
		$Size = "1GB"
		$displayValue = "{0:N2}" -f ($items.Sum / $Size) + $Size.Substring(1, 2)
		Write-Host $displayValue -ForegroundColor Red
	}
	elseif ($items.Sum -lt 1000000000 -and $items.Sum -gt 1000000)
	{
		$Size = "1MB"
		$displayValue = "{0:N2}" -f ($items.Sum / $Size) + $Size.Substring(1, 2)
		Write-Host $displayValue -ForegroundColor Green
	}
	elseif ($items.Sum -lt 1000000)
	{
		$Size = "1KB"
		$displayValue = "{0:N2}" -f ($items.Sum / $Size) + $Size.Substring(1, 2)
		Write-Host $displayValue  -ForegroundColor Gray
	}
	else
	{
		Write-Host "No size for files specified."
	}


	# Add a parameter that will show the sizes of all the files in a folder.
	if ($FullList)
	{
		$startFolder = $FilePath
		if (!$FilePath) {
			$startFolder = Get-Location
		}

		#Variable used to hold an array of folder items.
		$folderItems = (Get-ChildItem -Directory $startFolder | Sort-Object)
		foreach ($f in $folderItems)
		{
			$subFolderItems = (Get-ChildItem $f.FullName -Recurse | Measure-Object -Property Length -sum)

			if ($subFolderItems.Sum -ge 1000000000)
			{
				$Size = "1GB"
				$display = $f.Name + " -- " + "{0:N2}" -f ($subFolderItems.sum / $Size) + $Size.Substring(1, 2)
				Write-Host "Folder: "$display -ForegroundColor Red
			}
			elseif ($subFolderItems.Sum -lt 1000000000 -and $subFolderItems.Sum -gt 1000000)
			{
				$Size = "1MB"
				$display = $f.Name + " -- " + "{0:N2}" -f ($subFolderItems.sum / $Size) + $Size.Substring(1, 2)
				Write-Host "Folder: "$display -ForegroundColor Green
			}
			elseif ($subFolderItems.Sum -lt 1000000)
			{
				$Size = "1KB"
				$display = $f.Name + " -- " + "{0:N2}" -f ($subFolderItems.sum / $Size) + $Size.Substring(1, 2)
				Write-Host "Folder: "$display -ForegroundColor Gray
			}
		}

		#Variable used to hold an array of file items.
		$fileItems = (Get-ChildItem -File $startFolder | Sort-Object)
		foreach ($i in $fileItems)
		{
			if ($i.Length -ge 1000000000)
			{
				$Size = "1GB"
				$subFileItems = (Get-ChildItem $i.FullName | Measure-Object -Property Length -sum)
				$displayValue = $i.Name + " -- " + "{0:N2}" -f ($subFileItems.sum / $Size) + $Size.Substring(1, 2)
				Write-Host $displayValue -ForegroundColor Red
			}
			elseif ($i.Length -lt 1000000000 -and $i.Length -gt 1000000)
			{
				$Size = "1MB"
				$subFileItems = (Get-ChildItem $i.FullName | Measure-Object -Property Length -sum)
				$displayValue = $i.Name + " -- " + "{0:N2}" -f ($subFileItems.sum / $Size) + $Size.Substring(1, 2)
				Write-Host $displayValue -ForegroundColor Green
			}
			elseif ($i.Length -lt 1000000)
			{
				$Size = "1KB"
				$subFileItems = (Get-ChildItem $i.FullName | Measure-Object -Property Length -sum)
				$displayValue = $i.Name + " -- " + "{0:N2}" -f ($subFileItems.sum / $Size) + $Size.Substring(1, 2)
				Write-Host $displayValue  -ForegroundColor Gray
			}
			else
			{
				Write-Host "No size for files specified."
			}
		}
	}
}
