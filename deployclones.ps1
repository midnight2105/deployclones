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
$VM = #"servername" 
$Datastore = #"datastorename"  
$NewVmList = #"comma_seperated_namelist"  
$CustSpec = #"name_of_custimation_spec"  
$taskTab = @{}
 
# Create all the VMs specified in $newVmList  
foreach($Name in $newVmList) {  
     $taskTab[(New-VM -Name $Name -ResourcePool $clustername -VM $VM -Datastore $datastore -OSCustomizationSpec $custSpec  -RunAsync).Id] = $Name  
}  

start-sleep -s 15 #may need to increase depending on environment

foreach ($Name in $NewVMList) 
	{Start-VM -VM $Name}