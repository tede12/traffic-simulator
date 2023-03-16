import Box from '@mui/material/Box';
import Grid from '@mui/material/Grid';


function App() {
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
                            position: "relative"
                        }}/>
                    </Grid>
                    <Grid item xs={2} padding={2}>

                        <h4>Debug options</h4>
                        {/* GUI */}
                        <div id="gui" style={{position: "absolute"}}/>
                        <p>Alive cars:
                            {/*<span id="aliveCars">{window.world.cars.objects.length}</span>*/}
                        </p>

                    </Grid>
                </Grid>
            </Box>

        </div>

    );
}

export default App;
