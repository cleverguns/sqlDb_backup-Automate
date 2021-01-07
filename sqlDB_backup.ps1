#Import SQL Module
Import-Module SQLPS

#Create Variables
$Server = "SYSTEM\SQLINSTANCE" #your path 
$Database = "DBNAME" #change it to your db name
$BackupFolder = "D:\Backup\" # i Use eternal drive to backup zip/sql files
$BackupTemp = "C:\Temp\SQLBackup\" #Added so you don't get old backup zips included in the current backup , u can change it to D:\
$DT = Get-Date -Format MM-dd-yyyy
$FilePath = "$($BackupTemp)$($Database)_db_$($dt).bak"

#Call SQL Command
Backup-SqlDatabase -ServerInstance $Server -Database $Database -BackupFile $FilePath

#Zip the backup (BAK) that is created
Add-Type -Assembly "System.IO.Compression.FileSystem";
[System.IO.Compression.ZipFile]::CreateFromDirectory($BackupTemp, "$($BackupFolder)\$($Database)_db_$($DT).zip");

#Remove THIS .bak file to save space
##$ThisBak=(Get-Date).AddDays(-7).ToString("MM-dd-yyy")
Remove-Item $FilePath

#Remove Old ZIP backup Files.  Our retention is 7 days
$OldFile=(Get-Date).AddDays(-7).ToString("MM-dd-yyy")
Remove-Item "$($BackupFolder)\$($Database)_db_$($OldFile).zip"