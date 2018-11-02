$usrs=@('Ivanov','Petrov')

foreach ($usr in $usrs)
{
  write-host ' '
  write-host '--[' -nonewline
  write-host $usr  -nonewline -foregroundcolor Red
  write-host ']-------- '
  #get-aduser $usr | FT Name, SamAccountName,UserPrincipalName,SID,ObjectGUID
  write-host 'Доменные группы: '
  $query = "ASSOCIATORS OF {Win32_Account.Name='"+$usr+"',Domain='DomainName'} WHERE ResultRole=GroupComponent ResultClass=Win32_Account"
  Get-WMIObject -Query $query | Select Name
  write-host '-------------------- '             
}
