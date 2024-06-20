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
    stage('run tests with TestDox') {
      steps {
        sh 'phpunit --bootstrap src/autoload.php --testdox tests'
      }
    }
    stage('run tests with JUnit results') {
      steps {
        sh 'phpunit --bootstrap src/autoload.php --log-junit target/junit-results.xml tests'
      }
      post {
        always {
          junit testResults: 'target/*.xml'
        }
      }
    }
    stage('static analysis with PHPStan') {
      steps {
        sh 'mkdir -p build/phpstan/cache'
        sh 'phpstan analyze src --level max --memory-limit=1G --cache-directory=build/phpstan/cache'
      }
    }
  }
}
