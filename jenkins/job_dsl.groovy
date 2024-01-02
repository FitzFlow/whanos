BASE_DIR = "INSERT_YOUR_PATH_HERE"

folder('Whanos base images') {
    description('base images')
}

folder('Projects') {
    description('projects')
}

freeStyleJob('Whanos base images/whanos-c') {
    steps {
        shell("docker build -t whanos-c $BASE_DIR/images/c/Dockerfile.base")
        shell("docker tag whanos-c localhost:5001/whanos-c")

        shell("docker push localhost:5001/whanos-c")
        shell("docker pull localhost:5001/whanos-c")
        shell("docker rmi whanos-c")
    }
    triggers {
        upstream('Build all base images')
    }
}

freeStyleJob('Whanos base images/whanos-java') {
    steps {
        shell("docker build -t whanos-java - < $BASE_DIR/images/java/Dockerfile.base")
        shell("docker tag whanos-java localhost:5001/whanos-java")

        shell("docker push localhost:5001/whanos-java")
        shell("docker pull localhost:5001/whanos-java")
        shell("docker rmi whanos-java")
    }
    triggers {
        upstream('Build all base images')
    }
}

freeStyleJob('Whanos base images/whanos-javascript') {
    steps {
        shell("docker build -t whanos-javascript $BASE_DIR/images/javascript/Dockerfile.base")
        shell("docker tag whanos-javascript localhost:5001/whanos-javascript")

        shell("docker push localhost:5001/whanos-javascript")
        shell("docker pull localhost:5001/whanos-javascript")
        shell("docker rmi whanos-javascript")
    }
    triggers {
        upstream('Build all base images')
    }
}

freeStyleJob('Whanos base images/whanos-python') {
    steps {
        shell("docker build -t whanos-python - < $BASE_DIR/images/python/Dockerfile.base")
        shell("docker tag whanos-python localhost:5001/whanos-python")

        shell("docker push localhost:5001/whanos-python")
        shell("docker pull localhost:5001/whanos-python")
        shell("docker rmi whanos-python")
    }
    triggers {
        upstream('Build all base images')
    }
}

freeStyleJob('Whanos base images/whanos-befunge') {
    steps {
        shell("docker build -t whanos-befunge - < $BASE_DIR/images/befunge/Dockerfile.base")
    }
    triggers {
        upstream('Build all base images')
    }
}

freeStyleJob('Build all base images') {
    triggers {
        upstream('*')
    }
}

BASE_DIR = "/Users/fitzflorian/delivery/tek3/DevOps/B-DOP-500-RUN-5-1-whanos-florian.etheve"

freeStyleJob('link-project') {
    parameters {
        stringParam('GITHUB_URL', '', 'GitHub repository URL')
        stringParam('DISPLAY_NAME', '', 'Display name for the job')
    }
    steps {
        dsl {
            text('''
                freeStyleJob("Projects/$DISPLAY_NAME") {
                    scm {
                        git {
                            remote {
                                name("main")
                                url("$GITHUB_URL")
                            }
                        }
                    }
                    steps {
                        shell("INSERT_YOUR_PATH_HERE/jenkins/find_language.sh")
                    }
                    triggers {
                        scm("* * * * *")
                    }
                    wrappers {
                        preBuildCleanup()
                    }
                }
            ''')
        }
    }
}