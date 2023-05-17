import {Component} from "react";
import {Box, Grid} from '@mui/material';
import Connection from "./components/Connection";
import VirtualScreen from "./components/VirtualScreen";


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
                    <h2 style={{textAlign: "center"}}>Smart Traffic Simulator</h2>
                </header>

                <Box>
                    <Grid container>
                        {/* CANVAS */}
                        <Grid item xs={10}>
                            <canvas id="canvas" style={{
                                top: 0,
                                left: 0,
                                width: "100%",
                                // Height should be in px and the 90% of the window height
                                height: window.innerHeight * 0.85 + "px",
                                display: "block",        // Absolutely needed
                                // position: "relative"
                                // overflow: "hidden"
                            }}/>
                        </Grid>

                        {/* GUI */}
                        <Grid item xs={2} padding={1}>
                            <h4>Debug options</h4>

                            <div id="gui" style={{
                                // position: "absolute"
                                height: window.innerHeight * 0.55 + "px",
                            }}/>

                            {/* VIRTUAL SCREEN */}
                            <VirtualScreen/>

                        </Grid>
                        {/* ----- CONNECTION ----- */}
                        <Connection/>
                    </Grid>


                </Box>


            </div>

        );
    }
}


