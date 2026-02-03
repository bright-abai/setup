for ($i = 101; $i -le 123; $i++) {
    scp C:\Control\Block-OtherBrowsers.ps1 teacher@192.168.104.${i}:\C:\Control
    #scp C:\Control\Arduino-2.3.7-installer.exe teacher@192.168.104.${i}:\C:\Users\student\Downloads
    #scp -r C:\Control\CH341SER teacher@192.168.104.${i}:\C:\Users\student\Downloads
}