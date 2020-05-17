FROM pahud/aws-cdk-autobuild:buildtools

FROM gitpod/workspace-full

COPY --from=0 /app /workspace/app

ENV foo bar
