$storage_account = "https://sandboxstoragesthcntl.blob.core.windows.net/"

$container_name = 'wvdtemplatefiles'  
$blobs = Get-AzureStorageBlob -Container $container_name -Context $storage_account  

$destination_path = 'C:\Artifacts'

$blobs = Get-AzureStorageBlob -Container $container_name -Context $storage_account  
foreach ($blob in $blobs)  
{  
   New-Item -ItemType Directory -Force -Path $destination_path  
   Get-AzureStorageBlobContent -Container $container_name -Blob $blob.Name -Destination $destination_path -Context $storage_account  
}  