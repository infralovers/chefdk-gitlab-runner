# chefdk-gitlab-runner


A custom jenkins docker image to run chefdk operations within this image. 

## Build it

```bash
docker build -t infralovers/chefdk-gitlab-runner:latest .
```

To use a different jenkins:slave version:

```bash
docker build -t infralovers/chefdk-gitlab-runner:latest --build-arg RUNNER_VERSION=ubuntu-v11.5.1 .
```

To switch the chefdk version you can use following parameter

```bash
docker build -t infralovers/chefdk-gitlab-runner:latest --build-arg CHEF_VERSION=3.5.13 .
```

You can also combine those parameters to customize the docker image.

## Configure the Container instance

```bash
export GITLAB_URL="https://my.gitlab.com"
export GITLAB_CONFIG="/srv/gitlab-runner/config"
export GITLAB_TOKEN="12345"

docker run --rm -t -i \
  -v $GITLAB_CONFIG:/etc/gitlab-runner \
  --name gitlab-runner \
  gitlab/gitlab-runner register \
  --non-interactive \
  --executor "docker" \
  --docker-privileged \
  --docker-image alpine:3 \
  --url "$GITLAB_URL" \
  --registration-token "$GITLAB_TOKEN" \
  --description "docker-runner" \
  --tag-list "docker" \
  --run-untagged \
  --locked="false"
  ```
  
## Run the container instance

  ```bash
  docker run -d --name gitlab-runner --restart always \
  -v $GITLAB_CONFIG:/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --name gitlab-runner \
  gitlab/gitlab-runner
```
