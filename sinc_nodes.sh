#!/bin/bash

# Detener y arrancar el nodo 1
docker stop nodeth1
sleep 5
docker start nodeth1
sleep 30  # Aumentar el tiempo de espera para que el nodo se sincronice nuevamente

# Verificar el número de bloque en todos los nodos
NODE1_BLOCK=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://localhost:8545 | jq -r .result)
NODE2_BLOCK=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://localhost:8546 | jq -r .result)
NODE3_BLOCK=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://localhost:8547 | jq -r .result)

# Verificar si los contenedores están en funcionamiento
if [ "$(docker inspect -f '{{.State.Running}}' nodeth1)" != "true" ]; then
  echo "nodeth1 no está en funcionamiento."
  exit 1
fi

if [ "$(docker inspect -f '{{.State.Running}}' nodeth2)" != "true" ]; then
  echo "nodeth2 no está en funcionamiento."
  exit 1
fi

if [ "$(docker inspect -f '{{.State.Running}}' nodeth3)" != "true" ]; then
  echo "nodeth3 no está en funcionamiento."
  exit 1
fi

echo "Nodo 1 está en el bloque: $NODE1_BLOCK"
echo "Nodo 2 está en el bloque: $NODE2_BLOCK"
echo "Nodo 3 está en el bloque: $NODE3_BLOCK"

if [ "$NODE1_BLOCK" == "$NODE2_BLOCK" ] && [ "$NODE1_BLOCK" == "$NODE3_BLOCK" ]; then
  echo "Todos los nodos están sincronizados."
else
  echo "Los nodos no están sincronizados."
fi
