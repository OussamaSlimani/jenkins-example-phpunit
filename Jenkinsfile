pipeline {
  agent any
  stages {
    stage('verify installations') {
      steps {
        sh '''
          php -v
          phpunit --version
        '''
      }
    }
    stage('run tests') {
      steps {
        sh 'phpunit --bootstrap src/autoload.php tests'
      }
    }
  }
}