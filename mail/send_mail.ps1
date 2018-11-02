$emailFrom = "me@domen.ru"
$emailTo = "user@domen.ru"
$subject = "Пример тестового сообщения"
$body = "Тестовое сообщение, отправленное через PowerShell"
$smtpServer = "mailserver.ru"
$smtp = new-object Net.Mail.SmtpClient($smtpServer)
$smtp.Send($emailFrom, $emailTo, $subject, $body)
