# - Обойти папки с логами, перенести старые логи в архивную папку
# - Сгенерировать итоговые результаты и выложить их в отдельную папку в виде архива
# - Отправить результаты по e-mail

###################################
cls
$cd = 'C:\StressTest' ### ---<<< !!! >>>--- ###
$tool = $cd+'\'+'Tool\Utility.exe' ### ---<<< !!! >>>--- ###

$arch = '_old'
$res = 'results'

$hostname = hostname
$hostname_3letter = $hostname.Substring(0,3)
$result = $res +"_"+ $hostname_3letter

$fld = @('Logs-GENERAL', 'LogsGENERAL') ### ---<<< !!! >>>--- ###

## Mail
$mail = "admin@gmail.com"  ### ---<<< !!! >>>--- ###
$psw = "passwo1d" ### ---<<< !!! >>>--- ###
$smtpName = "smtp.gmail.com" ### ---<<< !!! >>>--- ###
$To = "for_me@mail.com" ### ---<<< !!! >>>--- ###
$Subject = "StressTest" + "_" + $hostname_3letter ### ---<<< !!! >>>--- ###
$Body = "Logs" 
$file = ""
###################################

cd $cd

# Даты, для которых не нужно архивировать файлы
$date1 = (get-date).AddDays(-1).ToString("yyyMMdd")
$date2 = (get-date).AddDays(-2).ToString("yyyMMdd")
$date3 = (get-date).AddDays(-3).ToString("yyyMMdd")
$date = get-date -UFormat "%Y%m%d"


### Zip-archive
function AddZip($source, $destination)
{
    Compress-Archive -Path $source"*" -Update -DestinationPath $destination
}


### Send mail
function SendMail($mail,$psw,$smtpName,$To,$Subject,$Body, $file)
{
    $msg = New-Object Net.Mail.MailMessage
    $smtp = New-Object Net.Mail.SmtpClient($smtpName)
    $smtp.EnableSsl = $true
    $msg.From = $mail
    $msg.To.Add($To)

    ## Attach 
    $attachment = New-Object System.Net.Mail.Attachment $file
    $msg.Attachments.Add($attachment)

    $msg.Subject = $Subject 
    $msg.Body = $Body
    $smtp.Credentials = New-Object System.Net.NetworkCredential("admin", $psw)

    $smtp.Send($msg)
}


### Test path (if folder not exist > CREATED!)
function TestPath
{
    Param($test_fld)

    if(!(Test-Path -Path $test_fld ))
    {
        New-Item -ItemType directory -Path $test_fld
    }
}

foreach ($f in $fld)
{
    $folder = $cd+'\'+$f
    $folder_old = $cd+'\'+$arch+'\'+$f
    $file_res = $cd+'\'+$result+'\'+$f + ".log"
   
    TestPath $cd'\'$arch
    TestPath $folder_old
    TestPath $cd'\'$result

        
    cd $folder    
    $outputofcommand = & $tool '/stat' > $file_res
    
    # Move old file
    Get-ChildItem $folder -Filter *.txt  | Where-Object {$_.Name -NotMatch "$date3|$date2|$date1|$date" } | Move-Item -Destination $folder_old -force
    write-host $f -ForegroundColor Green
}

$dir_result=$cd+'\'+$result

TestPath $cd'\'$arch'\Archive\'

$zip = $cd+'\'+$arch + "\Archive\" + $result + ".zip"
AddZip $dir_result $zip
write-host "Archiving folder ["$dir_result"] in file "$zip 

#function SendMail($mail,$psw,$smtpName,$To,$Subject,$Body, $file)
SendMail $mail $psw $smtpName $To $Subject $Body $zip  
write-host "Sended mail to ["$To"]"

write-host 'See in '$cd'\'$result -ForegroundColor Yellow
write-host 'Done!' -ForegroundColor Cyan
