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
        // Create a custom PHPStan configuration file with tmpDir setting
        writeFile file: 'phpstan_tmp.neon', text: '''
parameters:
    tmpDir: $WORKSPACE/phpstan_cache
'''

        // Create the temporary cache directory
        sh 'mkdir -p $WORKSPACE/phpstan_cache'

        // Run PHPStan with the custom configuration file
        sh 'phpstan analyze --error-format=json --configuration=phpstan_tmp.neon --memory-limit=1G src -l 6 > static_analysis.json'
      }
    }
  }
}
