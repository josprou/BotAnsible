function checkports{
    $ports = 7,9,13,17,19,21,22,23,25,26,37,53,79,80,81,82,88,106,110,111,113,119,135,139,143,144,179,199,255,389,
        427,443,444,445,465,513,514,515,543,544,548,554,587,631,636,646,808,873,990,993,995,1000,1024,1025,
        1026,1027,1028,1029,1030,1031,1038,1041,1071,1110,1433,1720,1723,1755,1801,2000,2001,2049,2103,2105,
        2107,2121,2601,2717,3000,3001,3128,3306,3389,3689,3703,3986,4899,5000,5001,5009,5060,5101,5190,5357,
        5432,5631,5666,5800,5900,5901,6000,6001,6004,6646,7000,7070,8000,8008,8009,8031,8080,8081,8443,8888,
        9000,9090,9100,9102,9999,10000,10010,32768,49152,49153,49154,49155,49156,49157
    $totalopen = 0
    $totalports = 0
    $hostname = (hostname)   
    $Target = $hostname
    $open_ports=@()  
    $allports=@()
    foreach($t in $Target){
        $totalopen = 0          
        $totalports = 0
        foreach ($p in $ports){
            $a=Test-NetConnection -ComputerName $t -Port $p -WarningAction SilentlyContinue
            $ipV4 = Test-Connection -ComputerName ($t) -Count 1
            if ($a.tcpTestSucceeded -eq "True"){
                $open_ports+=New-Object -TypeName PSObject -Property ([ordered]@{
                    'Port'=$a.RemotePort.ToString();
                    'Status'=$a.tcpTestSucceeded;
                    'Target'=$ipV4.IPV4Address.IPAddressToString
                })           
                $totalopen += 1 
            }       
            $allports+=New-Object -TypeName PSObject -Property ([ordered]@{
                'Port'=$a.RemotePort.ToString();
                'Status'=$a.tcpTestSucceeded;
                'Target'=$ipV4.IPV4Address.IPAddressToString
            })         
            $totalports += 1 
        } 
       
        $info += "total scan ports "+$totalports+" on target "+$ipV4.IPV4Address.IPAddressToString+"`n"
        $info += "total open ports "+$totalopen+" on target "+$ipV4.IPV4Address.IPAddressToString+"`n"
        if ($totalopen -eq 0 ){
            $info += "none ports open target "+$ipV4.IPV4Address.IPAddressToString+"`n"
        }
    }
    return @{results=$open_ports;success=$true}
}
