# Scale Unit Terraform

This folder contains terraform script and custom modules used to create all the components for deploying a "scale unit" by the Control Plane (CP).  The scale unit is defined as the following components:

1. Storage Account
2. Event Hub Namespace
   - One Event Hub
3. App Service and Function App
   - Java app deployed via URL
   - Creates an App Insights resource for the function app
4. All metrics for above components routed to a Log Analytics Workspace in the CP

To run the scale unit terraform script, following the instructions in CP [readme](../../../eng/terraform/control-plane/readme.md). Copy the file [terraform.tfvars.sample](scale_unit/terraform.tfvars.sample), rename it to terraform.tfvars, then set all the variables to your desired values in the file.

*Note* that by commenting out the backend block near the top of the main.tf, terraform will simply write the state file (terraform.tfstate) to the directory.

```json
terraform {
//  backend "azurerm" {
//  }
}
```
