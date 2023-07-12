import {Component} from "react";
import Connection from "./components/Connection";
import VirtualScreen from "./components/VirtualScreen";
import LegendButton from './components/Legend';
import {Box, Grid} from '@mui/material';


export default class App extends Component {
    constructor(props) {
        super(props);
        this.state = {
            carsNumber: 0,
        }

    }

    componentDidMount() {
        this.timer = setInterval(() => {
            if (window.world === undefined) return
            let carsNumber = Object.keys(window.world.cars.objects).length
            this.setState({carsNumber: carsNumber})
        }, 1000)
    }

    componentWillUnmount() {
        clearInterval(this.timer)
    }

    render() {
        return (
            <div className="App">
                <header className="App-header">
                    <h3 style={{textAlign: "center"}}>Smart Traffic Simulator</h3>
                </header>

                <Box>
                    <Grid container>
                        {/* CANVAS */}
                        <Grid item xs={10}>
                            <canvas
                                id="canvas"
                                style={{
                                    top: 0,
                                    left: 0,
                                    width: "100%",
                                    // Height should be in px and the 90% of the window height
                                    height: window.innerHeight * 0.87 + "px",
                                    display: "block", // Absolutely needed
                                    // position: "relative"
                                    // overflow: "hidden"
                                }}
                            />
                        </Grid>

                        <Grid item xs={2} padding={1}>
                            {/*<h4>Debug options</h4>*/}
                            {/* GUI */}

                            <Grid item xs={12}>
                                <div
                                    id="gui-container"
                                    style={{
                                        height: window.innerHeight * 0.6 + "px",
                                        overflowY: "auto", // Enable vertical scrolling
                                        overflowX: "hidden",    // Disable horizontal scrolling
                                        // padding: "10px", // Add padding for aesthetics
                                    }}
                                >
                                    <div id="gui"/>
                                </div>
                            </Grid>

                            {/* VIRTUAL SCREEN */}
                            <VirtualScreen/>

                        </Grid>
                        {/* ----- CONNECTION ----- */}
                        <Connection/>
                        {/* ----- LEGEND ----- */}
                        <LegendButton />
                    </Grid>
                </Box>
            </div>

        );
    }
}


