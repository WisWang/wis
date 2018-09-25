pipeline {
  agent any
  stages {
    stage('testp') {
      parallel {
        stage('testp') {
          steps {
            sh 'df -h'
          }
        }
        stage('ttt22') {
          steps {
            sh 'echo "hello"'
          }
        }
        stage('tttva') {
          steps {
            echo 'va'
          }
        }
      }
    }
    stage('p2tp') {
      steps {
        echo 'dfd'
        sleep 1
        error 'nar'
      }
    }
  }
}