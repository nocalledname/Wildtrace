; Depth-Boids — Cabbage 3 版（cab3-depth-boids）
; 8 只 boids（1 只头鸟 + 7 只跟随）驱动 8 路空间化延迟抽头 + 混响
; 自定义 UI 入口见 cabbage.project.json -> index.html
;
; 与 Cabbage 2 版的差别只在「UI 反馈」这一层：
;   · 原来的 bird1..bird7 image 控件由 HTML 自己画（鸟形 + 扑翼动画）
;   · 头鸟的位置就是 x / y 两个宿主参数，HTML 的 pad 拖拽直接写它们
;   · Csound 只额外推 bx1..bx7 / by1..by7（0~1 归一位置）与 outL / outR
;   · 鼠标双击 / 拖拽状态机整体删除（原来是为了在 Cabbage 2 里做 pad 拖拽）
;
; 信号流（PARAM_IDX 必须与下面 widget 的书写顺序逐字一致）：
;   x → y                                         头鸟位置
;   → coh → ali → sep → speed                     群体物理
;   → delay_base → feedback → mod_rate → Flock_Decay   延迟网络
;   → m1..m7                                      每只从鸟的变调深度
;   → minWet → maxWet → roomSize → cutoff         空间
;   → dry_wet → vol                               总输出

<CsoundSynthesizer>
<Cabbage>
{
    "pluginId": "C3BD",
    "enableDevTools": true,
    "channelConfig": [
        {
            "name": "2 in 2 out",
            "ins": "2",
            "outs": "2"
        }
    ],
    "widgets": [
        {
            "type": "form",
            "caption": "Cab3-Depth-Boids",
            "size": {
                "width": 620,
                "height": 760
            },
            "guiMode": "queue"
        },
        {
            "type": "horizontalSlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 80,
                "height": 24
            },
            "label": {
                "text": "Position X"
            },
            "channels": [
                {
                    "id": "x",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.5,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "horizontalSlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -140,
                "width": 80,
                "height": 24
            },
            "label": {
                "text": "Position Y"
            },
            "channels": [
                {
                    "id": "y",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.5,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Cohesion"
            },
            "channels": [
                {
                    "id": "coh",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Alignment"
            },
            "channels": [
                {
                    "id": "ali",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Separation"
            },
            "channels": [
                {
                    "id": "sep",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 1,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Speed"
            },
            "channels": [
                {
                    "id": "speed",
                    "range": {
                        "min": 0.001,
                        "max": 0.1,
                        "defaultValue": 0.01,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Delay Base"
            },
            "channels": [
                {
                    "id": "delay_base",
                    "range": {
                        "min": 10,
                        "max": 1400,
                        "defaultValue": 30,
                        "skew": 1,
                        "increment": 1
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Feedback"
            },
            "channels": [
                {
                    "id": "feedback",
                    "range": {
                        "min": 0,
                        "max": 0.95,
                        "defaultValue": 0.4,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "LFO Rate"
            },
            "channels": [
                {
                    "id": "mod_rate",
                    "range": {
                        "min": 0.01,
                        "max": 5,
                        "defaultValue": 0.5,
                        "skew": 0.5,
                        "increment": 0.01
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Flock Decay"
            },
            "channels": [
                {
                    "id": "Flock_Decay",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.8209,
                        "skew": 1,
                        "increment": 0.0001
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "1"
            },
            "channels": [
                {
                    "id": "m1",
                    "range": {
                        "min": 0,
                        "max": 50,
                        "defaultValue": 0,
                        "skew": 0.3,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "2"
            },
            "channels": [
                {
                    "id": "m2",
                    "range": {
                        "min": 0,
                        "max": 50,
                        "defaultValue": 0,
                        "skew": 0.3,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "3"
            },
            "channels": [
                {
                    "id": "m3",
                    "range": {
                        "min": 0,
                        "max": 50,
                        "defaultValue": 0,
                        "skew": 0.3,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "4"
            },
            "channels": [
                {
                    "id": "m4",
                    "range": {
                        "min": 0,
                        "max": 50,
                        "defaultValue": 0,
                        "skew": 0.3,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "5"
            },
            "channels": [
                {
                    "id": "m5",
                    "range": {
                        "min": 0,
                        "max": 50,
                        "defaultValue": 0,
                        "skew": 0.3,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "6"
            },
            "channels": [
                {
                    "id": "m6",
                    "range": {
                        "min": 0,
                        "max": 50,
                        "defaultValue": 0,
                        "skew": 0.3,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "7"
            },
            "channels": [
                {
                    "id": "m7",
                    "range": {
                        "min": 0,
                        "max": 50,
                        "defaultValue": 0,
                        "skew": 0.3,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "horizontalSlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 80,
                "height": 24
            },
            "label": {
                "text": "Wet Min"
            },
            "channels": [
                {
                    "id": "minWet",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.1,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "horizontalSlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -140,
                "width": 80,
                "height": 24
            },
            "label": {
                "text": "Wet Max"
            },
            "channels": [
                {
                    "id": "maxWet",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.6,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Room"
            },
            "channels": [
                {
                    "id": "roomSize",
                    "range": {
                        "min": 10,
                        "max": 100,
                        "defaultValue": 50,
                        "skew": 1,
                        "increment": 0.1
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Damping"
            },
            "channels": [
                {
                    "id": "cutoff",
                    "range": {
                        "min": 1000,
                        "max": 16000,
                        "defaultValue": 16000,
                        "skew": 0.5,
                        "increment": 1
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Flock Mix"
            },
            "channels": [
                {
                    "id": "dry_wet",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.5,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "rotarySlider",
            "visible": false,
            "automatable": true,
            "bounds": {
                "left": -120,
                "top": -120,
                "width": 60,
                "height": 60
            },
            "label": {
                "text": "Master Gain"
            },
            "channels": [
                {
                    "id": "vol",
                    "range": {
                        "min": 0,
                        "max": 8,
                        "defaultValue": 2,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -160,
                "top": -120,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "bx1",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.5,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -160,
                "top": -140,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "by1",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.5,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -160,
                "top": -160,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "bx2",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.5,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -160,
                "top": -180,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "by2",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.5,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -160,
                "top": -200,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "bx3",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.5,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -160,
                "top": -220,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "by3",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.5,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -160,
                "top": -240,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "bx4",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.5,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -160,
                "top": -260,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "by4",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.5,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -160,
                "top": -280,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "bx5",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.5,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -160,
                "top": -300,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "by5",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.5,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -160,
                "top": -320,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "bx6",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.5,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -160,
                "top": -340,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "by6",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.5,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -160,
                "top": -360,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "bx7",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.5,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -160,
                "top": -380,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "by7",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0.5,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -200,
                "top": -400,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "bdir",
                    "range": {
                        "min": 0,
                        "max": 360,
                        "defaultValue": 0,
                        "skew": 1,
                        "increment": 0.1
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -200,
                "top": -420,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "ba1",
                    "range": {
                        "min": 0,
                        "max": 360,
                        "defaultValue": 0,
                        "skew": 1,
                        "increment": 0.1
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -200,
                "top": -440,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "ba2",
                    "range": {
                        "min": 0,
                        "max": 360,
                        "defaultValue": 0,
                        "skew": 1,
                        "increment": 0.1
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -200,
                "top": -460,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "ba3",
                    "range": {
                        "min": 0,
                        "max": 360,
                        "defaultValue": 0,
                        "skew": 1,
                        "increment": 0.1
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -200,
                "top": -480,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "ba4",
                    "range": {
                        "min": 0,
                        "max": 360,
                        "defaultValue": 0,
                        "skew": 1,
                        "increment": 0.1
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -200,
                "top": -500,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "ba5",
                    "range": {
                        "min": 0,
                        "max": 360,
                        "defaultValue": 0,
                        "skew": 1,
                        "increment": 0.1
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -200,
                "top": -520,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "ba6",
                    "range": {
                        "min": 0,
                        "max": 360,
                        "defaultValue": 0,
                        "skew": 1,
                        "increment": 0.1
                    }
                }
            ]
        },
        {
            "type": "numberSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -200,
                "top": -540,
                "width": 60,
                "height": 24
            },
            "channels": [
                {
                    "id": "ba7",
                    "range": {
                        "min": 0,
                        "max": 360,
                        "defaultValue": 0,
                        "skew": 1,
                        "increment": 0.1
                    }
                }
            ]
        },
        {
            "type": "verticalSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -200,
                "top": -120,
                "width": 13,
                "height": 170
            },
            "channels": [
                {
                    "id": "outL",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        },
        {
            "type": "verticalSlider",
            "visible": false,
            "automatable": false,
            "bounds": {
                "left": -200,
                "top": -320,
                "width": 13,
                "height": 170
            },
            "channels": [
                {
                    "id": "outR",
                    "range": {
                        "min": 0,
                        "max": 1,
                        "defaultValue": 0,
                        "skew": 1,
                        "increment": 0.001
                    }
                }
            ]
        }
    ]
}
</Cabbage>
<CsOptions>
-n -d -+rtmidi=NULL
</CsOptions>
<CsInstruments>

ksmps = 64
nchnls = 2
0dbfs = 1

; =========================================================
; 软膝限幅器：|x| <= 0.85 时完全线性（零谐波），
; 超过后按 C1 连续地压到 0.98 上限。
; 不用 tanh 的原因：tanh 从 0.5 起就开始明显弯曲，
; 干声稍微热一点就产生 -26 dB 的谐波 —— 那正是「滋滋」。
; =========================================================
opcode SoftClip, a, a
    aIn xin
    kThr  = 0.85
    kCeil = 0.98
    kSpan = kCeil - kThr
    aAx   = abs(aIn)
    aU    = limit(aAx - kThr, 0, 100)
    aShp  = kThr + kSpan * (1 - exp(-aU / kSpan))
    aOver = limit((aAx - kThr) * 200, 0, 1)
    aClip = (aIn / (aAx + 1e-20)) * aShp
    aOut  = aIn + (aClip - aIn) * aOver
    xout aOut
endop

; 8 只 boids：索引 0 = 头鸟（用户控制），1..7 = 跟随
giNumBoids = 8
gkX[] init 8
gkY[] init 8
gkVx[] init 8
gkVy[] init 8
; 航向：一阶低通后的速度分量，用来推 ba1..ba7 / bdir（单位：模型坐标系，y 向上）
gkDx[] init 8
gkDy[] init 8

; [UDO] 核心渲染引擎（与 Cabbage 2 版一致）
opcode DepthStereoRender, aaaa, aaaakkk
    aInL, aInR, aX, aY, kMinWet, kMaxWet, kRoomSize xin

    aX = limit(aX, 0.001, 0.999)
    aY = limit(aY, 0.001, 0.999)

    ; 统一距离：以 (0.5, 0) 下边中央为参考点，统一驱动延迟多普勒、
    ; 空气吸收、距离衰减与混响发送
    aDistance = sqrt(((aX - 0.5) ^ 2) + (aY ^ 2)) * 0.89442719
    aRoomSize interp kRoomSize

    ; 1. 方位：X 轴等功率左右平移
    aL_pan = cos(aX * 1.570796)
    aR_pan = sin(aX * 1.570796)
    aMono = (aInL + aInR) * 0.5

    aPanL = aMono * aL_pan
    aPanR = aMono * aR_pan

    ; 2. 距离延迟
    aDelayTime = 0.1 + (aDistance * aRoomSize)
    aDlyL vdelay3 aPanL, aDelayTime, 150
    aDlyR vdelay3 aPanR, aDelayTime, 150

    ; 3. 空气吸收（高频随深度衰减）
    aDepthInv = 1 - aDistance
    aCutoff = 1000 + ((aDepthInv * aDepthInv * aDepthInv) * 19000)

    aFiltL tone aDlyL, aCutoff
    aFiltR tone aDlyR, aCutoff

    ; 4. 空间衰减（与房间大小绑定）
    aDecayFactor = 1.2 + ((aRoomSize - 10) / 90) * 2.3
    aDistAmp = exp(-aDistance * aDecayFactor)

    aDryL = 0.5 * aFiltL * aDistAmp
    aDryR = 0.5 * aFiltR * aDistAmp

    ; 5. 空间混响发送量
    aMinWet interp kMinWet
    aMaxWet interp kMaxWet
    aWetSend = aMinWet + (aDistance * (aMaxWet - aMinWet))
    ; 湿声发送同样乘距离衰减：否则远端干声被压 -19~-30 dB，湿声却按
    ; Wet Send Max 涨到 +15.6 dB，湿/干比高达 20 倍 —— 只剩混响，
    ; 「音源在消散」的听感被糊成一团。
    aWetSend = aWetSend * aDistAmp

    aWetL = 0.5 * aFiltL * aWetSend
    aWetR = 0.5 * aFiltR * aWetSend

    aWetL = tanh(aWetL)
    aWetR = tanh(aWetR)
    xout aDryL, aDryR, aWetL, aWetR
endop


instr 1
    ; --- 1. 读取参数（顺序与 PARAM_IDX 无关，这里只是取值） ---
    kX          cabbageGetValue "x"
    kY          cabbageGetValue "y"

    kCoh        cabbageGetValue "coh"
    kAli        cabbageGetValue "ali"
    kSep        cabbageGetValue "sep"
    kMaxSpeed   cabbageGetValue "speed"

    kDelayBase  cabbageGetValue "delay_base"
    kFbk        cabbageGetValue "feedback"
    kLFORate    cabbageGetValue "mod_rate"
    kFD         cabbageGetValue "Flock_Decay"

    kM1         cabbageGetValue "m1"
    kM2         cabbageGetValue "m2"
    kM3         cabbageGetValue "m3"
    kM4         cabbageGetValue "m4"
    kM5         cabbageGetValue "m5"
    kM6         cabbageGetValue "m6"
    kM7         cabbageGetValue "m7"

    kMinWet     cabbageGetValue "minWet"
    kMaxWet     cabbageGetValue "maxWet"
    kRoomSize   cabbageGetValue "roomSize"
    kCutoff     cabbageGetValue "cutoff"

    kMix        cabbageGetValue "dry_wet"
    kVol        cabbageGetValue "vol"

    ; --- 2. 初始化从鸟 ---
    ; rnd(常量) 的参数是常量 → 在 i-time 求值一次，整个音符返回同一个数。
    ; 原版写 rnd(1) / rnd(0.02)，结果 7 只从鸟的初始位置与速度完全相同，
    ; 之后分离力算出来恒为 0（kDx=kDy=0），整群永远叠在一个点上。
    ; 传 k 率变量才会每次重新取值。
    if timeinstk() == 1 then
        kInitOne init 1
        kInitI init 1
        while kInitI < giNumBoids do
            gkX[kInitI]  = rnd(kInitOne)
            gkY[kInitI]  = rnd(kInitOne)
            gkVx[kInitI] = rnd(kInitOne) * 0.02 - 0.01
            gkVy[kInitI] = rnd(kInitOne) * 0.02 - 0.01
            gkDx[kInitI] = gkVx[kInitI]
            gkDy[kInitI] = gkVy[kInitI]
            kInitI += 1
        od
    endif

    ; 头鸟上一拍位置（算航向用）
    kLXp init 0.5
    kLYp init 0.5
    if timeinstk() == 1 then
        gkDx[0] = 0.01
        gkDy[0] = 0.01
    endif

    ; --- 3. Boids 物理循环（30 Hz，与 UI 推送同频） ---
    if metro(30) == 1 then
        gkX[0] = kX
        gkY[0] = kY

        kIdx init 1
        kIdx = 1
        while kIdx < giNumBoids do
            kAvgX = 0
            kAvgY = 0
            kAvgVx = 0
            kAvgVy = 0
            kSepX = 0
            kSepY = 0
            kCount = 0

            kJdx = 0
            while kJdx < giNumBoids do
                if kIdx != kJdx then
                    kDx = gkX[kJdx] - gkX[kIdx]
                    kDy = gkY[kJdx] - gkY[kIdx]
                    kDist = sqrt(kDx*kDx + kDy*kDy) + 0.001
                    if kDist < 0.25 then
                        kAvgX = kAvgX + gkX[kJdx]
                        kAvgY = kAvgY + gkY[kJdx]
                        kAvgVx = kAvgVx + gkVx[kJdx]
                        kAvgVy = kAvgVy + gkVy[kJdx]
                        kCount = kCount + 1
                        if kDist < 0.06 then
                            kSepX = kSepX - (kDx / kDist)
                            kSepY = kSepY - (kDy / kDist)
                        endif
                    endif
                endif
                kJdx += 1
            od

            if kCount > 0 then
                gkVx[kIdx] = gkVx[kIdx] + ((kAvgX/kCount - gkX[kIdx]) * kCoh * 0.04)
                gkVy[kIdx] = gkVy[kIdx] + ((kAvgY/kCount - gkY[kIdx]) * kCoh * 0.04)
                gkVx[kIdx] = gkVx[kIdx] + ((kAvgVx/kCount - gkVx[kIdx]) * kAli * 0.04)
                gkVy[kIdx] = gkVy[kIdx] + ((kAvgVy/kCount - gkVy[kIdx]) * kAli * 0.04)
            endif

            gkVx[kIdx] = gkVx[kIdx] + (kSepX * kSep * 0.025) + ((gkX[0] - gkX[kIdx]) * 0.005)
            gkVy[kIdx] = gkVy[kIdx] + (kSepY * kSep * 0.025) + ((gkY[0] - gkY[kIdx]) * 0.005)

            kSpd = sqrt(gkVx[kIdx]*gkVx[kIdx] + gkVy[kIdx]*gkVy[kIdx]) + 0.0001
            if kSpd > kMaxSpeed then
                gkVx[kIdx] = (gkVx[kIdx] / kSpd) * kMaxSpeed
                gkVy[kIdx] = (gkVy[kIdx] / kSpd) * kMaxSpeed
            endif
            gkX[kIdx] = limit(gkX[kIdx] + gkVx[kIdx], 0, 1)
            gkY[kIdx] = limit(gkY[kIdx] + gkVy[kIdx], 0, 1)

            ; 方向低通：速度太小就不更新，否则停住时会随机抖动
            if (abs(gkVx[kIdx]) + abs(gkVy[kIdx])) > 0.0004 then
                gkDx[kIdx] = gkDx[kIdx] * 0.72 + gkVx[kIdx] * 0.28
                gkDy[kIdx] = gkDy[kIdx] * 0.72 + gkVy[kIdx] * 0.28
            endif
            kIdx += 1
        od

        ; 头鸟：航向来自"这一拍走了多少"，不是用户拖拽方向
        ; （用户可能只是往下拖 pad，但鸟实际是被拖过去的，方向要跟实际位移）
        kLDx = gkX[0] - kLXp
        kLDy = gkY[0] - kLYp
        if (abs(kLDx) + abs(kLDy)) > 0.00012 then
            gkDx[0] = gkDx[0] * 0.55 + kLDx * 0.45
            gkDy[0] = gkDy[0] * 0.55 + kLDy * 0.45
        endif
        kLXp = gkX[0]
        kLYp = gkY[0]
    endif

    ; --- 4. UI 推送：7 只从鸟的归一化位置（头鸟 = x / y，前端已知） ---
    kUIMetro metro 30
    if kUIMetro == 1 then
        cabbageSetValue "bx1", gkX[1], kUIMetro
        cabbageSetValue "by1", gkY[1], kUIMetro
        cabbageSetValue "bx2", gkX[2], kUIMetro
        cabbageSetValue "by2", gkY[2], kUIMetro
        cabbageSetValue "bx3", gkX[3], kUIMetro
        cabbageSetValue "by3", gkY[3], kUIMetro
        cabbageSetValue "bx4", gkX[4], kUIMetro
        cabbageSetValue "by4", gkY[4], kUIMetro
        cabbageSetValue "bx5", gkX[5], kUIMetro
        cabbageSetValue "by5", gkY[5], kUIMetro
        cabbageSetValue "bx6", gkX[6], kUIMetro
        cabbageSetValue "by6", gkY[6], kUIMetro
        cabbageSetValue "bx7", gkX[7], kUIMetro
        cabbageSetValue "by7", gkY[7], kUIMetro

        ; 航向角（度，0 = 屏向右、顺时针增加；SVG 的 y 轴向下，所以取 -dy）
        ; Csound 没有 atan2，反正是 taninv2(y, x)；返回 -π..π，负数补 360
        kAngL = taninv2(-gkDy[0], gkDx[0]) * 57.29578
        if kAngL < 0 then
            kAngL = kAngL + 360
        endif
        cabbageSetValue "bdir", kAngL, kUIMetro

        kIdx = 1
        while kIdx < giNumBoids do
            kAng = taninv2(-gkDy[kIdx], gkDx[kIdx]) * 57.29578
            if kAng < 0 then
                kAng = kAng + 360
            endif
            if kIdx == 1 then
                cabbageSetValue "ba1", kAng, kUIMetro
            elseif kIdx == 2 then
                cabbageSetValue "ba2", kAng, kUIMetro
            elseif kIdx == 3 then
                cabbageSetValue "ba3", kAng, kUIMetro
            elseif kIdx == 4 then
                cabbageSetValue "ba4", kAng, kUIMetro
            elseif kIdx == 5 then
                cabbageSetValue "ba5", kAng, kUIMetro
            elseif kIdx == 6 then
                cabbageSetValue "ba6", kAng, kUIMetro
            elseif kIdx == 7 then
                cabbageSetValue "ba7", kAng, kUIMetro
            endif
            kIdx += 1
        od
    endif

    ; --- 5. 音频：10 s 延迟线 + 7 路 LFO 调制抽头 ---
    aInL, aInR inch 1, 2
    ; 8 个声源求和：按功率求和的正确归一化是 1/sqrt(8) = -9.03 dB。
    ; 之前试过 -3 dB，但 Master 默认已从 2 提到 4（+6 dB），正好抵消，
    ; 实测 Quad 版仍会顶到限幅器。这里取 -9 dB：
    ;   0.35355339 = 1/sqrt(8) = 10^(-9.0309/20)
    ; 一次性压住干声、7 路抽头和反馈网络，末端 SoftClip 只做兜底。
    aInAtt = 0.35355339
    aSig = (aInL + aInR) * 0.5 * aInAtt
    aFbkSum init 0

    aBuf delayr 10.0

    ; 7 路带相位偏移的 LFO（m1..m7 默认 0 → 不调制）
    kL1 oscil kM1, kLFORate,       -1, 0.0
    kL2 oscil kM2, kLFORate * 1.1, -1, 0.1
    kL3 oscil kM3, kLFORate * 0.9, -1, 0.2
    kL4 oscil kM4, kLFORate * 1.2, -1, 0.3
    kL5 oscil kM5, kLFORate * 0.8, -1, 0.4
    kL6 oscil kM6, kLFORate * 1.3, -1, 0.5
    kL7 oscil kM7, kLFORate * 0.7, -1, 0.6

    aDelayBase interp kDelayBase

    ; LFO 转 a 率，消除拉链声
    aL1 interp kL1
    aL2 interp kL2
    aL3 interp kL3
    aL4 interp kL4
    aL5 interp kL5
    aL6 interp kL6
    aL7 interp kL7

    ; 抽头时基：同值累加 —— 第 n 路 = base x n（10 s 缓冲上限 9.9 s）
    aT1 deltapi limit((aDelayBase*1 + aL1)/1000, 0.01, 9.9)
    aT2 deltapi limit((aDelayBase*2 + aL2)/1000, 0.01, 9.9)
    aT3 deltapi limit((aDelayBase*3 + aL3)/1000, 0.01, 9.9)
    aT4 deltapi limit((aDelayBase*4 + aL4)/1000, 0.01, 9.9)
    aT5 deltapi limit((aDelayBase*5 + aL5)/1000, 0.01, 9.9)
    aT6 deltapi limit((aDelayBase*6 + aL6)/1000, 0.01, 9.9)
    aT7 deltapi limit((aDelayBase*7 + aL7)/1000, 0.01, 9.9)

    ; 逐路音量滚降（Flock Decay 是振幅系数，不是时基系数）
    aFD interp kFD
    aT1 = aT1 * aFD
    aT2 = aT2 * aFD ^ 2
    aT3 = aT3 * aFD ^ 3
    aT4 = aT4 * aFD ^ 4
    aT5 = aT5 * aFD ^ 5
    aT6 = aT6 * aFD ^ 6
    aT7 = aT7 * aFD ^ 7

    ; 反馈混合并回灌
    aFbkSum = (aT1+aT2+aT3+aT4+aT5+aT6+aT7) * kFbk / 7
    delayw aSig + aFbkSum

    ; --- 6. 空间分配与混合输出 ---
    kGlide = 0.05   ; 50 ms 平滑，填补 30 Hz 阶梯

    ; 头鸟（0）：干声
    kX0_sm portk gkX[0], kGlide
    kY0_sm portk gkY[0], kGlide
    aX0 interp kX0_sm
    aY0 interp kY0_sm
    aIn0 = aSig * (1 - kMix)
    aDryL0, aDryR0, aWetL0, aWetR0 DepthStereoRender aIn0, aIn0, aX0, aY0, kMinWet, kMaxWet, kRoomSize

    ; 从鸟 1
    kX1_sm portk gkX[1], kGlide
    kY1_sm portk gkY[1], kGlide
    aX1 interp kX1_sm
    aY1 interp kY1_sm
    aIn1 = aT1 * kMix
    aDryL1, aDryR1, aWetL1, aWetR1 DepthStereoRender aIn1, aIn1, aX1, aY1, kMinWet, kMaxWet, kRoomSize

    ; 从鸟 2
    kX2_sm portk gkX[2], kGlide
    kY2_sm portk gkY[2], kGlide
    aX2 interp kX2_sm
    aY2 interp kY2_sm
    aIn2 = aT2 * kMix
    aDryL2, aDryR2, aWetL2, aWetR2 DepthStereoRender aIn2, aIn2, aX2, aY2, kMinWet, kMaxWet, kRoomSize

    ; 从鸟 3
    kX3_sm portk gkX[3], kGlide
    kY3_sm portk gkY[3], kGlide
    aX3 interp kX3_sm
    aY3 interp kY3_sm
    aIn3 = aT3 * kMix
    aDryL3, aDryR3, aWetL3, aWetR3 DepthStereoRender aIn3, aIn3, aX3, aY3, kMinWet, kMaxWet, kRoomSize

    ; 从鸟 4
    kX4_sm portk gkX[4], kGlide
    kY4_sm portk gkY[4], kGlide
    aX4 interp kX4_sm
    aY4 interp kY4_sm
    aIn4 = aT4 * kMix
    aDryL4, aDryR4, aWetL4, aWetR4 DepthStereoRender aIn4, aIn4, aX4, aY4, kMinWet, kMaxWet, kRoomSize

    ; 从鸟 5
    kX5_sm portk gkX[5], kGlide
    kY5_sm portk gkY[5], kGlide
    aX5 interp kX5_sm
    aY5 interp kY5_sm
    aIn5 = aT5 * kMix
    aDryL5, aDryR5, aWetL5, aWetR5 DepthStereoRender aIn5, aIn5, aX5, aY5, kMinWet, kMaxWet, kRoomSize

    ; 从鸟 6
    kX6_sm portk gkX[6], kGlide
    kY6_sm portk gkY[6], kGlide
    aX6 interp kX6_sm
    aY6 interp kY6_sm
    aIn6 = aT6 * kMix
    aDryL6, aDryR6, aWetL6, aWetR6 DepthStereoRender aIn6, aIn6, aX6, aY6, kMinWet, kMaxWet, kRoomSize

    ; 从鸟 7
    kX7_sm portk gkX[7], kGlide
    kY7_sm portk gkY[7], kGlide
    aX7 interp kX7_sm
    aY7 interp kY7_sm
    aIn7 = aT7 * kMix
    aDryL7, aDryR7, aWetL7, aWetR7 DepthStereoRender aIn7, aIn7, aX7, aY7, kMinWet, kMaxWet, kRoomSize

    aDryL = (aDryL0+aDryL1+aDryL2+aDryL3+aDryL4+aDryL5+aDryL6+aDryL7)
    aDryR = (aDryR0+aDryR1+aDryR2+aDryR3+aDryR4+aDryR5+aDryR6+aDryR7)

    aWetL = (aWetL0+aWetL1+aWetL2+aWetL3+aWetL4+aWetL5+aWetL6+aWetL7)
    aWetR = (aWetR0+aWetR1+aWetR2+aWetR3+aWetR4+aWetR5+aWetR6+aWetR7)

    ; --- 7. 混响器 ---
    kFeedback = 0.1 + ((kRoomSize - 10) / 90) * 0.8
    kFeedback_smooth portk kFeedback, 0.05
    kCutoff_smooth   portk kCutoff, 0.05

    aRevL, aRevR reverbsc aWetL, aWetR, kFeedback_smooth, kCutoff_smooth

    aOutL = aDryL + aRevL
    aOutR = aDryR + aRevR

    aVol interp kVol
    aOutL = aOutL * aVol
    aOutR = aOutR * aVol

    ; 唯一的限幅器：链末端。0.85 以下完全线性，只在冲头时压缩。

    aOutL = SoftClip(aOutL)

    aOutR = SoftClip(aOutR)


    out aOutL, aOutR

    ; --- 8. 双声道电平捕捉 ---
    kTrig metro 60
    kOutL maxk abs(aOutL), kTrig, 1
    kOutR maxk abs(aOutR), kTrig, 1

    cabbageSetValue "outL", portk(kOutL, .05), kTrig
    cabbageSetValue "outR", portk(kOutR, .05), kTrig
endin

</CsInstruments>
<CsScore>
f0 z
i1 0 [60*60*24*7]
</CsScore>
</CsoundSynthesizer>
