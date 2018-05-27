## Packer Configurations

- using Packer to create native AWS AMI which will be used in the Launch Configuration for our Auto Scaling Group which is attached to the Load Balancer.
- Packer is used to bake everything into the native AWS AMI

- Shell provisioner to install Ansible and create project directory
- File provisioner to copy project code.
- Ansible provisioner to configure our machine.

We’ve used AWS amazon-ebs builder to create a builder. You should be able to understand configuration by reading out. Or you can put a comment if you do not understand something

## Terraform Configurations
- rraform will use latest AMI (notice most_recent = true) and will modify AWS resources to use new AMI. Executing terraform apply will modify and recreate some of the resources in a way so create happens before destroy (notice create_before_destroy). You can also extract AMI id from Packer

Some important points to note here are:

	Both LC and ASG have creaet_before_destroyset to true
	The LC omits the name attribute to allow Terraform to auto-generate a random one, which prevent collisions

	The ASG interpolates the launch configuration name into its name, so LC changes always force replacement of the ASG (and not just an ASG update).
    
    The ASG sets min_elb_capicity which means Terraform will wait for instances in the new ASG to show up as InService in the ELB before considering the ASG successfully created

- The behavior when AMI changes is:
    New LC is created with the fresh AMI
    New ASG is created with the fresh LC
    Once all new instances are InService, Terraform begins destroy of old ASG
    Once old ASG is destroyed, Terraform destroys old 

