# cromwell-ubuntu18-devbox
Development environment for Broad's cromwell wdl workflows with cromwell, croo and WOMtool, built on Ubuntu 18.04 

## How do I use this ? 
```
https://github.com/tweep/cromwell-ubuntu18-devbox.git
cd cromwell-ubuntu18-devbox 
make test 
make run  
java -jar cromwell-XY.jar helloWorld.wdl
``` 

## Development via container 
Running `make test` will start a container and mount the code to `/home/Users/ubuntu/code`. You can modify the code/wdl in the checkout  outside of the container, however changes will be visible inside the container.   

```  
cd cromwell-ubuntu18-devbox 
make test 
cd /home/ubuntu/code 
make helloWorld 
```
