#  Introduction

This is a script with the sole purpose of deploying and configuring MongoDB in AWS EC2 instance


## BEFORE YOU RUN THE SCRIPT DO THE FOLLOWING

1. Check the `variables.tf` file and be sure that the `default` values are what you want.
2. In the `provider.tf` file, the default `aws region` I used is `eu-west-1` in `line 4`, please change to any region of your choice if you are not using that region.
3. In the `provider.tf` file, you can change the `availability_zone` to what you your preferred choice
4. In the `provider.tf` file, I commentted out the `shared_credentials_file` line because I am not sure if you would prefer to use that or just use the `access_key` & `secret_key` by copying your values from your AWS console and pasting them in the empty double qoutes.
**NB** WHATEVER YOU DO, PLEASE DO YOU PUSH THIS FILE TO THE CLOUD (GITHUB) WITH YOUR KEYS STILL THERE.

5. Before you run this script, ensure that you have a security group that only allows traffic to only these open ports `22`, `27017` and the `ICMP` port (The ICMP port is only necessary when you want to ping your instance, so its not really necessary). Also note that the only `IP address` that should have access to the database, should be blocked to the `/32` cidr group, so that only one IP address us able to access the instance. on each of the port mentioned above. 
However, if you choose to use a more relaxed firewall/security group rules, then thats fine.



## How to Run Script

1. Ensure that you have the following files:
     - `config.sh`
     - `disable-transparent-hugepages`
     - `provider.tf`
     - `variable.tf`
     - `remote_config.sh`
     - `.gitignore`

2. Ensure that you have `Terraform` Installed on your machine 
     - for `MacOS` users, please use this search result https://www.google.com/search?q=how+to+install+terraform+on+mac&oq=how+to+install+terraform&aqs=chrome.2.69i57j0l7.9577j0j1&sourceid=chrome&ie=UTF-8
     - for windows users, use this search result https://www.google.com/search?sxsrf=ACYBGNRsgU_RY30dzb7tvVvWrEvnK0J5yw%3A1580838410771&ei=Cq45Xr7VLoOQ8gKLj4S4CA&q=how+to+install+terraform+on+windows&oq=how+to+install+terraform+on+&gs_l=psy-ab.1.1.35i39j0i20i263j0l8.68888.69869..71317...1.2..0.245.836.0j2j2......0....1..gws-wiz.......0i71.RbIkDdqrxzw

3. When you are sure that `Terraform` is installed, in the current directory where the files in `item 1` are, run both if these commands `chmod 755 config.sh` & `chmod 755 remote_config.sh` to make both files executable files
4. When `1 - 3` have been done, then run the command `sudo ./remote_config.sh` and then the database would be created in the cloud.

