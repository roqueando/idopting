# Idopting

Idopting is a mini project to show how distributed computing works with RPC and other architectures that is not microservices only.

## Workers

In that project we have four workers: Main, Products and Checkout. All that workers communicate with main (and can be communicated with other services too).

### Main
Is a simple process that will be running the client interface. Think `main` as a running process or a http server, the client must have a interface to interact with other workers.

### Products
That worker will just return a list of products that Idopting give to the client choose to pass into checkout

### Checkout
That worker will do a long process that will be simulating the process of buying the product. When the process finishes, will send a message to `main` alerting that product was bought successfully.


## Okay, but what is the magic in this?

Well, that is an another architecture to build a system, and fault tolerant. If the some authorization service drop out, the customers must still buy products without registration. If it's already logged in into the system and the authorization service fell, these customers must see all the list. If all of that just is not reachable but the customer is in the checkout ready to buy the product, the system needs to authorize that transaction even the product list wast not working.

## But is kinda microservices?

No, that architecture will use isolated deployments for each worker and will not be a HTTP or web server concept, we will work with processes, like the old times. These processes will stay in a erlang machine inside a server (Cloud, VPS, Docker, etc) running a long process that will be our worker, being ready to listen messages and RPC calls, using all the power of the machine. And the client (main) will communicate with other nodes by using RPC calls, and then all that things will be processed in isolated parts.

## Why not use gRPC to do that?
If I have a tested and covered tool that is inside Elixir to handle with RPC calls, is more than sufficient to handle that.

## Pros
- That architecture will use umbrella to organize in a monorepo
- Can be tested in isolation
- Can be created a release for all workers and deploy that on your own

## Cons
- All that things will be communicated by RPC calls (only if you separate everything in each worker)
- To find other nodes you need to manually discover the machine that is running that process.
