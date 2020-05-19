# Connect to vCenter
Write-Host "Connecting to VI Server"
$global:DefaultVIServer

$newServer = "false"
if ($global:DefaultVIServer) {
    $viserver = $global:DefaultVIServer.Name
    Write-Host "$VIServer is connected." -ForegroundColor green -BackgroundColor blue
    $in = Read-Host "If you want to connect again/another vCenter? Yes[Y] or No[N](Default: N)"
	if($in -eq "Y"){
	$newServer = "true"
	}
	if ($newServer -eq "true") {
    Disconnect-VIServer -Server "$viserver" -Confirm:$False
	$VCServer = Read-Host "Enter the vCenter server name" 
	$viserver = Connect-VIServer $VCServer  
		if ($VIServer -eq ""){
		Write-Host
		Write-Host "Please input a valid credential"
		Write-Host
		exit
		}	
    }
}else{
	$VCServer = Read-Host "Enter the vCenter server name" 
	$VIServer = Connect-VIServer $VCServer  
	if ($VIServer -eq ""){
		Write-Host
		Write-Host "Please input a valid credential"
		Write-Host
		exit
	}
}

$ClusterName = Read-host "Please enter a cluster name"
$VM = "TMilestoneRec" 
$Datastore = "vsanDatastore-DC3_Video_V2"  
$NewVmList = "pwmilcin014"#, "pwmilcin016", "pwmilcin017", "pwmilcin018", "pwmilcin019"  
$CustSpec = "new_cust_sp"  
$taskTab = @{}
 
# Create all the VMs specified in $newVmList  
foreach($Name in $newVmList) {  
     $taskTab[(New-VM -Name $Name -ResourcePool $clustername -VM $VM -Datastore $datastore -OSCustomizationSpec $custSpec  -RunAsync).Id] = $Name  
}  

start-sleep -s 15

foreach ($Name in $NewVMList) 
	{Start-VM -VM $Name}