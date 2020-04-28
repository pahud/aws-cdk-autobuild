# pahud/aws-cdk-autobuild
**aws-cdk-autobuild** is an autobuild docker image generated and pushed to docker hub every day automatically with [@pahud/aws-codebuild-patterns](https://www.npmjs.com/package/@pahud/aws-codebuild-patterns) running in **AWS CodeBuild** by _Pahud Hsieh_. The image provides you with the latest `node_modules`  generated from the `packages` from the aws/aws-cdk official github repository.

## docker hub 
[pahud/aws-cdk-autobuild:latest](https://hub.docker.com/repository/docker/pahud/aws-cdk-autobuild)

## why should I use it
This image gives you all you need out-of-the-box and you don't have to `npm install` any required `@aws-cdk` modules.

## image content
The docker image provides `/app/node_modules` built and generated with the `build.sh` and `linkall.sh` command so you don't have to `npm install` extra `@aws-cdk` node_modules  in your local environment. You just need to mount some required folders and files with `docker run -v`. Check the sample usage below.

## sample usage

```sh
# create any empty dir
$ mdkir demo && cd demo
$ cdk init -l typescript
$ npm run build
# make the alias
$ alias cdk-docker='docker run -ti -v $(pwd)/bin:/app/bin -v $(pwd)/lib:/app/lib -v $(pwd)/cdk.json:/app/cdk.json -v ${HOME}/.aws:/root/.aws -w /app pahud/aws-cdk-autobuild:latest'
# get the version
$ cdk-docker --version
# cdk synth in the docker container
$ cdk-docker synth
# cdk deploy in the docker  container 
$ cdk-docker deploy
# destroy it
$ cdk-docker destroy
```

Check the **CONTRIBUTING.md** from `aws/aws-cdk` for more details about how to use the docker image.

https://github.com/aws/aws-cdk/blob/master/CONTRIBUTING.md#full-docker-build

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


