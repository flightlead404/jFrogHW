pipeline {
    agent any
    tools { 
          maven 'Homebrew maven'
    }
    stages {
        stage('Clone repository') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/spring-projects/spring-petclinic.git'
            }
        }
/*
        stage('Resolve dependencies') {
            steps {
                script {
                    def server = Artifactory.server 'InfoD.jFrog'
                    def rtMaven = Artifactory.newMavenBuild()
                    rtMaven.tool = 'Maven'
                    rtMaven.deployer server: server, releaseRepo: 'libs-release-local', snapshotRepo: 'libs-snapshot-local'
                    rtMaven.resolver server: server, repo: 'jcenter'
                    rtMaven.run pom: 'pom.xml', goals: 'clean install -Dmaven.test.skip=true'
                }
            }
        }
*/
        stage('Run tests') {
            steps {
                script {
                    sh 'mvn test'
                }
            }
        }

        stage('Package as Docker Image') {
           steps {
                sh 'mvn package'
                sh '/usr/local/bin/docker build -t spring-petclinic -f /Users/mwalker/Documents/jFrogHomework/Dockerfile .'
            }
        }

        stage('Analyze image') {
            steps {
                // Log into Docker Hub
                sh 'echo $DOCKER_PAT | /usr/local/bin/docker login -u $DOCKER_USER --password-stdin'
                // Analyze and fail on critical or high vulnerabilities
                sh '/usr/local/bin/docker-scout cves spring-petclinic --exit-code --only-severity critical,high'
            }
        }
        
        stage('Publish Docker image') {
            steps {
                script {
                    sh 'echo $DOCKER_PAT | /usr/local/bin/docker login -u $DOCKER_USER --password-stdin'
                    sh '/usr/local/bin/docker tag spring-petclinic flightlead404/spring-petclinic:latest'
                    sh '/usr/local/bin/docker push flightlead404/spring-petclinic:latest'
                }
            }
        }
       stage('Docker Logout') {
            steps {
                sh '/usr/local/bin/docker logout'
            }
        }
    }
}

