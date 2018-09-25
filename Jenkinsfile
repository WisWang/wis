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
script {
	try {
	    // run tests in the same workspace that the project was built
	    error 'nar'
	} catch (e) {
	    // if any exception occurs, mark the build as failed
	    currentBuild.result = 'SUCCESS'
	    throw e
	} finally {
	    // perform workspace cleanup only if the build have passed
	    // if the build has failed, the workspace will be kept
	    echo 'need success'
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
    stage('post') {
      steps {
        catchError()
      }
    }
  }
}
