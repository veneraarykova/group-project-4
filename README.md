# group-project-4
Creating AWS account instruction
Visit the AWS Signup Pages
Open your web browser and navigate to the AWS signup page: https://aws.amazon.com/.
 Click on "Create an AWS Account"
On the AWS homepage, click on the "Create an AWS Account" button located at the top right corner.
 Provide Your Email Address
You'll be directed to a page where you'll need to provide your email address. Enter your email and click "Next."
Enter Your Account Information
Fill out the account information: Username: Choose a unique username for your AWS account.
Password: Create a strong and secure password for your AWS account.
Confirm Password: Re-enter the password to confirm it.
Click "Next" when done.
Contact Information
Fill in your contact information, including your name, phone number, and a recovery email address. Click "Next" when ready.
 Payment Information
AWS requires a valid payment method to verify your identity and to charge for services you may use beyond the free tier limits. Enter your credit card information, including the cardholder's name, card number, expiration date, and security code (CVV). Click "Verify and Add" when done.
Confirmation
Review the information you provided, including your account information, contact details, and payment information. Make sure everything is correct. If everything looks good, click "Create Account and Continue."
 Sign In to AWS Console
Once your AWS account is created, you'll be directed to the AWS Management Console. 
Importing the Public key from the local terminal to AWS key pairs:

      Open a web browser and go to the Amazon EC2 console by navigating to
      https://console.aws.amazon.com/ec2/.

      In the EC2 Dashboard, choose Key Pairs option.

    On the right corner, please click < Actions >, click < import key 
      For the < Name > enter a descriptive name for the key pair (e.g. my-laptop-      key)
Get the public key of your local computer: Open Terminal (for Mac) or Power Shell (for Windows) and type “cat ~/.ssh/id_rsa.pub” and copy output.
Put the public key of your local computer into Public key contents text box and press “import key pair” for creating EC2 instances
      

3. Creating the EC2 instance  
    Log In to the AWS Management Console
    Open your web browser and navigate to the AWS Management Console:   
    On the Search bar, please type “EC2” and navigate to the EC2 service.
    Click on Launch Instance on the right corner top.
    Type the name of instance.
    Choose an Amazon Linux 2023 AMI (Free tier eligible) 
    Choose an instance type t2.micro (Free tier eligible) 
    Choose key pair to connect to your instance securely. Key pair was created            before from your local machine, and was imported to AWS Key Pairs.
      Click Launch Instance; Your EC2 instance will now be launched.

3. Configure the AWS CLI:
Open your web browser and navigate to the AWS Management Console:
https://aws.amazon.com/.

Click the “Sign in to the Console” button at the top right corner.
Enter your AWS account credentials (your email address and password) and click the “Sign In” button.
 Open the IAM Dashboard
Once you are logged in, you will be taken to the AWS Management Console. In the top-left corner, you can search for services. Type “IAM” into the search bar and select “IAM”
(Identity and Access Management) from the results.
Navigate to Users
In the IAM Dashboard, look for the “Users” option in the left-hand sidebar and click on it.
 Select Your IAM User
On the “Users” page, you will see a list of IAM users if you have any. Click “Create user”
Type User name and select “Provide user access to the AWS Management Console Optional”.
Select “I want to create an IAM user”
Then click “Next”.
Review your choices and click “Create user”.
On the “Set permissions” page, you will see Permissions options.
Select “Attach policies directly” and choose “AdministratorAccess”.
Click “Next”.
Then copy and save your Console password and click “Return to users list”.
On the “IAM Users” page, you will see Users. Click your user name.
Under Summary dashboard you will see “Security credentials” tab. Click on it. 
Scroll down until Access keys dashboard. Click “Create access key”
On the “Access key best practices and alternatives” page, you will see Use case. Click
Command Line Interface (CLI) and Confirmation.
Then click next and Create access key.
On the “Retrieve access keys” page, you will see Access key and  Secret access key.  Copy and save your Access key and Secret access key.
Open your Linux terminal and run the following command:“aws configure”
Enter Your AWS Access Key ID. Copy and paste it from your AWS security credentials. Click Enter.
Enter Your AWS Secret Access Key: Copy and paste it from your AWS security credentials. 
Click Enter.
Default Region Name: Type “us-east-2”
Click Enter.
Default Output Format: Type “json”
Click Enter.
That`s it! Your AWS CLI is now configured on your Linux terminal. You can start using AWS CLI commands to interact with AWS services from your command line.

4. Write a bash script on the instance we created:
Get the Public key from the Instance we created and shot your local terminal with the command: “ssh ec2-user@ <public key>”
Create and write a bash script using the next code: vi <mane of the file, it should always end with .sh> e.g.  vi project4.sh and copy and paste the next code:

#!/bin/bash

region=us-east-2
az1=us-east-2a
az2=us-east-2b
az3=us-east-2c

ami_id=ami-01103fb68b3569475

key_name=my-laptop-key


# VPC named "vpc-group-4" with CIDR block 10.0.0.0/16

vpc_id=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --tag-specification "ResourceType=vpc,Tags=[{Key=Name,Value=vpc-group-4}]" --query Vpc.VpcId --output text)



# Security group named “sg-group-4"

sg_id=$(aws ec2 create-security-group --group-name Securitygroup4 --description "Demo Security Group" --vpc-id $vpc_id --query GroupId --output text)



#Open inbound ports 22, 80, 443 for everything in security group “sg-group-4"

aws ec2 authorize-security-group-ingress --group-id $sg_id --protocol tcp --port 22 --cidr 0.0.0.0/0 --region $region

aws ec2 authorize-security-group-ingress --group-id $sg_id --protocol tcp --port 80 --cidr 0.0.0.0/0 --region $region

aws ec2 authorize-security-group-ingress --group-id $sg_id --protocol tcp --port 443 --cidr 0.0.0.0/0 --region $region



# Create 3 public subnets: 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24 in each availability zones respectively (us-east-2a, us-east-2b, us-east-2c)

subnet1_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 10.0.1.0/24 --availability-zone $az1 --query Subnet.SubnetId --output text --region $region)

subnet2_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 10.0.2.0/24 --availability-zone $az2 --query Subnet.SubnetId --output text --region $region)
subnet3_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 10.0.3.0/24 --availability-zone $az3 --query Subnet.SubnetId --output text --region $region)



#Create Internet Gateway

igw_id=$(aws ec2 create-internet-gateway --query 
InternetGateway.InternetGatewayId --output text)

#Attach Internet Gateway to VPC “vpc-group-4"

aws ec2 attach-internet-gateway --vpc-id $vpc_id --internet-gateway-id $igw_id
 

# Launch EC2 Instance

aws ec2 run-instances --image-id $ami_id --subnet-id $subnet1_id --security-group-ids $sg_id --instance-type t2.micro --key-name $key_name --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=ec2-group-4}]" --region $region

# Optionally, you need to replace <AMI-ID>, <instance-type>, and <key-name> with appropriate values for your 
code
  

Once you paste this code, click the “esc” button and type “ :wq” and enter.
Make sure Script Executable: Before running your Bash script, you may need to make it executable.Use the chmod command:
Chmod +x    ~/script.sh
Finally, you can execute your bash script:
./script.sh

Go to you AWS Console ==> type “VPC” on the search bar, click “VPC”
Check  the VPC named "vpc-group-4" with CIDR block 10.0.0.0/16 is created. Scroll down on VPC Dashboard and click on “Security Group”
Check the “Security group named “sg-group-4”” is created. Click on security group and check the inbound rules on the bottom. 
Check if the ports 22, 80, 443 for everything in security group “sg-group-4” are open. 
Choose the “Subnet on the Dashboard. Check if 3 public subnets are created: 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24 in each availability zones respectively (us-east-2a, us-east-2b, us-east-2c)
Go to the Internet Gateway on Dashboard and check if it was created and attached to VPC “vpc-group-4”
Click EC2 Instance and check if “ec2-group-4” instance was launched.




5. Creating the GitHub Account:

Here`s a step-by-step explanation of how to create a GitHub account:

Visit GitHub`s Website
Open your web browser and go to GitHub`s official website:
[https://github.com/]( https://github.com/ ).

*Step 2: Start Sign-Up
On the GitHub homepage, click on the “Sign up” button, typically located in the upper right corner.
*Step 3: Enter Your Information
You`ll be directed to the Sign-Up page.
Fill in your **Username**: Choose a unique username that will be your GitHub handle.
Enter a valid **Email Address**: Use an email you have access to as GitHub will send a
verification email.
Create a **Password**: Choose a strong password following the provided guidelines.

*Step 4: Verify Your Account
After entering your information, click the “Next” or “Create account” button.
GitHub will send a verification email to the address you provided.
Check your email inbox for a message from GitHub and click the verification link inside it to confirm your email.
*Step 5: Complete Your Profile
Once your email is verified, you can return to GitHub.
You`ll be prompted to complete your profile. Add a profile picture and some basic information about yourself.

*Step 6: Choose Your Plan
GitHub offers both free and paid plans. For most users, the free plan is sufficient. Select the “Free” plan and click “Continue”.

*Step 7: Tailor Your Experience (Optional)

GitHub will ask you about your experience level and the type of work you plan to do. You can select your preferences, but this step is optional.

*Step 8: Verify Your Identity (Optional)
GitHub may ask for additional verification to confirm your identity. Follow the on-screen instructions if prompted.

*Step 9: Welcome to GitHub!
Once you`ve completed these steps, you`ll be directed to your GitHub dashboard.
Remember to keep your username and password secure. 

  6.  Push the code to GitHub account:
1 *Install Git:
  If Git is not already installed on your computer, download and install it from the [Git
website]( https://git-scm.com/ ).
2*Configure Git:
   Open a terminal or command prompt and set your name and email address for Git. Replace
`Your Name` and `your@email.com` with your actual name and email:
   ```
   git config --global user.name “Your Name”
   git config --global user.email “your@email.com"
   ```
3 *Create a New Repository on GitHub:
   Log in to your GitHub account, click the “+” icon in the top-right corner, and select “New Repository” Follow the prompts to create a new repository.

4 *Clone the Repository:

   On the repository`s page, click the green “Code” button and copy the URL provided. Then, in
your terminal, navigate to the directory where you want to store your project and run the
following command, replacing `repository_url` with the URL you copied:
   git clone repository_url
5 *Add Your Code:
   Move your project files into the cloned directory. You can also create new files directly in this
directory.

6 *Stage Your Changes:
   In your terminal, navigate to the repository directory. Use the following command to stage
your changes (replace `filename` with the actual filename or use `.` to stage all changes):
   git add filename
7 *Commit Your Changes:
   After staging your changes, commit them with a descriptive message:
   git commit -m “Your commit message here”

8 *Push to GitHub:
  Finally, push your committed changes to your GitHub repository:
   git push origin master
 If you`re using a different branch, replace `master` with the branch name.
9 *Authentication:
   If prompted, enter your GitHub username and password or, preferably, set up SSH keys for secure authentication.

10 *Check Your Repository:
 Go to your GitHub repository on the web, and you should see your code

