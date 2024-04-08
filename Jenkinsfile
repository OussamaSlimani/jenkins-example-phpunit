pipeline {
  agent any
  stages {
    stage('verify installations') {
      steps {
        sh '''
          php -v
          phpunit11 --version
        '''
      }
    }
    stage('run tests') {
      steps {
        sh 'phpunit11 --bootstrap src/autoload.php tests'
      }
    }
  }
}