pipeline {
  agent any

  environment {
    AWS_REGION      = "ap-south-1"
    MODULES_GIT_URL = "https://github.com/GalamManesha/modules-concepts.git"
    MODULES_BRANCH  = "main"
  }

  options {
    skipDefaultCheckout(true)
    timestamps()
  }

  stages {
    stage('Checkout infra repo (should contain module/main.tf)') {
      steps {
        checkout scm
      }
    }

    stage('Fetch modules repo into module/modules/module') {
      steps {
        script {
          sh '''
            set -e
            tmpdir=$(mktemp -d)
            echo "Cloning modules repo..."
            git clone --depth 1 --branch ${MODULES_BRANCH} ${MODULES_GIT_URL} "$tmpdir"
            mkdir -p module/modules/module
            if [ -d "$tmpdir/module" ]; then
              echo "Copying implementation from $tmpdir/module -> module/modules/module"
              rsync -a --delete "$tmpdir/module/" module/modules/module/
            else
              echo "ERROR: expected folder 'module' not found in modules repo root."
              ls -la "$tmpdir"
              rm -rf "$tmpdir"
              exit 1
            fi
            rm -rf "$tmpdir"
          '''
        }
      }
    }

    stage('Sanity: show layout and check required files') {
      steps {
        script {
          sh '''
            set -e
            echo "Workspace root: $(pwd)"
            echo "Listing root:"
            ls -la || true
            echo "Listing module/:"
            ls -la module || true
            echo "Listing module/modules/module/:"
            ls -la module/modules/module || true

            # Ensure root main.tf exists
            if [ ! -f module/main.tf ]; then
              echo "ERROR: module/main.tf not found. Put your root caller (module/main.tf) in the infra repo."
              exit 1
            fi

            # Ensure module variables file exists and has expected variables
            if [ ! -f module/modules/module/variables.tf ]; then
              echo "ERROR: module/modules/module/variables.tf not found. Module must declare its variables."
              exit 1
            fi

            # quick grep to confirm variables names (instance_type or ami must be present)
            grep -E 'variable\\s+\"(instance_type|ami|ami_id)\"' -n module/modules/module/variables.tf || {
              echo "WARNING: variables.tf does not declare instance_type or ami/ami_id. Confirm variable names match caller."
            }
          '''
        }
      }
    }

    stage('Terraform Init') {
      steps {
        dir('module') {
          withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: 'aws-cred'
          ]]) {
            sh '''
              set -e
              echo "Terraform version:"
              terraform --version
              echo "Running terraform init in $(pwd)"
              terraform init -input=false -no-color
            '''
          }
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        dir('module') {
          withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: 'aws-cred'
          ]]) {
            sh '''
              set -e
              terraform plan -out=tfplan -input=false -no-color
              terraform show -no-color tfplan > plan.txt || true
            '''
            archiveArtifacts artifacts: 'module/plan.txt', onlyIfSuccessful: true
          }
        }
      }
    }

    stage('Terraform Apply (auto-approve)') {
      steps {
        dir('module') {
          withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: 'aws-cred'
          ]]) {
            sh '''
              set -e
              terraform apply -input=false -auto-approve tfplan
            '''
          }
        }
      }
    }
  }

  post {
    always {
      dir('module') {
        sh 'echo "===== terraform state list ====="; terraform state list || true'
      }
    }
    success { echo "EC2 created successfully (or apply succeeded)." }
    failure { echo "Pipeline failed — check console output." }
  }
}
