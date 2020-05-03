# pahud/aws-cdk-autobuild
**aws-cdk-autobuild** is an autobuild docker image generated and pushed to docker hub on a hourly basis with [@pahud/aws-codebuild-patterns](https://www.npmjs.com/package/@pahud/aws-codebuild-patterns) running in **AWS CodeBuild**. Behind the scene a codebuild project just git clone the master branch from `aws/aws-cdk` and docker build into `pahud/aws-cdk-autobuild:latest` based on the [Dockerfile](https://github.com/aws/aws-cdk/blob/master/Dockerfile) provided in aws/aws-cdk. Check the [buildspec.yml](./buildspec.yml) file for the CodeBuild project in use.

## latest docker image URI
[pahud/aws-cdk-autobuild:latest](https://hub.docker.com/repository/docker/pahud/aws-cdk-autobuild)

## CDK development in the container

As `pahud/aws-cdk-autobuild:latest` auto builds itself everyday from the `aws/aws-cdk` master branch, you probably would love to pull the image to the local, spinning up a docker and develop in the container with your favorite IDE such as VSCode or Cloud9. The following steps is my current practice.

```bash
# update the docker image
docker pull pahud/aws-cdk-autobuild:latest
# run a container
container=$(docker run -d --entrypoint='' pahud/aws-cdk-autobuild:latest false)
# copy /app from the container to local
docker cp ${container}:/app ./
# delete the container
docker rm -f ${container}

# let's run another container and mount the local ./app into the container:/app
# so we can develop with our favorite IDE outsides the container while we still can build or test it in the container
# enter the shell of the container
docker run -ti --entrypoint='' \
-v $PWD/app:/app \
-v $HOME/.aws:/root/.aws \
-v $HOME/.ssh:/root/.ssh \
-e PS1='\[\033[01;32m\]$(whoami)(cdk-docker)\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1 " (%s)" 2>/dev/null) $' \
pahud/aws-cdk-autobuild bash


# some prerequisities in the container
export PATH=$PATH:/app/node_modules/.bin:/app/packages/cdk/node_modules/.bin
npm i -D lerna
npm i -g aws-cdk


# runs an npm script via lerna for a the current module
alias lr='/app/node_modules/.bin/lerna run --stream --scope $(node -p "require(\"./package.json\").name")'

# runs "yarn build" (build + test) for the current module
alias lb='lr build'
alias lt='lr test'

# runs "yarn watch" for the current module (recommended to run in a separate terminal session):
alias lw='lr watch'

# we still need to run yarn install
yarn install
```

```


