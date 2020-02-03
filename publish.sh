sh ./build.sh
docker login
docker tag devside/node-gcloud-helm:13.6.0
docker push devside/node-gcloud-helm:13.6.0
