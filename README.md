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

## TODO

- [see 3D model](http://lo-th.github.io/root/traffic/) for inspiration
- [pathfinding](https://github.com/lo-th/Dedal.lab)


### ROADMAP
- [x] Draw car path
- [x] Draw a priori track path
- [ ] Choose destination for my car
- [ ] Add algorithm for pathfinding
- [ ] Control my car with arrow keys

### BUGS
- [ ] Fix blocked cars (see on .move() method of Car class)
- [ ] Check algorithm for car generation and trajectory


# TIPS
drawSegment must me called like this:
```coffeescript
@graphics.drawSegment(myRoad.middleLine)
@graphics.stroke 'green'
```