docker build -t stephengrider/multi-client:latest -t milkplease/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t cygnetops/multi-server-pgfix-5-11:latest -t milkplease/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t stephengrider/multi-worker:latest -t milkplease/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push stephengrider/multi-client:latest
docker push cygnetops/multi-server-pgfix-5-11:latest
docker push stephengrider/multi-worker:latest

docker push milkplease/multi-client:$SHA
docker push milkplease/multi-server:$SHA
docker push milkplease/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=milkplease/multi-server:$SHA
kubectl set image deployments/client-deployment client=milkplease/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=milkplease/multi-worker:$SHA