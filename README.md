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
At present, I'm still working on implementation, but when finished, this would go here.

### Prerequisites
- This tutorial uses AWS, so you need an AWS account with billing set up.
- AWS CLI installed.
- Terraform installed.

### How To Use (Steps to Reproduce)
1. Enroll in CS312.
2. Cry.
3. ???
4. Profit!