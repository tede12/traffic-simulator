import React, {useEffect, useState} from 'react';
import axios from 'axios';
import {styled} from '@mui/material/styles';
import CircleIcon from '@mui/icons-material/Circle';
import {Box, CardContent} from "@mui/material";
import {green, red} from '@mui/material/colors';
import {apiUrl} from "../coffee/settings";


const CustomizedCircleIcon = styled(CircleIcon)`
  animation: blinker 1.5s linear infinite;

  @keyframes blinker {
    70% {
      opacity: 0.7; // 0
    }
  }
`;


function Connection() {
    // const [data, setData] = useState([]);
    const [connected, setConnected] = useState(false);
    const [lastConnection, setLastConnection] = useState(null);
    const [timePassed, setTimePassed] = useState(null);


    const displayTime = (seconds, granularity = 2) => {
        let result = [];

        const intervals = [
            ['w', 604800],
            ['d', 86400],
            ['h', 3600],
            ['m', 60],
            ['s', 1],
        ];

        for (let i = 0; i < intervals.length; i++) {
            let name = intervals[i][0];
            let count = intervals[i][1];

            let value = Math.floor(seconds / count);
            if (value) {
                seconds -= value * count;
                result.push(`${value}${name}`);
            }
        }

        let res = result.slice(0, granularity).join(', ');
        if (!res) {
            return `${seconds.toFixed(0)}s ago`;
        }
        return `${res} ago`;
    };


    const convertTimeToReadable = () => {
        if (!lastConnection) {
            return null;
        }
        return displayTime((new Date() - lastConnection) / 1000);
    };

    const fetchDataSync = () => {
        axios.get(apiUrl + '/isConnected', {
            headers: {
                'Content-Type': 'application/json',
            },
            mode: 'cors',
            timeout: 3000,
        }).then((res) => {

            // setData(res.data);

            setConnected(true);
            setLastConnection(new Date());

        }).catch((err) => {
            // console.log(err);
            setConnected(false);
        });

    };

    useEffect(() => {
        // first fetch (for setting the initial state)
        fetchDataSync();

        // then fetch every 5 seconds
        const fetchDataInterval = setInterval(() => {
            fetchDataSync();
        }, 5000);

        // then update the time passed every second
        const updateTimePassedInterval = setInterval(() => {
            setTimePassed(convertTimeToReadable());
        }, 1000);

        // Cleanup function to clear intervals when the component unmounts or when dependencies change
        return () => {
            clearInterval(fetchDataInterval);
            clearInterval(updateTimePassedInterval);
        };
    }); // Empty dependency array ensures that the effect runs only once

    return (
        <CardContent>
            <Box sx={{position: 'relative'}}>   {/*  sx={{position: 'relative', height: 200}}>*/}
                <div style={{minHeight: '50px', display: 'flex', justifyContent: 'left', alignItems: 'center'}}>
                    <div
                        style={{marginLeft: '10px', width: '20px', height: '20px', borderRadius: '10px',}}> {connected ?
                        <CustomizedCircleIcon sx={{color: green[700]}} fontSize="small"/> :
                        <CustomizedCircleIcon sx={{color: red[700]}} fontSize="small"/>
                    } </div>
                    <div style={{marginLeft: '10px'}}>
                        <span
                            style={{paddingRight: '20px'}}>Connection {connected ? 'active' : 'inactive'} {timePassed ? '(' + timePassed + ')' : ''} </span>
                        <span style={{paddingRight: '20px'}}> - </span>
                        <a href={apiUrl} target="_blank" rel="noopener noreferrer"> API</a>
                    </div>

                </div>
            </Box>
        </CardContent>
    );
}

export default Connection;



