pipeline {
  agent any
  stages {
    stage('testp') {
      steps {
        sh 'df -h'
      }
    }
    stage('wis2') {
      agent any
      steps {
        sleep 3
      }
    }
  }
}