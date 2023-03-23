'use strict'
# Name (key) should be better if it doesn't contain spaces or special characters for correct mapping
savedMaps = {
    "map_media": {
        "intersections": {
            "intersection1": {
                "id": "intersection1",
                "rect": {
                    "x": -56,
                    "y": -70,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.49333182358600114,
                    "phaseOffset": 36.003182098761854
                }
            },
            "intersection2": {
                "id": "intersection2",
                "rect": {
                    "x": -56,
                    "y": -28,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.9931487871201317,
                    "phaseOffset": 94.45425662419179
                }
            },
            "intersection3": {
                "id": "intersection3",
                "rect": {
                    "x": -56,
                    "y": 14,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.5111694993383065,
                    "phaseOffset": 98.9535040345068
                }
            },
            "intersection4": {
                "id": "intersection4",
                "rect": {
                    "x": -14,
                    "y": 14,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.5204929088669135,
                    "phaseOffset": 11.398725456699443
                }
            },
            "intersection5": {
                "id": "intersection5",
                "rect": {
                    "x": 28,
                    "y": 14,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.3368730313018393,
                    "phaseOffset": 76.21517814974356
                }
            },
            "intersection6": {
                "id": "intersection6",
                "rect": {
                    "x": 28,
                    "y": -28,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.6838292154389645,
                    "phaseOffset": 16.695407344145806
                }
            },
            "intersection7": {
                "id": "intersection7",
                "rect": {
                    "x": 28,
                    "y": -70,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.05686790274246234,
                    "phaseOffset": 91.24943975662923
                }
            },
            "intersection8": {
                "id": "intersection8",
                "rect": {
                    "x": -14,
                    "y": -70,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.7500457945655898,
                    "phaseOffset": 0.17302231486515662
                }
            },
            "intersection9": {
                "id": "intersection9",
                "rect": {
                    "x": -14,
                    "y": -28,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.060722805547838155,
                    "phaseOffset": 35.01749440910415
                }
            }
        },
        "roads": {
            "road1": {
                "id": "road1",
                "source": "intersection8",
                "target": "intersection9"
            },
            "road2": {
                "id": "road2",
                "source": "intersection9",
                "target": "intersection8"
            },
            "road3": {
                "id": "road3",
                "source": "intersection9",
                "target": "intersection6"
            },
            "road4": {
                "id": "road4",
                "source": "intersection6",
                "target": "intersection9"
            },
            "road5": {
                "id": "road5",
                "source": "intersection6",
                "target": "intersection5"
            },
            "road6": {
                "id": "road6",
                "source": "intersection5",
                "target": "intersection6"
            },
            "road7": {
                "id": "road7",
                "source": "intersection5",
                "target": "intersection4"
            },
            "road8": {
                "id": "road8",
                "source": "intersection4",
                "target": "intersection5"
            },
            "road9": {
                "id": "road9",
                "source": "intersection4",
                "target": "intersection3"
            },
            "road10": {
                "id": "road10",
                "source": "intersection3",
                "target": "intersection4"
            },
            "road11": {
                "id": "road11",
                "source": "intersection3",
                "target": "intersection2"
            },
            "road12": {
                "id": "road12",
                "source": "intersection2",
                "target": "intersection3"
            },
            "road13": {
                "id": "road13",
                "source": "intersection2",
                "target": "intersection1"
            },
            "road14": {
                "id": "road14",
                "source": "intersection1",
                "target": "intersection2"
            },
            "road15": {
                "id": "road15",
                "source": "intersection1",
                "target": "intersection8"
            },
            "road16": {
                "id": "road16",
                "source": "intersection8",
                "target": "intersection1"
            },
            "road17": {
                "id": "road17",
                "source": "intersection8",
                "target": "intersection7"
            },
            "road18": {
                "id": "road18",
                "source": "intersection7",
                "target": "intersection8"
            },
            "road19": {
                "id": "road19",
                "source": "intersection7",
                "target": "intersection6"
            },
            "road20": {
                "id": "road20",
                "source": "intersection6",
                "target": "intersection7"
            },
            "road21": {
                "id": "road21",
                "source": "intersection9",
                "target": "intersection4"
            },
            "road22": {
                "id": "road22",
                "source": "intersection4",
                "target": "intersection9"
            },
            "road23": {
                "id": "road23",
                "source": "intersection9",
                "target": "intersection2"
            },
            "road24": {
                "id": "road24",
                "source": "intersection2",
                "target": "intersection9"
            }
        },
        "carsNumber": 2,
        "time": 173.50094999999797
    }
    "map_semplice": {
        "intersections": {
            "intersection21": {
                "id": "intersection21",
                "rect": {
                    "x": -42,
                    "y": 0,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.9479743836461125,
                    "phaseOffset": 94.66763575323544
                }
            },
            "intersection22": {
                "id": "intersection22",
                "rect": {
                    "x": 0,
                    "y": 0,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.9741343229976489,
                    "phaseOffset": 3.8664580723590136
                }
            },
            "intersection23": {
                "id": "intersection23",
                "rect": {
                    "x": 42,
                    "y": 0,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.6763116557404703,
                    "phaseOffset": 27.113770026741115
                }
            },
            "intersection24": {
                "id": "intersection24",
                "rect": {
                    "x": 42,
                    "y": -42,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.7196118014172435,
                    "phaseOffset": 42.09140048192721
                }
            },
            "intersection25": {
                "id": "intersection25",
                "rect": {
                    "x": 0,
                    "y": -42,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.31777769449575577,
                    "phaseOffset": 28.50633200161039
                }
            },
            "intersection26": {
                "id": "intersection26",
                "rect": {
                    "x": -42,
                    "y": -42,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.050492654229082,
                    "phaseOffset": 91.51886321434517
                }
            }
        },
        "roads": {
            "road57": {
                "id": "road57",
                "source": "intersection26",
                "target": "intersection21"
            },
            "road58": {
                "id": "road58",
                "source": "intersection21",
                "target": "intersection26"
            },
            "road59": {
                "id": "road59",
                "source": "intersection21",
                "target": "intersection22"
            },
            "road60": {
                "id": "road60",
                "source": "intersection22",
                "target": "intersection21"
            },
            "road61": {
                "id": "road61",
                "source": "intersection22",
                "target": "intersection23"
            },
            "road62": {
                "id": "road62",
                "source": "intersection23",
                "target": "intersection22"
            },
            "road63": {
                "id": "road63",
                "source": "intersection23",
                "target": "intersection24"
            },
            "road64": {
                "id": "road64",
                "source": "intersection24",
                "target": "intersection23"
            },
            "road65": {
                "id": "road65",
                "source": "intersection24",
                "target": "intersection25"
            },
            "road66": {
                "id": "road66",
                "source": "intersection25",
                "target": "intersection24"
            },
            "road67": {
                "id": "road67",
                "source": "intersection25",
                "target": "intersection26"
            },
            "road68": {
                "id": "road68",
                "source": "intersection26",
                "target": "intersection25"
            },
            "road69": {
                "id": "road69",
                "source": "intersection25",
                "target": "intersection22"
            },
            "road70": {
                "id": "road70",
                "source": "intersection22",
                "target": "intersection25"
            }
        },
        "carsNumber": 2,
        "time": 138.33831499999914
    },
    "mappa_complicata": {
        "intersections": {
            "intersection87": {
                "id": "intersection87",
                "rect": {
                    "x": -112,
                    "y": -70,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.5217022137739413,
                    "phaseOffset": 1.5642095884635498
                }
            },
            "intersection88": {
                "id": "intersection88",
                "rect": {
                    "x": -112,
                    "y": -42,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.9398669531001806,
                    "phaseOffset": 35.77074627552086
                }
            },
            "intersection89": {
                "id": "intersection89",
                "rect": {
                    "x": -112,
                    "y": -14,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.642267830383092,
                    "phaseOffset": 17.473850551103844
                }
            },
            "intersection90": {
                "id": "intersection90",
                "rect": {
                    "x": -112,
                    "y": 14,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.09020765115496143,
                    "phaseOffset": 22.21522877435507
                }
            },
            "intersection91": {
                "id": "intersection91",
                "rect": {
                    "x": -28,
                    "y": 14,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.7514962471148281,
                    "phaseOffset": 48.78687282771161
                }
            },
            "intersection92": {
                "id": "intersection92",
                "rect": {
                    "x": -28,
                    "y": -14,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.3602489087495704,
                    "phaseOffset": 66.47258451973501
                }
            },
            "intersection93": {
                "id": "intersection93",
                "rect": {
                    "x": -28,
                    "y": -42,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.5532482246415711,
                    "phaseOffset": 15.743268270901535
                }
            },
            "intersection94": {
                "id": "intersection94",
                "rect": {
                    "x": -28,
                    "y": -70,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.606836705799384,
                    "phaseOffset": 79.34935652703616
                }
            },
            "intersection95": {
                "id": "intersection95",
                "rect": {
                    "x": 42,
                    "y": -70,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.6984370810517877,
                    "phaseOffset": 19.39702370556622
                }
            },
            "intersection96": {
                "id": "intersection96",
                "rect": {
                    "x": 42,
                    "y": -42,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.10535891056544133,
                    "phaseOffset": 0.7379432534991848
                }
            },
            "intersection97": {
                "id": "intersection97",
                "rect": {
                    "x": 42,
                    "y": -14,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.22950889256440132,
                    "phaseOffset": 14.990724495653529
                }
            },
            "intersection98": {
                "id": "intersection98",
                "rect": {
                    "x": 42,
                    "y": 14,
                    "_width": 14,
                    "_height": 14
                },
                "controlSignals": {
                    "flipMultiplier": 0.6392255718911695,
                    "phaseOffset": 41.65034216633665
                }
            }
        },
        "roads": {
            "road201": {
                "id": "road201",
                "source": "intersection91",
                "target": "intersection98"
            },
            "road202": {
                "id": "road202",
                "source": "intersection98",
                "target": "intersection91"
            },
            "road203": {
                "id": "road203",
                "source": "intersection98",
                "target": "intersection97"
            },
            "road204": {
                "id": "road204",
                "source": "intersection97",
                "target": "intersection98"
            },
            "road205": {
                "id": "road205",
                "source": "intersection97",
                "target": "intersection96"
            },
            "road206": {
                "id": "road206",
                "source": "intersection96",
                "target": "intersection97"
            },
            "road207": {
                "id": "road207",
                "source": "intersection96",
                "target": "intersection95"
            },
            "road208": {
                "id": "road208",
                "source": "intersection95",
                "target": "intersection96"
            },
            "road209": {
                "id": "road209",
                "source": "intersection95",
                "target": "intersection94"
            },
            "road210": {
                "id": "road210",
                "source": "intersection94",
                "target": "intersection95"
            },
            "road211": {
                "id": "road211",
                "source": "intersection94",
                "target": "intersection93"
            },
            "road212": {
                "id": "road212",
                "source": "intersection93",
                "target": "intersection94"
            },
            "road213": {
                "id": "road213",
                "source": "intersection93",
                "target": "intersection88"
            },
            "road214": {
                "id": "road214",
                "source": "intersection88",
                "target": "intersection93"
            },
            "road215": {
                "id": "road215",
                "source": "intersection87",
                "target": "intersection88"
            },
            "road216": {
                "id": "road216",
                "source": "intersection88",
                "target": "intersection87"
            },
            "road217": {
                "id": "road217",
                "source": "intersection87",
                "target": "intersection94"
            },
            "road218": {
                "id": "road218",
                "source": "intersection94",
                "target": "intersection87"
            },
            "road219": {
                "id": "road219",
                "source": "intersection92",
                "target": "intersection93"
            },
            "road220": {
                "id": "road220",
                "source": "intersection93",
                "target": "intersection92"
            },
            "road221": {
                "id": "road221",
                "source": "intersection92",
                "target": "intersection89"
            },
            "road222": {
                "id": "road222",
                "source": "intersection89",
                "target": "intersection92"
            },
            "road223": {
                "id": "road223",
                "source": "intersection89",
                "target": "intersection90"
            },
            "road224": {
                "id": "road224",
                "source": "intersection90",
                "target": "intersection89"
            },
            "road225": {
                "id": "road225",
                "source": "intersection90",
                "target": "intersection91"
            },
            "road226": {
                "id": "road226",
                "source": "intersection91",
                "target": "intersection90"
            },
            "road227": {
                "id": "road227",
                "source": "intersection88",
                "target": "intersection89"
            },
            "road228": {
                "id": "road228",
                "source": "intersection89",
                "target": "intersection88"
            },
            "road231": {
                "id": "road231",
                "source": "intersection91",
                "target": "intersection92"
            },
            "road232": {
                "id": "road232",
                "source": "intersection92",
                "target": "intersection91"
            }
        },
        "carsNumber": 4,
        "time": 353.8403300000037
    }
}

module.exports = savedMaps

