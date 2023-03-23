# Traffic simulator

[Github](https://github.com/volkhin/RoadTrafficSimulator)  
[Online demo](http://volkhin.com/RoadTrafficSimulator/)

# How to run

1. Install all dependencies  
   `npm install`

2. Run 2 scripts in parallel  
   `npm cstart`  
   `npm start`

# Commands

- shift + click - add new intersection
- shift + drag - add new road
- ctrl + click - add my car (only on intersections with signal lights)

## TODO

- [see 3D model](http://lo-th.github.io/root/traffic/) for inspiration
- [pathfinding](https://github.com/lo-th/Dedal.lab)


### ROADMAP
- [x] Draw car path
- [ ] Draw a priori track path
- [ ] Choose destination for my car
- [ ] Add algorithm for pathfinding
- [ ] Control my car with arrow keys

### BUGS
- [ ] Fix blocked cars (see on .move() method of Car class)
- [ ] Check algorithm for car generation and trajectory
- 