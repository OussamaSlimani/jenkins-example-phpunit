pipeline {
  agent any
  stages {
    stage('Verify Installations') {
      steps {
        sh '''
          php -v
          phpunit --version
          phpstan --version
        '''
      }
    }
    stage('Run Tests') {
      steps {
        sh 'phpunit --bootstrap src/autoload.php tests'
      }
    }
    stage('Run Tests with TestDox') {
      steps {
        sh 'phpunit --bootstrap src/autoload.php --testdox tests'
      }
    }
    stage('Run Tests with JUnit Results') {
      steps {
        sh 'phpunit --bootstrap src/autoload.php --log-junit target/junit-results.xml tests'
      }
      post {
        always {
          junit testResults: 'target/*.xml'
        }
      }
    }
    stage('Static Analysis with PHPStan') {
      steps {
        // Use a directory within the Jenkins workspace for the cache
        sh 'mkdir -p $WORKSPACE/phpstan_cache'

        // Run PHPStan with custom cache directory
        sh 'phpstan analyze --error-format=json --configuration=phpstan.neon --memory-limit=1G --tmp-dir=$WORKSPACE/phpstan_cache src -l 6 > static_analysis.json'
      }
    }
  }
}
