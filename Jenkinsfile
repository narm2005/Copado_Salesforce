// Declarative pipeline: runs the Robot Framework / QWeb suite against a Salesforce org.
// Needs: an agent with Python 3.9-3.12 + Google Chrome, the "Robot Framework" Jenkins plugin,
// and a "Username with password" credential with ID sf-dev-org.
pipeline {
  agent { label 'python-chrome' }

  parameters {
    choice(name: 'SUITE_TAG', choices: ['smoke', 'regression'], description: 'Which tagged tests to run')
    string(name: 'SF_ORG_URL', defaultValue: 'https://your-domain.develop.my.salesforce.com',
           description: 'Lightning org URL')
  }

  options { timestamps(); timeout(time: 30, unit: 'MINUTES') }

  stages {
    stage('Install') {
      steps {
        sh '''
          python3 -m venv .venv
          . .venv/bin/activate
          pip install -r requirements.txt
        '''
      }
    }

    stage('Run tests') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'sf-dev-org',
                         usernameVariable: 'SF_USERNAME', passwordVariable: 'SF_PASSWORD')]) {
          sh '''
            . .venv/bin/activate
            export SF_ORG_URL="${SF_ORG_URL}"
            robot --outputdir results --include "${SUITE_TAG}" \
                  --xunit xunit.xml tests/ || true
          '''
          // "|| true" lets Jenkins publish results; the robot step below marks the build.
        }
      }
    }
  }

  post {
    always {
      robot outputPath: 'results',
            passThreshold: 100.0,
            unstableThreshold: 80.0,
            otherFiles: '**/*.png'
      junit allowEmptyResults: true, testResults: 'results/xunit.xml'
      archiveArtifacts artifacts: 'results/**', allowEmptyArchive: true
    }
  }
}
