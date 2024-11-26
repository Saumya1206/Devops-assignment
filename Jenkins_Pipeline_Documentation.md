
# Jenkins Pipeline Documentation

This documentation explains the implementation of a Jenkins pipeline with parameters, stages, and steps for building a Maven project. The pipeline includes several stages, such as cleaning the workspace, cloning the repository, cleaning the Maven project, installing dependencies, running tests, packaging the application, and publishing the artifacts. Additionally, it demonstrates the use of parameters to select different branches for the pipeline execution.

## Overview of the Pipeline

The pipeline consists of the following stages:

1. **Cleanup Workspace**: Cleans the workspace to ensure that each build starts fresh.
2. **Clone Repository**: Clones the repository from GitHub based on the selected branch.
3. **Clean Project**: Cleans the Maven project to remove any previously compiled files.
4. **Install Dependencies**: Installs project dependencies using Maven.
5. **Run Tests**: Runs tests for the project using Maven.
6. **Package Application**: Packages the application into a deployable artifact (JAR file).
7. **Publish Artifacts**: Archives the generated artifacts so they can be downloaded from Jenkins.

The pipeline also uses a **parameter** to allow the user to specify which Git branch to build.

## Parameters

The pipeline includes the following parameter:

- **BRANCH_NAME** (string): This parameter allows the user to specify which Git branch to build. The default value is set to `main`, but you can change it to any valid branch name in the repository.

  ```groovy
  string(name: 'BRANCH_NAME', defaultValue: 'main', description: 'Branch to build')
  ```

## Pipeline Steps

### 1. Cleanup Workspace

This stage cleans the workspace to ensure that each build starts fresh. It removes any files from previous builds.

```groovy
cleanWs()
```

### 2. Clone Repository

This stage clones the Git repository using the branch specified by the `BRANCH_NAME` parameter. If no branch is specified, it defaults to the `main` branch.

```groovy
bat "git clone --branch ${params.BRANCH_NAME} https://github.com/Aseemakram19/maven-app.git"
```

### 3. Clean Project

This step cleans the Maven project by removing any previously compiled files.

```groovy
bat "mvn clean -f maven-app"
```

### 4. Install Dependencies

This step installs the necessary dependencies for the Maven project.

```groovy
bat "mvn install -f maven-app"
```

### 5. Run Tests

This stage runs the tests for the Maven project.

```groovy
bat "mvn test -f maven-app"
```

### 6. Package Application

After the tests are run, this step packages the application into a JAR file.

```groovy
bat "mvn package -f maven-app"
```

### 7. Publish Artifacts

Finally, this step archives the generated JAR file as a build artifact. This allows you to download the artifact from Jenkins after the build is complete.

```groovy
archiveArtifacts allowEmptyArchive: true, artifacts: 'maven-app/target/*.jar', fingerprint: true
```

- **allowEmptyArchive**: If no artifacts are found, this will allow the step to succeed without errors.
- **artifacts**: Specifies the path and file pattern to identify the artifacts (e.g., `.jar` files).
- **fingerprint**: Ensures that Jenkins tracks and identifies the artifacts.

## Timeout

The pipeline is configured to fail if it runs for more than 1 minute. This is achieved using the `timeout` option in the `options` block.

```groovy
options {
    timeout(time: 1, unit: 'MINUTES')
}
```

## Full Pipeline Code

```groovy
pipeline {
    agent any
    tools {
        maven 'MAVEN_HOME'
    }
    parameters {
        string(name: 'BRANCH_NAME', defaultValue: 'main', description: 'Branch to build')
    }
    options {
        timeout(time: 1, unit: 'MINUTES')
    }
    stages {
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Clone Repository') {
            steps {
                bat "git clone --branch ${params.BRANCH_NAME} https://github.com/Aseemakram19/maven-app.git"
            }
        }
        stage('Clean Project') {
            steps {
                bat "mvn clean -f maven-app"
            }
        }
        stage('Install Dependencies') {
            steps {
                bat "mvn install -f maven-app"
            }
        }
        stage('Run Tests') {
            steps {
                bat "mvn test -f maven-app"
            }
        }
        stage('Package Application') {
            steps {
                bat "mvn package -f maven-app"
            }
        }
        stage('Publish Artifacts') {
            steps {
                archiveArtifacts allowEmptyArchive: true, artifacts: 'maven-app/target/*.jar', fingerprint: true
            }
        }
    }
}
```

## Conclusion

This Jenkins pipeline demonstrates how to automate the process of building a Maven project, running tests, and publishing the generated artifacts. It also introduces the concept of parameters to allow the user to select different branches for the pipeline execution, making it flexible and reusable.
