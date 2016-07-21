DevopsKata
==========


Hello, welcome to calphool/devopskata!
--------------------------------------

This repo holds a set of related bash, terraform, and ansible scripts that produce a reusable CI/CD pipeline in Amazon AWS for a github repo.


### Step 1.
---

To begin, you need to install the AWS CLI tools, which are [available here.](https://aws.amazon.com/cli/)
You will need to set up your AWS account so that you have a user that has AmazonEC2FullAccess permissions
(and IAM permissions sufficient to inquire to users).  (Follow the AWS CLI install process to get that 
account configured properly in your .aws folder)[http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html]
Note:  make sure your environment variables have been set properly and you can use the AWS CLI to do some
basic inquiry into your AWS environment before proceding.

### Step 2.
---
Clone this repo locally.  From inside the bootstrap/jenkinsmaster/ folder, run `source setenv.sh`.  Once this is done,
run `./start.sh`.  The script will ask you for four pieces of information:  your github user id, your github password, 
the name of a github repo you want to monitor, and the path to your .pem file from Step 1.

./start.sh will begin installing what it needs (terraform), and then it will start a provisioning process that 
builds three EC2 instances.


**Note:** the ./start.sh script has only been tested on a Mac at this point.  It probably doesn't work from a Linux distro right now.