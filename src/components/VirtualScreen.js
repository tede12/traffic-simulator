import React, {useEffect, useState} from 'react';
import {Card, CardContent, Grid, Typography} from '@mui/material';
import {ArrowDownward, ArrowUpward, DirectionsCar, TurnLeft, TurnRight} from '@mui/icons-material';

const VirtualScreen = () => {

    // Get the virtual screen data from the window object every time it changes
    const [virtualScreen, setVirtualScreen] = useState({
        carAcceleration: 0,
        carDirection: undefined,
        carLane: undefined,
        carRoad: undefined,
        carSpeed: 0,
        carTargetLane: undefined
    });

    const getNewData = () => {
        if (window?.virtualScreen === undefined) {
            return;
        }

        setVirtualScreen(window.virtualScreen);
    };

    // Update the virtual screen data every time it changes
    useEffect(() => {
        setInterval(() => {
                getNewData();
            }, 500
        );


    }, []);


    return (
        <Card>
            <CardContent>
                <Typography variant="h6" gutterBottom>
                    Navigator
                </Typography>
                <Grid container spacing={2} alignItems="center">
                    <Grid item xs={12} sm={6} md={4}>
                        <Grid direction="column" alignItems="center" justifyContent="center">
                            <div style={{
                                transition: 'transform 0.5s'
                            }}>
                                {virtualScreen.carDirection === 'up' ? <ArrowUpward fontSize="large"/> : <></>}
                                {virtualScreen.carDirection === 'down' ? <ArrowDownward fontSize="large"/> : <></>}
                                {virtualScreen.carDirection === 'left' ? <TurnLeft fontSize="large"/> : <></>}
                                {virtualScreen.carDirection === 'right' ? <TurnRight fontSize="large"/> : <></>}
                            </div>

                            <div style={{transition: 'left 0.5s'}}>
                                <DirectionsCar fontSize="large"/>
                            </div>
                        </Grid>
                    </Grid>
                    <Grid item xs={12} sm={6} md={8}>
                        <Typography variant="body2" component="div">
                            <strong>Acceleration:</strong> {virtualScreen.carAcceleration || 'N/A'}
                        </Typography>
                        <Typography variant="body2" component="div">
                            <strong>Direction:</strong> {virtualScreen.carDirection || 'N/A'}
                        </Typography>
                        <Typography variant="body2" component="div">
                            <strong>Lane:</strong> {virtualScreen.carLane || 'N/A'}
                        </Typography>
                        <Typography variant="body2" component="div">
                            <strong>Road:</strong> {virtualScreen.carRoad || 'N/A'}
                        </Typography>
                        <Typography variant="body2" component="div">
                            <strong>Speed:</strong> {virtualScreen.carSpeed || 'N/A'}
                        </Typography>
                        <Typography variant="body2" component="div">
                            <strong>Next Lane:</
                                strong> {virtualScreen.carTargetLane || 'N/A'}
                        </Typography>
                    </Grid>
                </Grid>
            </CardContent>
        </Card>
    );
};

export default VirtualScreen;

