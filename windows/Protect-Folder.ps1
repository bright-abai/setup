function Deny-Write {
    param (
        [string]$folder,
    )

    $acl = New-Object System.Security.AccessControl.DirectorySecurity
    $acl.SetAccessRuleProtection($true, $false)

    $inheritance = "ContainerInherit, ObjectInherit"
    $propagation = "None"

    $AllowSystem  = New-Object System.Security.AccessControl.FileSystemAccessRule("System" , "FullControl", $inheritance, $propagation, "Allow")
    $allowTeachers = New-Object System.Security.AccessControl.FileSystemAccessRule($teacher, "FullControl", $inheritance, $propagation, "Allow")
    $allowStudents  = New-Object System.Security.AccessControl.FileSystemAccessRule($student, "ReadAndExecute", $inheritance, $propagation, "Allow")
    $denyStudents  = New-Object System.Security.AccessControl.FileSystemAccessRule($student, "Write, Delete, DeleteSubdirectoriesAndFiles", $inheritance, $propagation, "Deny")
    $acl.AddAccessRule($allowSystem)
    $acl.AddAccessRule($allowTeachers)
    $acl.AddAccessRule($allowStudents)
    $acl.AddAccessRule($denyStudents)

    Set-Acl $folder $acl
}

$computerName = $env:COMPUTERNAME
$student = "$computerName\student"
$teacher = "$computerName\teacher"

$gamesFolder = "C:\Games"

Deny-Write $gamesFolder
