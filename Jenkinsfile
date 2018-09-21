pipeline {
  agent any
  stages {
    stage('test') {
      parallel {
        stage('test') {
          steps {
            node(label: 'any')
            echo 'hello'
            catchError() {
              echo '123'
              echo '444'
              waitUntil() {
                echo '123'
              }

            }

          }
        }
        stage('testp') {
          steps {
            sh 'df -h'
          }
        }
      }
    }
    stage('deploy') {
      steps {
        echo '123'
      }
    }
  }
}