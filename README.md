# Template for ROS

This holds docker containers so we can work together very easily

In the file run you can find several functions that can be used to setup the environment

Be sure that docker engine is installed ( we don't need the docker desktop)

1. chmod +x ./run

2. sudo ./run build

3. To run the simulation: sudo ./run start

4. There is still a problem if you run it once, so go into the terminal container and build. Then restart everything and it would be fine

5. development docker -> so you can build: sudo ./run terminal

6. Before shutting down: sudo ./run stop

There is a alias for building: cbuild in all containers

Adding packages from online sources can be done in the dockerfile -> so that everyone get the same environment
