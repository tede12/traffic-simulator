# Traffic simulator

[Github](https://github.com/volkhin/RoadTrafficSimulator)  
[Online demo](http://volkhin.com/RoadTrafficSimulator/)

# How to run

1. Install all dependencies  
   `npm install`

2. Run 2 scripts in parallel  
   `npm run cstart`  
   `npm run start`

# Commands

- shift + click - add new intersection
- shift + drag - add new road
- ctrl + click (on lanes) - add new car (if track path exists the car will follow it)
- alt (or option) + click (on intersections) - add new point to track path
- alt (or option) + click (everywhere except intersections) - remove last point from track path
- alt (or option) + 's' - save and draw track path (if it exists, else remove it)
- alt (or option) + 'c' - send path to pathFinder, draw path and start car (needs pathFinder server running)
  - repeating the command in different period of time, you will get the best path in the current situation

## TODO

- [see 3D model](http://lo-th.github.io/root/traffic/) for inspiration
- [pathfinding](https://github.com/lo-th/Dedal.lab)


### ROADMAP
- [x] Draw car path
- [x] Draw a priori track path
- [x] Choose destination for my car
- [x] Add algorithm for pathfinding
- [x] Enable resize of map when Running checkbox is off and generate only closed maps
- [ ] Send map first time to pathFinder, add Unique ID for each map
- [ ] NO spawn cars when my car is placed on the road for 5 seconds
- [ ] Add little screen with my car info on the simulator
- [ ] Set new weights and get the current best path when car is moving
- [ ] Socket for checking if pathFinder server is running
- [ ] Control my car with arrow keys

### BUGS
- [ ] Fix blocked cars (see on .move() method of Car class)
- [ ] Check algorithm for car generation and trajectory
- [ ] After the pathFinder sends the new path, if there are too many cars on the road, myCar fails to get direction


# TIPS
- drawSegment must be called like this:
   ```coffeescript
   @graphics.drawSegment(myRoad.middleLine)
   @graphics.stroke 'green'
   ```
- `mousedown` event should be bound to `canvas` element, not `window` or `document` otherwise it will stick the map to the mouse cursor when you drag it

- **CORS** are all fixed, for running javascript debugger without errors with WebStorm, just follow these steps:
    `Settings -> Build, Execution, Deployment -> Debugger -> Allow unsigned requests` this prevent from adding 
unauthorized headers to requests.