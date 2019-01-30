docker build -t stephengrider/multi-client:latest -t stephengrider/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t ygrinman/multi-server:latest -t ygrinman/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t ygrinman/multi-worker:latest -t ygrinman/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push stephengrider/multi-client:latest
docker push ygrinman/multi-server:latest
docker push ygrinman/multi-worker:latest

docker push stephengrider/multi-client:$SHA
docker push ygrinman/multi-server:$SHA
docker push ygrinman/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=ygrinman/multi-server:$SHA
kubectl set image deployments/client-deployment client=stephengrider/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=ygrinman/multi-worker:$SHA
