# CS 312 Course Project P2
This repository contains my implementation of part 2 of the course project for CS 312, AKA System Administration.

### What is Part 2 of the Course Project?
Glad you asked. Listed below are a copy of the broad guidelines:
- Setup a git repo
    - Write infrastructure provisioning scripts (e.g., Terraform, Pulumi, Ansible, ...) to set up your AWS resources
    - Setup networking
    - (Optional) Specify and configure the Docker image to deploy
- (Optional) Write a configuration script to set up your Minecraft server (e.g., Ansible, bash, ...)
- Make sure that, through your scripts, the Minecraft server is configured to restart when the resources reboot.
    - From the previous documentation, the server auto-started but was not shutting down properly (look into how to stop the service properly).
- Connect to your instance's public IP address (i.e., your Minecraft server address) with ```nmap -sV -Pn -p T:25565 <instance_public_ip>```.
- Write the documentation as the git repo's README, and have all the scripts versioned.

In other words, create a script that essentially provisions and configures a Minecraft server automatically.

### How did I do this?
Essentially, this repository contains two scripts: one Terraform script that deploys the server initially with the correct firewall settings. Once Terraform deploys, the second script is ran automatically on the target that is deployed.

This second script handles installation and setup of the Minecraft server, as well as creation of the automated service that restarts the server on boot.

### Prerequisites
- This tutorial uses AWS, so you need an AWS account with billing set up.
- AWS CLI installed.
- Terraform installed.
- An AWS key generated and the private key file downloaded. In this case, the key is named "MC.pem"

### How To Use (Steps to Reproduce)
1. Download an AWS key from the Console, or use one you've already generated.
2. Get an access token, secret key, and access key, and place them into a variables.tf file that looks like this:
```
variable "accesskey" {
  description = "Amazon Parameters"
  type        = string
  default     = "<access key here>"
}

variable "secretkey" {
  description = "Secret Key"
  type        = string
  default     = "<secret key here>"
}

variable "accesstoken" {
  description = "Token"
  type        = string
  default     = "<access token here>"
}
```
3. Choose your desired instance type (by default, t3.small is used, which has 2 vCPUs and 2GB of RAM) and fill it in under the instance details on line 115 of main.tf.
4. Run the script using ```terraform apply``` and confirm by entering yes when prompted.
5. Wait for the script to finish - it can take up to 5 minutes. Allow additional time after the script finishes for the server to reboot.