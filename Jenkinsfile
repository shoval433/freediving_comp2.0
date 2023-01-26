pipeline{
    agent any
    options {
        timestamps()
        
    }
    environment{   
        def Ver_Calc=""
    }
    stages{
        stage("CHEKOUT"){
            steps{
                echo "===============================================Executing CHEKOUT==============================================="
                deleteDir()
                checkout scm
    
            }
            
        }
        

        
        stage("Building for all"){
            steps{
                echo "===============================================Executing Building for all==============================================="
                sh "docker-compose build --no-cache "
                sh "docker-compose up -d"
            }
        }
        stage("test build"){
            steps{
                 echo "===============================================Executing test build==============================================="
                script{
                    sh "curl http://43.0.20.203:5001"
                }
                
            }
        }
    
        stage("e2e test"){
            when{
                anyOf {
                        branch "main"
                        branch "feature/*"
                        branch "master"
                }
            }
            steps{
                echo "===============================================Executing e2e test==============================================="
                script{
                    dir("app/test"){
                        sh "./testing.sh 43.0.20.203 5001"
                    }

                }
            }
        }
        stage("calc tag"){
            when{
                anyOf {
                        branch "main"
                        branch "master"
                }
            }
            steps{
                echo "===============================================Executing calc tag==============================================="
                script{
                    
                    Ver_Calc=sh (script: "git describe --tags | cut -d '-' -f1",
                    returnStdout: true).trim()
                    
                    sh "./tag_check.sh $Ver_Calc"
                    
                }  
                
            }
           
        }
        stage("Publish"){
            when{
                anyOf {
                        branch "main"
                        branch "master"
                }
            }
            //
            steps{
                echo "===============================================Executing Publish==============================================="
                
                script{
                withCredentials([[
                                $class: 'AmazonWebServicesCredentialsBinding',
                                credentialsId: 'aws_shoval',
                                accessKeyVaeiable: 'AWS_ACCESS_KET_ID',
                                secretKeyVariable: 'AWS_SECRET_KEY_ID'
                                ]]) {
                                sh "docker tag freedive_comp_main-app_comp freedivingcompetitions:${Ver_Calc}"
                            docker.withRegistry("http://644435390668.dkr.ecr.eu-west-3.amazonaws.com/freedivingcompetitions", "ecr:eu-west-3:644435390668") {
                            docker.image("freedivingcompetitions:${Ver_Calc}").push()
                            }
                }
                }


            }
           
        }
        stage("Deploy"){
            when{
                anyOf {
                        branch "main"
                        branch "master"
                }
            }
            
            steps{
                echo "===============================================Executing Deploy==============================================="
                //
                script{
                    sh "ssh ubuntu@43.0.20.24 'rm -f docker-compose-prod.yaml && rm -rd ./nginx2 ./templates'"
                    sh "tar -czvf start_to_ec2.tar.gz docker-compose-prod.yaml ./nginx2 "
                    sh "echo 'yes'|scp start_to_ec2.tar.gz ubuntu@43.0.20.24:/home/ubuntu/"

                    sh "cd app && tar -czvf templates.tar.gz ./templates"
                    sh "cd app && echo 'yes'|scp templates.tar.gz ubuntu@43.0.20.24:/home/ubuntu/"
                    sh "ssh ubuntu@43.0.20.24 'aws ecr get-login-password --region eu-west-3 | docker login --username AWS --password-stdin 644435390668.dkr.ecr.eu-west-3.amazonaws.com'"
                    sh""" 
                    ssh ubuntu@43.0.20.24 'tar -xvzf start_to_ec2.tar.gz'
                    ssh ubuntu@43.0.20.24 'tar -xvzf templates.tar.gz'
                    ssh ubuntu@43.0.20.24 'docker compose -f docker-compose-prod.yaml down && export VERSION_COMP=${Ver_Calc} && docker compose -f docker-compose-prod.yaml up --build -d '
                    """
                    
                }


            }
           
        }
    }
    post{
        always{
            sh "docker-compose down"
        }

        success{
            script{
                
            

                emailext    recipientProviders: [culprits()],
                subject: 'Congratulations', body: 'Well, this time you didnt mess up',  
                attachLog: true


                // emailext to: 'shoval123055@gmail.com',
                // subject: 'Congratulations!', body: 'Well, this time you didnt mess up',  
                // attachLog: true
                
            
            
                
            }
        }
        failure{
            script{
                emailext   recipientProviders: [culprits()],
                subject: 'YOU ARE BETTER THEN THAT !!! ', body: 'Dear programmer, you have broken the code, you are asked to immediately sit on the chair and leave the coffee corner.',  
                attachLog: true


                // emailext   to: 'shoval123055@gmail.com',
                // subject: 'YOU ARE BETTER THEN THAT !!! ', body: 'Dear programmer, you have broken the code, you are asked to immediately sit on the chair and leave the coffee corner.',  
                // attachLog: true
            }      
           
            

        }
    }
}
