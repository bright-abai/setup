function Deny-Write {
    param (
        [string]$folder
    )

    $acl = New-Object System.Security.AccessControl.DirectorySecurity
    $acl.SetAccessRuleProtection($true, $false)

    $inheritance = "ContainerInherit, ObjectInherit"
    $propagation = "None"

    $AllowSystem  = New-Object System.Security.AccessControl.FileSystemAccessRule("System" , "FullControl", $inheritance, $propagation, "Allow")
    $allowTeachers = New-Object System.Security.AccessControl.FileSystemAccessRule($teacher, "FullControl", $inheritance, $propagation, "Allow")
    $allowStudents  = New-Object System.Security.AccessControl.FileSystemAccessRule($student, "FullControl", $inheritance, $propagation, "Allow")
    # $denyStudents  = New-Object System.Security.AccessControl.FileSystemAccessRule($student, "Delete, DeleteSubdirectoriesAndFiles", "Deny")
    $acl.AddAccessRule($allowSystem)
    $acl.AddAccessRule($allowTeachers)
    $acl.AddAccessRule($allowStudents)
    # $acl.AddAccessRule($denyStudents)

    Set-Acl $folder $acl

    Write-Host "Protected $folder"
}

function Allow-Write {
    param (
        [string]$folder
    )

    $acl = New-Object System.Security.AccessControl.DirectorySecurity
    $acl.SetAccessRuleProtection($true, $false)

    $inheritance = "ContainerInherit, ObjectInherit"
    $propagation = "None"

    $AllowSystem  = New-Object System.Security.AccessControl.FileSystemAccessRule("System" , "FullControl", $inheritance, $propagation, "Allow")
    $allowTeachers = New-Object System.Security.AccessControl.FileSystemAccessRule($teacher, "FullControl", $inheritance, $propagation, "Allow")
    $allowStudents  = New-Object System.Security.AccessControl.FileSystemAccessRule($student, "FullControl", $inheritance, $propagation, "Allow")
    
    $acl.AddAccessRule($allowSystem)
    $acl.AddAccessRule($allowTeachers)
    $acl.AddAccessRule($allowStudents)

    Set-Acl $folder $acl

    Write-Host "Protected $folder"
}

$computerName = $env:COMPUTERNAME
$student = "$computerName\student"
$teacher = "$computerName\teacher"

$programmingFolder = "C:\Programming"

Allow-Write $programmingFolder