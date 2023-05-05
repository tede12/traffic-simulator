import Box from '@mui/material/Box';
import Grid from '@mui/material/Grid';
import {Component} from "react";


export default class App extends Component {
    constructor(props) {
        super(props);
        this.state = {
            carsNumber: 0
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

                <Box sx={{flexGrow: 1}}>
                    <Grid container spacing={2}>
                        <Grid item xs={10} padding={2}>
                            {/* CANVAS */}
                            <canvas id="canvas" style={{
                                top: 0,
                                left: 0,
                                width: "100%",
                                height: "100%",
                                display: "block"        // Absolutely needed
                                // position: "relative"
                            }}/>
                        </Grid>
                        <Grid item xs={2} padding={2}>

                            <h4>Debug options</h4>
                            {/* GUI */}
                            <div id="gui" style={{
                                // position: "absolute"
                            }}/>

                            <h2>Alive cars: <br/>
                                <span>{this.state.carsNumber}</span>
                            </h2>

                        </Grid>
                    </Grid>
                </Box>

            </div>

        );
    }
}


