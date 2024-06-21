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
        script {
          try {
            sh 'phpunit --bootstrap src/autoload.php tests'
          } catch (Exception e) {
            currentBuild.result = 'FAILURE'
            error 'Unit tests failed.'
          }
        }
      }
    }
    stage('Run Tests with TestDox') {
      steps {
        script {
          try {
            sh 'phpunit --bootstrap src/autoload.php --testdox tests'
          } catch (Exception e) {
            currentBuild.result = 'FAILURE'
            error 'TestDox tests failed.'
          }
        }
      }
    }
    stage('Run Tests with JUnit Results') {
      steps {
        script {
          try {
            sh 'phpunit --bootstrap src/autoload.php --log-junit target/junit-results.xml tests'
          } catch (Exception e) {
            currentBuild.result = 'FAILURE'
            error 'JUnit tests failed.'
          }
        }
      }
      post {
        always {
          junit testResults: 'target/*.xml'
        }
      }
    }
    stage('Static Analysis with PHPStan') {
      steps {
        script {
          try {
            // Create a custom PHPStan configuration file with tmpDir setting
            writeFile file: 'phpstan_tmp.neon', text: '''
parameters:
    tmpDir: $WORKSPACE/phpstan_cache
'''

            // Create the temporary cache directory
            sh 'mkdir -p $WORKSPACE/phpstan_cache'

            // Run PHPStan with the custom configuration file
            sh 'phpstan analyze --error-format=json --configuration=phpstan_tmp.neon --memory-limit=1G src -l 6 > static_analysis.json'
          } catch (Exception e) {
            currentBuild.result = 'FAILURE'
            error 'PHPStan static analysis failed.'
          }
        }
      }
    }
    stage('Build Docker Image') {
      when {
        expression {
          currentBuild.result == null || currentBuild.result == 'SUCCESS'
        }
      }
      steps {
        script {
          try {
            sh 'docker build -t my-php-app-pipeline .'
          } catch (Exception e) {
            currentBuild.result = 'FAILURE'
            error 'Docker image build failed.'
          }
        }
      }
    }
  }
  post {
    failure {
      echo 'One or more stages failed. The Docker image was not built.'
    }
    success {
      echo 'All stages passed. The Docker image was built successfully.'
    }
  }
}
