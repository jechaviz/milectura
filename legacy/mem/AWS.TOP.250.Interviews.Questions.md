## TOP 250+ Interviews Questions on AWS

1. What is AWS?
> Amazon Web Services (AWS) is a platform that provides on-demand resources for hosting web services, storage, networking, databases and other resources over the internet with a pay-as-we-go pricing.

2. What are the components of AWS?
>- EC2 – Elastic Compute Cloud
>- S3 – Simple Storage Service
>- Route53
>- EBS – Elastic Block Store
>- Cloudwatch
>- Key-Paris
>- etc.

3. What are key-pairs?
> They're secure login information containing a public-key and private-key to login to instances/virtual machines in AWS.

4. What is S3?
> S3 (Simple Storage Service) is a storage service for any amount of data with payment model pay-as-we-go.

5. What are the pricing models for EC2 instances?
>1. On-demand
>2. Reserved
>3. Spot
>4. Scheduled
>5. Dedicated

6. What are the types of volumes for EC2 instances?
>1. Instance store volumes
>2. EBS – Elastic Block Stores

7. What are EBS volumes?
> Elastic Block Stores (EBS) are persistent volumes attachables to instances to preserve data when instances are stopped. Data is deleted when we stop the instances on instance store volumes. 

8. What are the types of volumes in EBS?
>1. General purpose
>2. Provisioned IOPS
>3. Magnetic
>4. Cold HDD
>5. Throughput optimized

9. What are the different types of instances?
>1. General purpose
>2. Computer Optimized
>3. Storage Optimized
>4. Memory Optimized
>5. Accelerated Computing

10. What is an auto-scaling and what are the components?
> Auto scaling allows us to automatically scale-up and scale-down the number of instances depending on the CPU utilization or memory utilization. There are 2 components in Auto scaling: Auto-scaling groups and Launch Configuration.

11. What are reserved instances?
> They're instances that we can reserve a fixed capacity of EC2 instances contracted 1 year or 3 years.

12. What is an AMI?
> Amazon Machine Image (AMI) is a template that contains 
>- software configurations
>- launch permission 
>- and a block device mapping 
> that specifies the volume to attach to the instance when it is launched.

13. What is an EIP?
> Elastic IP address (EIP) is a static IP address service for AWS instances. By default when we stop and restart an AWS instance, we get a new IP address each time.

14. What is Cloudwatch?
> Cloudwatch is a used to monitor the AWS resources like health check, network, Application, etc.

15. What are the monitoring types in Cloudwatch?
>- Basic (Free) 
>- Detailed (Chargeable).

16. What are the cloudwatch metrics that are available for EC2 instances?
> 1. Diskreads, 
> 2. Diskwrites, 
> 3. CPU utilization, 
> 4. networkpacketsIn, 
> 5. networkpacketsOut, 
> 6. networkIn, 
> 7. networkOut, 
> 8. CPUCreditUsage, 
> 9. CPUCreditBalance.

17. What is the size of individual objects that we can store in S3
> From 0 bytes to 5TB.

18. What are the different storage classes in S3?
>1. Standard **frequently** accessed (default)
>2. Standard **infrequently** accessed 
>3. Glacier
>4. Reduced Redundancy Storage (RRS)
>5. One-zone infrequently accessed.

19. What is the default storage class in S3?
>  The Standard **frequently** accessed.

20. What is Glacier?
> It's the back up or archival tool used to back up the data in S3.

21. What are the 2 ways to secure the access to the S3 bucket?
>1. ACL – Access Control List
>2. Bucket polices

22. How can we encrypt data in S3?
> By using Server Side Encryption of next types:
>- AES 256 encryption (S3)
>- Key management Service (KMS)
>- Client Side (C)

23. What are the parameters for S3 pricing model?
>1. Storage used
>2. Number of requests we make
>3. Storage management
>4. Data transfer
>5. Transfer acceleration

24. What is the pre-requisite to work with Cross region replication in S3?
>In both sthece bucket and destination:
>1. To enable versioning 
>2. They must be in different region.

25. What are roles?
> Roles are used to provide permissions to entities that we trust within the AWS account.
> Roles are users in another account. 
> Roles are similar to users but with roles we do not need to create any username and password to work with the resources.

26. What are policies and what are the types of policies?
> Policies are access permissions attachables to users created. There're 2 types:
>1. Managed policies
>2. Inline policies

27. What is Cloudfront?
> It's a Content Delivery Network (CDN) of AWS that provides businesses and application developers an easy and efficient way to distribute their content with low latency and high data transfer speeds.

28. What are Edge Locations (EL)?
> They're cached content locations. Normally the content will be got from an Edge Location, or content copy will be created in an Edge Location when not available . In last case, content will be got from the origin location.

29. What is the maximum individual archive that we can store in Glacier?
> Up to 40 TB.

30. What is VPC?
> Virtual Private Cloud (VPC) is a network logically isolated in the cloud. It allows easily customize the networking configuration. In a VPC we can have our own IP address range, subnets, internet gateways, NAT gateways and security groups.

31. What is VPC peering connection?
> It's a 1 to 1 VPC connection. Instances in these VPC behave as if they were in the same network.

32. What are NAT gateways?
> Network Address Translation gateways (NAT) enables instances in a private subnet to connect to the internet but prevent the internet from initiating a connection with those instances.

33. How can we control the security to the VPC?
> We can use security groups and Network Access Control List (NACL).

34. What are the different types of storage gateway?
>1. File
>2. Volume
>3. Tape

35. What is a Snowball?
> It's a a petabyte-scale data transport solution that uses secure appliances to transfer large amounts of data into and out of AWS with: 
>1. Reduced network costs
>2. Reduced transfer times 
>3. Better security.

36. What are the database types in RDS?
>1. Aurora
>2. Oracle
>3. MYSQL server
>4. Postgresql
>5. MariaDB
>6. SQL server

37. What is Amazon Redshift?
> It's a data warehouse in the cloud with fast and powerful, fully managed, petabyte scale.

38. What is SNS?
> Simple Notification Service (SNS) is a web service to receive email or message notifications easily from the cloud. 

39. What are the types of routing polices in Route 53?
>1. Simple routing
>2. Latency routing
>3. Failover routing
>4. Geolocation routing
>5. Weighted routing
>6. Geoproximity Routing Policy (Traffic Flow Only)
>7. Multivalue answer (Use when you want Route 53 to respond to DNS queries with up to 8 healthy records selected at random)

40. What is the maximum size of messages in SQS?
> 256 KB.

41. What are the types of queues in SQS?
>1. Standard Queue
>2. First In First Out (FIFO)

42. What is multi-AZ RDS?
> Multi-Availability Zone (AZ) RDS allows to have a replica of the production database in another Availability Zone. It's used for disaster recovery: if primary database goes down, the application will automatically failover to the standby exact copy database.

43. What are the types of backups in RDS database?
>1. Automated backups
>2. Manual backups which are known as snapshots.

44. What is the difference between security groups and network access control list?
>| Feature                                   | Security Groups   | Network access control list |
>| ----------------------------------------- | ----------------- | --------------------------- |
>| Can **control the access** at             | Instance level    | Subnet level                |
>| Can add rules for                         | "Allow" only      | "Allow" and "Deny"          |
>| Number of security groups that can assign | Unlimited         | Up to 5                     |
>| Evaluates rules when allowing the traffic | Before, All rules | Processed in order number   |
>| Filtering                                 | Statefull         | Stateless                   |

45. What are the types of load balancers in EC2?
>1. Application
>2. Classic
>3. Network

46. What is and ELB?
> Elastic Load balancing (ELB) it's a Load Distributor for the Incoming Application Traffic or Network Traffic across multiple targets, like EC2, containers and IP addresses.

47. What are the 2 types of access that we can provide when we are creating users?
>1. Console
>2. Programmatic 

48. What are the benefits of auto scaling?
>1. Better Availability
>2. Better Cost Management
>3. Better Fault Tolerance

49. What are security groups?
> They're a firewall that contains the traffic for one or more instances. 
> We can: 
>1. Associate one or more security groups to the instances when we launch them. 
>2. Add rules to each security group that allow traffic to and from its associated instances. 
>3. Modify the rules of a security group at any time, the new rules are automatically and immediately applied to all the instances that are associated with the security group

50. What are shared AMI's?
> Shared AMI's are the AMI that are created by other developed and made available for other developed to use.

51. What is the difference between Classic and Application Load Balancer?
>| Application Load Balancer | Classic Load Balancer |
>| ------------------------- | --------------------- |
>| Dynamic port mapping      | -                     |
>| Multiple port             | One port              |
>| Multiple listeners        | one listener          |

52. By default how many IP addresses does AWS reserve in a subnet?
> 5

53. What is meant by subnet?
> A large section of IP Address divided in to chunks

54. How can we convert a public subnet to private subnet?
> Remove IGW & add NAT Gateway, Associate subnet in Private route table

55. Is it possible to reduce a EBS volume?
> We can increase it but not reduce them, so, it's not possible, 

56. What is the use of Elastic IP? Are they charged by AWS?
> These are IPv4 address which are used to connect the instance from internet. 
> They are charged if the instances are not attached to it.

57. One of my S3 is bucket is deleted but I need to restore it, is there any possible way?
> If versioning is enabled we can easily restore them

58. When I try to launch an EC2 instance, I'm getting "Service limit Exceed", how to fix the issue?
> We need to contact AWS support to increase the limit based on the requirement (20 running instances per region is the value per default)

59. I need to modify the EBS volumes in Linux and Windows, is it possible?
> Yes, It's possible from console. To achieve the modification:
>1. Use modify volumes in section 
>2. Give the size we need 
>3. for Windows go to disk management 
>4. for Linux mount it 

60. Is it possible to stop a RDS instance? If so, how can I do that?
> RDS Instances which are non-production and non multi AZ's are possible to stop them. 

61. What are "Parameter Groups" in RDS and what is the Use of them?
> AWS offers a wide set of parameter in RDS, as parameter group, which is modified as per requirement

62. What is the use of tags and how they are useful?
> Tags are used for identification and grouping AWS Resources

63. I'm viewing an AWS Console, but unable to launch the instance, I receive an IAM Error, how can I rectify it?
> As AWS user I don't have access to use it, I need to have permissions to use it further.

64. I don't want my AWS Account ID to be exposed to users, how can I avoid it?
> In IAM console there is option as sign in url where I can rename my own account name with AWS account

65. By default, how many Elastic IP address does AWS Offer?
> 5 elastic IP per region

66. We have enabled sticky session with ELB. What does it do with the instance?
> Binds the user session with a specific instance

67. Which type of load balancer makes routing decisions at either the transport layer or the Application layer and supports either EC2 or VPC.
> Classic Load Balancer

68. Which is the Virtual Network Interface that we can attach to an instance in a VPC?
> Elastic Network Interface

69. We have launched a Linux instance in AWS EC2. While configuring security group, we have selected SSH, HTTP, HTTPS protocol. Why do we need to select SSH?
> To verify that there is a rule that allows traffic from EC2 Instance to the computer.

70. We have chosen a Windows instance with Classic and we want to make some change to the Security group. How will these changes be effective?
> Changes are automatically applied to Windows instances.

71. Which type of cloud service comes with Load Balancer and DNS service?
> IAAS-Storage

72. We have an EC2 instance that has an unencrypted volume. We want to create another encrypted volume from this unencrypted volume. What are the steps to achieve this?
>1. Create a snapshot of the unencrypted volume (applying encryption parameters)
>2. Copy the snapshot and 
>3. Create a volume from the copied snapshot

73. Where does the user specify the maximum number of instances with the auto scaling Commands?
> Auto scaling Launch Config

74. Which are the types of AMI provided by AWS?
>1. Instance Store backed
>2. EBS Backed

75. After configuring ELB, we need to ensure that the user requests are always attached to a Single instance. What setting can we use?
> Sticky session

76. When do I prefer to Provisioned IOPS over the Standard RDS storage?
> When we have batch-oriented workloads. Provisioned IOPS delivers high IO rates, but it is also expensive. However, batch processing workloads do not require manual intervention.

77. When running my DB instance as a Multi-AZ deployment, can I use the standby for read or write operations?
> No, the standby replica cannot serve read requests. Multi-AZ deployments are designed to provide enhanced database availability and durability, rather than read scaling benefits.

78. Which the AWS services that will we use to collect and process e-commerce data for near real-time analysis?
>- Amazon DynamoDB.
>- Amazon ElastiCache.
>- Amazon Elastic MapReduce.
>- Amazon Redshift.

79. A company is deploying the new two-tier web application in AWS. The company has limited staff and the requires high availability, and the application requires to do complex queries and table joins. Which configuration provides to the solution for company's requirements?
> Amazon DynamoDB. (Read http://www.allthingsdistributed.com/2013/03/dynamodb-one-year-later.html).

80. Which are use cases for Amazon DynamoDB?
>1. Storing JSON documents
>2. Storing metadata for S3 objects
>3. Running relational joins and complex updates
>4. Storing large amounts of infrequently accessed data

81. Our application has to the retrieve data from the user's mobile every 5 minutes and then data is stored in the DynamoDB. Later every day, at a particular time, the data is an extracted into S3 in a per user basis, and then, the application is later used to visualize the data to user. We are asked to optimize the architecture of the backend system to lower our cost; what would we recommend do in AWS?
> Introduce Amazon Elasticache since it reads from the Amazon DynamoDB table and reduce the provisioned read throughput.

82. We are running a website on EC2 instances deployed across multiple Availability Zones with a Multi-AZ RDS MySQL Extra Large DB Instance. The site performs a high number of small reads and writes per second and relies on an eventual consistency model. After comprehensive tests we discover that there is read contention on RDS MySQL. Which are the best approaches to meet these requirements?
>1. Deploy ElastiCache in-memory cache running in each availability zone
>2. Increase the RDS MySQL Instance size
>3. Implement provisioned IOPS.

83. A startup is running a pilot deployment of around 100 sensors to measure street noise and air quality in urban areas for 3 months. It was noted that every month around 4GB of sensor data is generated. The company uses a load balanced auto scaled layer of EC2 instances and a RDS database with 500 GB standard storage. The pilot was a success and now they want to deploy at least 100K sensors which need to be supported by the backend. We need to store the data for at least 2 years to analyze it. Which setup would we prefer?
> Replace the RDS instance with a 6 node Redshift cluster of 96TB of storage.

84. Let's suppose we have an application where do we have to render images and also do some of general computing. Which service will be best fit the need?
> Application Load Balancer. It supports path based routing, so it can take decisions based on the URL. Therefore, if the task needs image rendering, it will route it to a different instance; and for general computing, it will route it to a different instance.

85. How we will change the instance type for instances which are running in the applications tier and are using Auto Scaling? Where will we change it from areas?
> Changed to Auto Scaling launch configuration areas.

86. We have a CMS running on a EC2 instance approaching to 100% CPU of utilization. Which actions will reduce the load on the instance?
> Create a load balancer and register the Amazon EC2 instance with it.

87. What does the Connection of draining do?
> The re-routes traffic from the instances which are going to be updated or have failed in health check.

88. When an instance is unhealthy, it's terminated and replaced with a new one. Which service does that?
> Fault tolerance.

89. What are the life cycle hooks used for the AutoScaling?
> They are used to the put an additional wait time to the scale in our scale out events.

90. A user has to setup an Auto Scaling group. Due to some issue the group has failed for launch a single instance for more than 24 hours. What will be happen to the Auto Scaling in the condition?
> The auto Scaling will suspend the scaling process.

91. We have an EC2 Security Group with several running EC2 instances. We changed the Security Group rules to allow inbound traffic on a new port and protocol, and then launch several new instances in the same Security Group. The new rules apply...
> Immediately to all the instances in the security group.

92. We would like to create a mirror image of the production environment in another region, for disaster recovery purposes. Which AWS resources do not need to be recreated in the second region?
>1. Route 53 Record Sets.
>2. IAM Roles

93. A company needs to capture all client connection information from its Application Load Balancer every 5 minutes. This data will be used to analyze traffic patterns and troubleshoot the application. How can we meet this requirement?
> Enable CloudTrail (AWS service that helps you enable operational and risk auditing, governance, and compliance of your account. Actions taken by a user, role, or an AWS service are recorded as events) on the Application Load Balancer.

94. Which of the services we can not use to deploy an app?
> AWS Lambda.

95. How does Elastic Beanstalk can apply updates?
> By duplicate ready with updates prepare before swapping.

96. I created a key in Oregon Region to encrypt my data in North Virginia Region for security purposes. Then I added 2 users to the key and the external AWS accounts. I wanted to encrypt an object in S3, but then the key I just created is not listed. What could be the reason & the solution?
> The key should be working in the same region.

97. A company needs to monitor the read and write IOPs metrics for their AWS MySQL RDS instance and send real-time alerts to their operations team. Which AWS services can accomplish this?
> Amazon CloudWatch and Amazon Route 53

98. An organization that is currently using consolidated billing has recently acquired another company that already has a number of AWS accounts. How could an Administrator ensure that all AWS accounts, from both the existing company and the acquired company, are billed to a single account?
> Invite the acquired company's AWS account to join the existing company's organization using AWS Organizations.

99. A user has created an application which will be hosted on EC2. The application makes API calls to DynamoDB to fetch certain data. The application running on this instance is using the SDK for making these calls to DynamoDB. Mention a best practice for security in this scenario?
> The user should attach an IAM role to the EC2 instance with necessary permissions for making API calls to DynamoDB. 

100. You have an application running on an EC2 Instance which will allow users to download files from a private S3 bucket using a pre-signed URL. Before generating the URL the application should verify the existence of the file in S3. How should the application use AWS credentials to access the S3 bucket securely?
> Create an IAM role for the EC2 that allows list access to objects in S3 buckets. 
> Launch to instance with this role, and retrieve an role's credentials from EC2 Instance metadata.

101. You use Amazon CloudWatch as the primary monitoring system for the web application. After a recent software deployment, the users are getting Intermittent 500 Internal Server Errors when using the web application. You want to create a CloudWatch alarm, and notify an on-call engineer when these occur. How can you accomplish this using AWS services?
>- Install a CloudWatch Logs Agent on the servers to stream web application logs to CloudWatch.
>- Create a CloudWatch Logs group and define metric filters that capture 500 Internal Server Errors. Set a CloudWatch alarm on that metric. 
>- Use Amazon Simple Notification Service to notify an on-call engineer when a CloudWatch alarm is triggered.

102. You are designing a multi-platform web application for AWS. The application will run on EC2 instances and will be accessed from PCs. Tablets and smart phones
Supported accessing platforms are Windows, MacOS, IOS and Android Separate sticky session and SSL certificate setups are required for different platform types.
Which is the most cost effective and performance efficient architecture setup?
> Assign multiple ELBS to an EC2 instance or group of EC2 instances running the common components of the web application, one ELB for each platform type Session stickiness and SSL termination are done at the ELBs. 
> Explanation: One ELB cannot handle different SSL certificates but since we are using sticky sessions it must be handled at the ELB level. SSL could be handled on the EC2 instances only with TCP configured ELB, ELB supports sticky sessions only in HTTP/HTTPS configurations.
> The way the Elastic Load Balancer does session stickiness is on a HTTP/HTTPS listener is by utilizing an HTTP cookie. If SSL traffic is not terminated on the Elastic Load Balancer and is terminated on the back-end instance, the Elastic Load Balancer has no visibility into the HTTP headers and therefore can not set or read any of the HTTP headers being passed back and forth.

103. You are migrating a legacy client-server application to AWS. The application responds to a specific DNS domain (e.g. www.example.com) and has a 2-tier architecture, with multiple application servers and a database server. Remote clients use TCP to connect to the application servers. The application servers need to know the IP address of the clients in order to function properly and are currently taking that information from the TCP socket. A Multi-AZ RDS MySQL instance will be used for the database. During the migration you can change the application code, but you have to file a change request. How would you implement the architecture on AWS in order to maximize scalability and high availability?
> File a change request to implement Proxy Protocol support In the application. Use an ELB with a TCP Listener and Proxy Protocol enabled to distribute load on two application servers in different AZs.

104. The application currently leverages AWS Auto Scaling to grow and shrink as load Increases/ decreases and has been performing well. The marketing team expects a steady ramp up in traffic to follow an upcoming campaign that will result in a 20x growth in traffic over 4 weeks. The forecast for the approximate number of Amazon EC2 instances necessary to meet the peak demand is 175. What should you do to avoid potential service disruptions during the ramp up in traffic?
> Check the service limits in Trusted Advisor and adjust as necessary so the forecasted count remains within limits.

105. You have a web application running on 6 Amazon EC2 instances, consuming about 45% of resources on each instance. You are using auto-scaling to make sure that 6 instances are running at all times. The number of requests this application processes is consistent and does not experience spikes. The application is critical to the business and you want high availability at all times. You want the load to be distributed evenly between all instances. You also want to use the same Amazon Machine Image (AMI) for all instances. Which architectural choice should you make?
> Deploy 3 EC2 instances in one availability zone and 3 in another availability zone and use Amazon Elastic Load Balancer.

106. You are designing an application that contains protected health information. Security and compliance requirements for the application mandate that all protected health information in the application use encryption at rest and in transit. The application uses a three-tier architecture where data flows through the load balancer and is stored on Amazon EBS volumes for processing, and the results are stored in Amazon S3 using the AWS SDK. Which of the following two options satisfy the security requirements?
> Use 
> TCP load balancing on the load balancer, 
> SSL termination on the Amazon EC2 instances, 
> OS-level disk encryption on the Amazon EBS volumes, 
> and Amazon S3 with server-side encryption.

107. A startup deploys its photo-sharing site in a VPC. An elastic load balancer distributes web traffic across two subnets. The load balancer session stickiness is configured to use the AWS-generated session cookie, with a session TTL of 5 minutes. The web server Auto Scaling group is configured as min-size=4, max-size=4. The startup is preparing for a public launch, by running load-testing software installed on a single Amazon Elastic Compute Cloud (EC2) instance running in us-west-2a. After 60 minutes of load-testing, the web server logs show the following:
| Webserver Logs                      | HTTP requests on load-tester | HTTP requests from private beta users |
| ----------------------------------- | ---------------------------- | ------------------------------------- |
| webserver #1 (subnet in us-west-2a) | 19,210                       | 434                                   |
| webserver #2 (subnet in us-west-2a) | 21,790                       | 490                                   |
| webserver #3 (subnet in us-west-2b) | 0                            | 410                                   |
| webserver #4 (subnet in us-west-2b) | 0                            | 428                                   |

Which recommendations can help ensure that load-testing HTTP requests are evenly distributed across the fthe web servers?
>- Re-configure the load-testing software to re-resolve DNS for each web request
>- Use a third-party load-testing service which offers globally distributed test clients

108. To serve Web traffic for a popular product the Chief Financial Officer and IT director have purchased 10 m1.large heavy utilization Reserved Instances (RIs), evenly spread across two availability zones; Route 53 is used to deliver the traffic to an Elastic Load Balancer (ELB). After several months, the product grows even more popular and you need additional capacity. As a result, the company purchases two C3.2xlarge medium utilization RIs. You register the two c3.2xlarge instances with the ELB and quickly find that the m1.large instances are at 100% of capacity and the c3.2xlarge instances have significant capacity that's unused. Which option is the most cost effective and uses EC2 capacity most effectively?
> Use a separate ELB for each instance type and distribute load to ELBs with Route 53 weighted round robin.

109. An AWS customer is deploying a web application that is the composed of a front-end running on the Amazon EC2 and confidential data that are stored on Amazon S3. The customer security policy is that all accessing operations to this sensitive data must authenticated and authorized by centralized access to management system that is operated by separate security team. In addition, the web application team that owns and administers the EC2 web front-end instances is prohibited from having any ability to access data that circumvents this centralized access to management system. Which are configurations will support these requirements?
> Configure the web application to get authenticate end-users against the centralized access on the management system. 
> Have a web application provision trusted to users STS tokens an entitling the download of the approved data directly from a Amazon S3.

110. A Enterprise customer is starting on their migration to the cloud, their main reason for the migrating is agility and they want to the make their internal Microsoft Active Directory available to many applications running on AWS, so internal users only have to remember one set of the credentials and as a central point, user take control for the leavers and joiners. How could they make their actions secure and highly available with minimal on-premises on infrastructure changes in the most cost and the timeefficient way?
> By Using a VPC, they could create an the extension to their data center and to make use of resilient hardware IPSEC on tunnels, 
> they could then have two domain consider to controller instances that are joined to the existing domain and reside within the different subnets in the different availability zones.

111. What is Cloud Computing?
> Cloud computing means it provides services to access programs, application, storage, network, server over the internet through browser or client side application on the PC, Laptop, Mobile by the end user without installing, updating and maintaining them.

112. Why we go for Cloud Computing?
>- Lower computing cost
>- Improved Performance
>- No IT Maintenance
>- Business connectivity
>- Easily upgraded
>- Device Independent

113. What are the deployment models using in Cloud?
>- Private Cloud
>- Public Cloud
>- Hybrid cloud
>- Community cloud

114. Explain Cloud Service Models?
>- SAAS (Software as a Service): It is software distribution model in which application are hosted by a vendor over the internet for the end user freeing from complex software and hardware management. (Ex: Google drive, drop box) 
>- PAAS (Platform as a Service): It provides platform and environment to allow developers to build applications. It frees developers without going into the complexity of building and maintaining the infrastructure. (Ex: AWS Elastic Beanstalk, Windows Azure)
>- IAAS (Infrastructure as a Service): It provides virtualized computing resources over the internet like cpu, memory, switches, routers, firewall, Dns, Load balancer (Ex: Azure, AWS)

115. What are the advantage of Cloud Computing?
>- Pay per use
>- Scalability
>- Elasticity
>- High Availability
>- Increase speed and Agility
>- Go global in Minutes

116. What is AWS?
> Amazon web service is a secure cloud services platform offering compute, power, database, storage, content delivery and other functionality to help business scale and grow. AWS is fully on-demand AWS is Flexibility, availability and Scalability AWS is Elasticity: scale up and scale down as needed.

117. What is mean by Region, Availability Zone and Edge Location?
> Region: An independent collection of AWS resources in a defined geography. A collection of Data centers (Availability zones). All availability zones in a region connected by high bandwidth.
> Availability Zones: An Availability zone is a simply a data center. Designed as independent failure zone. High speed connectivity, Low latency.
> Edge Locations:  Are CDN endpoints for cloud front in AWS Infrastructure to deliver content to end user with low latency

118. How to access AWS Platform?
>- AWS Console
>- AWS CLI (Command line interface)
>- AWS SDK (Software Development Kit)

119. What is EC2? What are the benefits in EC2?
> Amazon Elastic compute cloud is a web service that provides resizable compute capacity in the cloud.AWS EC2 provides scalable computing capacity in the AWS Cloud. These are the virtual servers also called as an instances. We can use the instances pay per use basis.
> Benefits:
>- Easier and Faster
>- Elastic and Scalable
>- High Availability
>- Cost-Effective

120. What are the pricing models available in AWS EC2?
>- On-Demand Instances
>- Reserved Instances
>- Spot Instances
>- Dedicated Host

121. What are the types using in AWS EC2?
>- General Purpose
>- Compute Optimized
>- Memory optimized
>- Storage Optimized
>- Accelerated Computing (GPU Based)

122. What is AMI? What are the types in AMI?
> Amazon machine image is a special type of virtual appliance that is used to create a virtual machine within the amazon Elastic compute cloud. AMI defines the initial software that will be in an instance when it is launched.
> Types of AMI:
>- Published by AWS
>- AWS Marketplace
>- Generated from existing instances
>- Uploaded virtual server

123. How to Addressing AWS EC2 instances?
>- Public Domain name system (DNS) name: When we launch an instance AWS creates a DNS name that can be used to access the
>- Public IP: A launched instance may also have a public IP address This IP address assigned from the address reserved by AWS and cannot be specified.
>- Elastic IP: An Elastic IP Address is an address unique on the internet that we reserve independently and associate with Amazon EC2 instance. This IP Address persists until the customer release it and is not tried to

124. What is Security Group?
> AWS allows we to control traffic in and out of the instance through virtual firewall called Security groups. Security groups allow we to control traffic based on port, protocol and sthece/Destination.

125. When the instance show retired state?
> Retired state only available in Reserved instances. Once the reserved instance reserving time (1 yr/3 yr) ends it shows Retired state.

126. Scenario: My EC2 instance IP address change automatically while instance stop and start. What is the reason for that and explain solution?
> AWS assigned Public IP automatically but it's change dynamically while stop and start. In that case we need to assign Elastic IP for that instance, once assigned it doesn't change automatically.

127. What is Elastic Beanstalk?
> AWS Elastic Beanstalk is the fastest and simplest way to get an application up and running on AWS. Developers can simply upload their code and the service automatically handle all the details such as resource provisioning, load balancing, Auto scaling and Monitoring.

128. What is Amazon Lightsail?
> Lightsail designed to be the easiest way to launch and manage a virtual private server with AWS.Lightsail plans include everything we need to jumpstart the project a virtual machine, ssd based storage, data transfer, DNS Management and a static ip.

129. What is EBS?
> Amazon EBS Provides persistent block level storage volumes for use with Amazon EC2 instances. Amazon EBS volume is automatically replicated with its availability zone to protect component failure offering high availability and durability. Amazon EBS volumes are available in a variety of types that differ in performance characteristics and Price.

130. How to compare EBS Volumes?
> Magnetic Volume: Magnetic volumes have the lowest performance characteristics of all Amazon EBS volume types.

> EBS Volume size: 
>- 1 GB to 1 TB 
>- Average IOPS: 100 IOPS 
>- Maximum throughput: 40-90 MB 
>- General-Purpose SSD: General purpose SSD volumes offers cost-effective storage that is ideal for a broad range of workloads. They're billed based on the amount of data space provisioned regardless of how much of data we actually store on the volume.
> EBS Volume size: 1 GB to 16 TB Maximum IOPS: upto 10000 IOPS Maximum throughput: 160 MB Provisioned IOPS SSD: Provisioned IOPS SSD volumes are designed to meet the needs of I/O intensive workloads, particularly database workloads that are sensitive to storage performance and consistency in random access I/O throughput. Provisioned IOPS SSD Volumes provide predictable, High performance.
> EBS Volume size: 4 GB to 16 TB Maximum IOPS: upto 20000 IOPS Maximum throughput: 320 MB

131. What is cold HDD and Throughput-optimized HDD?
> Cold HDD: Cold HDD volumes are designed for less frequently accessed workloads. These volumes are significantly less expensive than throughput-optimized HDD volumes.
> EBS Volume size: 500 GB to 16 TB Maximum IOPS: 200 IOPS Maximum throughput: 250 MB Throughput-Optimized HDD: Throughput-optimized HDD volumes are low cost HDD volumes designed for frequent access, throughput-intensive workloads such as big data, data warehouse.
> EBS Volume size: 500 GB to 16 TB Maximum IOPS: 500 IOPS Maximum throughput: 500 MB

132. What is Amazon EBS-Optimized instances?
> Amazon EBS optimized instances to ensure that the Amazon EC2 instance is prepared to take advantage of the I/O of the Amazon EBS Volume. An amazon EBS-optimized instance uses an optimized configuration stack and provide additional dedicated capacity for Amazon EBS I/When we select Amazon EBS-optimized for an instance we pay an additional hthely charge for that instance.

133. What is EBS Snapshot?
>- It can back up the data on the EBS Volume. Snapshots are incremental backups.
>- If this is the first snapshot it may take some time to create. Snapshots are point in time copies of volumes.

134. How to connect EBS volume to multiple instance?
> We can't able to connect EBS volume to multiple instance, but we can able to connect multiple EBS Volume to single instance.

135. What are the virtualization types available in AWS?
> Hardware assisted Virtualization: HVM instances are presented with a fully virtualized set of hardware and they executing boot by executing master boot record of the root block device of the image. It is default Virtualization.
> Para virtualization: This AMI boot with a special boot loader called PV-GRUB. The ability of the guest kernel to communicate directly with the hypervisor results in greater performance levels than other virtualization approaches but they cannot take advantage of hardware extensions such as networking, GPU etc. Its customized Virtualization image. Virtualization image can be used only for particular service.

136. Differentiate Block storage and File storage?
> Block Storage: Block storage operates at lothe level, raw storage device level and manages data as a set of numbered, fixed size blocks.
> File Storage: File storage operates at a higher level, the operating system level and manage data as a named hierarchy of files and folders.

137. What are the advantage and disadvantage of EFS? 
> Advantages:
>- Fully managed service
>- File system grows and shrinks automatically to petabyte
>- Can support thousands of concurrent connections
>- Multi AZ replication
>- Throughput scales automatically to ensure consistent low latency 
> Disadvantages:
>- Not available in all region
>- Cross region capability not available
>- More complicated to provision compared to S3 and EBS

138. What are the things we need to remember while creating S3 bucket?
>- Amazon S3 and Bucket names must be unique across all AWS. Bucket names can contain upto 63 lothecase letters, numbers, hyphens and we can create and use multiple buckets we can have upto 100 per account

139. What are the storage class available in Amazon S3?
>- Amazon S3 Standard
>- Amazon S3 Standard-Infrequent Access
>- Amazon S3 Reduced Redundancy Storage
>- Amazon Glacier

140. Explain Amazon S3 lifecycle rules?
> Amazon S3 lifecycle configuration rules, we can significantly reduce the storage costs by automatically transitioning data from one storage class to another or even automatically delete data after a period of time.

>- Store backup data initially in Amazon S3 Standard
>- After 30 days, transition to Amazon Standard IA
>- After 90 days, transition to Amazon Glacier
>- After 3 years, delete

141. What is the relation between Amazon S3 and AWS KMS?
> To encrypt Amazon S3 data at rest, we can use several variations of Server-Side Encryption. 
> Amazon S3 encrypts the data at the object level as it writes it to disks in its data centers and decrypt it for we when we access it'll SSE performed by Amazon S3 and AWS Key Management Service (AWS KMS) uses the 256-bit Advanced Encryption Standard (AES).

142. What is the function of cross region replication in Amazon S3?
> Cross region replication is a feature allows we asynchronously replicate all new objects in the sthece bucket in one AWS region to a target bucket in another region. To enable cross-region replication, versioning must be turned on for both sthece and destination buckets. Cross region replication is commonly used to reduce the latency required to access objects in Amazon S3

143. How to create Encrypted EBS volume?
> we need to select Encrypt this volume option in Volume creation page. While creation a new master key will be created unless we select a master key that we created separately in the service. Amazon uses the AWS key management service (KMS) to handle key management.

144. Explain stateful and Stateless firewall.
> Stateful Firewall: A Security group is a virtual stateful firewall that controls inbound and outbound network traffic to AWS resources and Amazon EC2 instances. Operates at the instance level. It supports allow rules only. Return traffic is automatically allowed, regardless of any rules.
> Stateless Firewall: A Network access control List (ACL) is a virtual stateless firewall on a subnet level. Supports allow rules and deny rules. Return traffic must be explicitly allowed by rules.

145. What is NAT Instance and NAT Gateway?
> NAT instance: A network address translation (NAT) instance is an Amazon Linux machine Image (AMI) that is designed to accept traffic from instances within a private subnet, translate the sthece IP address to the Public IP address of the NAT instance and forward the traffic to IWG. 
> NAT Gateway: A NAT gateway is an Amazon managed resources that is designed to operate just like a NAT instance but it is simpler to manage and highly available within an availability Zone. To allow instance within a private subnet to access internet resources through the IGW via a NAT gateway.

146. What is VPC Peering?
> Amazon VPC peering connection is a networking connection between two amazon vpc's that enables instances in either Amazon VPC to communicate with each other as if they are within the same network. we can create amazon VPC peering connection between the own Amazon VPC's or Amazon VPC in another AWS account within a single region.

147. What is MFA in AWS?
> Multi factor Authentication can add an extra layer of security to the infrastructure by adding a second method of authentication beyond just password or access key.

148. What are the Authentication in AWS?
>- User Name/Password
>- Access Key
>- Access Key/ Session Token

149. What is Data warehouse in AWS?
> Data ware house is a central repository for data that can come from one or more stheces. Organization typically use data warehouse to compile reports and search the database using highly complex queries.
> Data warehouse also typically updated on a batch schedule multiple times per day or per hthe compared to an OLTP (Online Transaction Processing) relational database that can be updated thousands of times per second.

150. What is mean by Multi-AZ in RDS?
> Multi AZ allows we to place a secondary copy of the database in another availability zone for disaster recovery purpose. Multi AZ deployments are available for all types of Amazon RDS Database engines. When we create s Multi-AZ DB instance a primary instance is created in one Availability Zone and a secondary instance is created by another Availability zone.

151. What is Amazon Dynamo DB?
> Amazon Dynamo DB is fully managed NoSQL database service that provides fast and predictable performance with seamless scalability. Dynamo DB makes it simple and Cost effective to store and retrieve any amount of data.

152. What is cloud formation?
> Cloud formation is a service which creates the AWS infrastructure using code. It helps to reduce time to manage resources. We can able to create the resources Quickly and faster.

153. How to plan Auto scaling?
>- Manual Scaling
>- Scheduled Scaling
>- Dynamic Scaling

154. What is Auto Scaling group?
> Auto Scaling group is a collection of Amazon EC2 instances managed by the Auto scaling service. Each auto scaling group contains configuration options that control when auto scaling should launch new instance or terminate existing instance.

155. Differentiate Basic and Detailed monitoring in cloud watch?
> Basic Monitoring: Basic monitoring sends data points to Amazon cloud watch every five minutes for a limited number of preselected metrics at no charge.
> Detailed Monitoring: Detailed monitoring sends data points to amazon CloudWatch every minute and allows data aggregation for an additional charge.

156. What is the relationship between Route53 and Cloud front?
> In Cloud front we will deliver content to edge location wise so here we can use Route 53 for Content Delivery Network. Additionally, if we are using Amazon CloudFront we can configure Route 53 to route Internet traffic to those resources.

157. What are the routing policies available in Amazon Route53?
>- Simple
>- Weighted
>- Latency Based
>- Failover
>- Geolocation

158. What is Amazon ElastiCache?
> Amazon ElastiCache is a web services that simplifies the setup and management of distributed in memory caching environment.
>- Cost Effective
>- High Performance
>- Scalable Caching Environment
>- Using Memcached or Redis Cache Engine

159. What is SES, SQS and SNS?
> SES (Simple Email Service): SES is SMTP server provided by Amazon which is designed to send bulk mails to customers in a quick and cost-effective manner.SES does not allows to configure mail server.
> SQS (Simple Queue Service): SQS is a fast, reliable and scalable, fully managed message queuing service. Amazon SQS makes it simple and cost Effective. It's temporary repository for messages to waiting for processing and acts as a buffer between the component producer and the consumer.
> SNS (Simple Notification Service): SNS is a web service that coordinates and manages the delivery or sending of messages to recipients.

160. How To Use Amazon Sqs? What Is Aws?
> Amazon Web Services is a secure cloud services stage, offering compute pothe, database storage, content delivery and other functionality to help industries scale and grow.

161. What is the importance of buffer in AWS?
> low price – Consume only the amount of calculating, storage and other IT devices needed. No long-term assignation, minimum spend or up-front expenditure is required.
> Elastic and Scalable – Quickly Rise and decrease resources to applications to satisfy customer demand and control costs. Avoid provisioning maintenance up-front for plans with variable consumption speeds or low lifetimes.

162. What is the way to secure data for resounding in the cloud?
>- Avoid storage sensitive material in the cloud. …
>- Read the user contract to find out how the cloud service storing works. …
>- Be serious about passwoRDS. …
>- Encrypt. …
>- Use an encrypted cloud service.

163. Name The Several Layers Of Cloud Computing?
> Cloud computing can be damaged up into three main services: Software-as-a-Service (SaaS),
> Infrastructure-as-a-Service (IaaS) and Platform-as-a-Service (PaaS). PaaS in the middle, and IaaS on the lowest

164. What Is Lambda edge In Aws?
> Lambda Edge lets we run Lambda functions to modify satisfied that Cloud Front delivers, executing the functions in AWS locations closer to the viethe. The functions run in response to Cloud Front events, without provisioning or managing server.

165. Distinguish Between Scalability And Flexibility?
> Cloud computing offers industries flexibility and scalability when it comes to computing needs:
> Flexibility. Cloud computing agrees the workers to be more flexible – both in and out of the workplace. Workers can access files using web-enabled devices such as smartphones, laptops and notebooks. In this way, cloud computing empothes the use of mobile technology.
> One of the key assistances of using cloud computing is its scalability. Cloud computing allows the business to easily expensive or downscale the IT requests as and when required. For example, most cloud service workers will allow we to increase the existing resources to accommodate increased business needs or changes. This will allow we to support the commercial growth without exclusive changes to the present IT systems.

166. What is IaaS?
> IaaS is a cloud service that runs services on “pay-for-what-we-use” basis. IaaS workers include Amazon Web Services, Microsoft Azure and Google Compute Engine Users: IT Administrators

167. What is PaaS?
> PaaS runs cloud platforms and runtime environments to develop, test and manage software Users: Software Developers

168. What is SaaS?
> In SaaS, cloud workers host and manage the software application on a pay-as-we-go pricing model Users: End Customers

169. Which Automation Gears Can Help With Spinup Services?
> The API tools can be used for spin up services and also for the written scripts. Persons scripts could be coded in Perl, bash or other languages of the preference. There is one more option that is flothey management and stipulating tools such as a dummy or improved descendant. A tool called Scalar can also be used and finally we can go with a controlled explanation like a Right scale. Which automation gears can help with pinup service.

170. What Is an Ami? How Do I Build One?
> An Amazon Machine Image (AMI) explains the programs and settings that will be applied when we launch an EC2 instance. Once we have finished organizing the data, services, and submissions on the ArcGIS Server instance, we can save the work as a custom AMI stored in Amazon EC2. we can scale out the site by using this institution AMI to launch added instances Use the following process to create the own AMI using the AWS Administration Console:
>*Configure an EC2 example and its attached EBS volumes in the exact way we want them created in the custom AMI.
>1. Log out of the instance, but do not stop or terminate it.
>2. Log in to the AWS Management Console, display the EC2 page for the region, then click Instances.
>3. Choose the instance from which we want to create a custom AMI.
>4. Click Actions and click Create Image.
>5. Type a name for Image Name that is easily identifiable to we and, optionally, input text for Image Description.
>6. Click Create Image.
>7. Read the message box that appears. To view the AMI standing, go to the AMIs page. 
> Here we can see the AMI being created. It can take a though to create the AMI. Plan for at least 20 minutes, or slower if we've connected a lot of additional applications or data.

171. What Are The Main Features Of Amazon Cloud Front?
> Amazon Cloud Front is a web service that speeds up delivery of the static and dynamic web content, such as .html, .css, .js, and image files, to the users.CloudFront delivers the content through
> a universal network of data centers called edge locations

172. What Are The Features Of The Amazon EC2 Service?
> Amazon Elastic Calculate Cloud (Amazon EC2) is a web service that provides secure, resizable compute capacity in the cloud. It is designed to make web-scale cloud calculating easier for designers. Amazon EC2's simple web serviceinterface allows we to obtain and configure capacity with minimal friction.

173. Explain Storage For Amazon EC2 Instance.?
> An instance store is a provisional storing type located on disks that are physically attached to a host machine. … This article will present we to the AWS instance store storage type, compare it to AWS Elastic Block Storage (AWS EBS), and show we how to backup data stored on instance stores to AWS EBS Amazon SQS is a message queue service used by scattered requests to exchange messages through a polling model, and can be used to decouple sending and receiving components

174. When attached to an Amazon VPC which two components provide connectivity with external networks?
>- Internet Gateway {IGW)
>- Virtual Private Gateway (VGW)

175. Which of the following are characteristics of Amazon VPC subnets?
>- Each subnet maps to a single Availability Zone.
>- By defaulting, all subnets can route between each other, whether they are private or public.

176. How can we send request to Amazon S3?
> Every communication with Amazon S3 is either genuine or anonymous. Authentication is a process of validating the individuality of the requester trying to access an Amazon Web Services (AWS) product. Genuine requests must include a autograph value that authenticates the request sender. The autograph value is, in part, created from the requester's AWS access keys (access key identification and secret access key).

177. What is the best approach to anchor information for conveying in the cloud ?
> Backup Data Locally. A standout amongst the most vital interesting points while overseeing information is to guarantee that we have reinforcements for the information,
>- Avoid Storing Sensitive Information. …
>- Use Cloud Services that Encrypt Data. …
>- Encrypt the Data. …
>- Install Anti-infection Software. …
>- Make PasswoRDS Stronger. …
>- Test the Security Measures in Place.

178. What is AWS Certificate Manager?
> AWS Certificate Manager is an administration that lets we effortlessly arrangement, oversee, and send open and private Secure Sockets Layer/Transport Layer Security (SSL/TLS) endorsements for use with AWS administrations and the inward associated assets. SSL/TLS declarations are utilized to anchor arrange interchanges and set up the character of sites over the Internet and additionally assets on private systems. AWS Certificate Manager expels the tedious manual procedure of obtaining, transferring, and reestablishing SSL/TLS endorsements.

179. What is the AWS Key Management Service
> AWS Key Management Service (AWS KMS) is an overseen benefit that makes it simple for we to make and control the encryption keys used to scramble the information. … AWS KMS is additionally coordinated with AWS CloudTrail to give encryption key use logs to help meet the inspecting, administrative and consistence needs.

180. What is Amazon EMR?
> Amazon Elastic MapReduce (EMR) is one such administration that gives completely oversaw facilitated Hadoop system over Amazon Elastic Compute Cloud (EC2).

181. What is Amazon Kinesis Firehose ?
> Amazon Kinesis Data Firehose is the least demanding approach to dependably stack gushing information into information stores and examination devices. … It is a completely overseen benefit that consequently scales to coordinate the throughput of the information and requires no continuous organization

182. What Is Amazon CloudSearch and its highlights ?
> Amazon CloudSearch is a versatile cloud-based hunt benefit that frames some portion of Amazon Web Services (AWS). CloudSearch is normally used to incorporate tweaked seek abilities into different applications. As indicated by Amazon, engineers can set a pursuit application up and send it completely in under 60 minutes.

183. Is it feasible for an EC2 exemplary occurrence to wind up an individual from a virtual private cloud?
> Amazon Virtual Private Cloud (Amazon VPC) empothes we to characterize a virtual system in the very own consistently disengaged zone inside the AWS cloud, known as a virtual private cloud (VPC). we can dispatch the Amazon EC2 assets, for example, occasions, into the subnets of the VPC. the VPC nearly looks like a conventional system that we may work in the very own server farm, with the advantages of utilizing adaptable foundation from AWS. we can design the VPC; we can choose its IP address extend, make subnets, and arrange cthese tables, organize portals, and security settings. we can interface occurrences in the VPC to the web or to the own server farm

184. Mention crafted by an Amazon VPC switch.
> VPCs and Subnets. A virtual private cloud (VPC) is a virtual system committed to the AWS account. It is consistently segregated from other virtual systems in the AWS Cloud. we can dispatch the AWS assets, for example, Amazon EC2 cases, into the VPC.

185. How would one be able to associate a VPC to corporate server farm?
> AWS Direct Connect empothes we to safely associate the AWS condition to the onpremises server farm or office area over a standard 1 gigabit or 10 gigabit Ethernet fiber-optic association. AWS Direct Connect offers committed fast, low dormancy association, which sidesteps web access suppliers in the system way. An AWS Direct Connect area gives access to Amazon Web Services in the locale it is related with, and also access to different US areas. AWS Direct Connect enables we to consistently parcel the fiber-optic associations into numerous intelligent associations called Virtual Local Area Networks (VLAN). we can exploit these intelligent associations with enhance security, separate traffic, and accomplish consistence necessities.

186. Is it conceivable to push off S3 with EC2 examples ?
> Truly, it very well may be pushed off for examples with root approaches upheld by local event stockpiling. By utilizing Amazon S3, engineers approach the comparative to a great degree versatile, reliable, quick, low-valued information stockpiling substructure that Amazon uses to follow its own overall system of sites. So as to perform frameworks in the Amazon EC2 air, engineers utilize the instruments giving to stack their Amazon Machine Images (AMIs) into Amazon S3 and to exchange them between Amazon S3 and Amazon EC2. Extra use case may be for sites facilitated on EC2 to stack their stationary substance from S3.

187. What is the distinction between Amazon S3 and EBS ?
> EBS is for mounting straightforwardly onto EC2 server examples. S3 is Object Oriented Storage that isn't continually waiting be gotten to (and is subsequently less expensive). There is then much less expensive AWS Glacier which is for long haul stockpiling where we don't generally hope to need to get to it, however wouldn't have any desire to lose it.
> There are then two principle kinds of EBS – HDD (Hard Disk Drives, i.e. attractive turning circles), which are genuinely ease back to access, and SSD, which are strong state drives which are excessively quick to get to, yet increasingly costly.
>- Finally, EBS can be purchased with or without Provisioned IOPS.
>- Obviously these distinctions accompany related estimating contrasts, so it merits focusing on the distinctions and utilize the least expensive that conveys the execution we require.

188. What do we comprehend by AWS?
> This is one of the generally asked AWS engineer inquiries questions. This inquiry checks the essential AWS learning so the appropriate response ought to be clear. Amazon Web Services (AWS) is a cloud benefit stage which offers figuring pothe, investigation, content conveyance, database stockpiling, sending and some different administrations to help we in the business development. These administrations are profoundly versatile, solid, secure, and cheap distributed computing administrations which are plot to cooperate and, applications in this manner made are further developed and escalade.

189. Clarify the principle components of AWS?
> The principle components of AWS are:
> Highway 53: Route53 is an exceptionally versatile DNS web benefit.
> Basic Storage Service (S3): S3 is most generally utilized AWS stockpiling web benefit.
> Straightforward E-mail Service (SES): SES is a facilitated value-based email benefit and enables one to smoothly send deliverable messages utilizing a RESTFUL API call or through an ordinary SMTP.
> Personality and Access Management (IAM): IAM gives enhanced character and security the board for AWS account.
> Versatile Compute Cloud (EC2): EC2 is an AWS biological community focal piece. It is in charge of giving on-request and adaptable processing assets with a “pay as we go” estimating model.
> Flexible Block Store (EBS): EBS offers consistent capacity arrangement that can be found in occurrences as a customary hard drive.
> CloudWatch: CloudWatch enables the controller to viewpoint and accumulate key measurements and furthermore set a progression of cautions to be advised if there is any inconvenience.
> This is among habitually asked AWS engineer inquiries questions. Simply find the questioner psyche and solution appropriately either with parts name or with the portrayal alongside.

190. I'm not catching the meaning by AMI? What does it incorporate?
> we may run over at least one AMI related AWS engineer inquiries amid the AWS designer meet. Along these lines, set theself up with a decent learning of AMI.
> AMI represents the term Amazon Machine Image. It's an AWS format which gives the data (an application server, and working framework, and applications) required to play out the dispatch of an occasion. This AMI is the duplicate of the AMI that is running in the cloud as a virtual server. we can dispatch occurrences from the same number of various AMIs as we require. AMI comprises of the followings:
> A pull volume format for a current example Launch authorizations to figure out which AWS recoRDS will inspire the AMI so as to dispatch the occasions Mapping for square gadget to compute the aggregate volume that will be appended to the example at the season of dispatch

191. Is vertically scale is conceivable on Amazon occurrence?
> Indeed, vertically scale is conceivable on Amazon example.
> This is one of the normal AWS engineer inquiries questions. In the event that the questioner is hoping to find a definite solution from we, clarify the system for vertical scaling.

192. What is the association among AMI and Instance?
> Various sorts of examples can be propelled from one AMI. The sort of an occasion for the most part manages the equipment segments of the host PC that is utilized for the case. Each kind of occurrence has unmistakable registering and memory adequacy.
> When an example is propelled, it gives a role as host and the client cooperation with it is same likewise with some other PC however we have a totally controlled access to the occurrences. AWS engineer inquiries questions may contain at least one AMI based inquiries, so set theself up for the AMI theme exceptionally well.

193. What is the distinction between Amazon S3 and EC2?
> The contrast between Amazon S3 and EC2 is given beneath:
> Amazon S3 Amazon EC2 The significance of S3 is Simple Storage Service. The importance of EC2 is Elastic Compute Cloud.
> It is only an information stockpiling administration which is utilized to store huge paired files. It is a
> cloud web benefit which is utilized to have the application made.
> It isn't required to run a server. It is sufficient to run a server.
> It has a REST interface and utilizations secure HMAC-SHA1 validation keys. It is much the same as a
> tremendous PC machine which can deal with application like Python, PHP, Apache and some other database.
> When we are going for an AWS designer meet, set theself up with the ideas of Amazon S3 and EC2, and the distinction between them.

194. What number of capacity alternatives are there for EC2 Instance?
> There are fthe stockpiling choices for Amazon EC2 Instance:
>- Amazon EBS 
>- Amazon EC2 
>- Instance Store 
>- Amazon S3 
>- Adding Storage
> Amazon EC2 is the basic subject we may run over while experiencing AWS engineer inquiries questions. Get a careful learning of the EC2 occurrence and all the capacity alternatives for the EC2 case.

195. What are the security best practices for Amazon EC2 examples?
> There are various accepted procedures for anchoring Amazon EC2 occurrences that are pertinent whether occasions are running on-preface server farms or on virtual machines. How about we view some broad prescribed procedures:
> Minimum Access: Make beyond any doubt that the EC2 example has controlled access to the case and in addition to the system. Offer access specialists just to the confided in substances.
> Slightest Privilege: Follow the vital guideline of minimum benefit for cases and clients to play out the capacities. Produce jobs with confined access for the occurrences.
> Setup Management: Consider each EC2 occasion a design thing and use AWS arrangement the executives administrations to have a pattern for the setup of the occurrences as these administrations incorporate refreshed enemy of infection programming, security highlights and so forth.
> Whatever be the activity job, we may go over security based AWS inquiries questions. Along these lines, motivate arranged with this inquiry to break the AWS designer meet.

196. Clarify the highlights of Amazon EC2 administrations.
> Amazon EC2 administrations have following highlights:
>- Virtual Computing Environments
>- Proffers Persistent capacity volumes 
>- Firewall approving we to indicate the convention 
>- Pre-designed lawets 
>- Static IP address for dynamic Cloud Computing

197. What is the system to send a demand to Amazon S3?
> Reply: There are 2 different ways to send a demand to Amazon S3 –
>- Using REST API 
>- Using AWS SDK Wrapper Libraries, these wrapper libraries wrap the REST APIs for Amazon

198. What is the default number of basins made in AWS?
> This is an extremely straightforward inquiry yet positions high among AWS engineer inquiries questions. Ansthe this inquiry straightforwardly as the default number of pails made in each AWS account is 100.

199. What is the motivation behind T2 examples?
> T2 cases are intended for Providing moderate gauge execution Higher execution as required by outstanding task at hand

200. What is the utilization of the cradle in AWS?
> This is among habitually asked AWS designer inquiries questions. Give the appropriate response in straightforward terms, the cradle is primarily used to oversee stack with the synchronization of different parts i.e. to make framework blame tolerant. Without support, segments don't utilize any reasonable technique to get and process demands. Be that as it may, the cushion makes segments to work in a decent way and at a similar speed, hence results in quicker administrations.

201. What happens when an Amazon EC2 occurrence is halted or ended?
> At the season of ceasing an Amazon EC2 case, a shutdown is performed in a typical way.
> From that point onward, the changes to the ceased state happen. Amid this, the majority of the Amazon EBS volumes are stayed joined to the case and the case can be begun whenever. The occurrence hours are not included when the occasion is the ceased state.
> At the season of ending an Amazon EC2 case, a shutdown is performed in an ordinary way. Amid this, the erasure of the majority of the Amazon EBS volumes is performed. To stay away from this, the estimation of credit deleteOnTermination is set to false. On end, the occurrence additionally experiences cancellation, so the case can't be begun once more.

202. What are the mainstream DevOps devices?
> In an AWS DevOps Engineer talk with, this is the most widely recognized AWS inquiries for DevOps. To ansthe this inquiry, notice the well known DevOps apparatuses with the kind of hardware –
>- Jenkins – Continuous Integration Tool 
>- Git – Version Control System Tool 
>- Nagios – Continuous Monitoring Tool 
>- Selenium – Continuous Testing Tool 
>- Docker – Containerization Tool 
>- Puppet, Chef, Ansible – Deployment and Configuration Administration Tools.

203. What are IAM Roles and Policies, What is the difference between IAM Roles and Policies.
> Roles are for AWS services, Where we can assign permission of some AWS service to other Service.
> Example – Giving S3 permission to EC2 to access S3 Bucket Contents.
> Policies are for users and groups, Where we can assign permission to user's and groups.
> Example – Giving permission to user to access the S3 Buckets.

204. What are the Defaults services we get when we create custom AWS VPC?
>- Route Table
>- Network ACL 
>- Security Group

205. What is the Difference Between Public Subnet and Private Subnet ?
> Public Subnet will have Internet Gateway Attached to its associated Route Table and Subnet, Private Subnet will not have the Internet Gateway Attached to its associated Route Table and Subnet Public Subnet will have internet access and Private subnet will not have the internet access directly.

206. How do we access the EC2 which has private IP which is in private Subnet ?
> We can access using VPN if the VPN is configured into that Particular VPC where EC2 is assigned to that VPC in the Subnet. We can access using other EC2 which has the Public access.

207. We have a custom VPC Configured and MYSQL Database server which is in Private Subnet and we need to update the MYSQL Database Server, What are the Option to do so.
> By using NAT Gateway in the VPC or Launch a NAT Instance (EC2) Configure or Attach the NAT Gateway in Public Subnet (Which has Route Table attached to IGW) and attach it to the Route Table which is Already attached to the Private Subnet.

208. What are the Difference Between Security Groups and Network ACL
> Security Groups Attached to EC2 instance
> Network ACL Attached to a subnet.
> Stateful – Changes made in Stateless – Changes made incoming rules is automatically in incoming rules is not applied to the outgoing applied to the outgoing rule rule Blocking IP Address can't be IP Address can be Blocked done Allow rules only, by default all Allow and Deny can be rules are denied Used.

209. What are the Difference Between Route53 and ELB?
> Amazon Route 53 will handle DNS servers. Route 53 give we web interface through which the DNS can be managed using Route 53, it is possible to direct and failover traffic. This can be achieved by using DNS Routing Policy.
> One more routing policy is Failover Routing policy. we set up a health check to monitor the application endpoints. If one of the endpoints is not available, Route 53 will automatically forward the traffic to other endpoint.
> Elastic Load Balancing ELB automatically scales depends on the demand, so sizing of the load balancers to handle more traffic effectively when it is not required.

210. What are the DB engines which can be used in AWS RDS?
>- MariaDB 
>- MYSQL DB 
>- MS SQL DB 
>- Postgres DB 
>- Oracle DB

211. What is Status Checks in AWS EC2?
> System Status Checks – System Status checks will look into problems with instance which needs AWS help to resolve the issue. When we see system status check failure, we can wait for AWS to resolve the issue, or do it by the self.
>- Network connectivity 
>- System pothe 
>- Software issues 
>- Data Centre's
> Hardware issues Instance Status Checks – Instance Status checks will look into issues which need the involvement to fix the issue. if status check fails, we can reboot that particular instance.
> Failed system status checks Memory Full Corrupted file system Kernel issues

212. To establish a peering connections between two VPC's What condition must be met?
>- CIDR Block should overlap 
>- CIDR Block should not overlap
>- VPC should be in the same region 
>- VPC must belong to same account.
>- CIDR block should not overlap between vpc setting up a peering connection . peering connection is allowed within a region, across region, across different account.

213. Troubleshooting with EC2 Instances:
> Instance States
>- If the instance state is 0/2- there might be some hardware issue 
>- If the instance state is ½there might be issue with OS.
> Workaround-Need to restart the instance, if still that is not working logs will help to fix the issue.

214. How EC2instances can be resized.
> EC2 instances can be resizable(scale up or scale down) based on requirement

215. EBS: its block-level storage volume which we can use after mounting with EC2 instances.
> For types please refer AWS Solution Architect book.

216. Difference between EBS,EFS and S3
>- We can access EBS only if its mounted with instance, at a time EBS can be mounted only with one instance.
>- EFS can be shared at a time with multiple instances S3 can be accessed without mounting with instances

217. Maximum number of bucket which can be crated in AWS.
> 100 buckets can be created by default in AWS account.To get more buckets additionally we have to request Amazon for that.

218. Maximum number of EC2 which can be created in VPC.
> Maximum 20 instances can be created in a VPC. we can create 20 reserve instances and request for spot instance as per demand.

219. How EBS can be accessed?
> EBS provides high performance block-level storage which can be attached with running EC2 instance. Storage can be formatted and mounted with EC2 instance, then it can be accessed.

220. Process to mount EBS to EC2 instance
>1. Create a Volume
>2. Attach a Volume to EC2 Instance
>3. Verify if Volume is attached or not by running linux command in Ec2-instance `$ lsblk`
>4. Check if the volume has any data using the following command `$ sudo file -s /dev/xvdf`. If output shows `/dev/xvdf: data`, means your volume is empty.
>5. Format the volume to the ext4 filesystem using `$ sudo mkfs -t ext4 /dev/xvdf` or xfs filesystem using `$ sudo mkfs -t xfs /dev/xvdf`
>6. Create a directory of your choice to mount our new ext4 volume `$ sudo mkdir /yourNewVolumeName`
>7. Mount the volume to 'yourNewVolumeName' directory with `$ sudo mount /dev/xvdf /yourNewVolumeName/`
>8. cd into 'yourNewVolumeName' directory and check the disk free space to validate the volume mount `$ cd /yourNewVolumeName; $ df -h .`
>9. To unmount the volume, use `umount /dev/xvdf`
>10. To mount an EBS volume to multiple ec2 instances, you can do it via EBS multi-attach functionality. This option only serves specific use-cases where multiple machines need to read/write to the same storage location concurrently. EBS multi attach option is available only for Provisioned IOPS (PIOPS) EBS volume types.

221. How do you permanently add a volume to your EC2?
> With each restart volume will get unmounted from instance, to keep this attached need to perform below step 
> Cd /etc/fstab
> /dev/xvdf /data ext4 defaults 0
> edit the file system name accordingly"

222. What is the Difference between the Service Role and SAML Federated Role.
> Service Role are meant for usage of AWS Services and based upon the policies attached to it,it will have the scope to do its task. Example : In case of automation we can create a service role and attached to it.
> Federated Roles are meant for User Access and getting access to AWS as per designed role. Example: We can have a federated role created for the office employee and corresponding to that a Group will be created in the AD and user will be added to it.

223. How many Policies can be attached to a role.
> 10 (Soft limit), We can have till 20.

224. What are the different ways to access AWS.
> 3 Different ways (CLI, Console, SDK)

225. How a Root AWS user is different from in IAM User.
> Root User will have acces to entire AWS environment and it will not have any policy attached to it. While IAM User will be able to do its task on the basis of policies attached to it.

226. What do we mean by Principal of least privilege in term of IAM.
> Principal of least privilege means to provide the same or equivalent permission to the user/role.

227. What is the meaning of non-explicit deny for an IAM User.
> When an IAM user is created and it is not having any policy attached to it,in that case he will not be able to access any of the AWS Service until a policy has been attached to it.

228. What is the precedence level between explicit allow and explicit deny.
> Explicit deny will always override Explicit Allow.

229. What is the benefit of creating a group in IAM.
> Creation of Group makes the user management process much simpler and user with the same kind of permission can be added in a group and at last addition of a policy will be much simpler to the group in comparison to doing the same thing manually.

230. What is the difference between the Administrative Access and Pothe User Access in term of pre-build policy.
> Administrative Access will have the Full access to AWS resources. While Pothe User Access will have the Admin access except the user/group management permission.

231. What is the purpose of Identity Provider.
> Identity Provider helps in building the trust between the AWS and the Corporate AD environment while we create the Federated role.

232. What are the benefits of STS (Security Token Service).
> It help in securing the AWS environment as we need not to embed or distributed the AWS Security credentials in the application. As the credentials are temporary we need not to rotate them and revoke them.

233. What is the benefit of creating the AWS Organization.
> It helps in managing the IAM Policies, creating the AWS Accounts programmatically, helps in managing the payment methods and consolidated billing.

234. What is the maximum file length in S3?
> UTF-8 1024 bytes

235. which activity cannot be done using autoscaling?
> Maintain fixed running of EC2

236. How will we secure data at rest in EBS?
> EBS data is always secure

237. What is the maximum size of S3 Bucket?
> 5TB

238. Can objects in Amazon S3 be delivered through amazon cloud front?
> Yes

239. which service is used to distribute content to end user service using global network of edge location?
> Virtual Private Cloud

240. What is ephemaral storage?
> Temporary storage

241. What are shaRDS in kinesis aws services?
> ShaRDS are used to store data in Kinesis.

242. Where can we find the ephemeral storage?
> In Instance store service.

243. I have some private servers on my premises also I have distributed some of My workload 999on the public cloud, what is the architecture called?
> Virtual private cloud

244. Route 53 can be used to route users to infrastructure outside of aws.True/false?
> False

245. Is simple workflow service one of the valid Simple Notification Service subscribers?
> No

246. which cloud model do Developers and organizations all around the world leverage extensively?
> IAAS-Infrastructure as a service.

247. Can cloud front serve content from a non AWS origin server?
> No

248. Is EFS a centralised storage service in AWS?
> Yes

249. Which AWS service will we use to collect and process ecommerce data for near real time analysis?
> Both Dynamo DB & Redshift

250. An high demand of IOPS performance is expected around 15000. Which EBS volume type would we recommend?
> Provisioned IOPS.