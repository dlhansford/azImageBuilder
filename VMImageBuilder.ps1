# Resource group name - we are using myImageBuilderRG in this example
imageResourceGroup=hansfordwvdtemplates
# Region location 
location=WestUS2
# Name for the image 
imageName=WSImageBuilder
# Run output name
runOutputName=WSBaseImage
# name of the image to be created
imageName=WSBaseImage
# Name of Subscription
subscriptionID=6f181101-2469-4ca2-95e8-5332ea49e2b9

# Provide Image Builder permission to RG (only needs to be done once)
az role assignment create \
    --assignee cf32a0cc-373c-47c9-9156-0db11f6a6dfc \
    --role Contributor \
    --scope /subscriptions/$subscriptionID/resourceGroups/$imageResourceGroup

# Download & update template file
curl https://github.com/dlhansford/azImageBuilder/blob/master/wsimagebuilder.json -o wsimagebuilder.json

sed -i -e "s/<subscriptionID>/$subscriptionID/g" wsimagebuilder.json
sed -i -e "s/<rgName>/$imageResourceGroup/g" wsimagebuilder.json
sed -i -e "s/<region>/$location/g" wsimagebuilder.json
sed -i -e "s/<imageName>/$imageName/g" wsimagebuilder.json
sed -i -e "s/<runOutputName>/$runOutputName/g" wsimagebuilder.json


# Create VM Image

az resource create \
    --resource-group $imageResourceGroup \
    --properties @wsimagebuilder.json \
    --is-full-object \
    --resource-type Microsoft.VirtualMachineImages/imageTemplates \
    -n WSBaseImage

#Start Image Creation

az resource invoke-action \
     --resource-group $imageResourceGroup \
     --resource-type  Microsoft.VirtualMachineImages/imageTemplates \
     -n helloImageTemplateWin02 \
     --action Run


# From Docs
curl https://raw.githubusercontent.com/danielsollondon/azvmimagebuilder/master/quickquickstarts/0_Creating_a_Custom_Windows_Managed_Image/helloImageTemplateWin.json -o helloImageTemplateWin.json

sed -i -e "s/<subscriptionID>/$subscriptionID/g" helloImageTemplateWin.json
sed -i -e "s/<rgName>/$imageResourceGroup/g" helloImageTemplateWin.json
sed -i -e "s/<region>/$location/g" helloImageTemplateWin.json
sed -i -e "s/<imageName>/$imageName/g" helloImageTemplateWin.json
sed -i -e "s/<runOutputName>/$runOutputName/g" helloImageTemplateWin.json

az resource create \
    --resource-group $imageResourceGroup \
    --properties @helloImageTemplateWin.json \
    --is-full-object \
    --resource-type Microsoft.VirtualMachineImages/imageTemplates \
    -n helloImageTemplateWin01