import React, {useState} from 'react';
import {IconButton, Menu, MenuItem, Tooltip} from '@mui/material';
import {Clear, ControlPoint, DirectionsCar, Gesture} from '@mui/icons-material';
import InfoOutlinedIcon from '@mui/icons-material/InfoOutlined';

const commandList = [
    {
        icon: Gesture, command: '⇧ + Click', description: 'Add new intersection',
    },
    {
        icon: Gesture, command: '⇧ + Drag', description: 'Add new road',
    },
    {
        icon: ControlPoint, command: 'Ctrl + Click (on lanes)', description: 'Add new car',
    },
    {
        icon: ControlPoint, command: 'Alt + Click (on intersections)', description: 'Add new point to track path',
    },
    {
        icon: Clear, command: 'Alt + Click (everywhere except intersections)',
        description: 'Remove last point from track path',
    },
    {
        icon: Gesture, command: 'Alt + Ｓ', description: 'Save and draw track path',
    },
    {
        icon: DirectionsCar, command: 'Alt + C',
        description: 'Send path to pathFinder, draw path, and start car',
    },
    {
        icon: DirectionsCar, command: 'Alt + G',
        description: 'Ask the shortest path based on road length and draw path',
    },
];

const LegendButton = () => {
    const [anchorEl, setAnchorEl] = useState(null);

    const handleClick = (event) => {
        setAnchorEl(event.currentTarget);
    };

    const handleClose = () => {
        setAnchorEl(null);
    };

    const menuItemStyle = {
        display: 'flex',
        alignItems: 'center',
        position: 'relative',
        paddingRight: '25px',
        borderLeft: '2px solid #ccc',
        height: '100%',
    };

    const commandStyle = {};

    const descriptionStyle = {
        fontSize: '13px',
        fontWeight: 'bold',
    };

    return (
        <>
            <Tooltip title="Legend">
                <IconButton onClick={handleClick}>
                    <InfoOutlinedIcon/>
                </IconButton>
            </Tooltip>
            <Menu
                anchorEl={anchorEl}
                open={Boolean(anchorEl)}
                onClose={handleClose}
                anchorOrigin={{
                    vertical: 'top',
                    horizontal: 'right',
                }}
                transformOrigin={{
                    vertical: 'top',
                    horizontal: 'right',
                }}
            >
                {commandList.map((item, index) => (
                    <MenuItem key={index} sx={menuItemStyle}>
                        {React.createElement(item.icon, {sx: {marginRight: '10px'}})}
                        <div>
                            <div style={commandStyle}>{item.command}</div>
                            <div style={descriptionStyle}>{item.description}</div>
                        </div>
                    </MenuItem>
                ))}
            </Menu>
        </>
    );
};

export default LegendButton;
