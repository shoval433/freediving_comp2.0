
# freediving_comp

This application is designed for freediving competitions and allows competitors to register for various events. 
Each competition has a unique database, and the application provides competitors with an updated list of participants. The application is built using Python Flask and utilizes MongoDB and Nginx for static files and reverse-proxying. All components are connected using Docker Compose.


## 🦑 About Me
My name is Shoval and i am DevOps Engineer focuses on deploying, automating, and maintaining cloud-based and on-premise infrastructure. I have a diverse skillset, having worked with a wide range of technologies, including AWS, Azure, Terraform, Jenkins,Artifactory, Git, Docker, Nginx, Python, Bash, and SQL.

In my most recent project, I was developing and implementing CI/CD workflows in Jenkins for multiple applications, working with Jfrog's Artifactory to manage artifacts, and building Python applications in a microservices architecture for deployment on AWS. My experience with virtual machines and different databases and web frameworks makes me a well-rounded engineer who can handle a variety of tasks.


## API Reference

#### GET 

##### receive the participants in the competition

```http
  GET /<comp>/
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `comp` | `string` | **Required**. Your competitions |

#### POST 

##### Adds participants in the competition

```http
  POST /<comp>/
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `<comp>,Competitor parameters`      | `string,dictionary` | **Required**. Competitor parameters |




## Environment Variables

Some important environment variables in the project that appear in the pipeline and in the terraform.

`VERSION_COMP`

`Ver_Calc`

`ARN_TG`


## Tech Stack

**Client:** HTML, Nginx

**Server:** Pytho Flask, MongoDB

**CI/CD:** Jenkins

**Cloud:** AWS 

**IAC:** Terraform 



## Roadmap CI/CD
#### Pull
- Completely deletes the old environment(deleteDir()).
- Pulling the code from the github repository(checkout scm).

#### Build

- Building the app.

#### Test

- Implement load testing to simulate real-world traffic and improve application scalability.
- Integrate security testing to detect vulnerabilities in the code.

#### Publish

- Implement versioning of published artifacts to enable better tracking and rollback.
- Integrate vulnerability scanning of artifacts before publishing.

#### Deploy

- Automate infrastructure provisioning to eliminate manual intervention and reduce deployment time.
- Implement automated rollback mechanisms to enable quick recovery in case of deployment failures.




## 🔗 Links

[![linkedin](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](www.linkedin.com/in/shoval-astamker-4149a6202)




