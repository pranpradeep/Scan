param 
( 
    [parameter()][string] $FolderPath = "C:\Users\v-prnara\Desktop\singedartifacts", 
    [parameter()][string] $FileExtension = ".xml"
) 
 

#Create Table object
$table = New-Object system.Data.DataTable “FileList”

#Define Columns
$col1 = New-Object system.Data.DataColumn FileName,([string])
$col2 = New-Object system.Data.DataColumn SignStatus,([string])

#Add the Columns
$table.columns.add($col1)
$table.columns.add($col2)

$Result = (TestPath($FolderPath)); 
If ($Result) 
{ 
    $Dir = get-childitem $FolderPath -recurse 
    $List = $Dir | where {$_.extension -eq $FileExtension} 

    $i=0
    foreach ($item in $List)
       {
          $cert= $(get-AuthenticodeSignature $item.FullName).SignerCertificate.Subject

               #Create a row
                $row = $table.NewRow()

                #Enter data in the row
                $row.FileName = $item.FullName
                $row.SignStatus = $cert

                #Add the row to the table
                $table.Rows.Add($row)

         
          
       }

    $table | format-table -AutoSize  | format-table Name 
    $tabCsv = $table | export-csv "C:\Users\v-prnara\Desktop\singedartifacts\files2.csv" -noType
} 
else 
{ 
    "Folder path is incorrect." 
} 
 
function TestPath()  
{ 
    $FileExists = Test-Path $FolderPath 
    If ($FileExists -eq $True)  
    { 
        Return $true 
    } 
    Else  
    { 
        Return $false 
    } 
}