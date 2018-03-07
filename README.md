# DevOp

Set up two EC2 instances in AWS.

  - One for Jenkins
  
  - One for hosting this app
  
  
Continous Deployment PipeLine using AWS CodePipeline

1. Check out code from Github (this repo)
2. Build and test the changed codes in AWS EC2 Jenkins
3. AWS CodeDeploy to deploy the app.


Steps 

•	Initial Settings
IAM instance profile
1.=> Identity and Access Management Console
2.=> Policies
3. Create new policy to get permission to access s3 buckets
4.Include below Json data in policy document
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": [
	"s3:Get*",
	"s3:List*"
	],
    "Resource": "*"
  }
}

5. => Roles
6. Create New Role
7. Select Amazon EC2 for AWS Service roles
8. In Attach Policy, select the policy you have created in Step 1-4

Service role for EC2 instance 
1. => Roles
2. Create New Roles
3. AWS CodeDeploy for AWS Service roles
4. AWSCodeDeployRole for Attach Policy
5. Save the Service Role ARN

•	Jenkins
Create EC2 for hosting Jenkins 
1.	=> EC2 DashBoard 
2.	Launch Instance, select Ubuntu Server and t2.micro (Free-tier)
3.	In Instance Details, choose the IAM role you have created in previous step in order to connect the S3 buckets
4.	In Security Group, create a new rule
Protocol: TCP Port Range: 8080 Source: Anywhere
5.	In Tags, create a new tag (Optional)
6.	Create a new key pair for connecting to this EC2 instance. Save the private key file
7.	Add name to EC2 (Ex. Jenkin Server)
8.	Copy the public DNS
Setting in EC2 for Jenkins
Reference: https://vexxhost.com/resources/tutorials/how-to-install-configure-and-use-jenkins-on-ubuntu-14-04/
9.	Open terminal and 
“ssh -i <private key file>.pem ubuntu@<public DNS>”
10.	Install Jenkins
“wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add –“
 “echo deb https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list”
“sudo apt-get update”
“sudo apt-get install Jenkins”
11.	Start Jenkins Server
“sudo service jenkins status”
12.	Go to <public DNS address>:8080 in any browser
13.	Copy the path in Jenkins page to find initial password
Ex. /var/lib/Jenkins/secrets/initialiAdminPassword
14.	In terminal “sudo cat <path>” and copy and paste the password
15.	Install suggested plugins
16.	=>Manage Jenkins => manage plugins
17.	Install plugin: AWS CodePipeline plugin. Install without restart
18.	=> Terminal for this EC2. Install Node.js
Reference: https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-16-04
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
  	sudo apt-get install -y nodejs
	sudo npm install -g npm
	

19.	Create another EC2 for deploying App. Repeat 1 – 9 
20.	In Terminal, install AWS CodeDeploy agent
References: https://docs.aws.amazon.com/codedeploy/latest/userguide/codedeploy-agent-operations-install-ubuntu.html
sudo apt-get install ruby
sudo apt-get install wget
wget https://bucket-name.s3.amazonaws.com/latest/install
bucket-name is the name of the Amazon S3 sds-s3-latest-bucket-name bucket that contains the AWS CodeDeploy Resource Kit files for your region. For example, for the US East (Ohio) Region, replace bucket-name with aws-codedeploy-us-east-2
chmod +x ./install
sudo ./install auto

•	Create AWS CodeDeploy Application
1.	=> AWS Code Deploy
2.	Select Custom Deployment
3.	In Add instances, Tag Type: Amazon EC2 Key: name Value: enter <Name of EC2>
4.	In Deployment Configuration, One at a time
5.	In Service Role, select the service role we have created before for AWS CodeDeploy
6.	Create appSpec.yml file in node.js app
