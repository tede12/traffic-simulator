import React, {useEffect, useState} from 'react';
import axios from 'axios';
import {styled} from '@mui/material/styles';
import CircleIcon from '@mui/icons-material/Circle';
import {Box, CardContent} from "@mui/material";
import {green, red} from '@mui/material/colors';


const CustomizedCircleIcon = styled(CircleIcon)`
  animation: blinker 1.5s linear infinite;

  @keyframes blinker {
    70% {
      opacity: 0.7; // 0
    }
  }
`;


function Connection() {
    const [data, setData] = useState([]);
    const [connected, setConnected] = useState(false);
    const [lastConnection, setLastConnection] = useState(null);
    const [timePassed, settimePassed] = useState(null);
    const [animate, setAnimate] = useState(false);

    const API_URL = 'http://127.0.0.1:8000/api/';

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
        axios.get(API_URL + 'isConnected', {
            headers: {
                'Content-Type': 'application/json',
            },
            mode: 'cors',
            timeout: 3000,
        }).then((res) => {

            setData(res.data);

            setConnected(true);
            setLastConnection(new Date());

        }).catch((err) => {
            // console.log(err);
            setConnected(false);
        });

    };

    useEffect(() => {
        fetchDataSync();
        const intervalId = setInterval(fetchDataSync, 5000);
        return () => clearInterval(intervalId);
    }, []);

    useEffect(() => {

        settimePassed(convertTimeToReadable());
        const intervalId = setInterval(() => {
            settimePassed(convertTimeToReadable());
        }, 1000);
        return () => clearInterval(intervalId);

    }, [connected, convertTimeToReadable, lastConnection]);

    // For animation of connected/disconnected
    useEffect(() => {
        let intervalId = setInterval(() => {
            setAnimate(!animate);
        }, 1000);

        return () => clearInterval(intervalId);
    }, [animate]);


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
                        <a href={API_URL} target="_blank" rel="noopener noreferrer"> API</a>
                    </div>

                </div>
            </Box>
        </CardContent>
    );
}

export default Connection;



