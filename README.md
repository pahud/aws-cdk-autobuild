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

## build your own autobuild pipeline and docker image
check the CDK script sample [here](https://github.com/pahud/cdk-samples/blob/5008183a4a73b6380969eb5147c0a46e474fda91/typescript/packages/aws-codebuild-patterns/samples/all.ts#L215-L275) to generate your own autobuild with CodeBuild


# pahud/aws-cdk-basic-runtime

This image aims to provide a minimal CDK runtime with node LTS and alpine linux while provides complete `node_modules` support.([compressed image size ~170MB](https://hub.docker.com/r/pahud/aws-cdk-basic-runtime/tags))

```bash
# build the runtime image
docker build -t pahud/aws-cdk-basic-runtime --build-arg BUILD_ARGS='--skip-test' . -f Dockerfile.runtime
```


