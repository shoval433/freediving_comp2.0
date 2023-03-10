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
                                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                                ]]) {
                                sh "cd app && docker build -t app . --no-cache"
                                sh "docker tag app freedivingcompetitions:${Ver_Calc}"
                            docker.withRegistry("http://644435390668.dkr.ecr.eu-west-3.amazonaws.com/freedivingcompetitions", "ecr:eu-west-3:644435390668") {
                            docker.image("freedivingcompetitions:${Ver_Calc}").push()
                            }
                            // freedive_comp20_main-app_comp-1
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

                    sh "tar -czvf start_to_ec2.tar.gz docker-compose-prod.yaml ./nginx2 "
                    sh "cd app && tar -czvf templates.tar.gz ./templates"
                    sh "cd app && mv templates.tar.gz ../init"
                    sh "mv start_to_ec2.tar.gz init/"
                    dir("terraform"){
                        sh "terraform init"
                        sh "terraform workspace select prod|| terraform workspace new prod "
                        sh "terraform apply -var VAR=${Ver_Calc} -replace=module.compute.aws_instance.prod_shoval_iac[0] -replace=module.compute.aws_instance.prod_shoval_iac[1] -auto-approve"
                        ARN_TG=sh (script: "terraform output lb_arn",
                    returnStdout: true).trim()
                    }
                     ARN_TG=sh (script: "echo ${ARN_TG} | sed 's/\"//g'",
                    returnStdout: true).trim()
                    echo "${ARN_TG}"
                    withCredentials([[
                                $class: 'AmazonWebServicesCredentialsBinding',
                                credentialsId: 'aws_shoval',
                                accessKeyVaeiable: 'AWS_ACCESS_KET_ID',
                                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                                ]]) {
                                   sh "aws elbv2 modify-target-group-attributes --target-group-arn ${ARN_TG} --attributes Key=stickiness.enabled,Value=true Key=stickiness.lb_cookie.duration_seconds,Value=86400"
                    }
                }
                

//

            }
           
        }
    }//
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
                //
            
            
                
            }
        }
        failure{
            script{
                 dir("terraform"){
                        sh "terraform init"
                        sh "terraform workspace select prod"
                        sh "terraform destroy -var VAR=${Ver_Calc} -auto-approve"
                    }
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
