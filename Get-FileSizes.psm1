<#	
	.NAME
		Get-FileSizes
	.DESCRIPTION
		A module that can be called to be used to find folder or file sizes.
	.EXAMPLE
		Get-FileSizes -FilePath C:\$env:USERNAME\Downloads\

		13.36GB
	.EXAMPLE
		Get-FileSizes -FilePath C:\$env:USERNAME\Downloads\ -FullList

		13.36GB
		C:\Users\Zachn\Downloads\ -- 13.36GB
		C:\Users\Zachn\Downloads\10514.0.150808-1529.TH2_RELEASE_SERVER_OEMRET_X64FRE_EN-US (1).ISO -- 4.62GB
		C:\Users\Zachn\Downloads\dark-bliss.vssettings -- 7.95KB
		C:\Users\Zachn\Downloads\en_visual_studio_team_foundation_server_2013_with_update_4_x86_x64_dvd_5921289.iso -- 2.46GB
		C:\Users\Zachn\Downloads\en_visual_studio_team_foundation_server_2013_with_update_5_x86_x64_dvd_6815779.iso -- 2.46GB
		C:\Users\Zachn\Downloads\en_windows_10_enterprise_x64_dvd_6851151.iso -- 3.67GB
		C:\Users\Zachn\Downloads\Microsoft_Press_ebook_Introducing_Microsoft_SQL_Server_2014_PDF.pdf -- 8.09MB
		C:\Users\Zachn\Downloads\Microsoft_Press_eBook_Introducing_Windows_10_Preview_PDF.pdf -- 6.39MB
		C:\Users\Zachn\Downloads\Microsoft_Press_ebook_Introducing_Windows_ITPro_PDF.pdf -- 9.31MB
		C:\Users\Zachn\Downloads\Microsoft_Press_ebook_Introducing_Windows_Server_2012_R2_PDF.pdf -- 11.21MB
		C:\Users\Zachn\Downloads\powershellorg-secrets-of-powershell-remoting-master.pdf -- 433.08KB
		C:\Users\Zachn\Downloads\ScriptingCMF.zip -- 65.10KB
		C:\Users\Zachn\Downloads\Sublime Text 2.0.2 x64 Setup.exe -- 6.21MB	
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
			Write-Host $displayValue -ForegroundColor Cyan
		}
		elseif ($items.Sum -lt 1000000000 -and $items.Sum -gt 1000000)
		{
			$Size = "1MB"
			$displayValue = "{0:N2}" -f ($items.Sum / $Size) + $Size.Substring(1, 2)
			Write-Host $displayValue -ForegroundColor Yellow
		}
		elseif ($items.Sum -lt 1000000)
		{
			$Size = "1KB"
			$displayValue = "{0:N2}" -f ($items.Sum / $Size) + $Size.Substring(1, 2)
			Write-Host $displayValue -ForegroundColor Green
		}
		else
		{
			Write-Host "No size for files specified."
		}
	
	
	# Add a parameter that will show the sizes of all the files in a folder.
	if ($FullList)
	{
		$startFolder = $FilePath
		
		$folderItems = (Get-ChildItem -Path $startFolder | Measure-Object -Property Length -Sum)
		"$startFolder -- " + "{0:N2}" -f ($items.Sum / $Size) + $Size.Substring(1, 2)
		
		$folderItems = (Get-ChildItem $startFolder | Where-Object { !$_.PSIsContainer -eq $True } | Sort-Object)
		foreach ($i in $folderItems)
		{
			if ($i.Length -ge 1000000000)
			{
				$Size = "1GB"
				$subFolderItems = (Get-ChildItem $i.FullName | Measure-Object -property length -sum)
				$displayValue = $i.FullName + " -- " + "{0:N2}" -f ($subFolderItems.sum / $Size) + $Size.Substring(1, 2)
				Write-Host $displayValue -ForegroundColor Cyan
			}
			elseif ($i.Length -lt 1000000000 -and $i.Length -gt 1000000)
			{
				$Size = "1MB"
				$subFolderItems = (Get-ChildItem $i.FullName | Measure-Object -property length -sum)
				$displayValue = $i.FullName + " -- " + "{0:N2}" -f ($subFolderItems.sum / $Size) + $Size.Substring(1, 2)
				Write-Host $displayValue -ForegroundColor Yellow
			}
			elseif ($i.Length -lt 1000000)
			{
				$Size = "1KB"
				$subFolderItems = (Get-ChildItem $i.FullName | Measure-Object -property length -sum)
				$displayValue = $i.FullName + " -- " + "{0:N2}" -f ($subFolderItems.sum / $Size) + $Size.Substring(1, 2)
				Write-Host $displayValue -ForegroundColor Green
			}
			else
			{
				Write-Host "No size for files specified."
			}
			#$subFolderItems = (Get-ChildItem $i.FullName | Measure-Object -property length -sum)
			#$i.FullName + " -- " + "{0:N2}" -f ($subFolderItems.sum / 1MB) + " MB"
		}
	}
	
	
}





