// Development API
// const apiUrl = 'http://localhost:8000/api';

// Production API
const apiUrl = 'https://itas.ddns.net/api';

const settings = {
    colors: {
        background: '#FFFFFF', // 97a1a1'
        redLight: 'hsl(0, 100%, 50%)',
        greenLight: '#85ee00',
        intersection: '#586970',
        road: '#586970',
        roadMarking: '#bbb',
        hoveredIntersection: '#3d4c53',
        tempRoad: '#aaa',
        gridPoint: '#586970',
        grid1: 'rgba(255, 255, 255, 0.5)',
        grid2: 'rgba(220, 220, 220, 0.5)',
        hoveredGrid: '#f4e8e1',
        hoveredLane: '#dbd0ca',
    },
    fps: 30,
    lightsFlipInterval: 260,
    gridSize: 14,
    mapSize: 4, // default is 2
    averageCarLength: 4.5,
    defaultTimeFactor: 5,
    defaultZoomLevel: 3, // Change this value to change the default zoom level (default is 3)
    maxZoomLevel: 20,
    minZoomLevel: 0.1,
    defaultMap: 'mappa_1', // null to disable or 'mappa_1' to enable
    connectedMap: true, // enable to generate only connected maps (all intersections are connected)
    debug: true,
    myWidth: 0,
    myHeight: 0,

    // signals settings
    showRedLights: true,
    triangles: true, // false -> circles
    trafficHighlight: true,
    carsNumber: 150,
    carsGap: 5,
    waitCarSpawn: 40, // time dependent to the canvas time factor, it's not seconds
    tooLongStop: 1000,

    // car settings
    myCar: {
        id: 'MACCHINA',
        color: '#000000',
        maxFollowPoints: 1000, // 3000 is the default value, 0 to disable
        carLine: 'white',
    },

    // roads setting
    updateRoadsInterval: 50,
    onlinePathUpdateInterval: 100,

    // API
    apiUrl: apiUrl,
    pathFinderUrl: apiUrl + '/pathFinder',
    mapUrl: apiUrl + '/map',
    roadsUrl: apiUrl + '/roads',
    onlinePathFinderUrl: apiUrl + '/onlinePathFinder',

    // mqtt settings
    mqtt: {
        port: 8883,
        protocol: 'mqtts',
        host: 'io.adafruit.com',
        username: 'sirmat',
        password: 'aio_CcIX34dhmTJxDN8msWlCWnciTmGd',
        topic: 'sirmat/feeds/path', // username + feed = sirmat + /feeds/path
    },

    // debug
    debugTestHtml: document.getElementById('test') != null, // true if I am in the test.html page
};

module.exports = settings;
