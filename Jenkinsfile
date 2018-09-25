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
      parallel {
        stage('p2tp') {
          steps {
            echo 'dfd'
            sleep 1
            script {
                def browsers = ['chrome', 'firefox']
                for (int i = 0; i < browsers.size(); ++i) {
                    echo "Testing the ${browsers[i]} browser"
                }
                try {
                error 'nar'
              } catch (e) {
                  currentBuild.result = 'SUCCESS'
                  throw e
              } finally {
                  echo 'need success'
              }
            }
          }
        }
        stage('p2tf') {
          steps {
            sh 'date'
          }
        }
      }
    }
  }
}
