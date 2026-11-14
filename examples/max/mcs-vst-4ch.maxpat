{
	"patcher": {
		"fileversion": 1,
		"appversion": {
			"major": 9,
			"minor": 0,
			"revision": 7,
			"architecture": "arm64",
			"modernui": 1
		},
		"rect": [
			90.0,
			40.0,
			760.0,
			680.0
		],
		"bgcolor": [
			1.0,
			1.0,
			1.0,
			1.0
		],
		"bglocked": 0,
		"openinpresentation": 0,
		"default_fontsize": 12.0,
		"default_fontface": 0,
		"default_fontname": "Arial",
		"gridonopen": 0,
		"gridsize": [
			15.0,
			15.0
		],
		"gridsnaponopen": 0,
		"statusbarvisible": 2,
		"toolbarvisible": 1,
		"devicewidth": 0.0,
		"description": "Wildtrace 4-channel AU host example (Max 9 mcs.vst~)",
		"digest": "",
		"tags": "",
		"style": "",
		"boxes": [
			{
				"box": {
					"id": "c0",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						20.0,
						8.0,
						520.0,
						20.0
					],
					"text": "Wildtrace 四声道 AU 宿主示例 · Max 9+",
					"fontname": "Arial",
					"fontsize": 16.0
				}
			},
			{
				"box": {
					"id": "c1",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						20.0,
						30.0,
						700.0,
						20.0
					],
					"text": "mcs.vst~ 的前两个参数是「输入/输出声道数」，必须写 4 4。普通 vst~ 只有立体声。",
					"fontname": "Arial",
					"fontsize": 12.0
				}
			},
			{
				"box": {
					"id": "c2",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						20.0,
						50.0,
						700.0,
						20.0
					],
					"text": "插件名写 AU 的显示名（不带 .component）。要换插件就改 mcs.vst~ 的第 3 个参数。",
					"fontname": "Arial",
					"fontsize": 12.0
				}
			},
			{
				"box": {
					"id": "c3",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						20.0,
						70.0,
						700.0,
						20.0
					],
					"text": "打开后点一下 loadbang（或重新打开 patch）让 4 路噪声出声。",
					"fontname": "Arial",
					"fontsize": 12.0
				}
			},
			{
				"box": {
					"id": "c4",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						20.0,
						105.0,
						200.0,
						20.0
					],
					"text": "① 4 路独立信号",
					"fontname": "Arial",
					"fontsize": 12.0
				}
			},
			{
				"box": {
					"id": "lb",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						20.0,
						128.0,
						80.0,
						22.0
					],
					"text": "loadbang",
					"fontname": "Arial",
					"fontsize": 12.0,
					"outlettype": [
						"bang"
					]
				}
			},
			{
				"box": {
					"id": "m1",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						20.0,
						155.0,
						40.0,
						20.0
					],
					"text": "1",
					"fontname": "Arial",
					"fontsize": 12.0,
					"outlettype": [
						""
					]
				}
			},
			{
				"box": {
					"id": "n1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						20.0,
						185.0,
						66.0,
						22.0
					],
					"text": "noise~",
					"fontname": "Arial",
					"fontsize": 12.0,
					"outlettype": [
						"signal"
					]
				}
			},
			{
				"box": {
					"id": "n2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						100.0,
						185.0,
						66.0,
						22.0
					],
					"text": "noise~",
					"fontname": "Arial",
					"fontsize": 12.0,
					"outlettype": [
						"signal"
					]
				}
			},
			{
				"box": {
					"id": "n3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						180.0,
						185.0,
						66.0,
						22.0
					],
					"text": "noise~",
					"fontname": "Arial",
					"fontsize": 12.0,
					"outlettype": [
						"signal"
					]
				}
			},
			{
				"box": {
					"id": "n4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						260.0,
						185.0,
						66.0,
						22.0
					],
					"text": "noise~",
					"fontname": "Arial",
					"fontsize": 12.0,
					"outlettype": [
						"signal"
					]
				}
			},
			{
				"box": {
					"id": "g1",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						20.0,
						218.0,
						66.0,
						22.0
					],
					"text": "*~ 0.05",
					"fontname": "Arial",
					"fontsize": 12.0,
					"outlettype": [
						"signal"
					]
				}
			},
			{
				"box": {
					"id": "g2",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						100.0,
						218.0,
						66.0,
						22.0
					],
					"text": "*~ 0.05",
					"fontname": "Arial",
					"fontsize": 12.0,
					"outlettype": [
						"signal"
					]
				}
			},
			{
				"box": {
					"id": "g3",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						180.0,
						218.0,
						66.0,
						22.0
					],
					"text": "*~ 0.05",
					"fontname": "Arial",
					"fontsize": 12.0,
					"outlettype": [
						"signal"
					]
				}
			},
			{
				"box": {
					"id": "g4",
					"maxclass": "newobj",
					"numinlets": 2,
					"numoutlets": 1,
					"patching_rect": [
						260.0,
						218.0,
						66.0,
						22.0
					],
					"text": "*~ 0.05",
					"fontname": "Arial",
					"fontsize": 12.0,
					"outlettype": [
						"signal"
					]
				}
			},
			{
				"box": {
					"id": "c5",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						20.0,
						255.0,
						200.0,
						20.0
					],
					"text": "② 打包成 4 声道",
					"fontname": "Arial",
					"fontsize": 12.0
				}
			},
			{
				"box": {
					"id": "p1",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 1,
					"patching_rect": [
						20.0,
						280.0,
						120.0,
						40.0
					],
					"text": "mc.pack~ 4",
					"fontname": "Arial",
					"fontsize": 12.0,
					"outlettype": [
						"signal"
					]
				}
			},
			{
				"box": {
					"id": "c6",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						20.0,
						345.0,
						400.0,
						20.0
					],
					"text": "③ 装载 AU（双击对象可打开插件自己的界面）",
					"fontname": "Arial",
					"fontsize": 12.0
				}
			},
			{
				"box": {
					"id": "v1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						20.0,
						370.0,
						320.0,
						40.0
					],
					"text": "mcs.vst~ 4 4 Cab3-Quad-Stasis",
					"fontname": "Arial",
					"fontsize": 12.0,
					"outlettype": [
						"signal"
					]
				}
			},
			{
				"box": {
					"id": "c7",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						20.0,
						435.0,
						300.0,
						20.0
					],
					"text": "④ 拆回 4 路 + 电平表",
					"fontname": "Arial",
					"fontsize": 12.0
				}
			},
			{
				"box": {
					"id": "u1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 4,
					"patching_rect": [
						20.0,
						460.0,
						120.0,
						60.0
					],
					"text": "mc.unpack~ 4",
					"fontname": "Arial",
					"fontsize": 12.0,
					"outlettype": [
						"signal",
						"signal",
						"signal",
						"signal"
					]
				}
			},
			{
				"box": {
					"id": "k1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						20.0,
						540.0,
						90.0,
						20.0
					],
					"text": "meter~",
					"fontname": "Arial",
					"fontsize": 12.0,
					"outlettype": [
						"float"
					]
				}
			},
			{
				"box": {
					"id": "k2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						130.0,
						540.0,
						90.0,
						20.0
					],
					"text": "meter~",
					"fontname": "Arial",
					"fontsize": 12.0,
					"outlettype": [
						"float"
					]
				}
			},
			{
				"box": {
					"id": "k3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						240.0,
						540.0,
						90.0,
						20.0
					],
					"text": "meter~",
					"fontname": "Arial",
					"fontsize": 12.0,
					"outlettype": [
						"float"
					]
				}
			},
			{
				"box": {
					"id": "k4",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"patching_rect": [
						350.0,
						540.0,
						90.0,
						20.0
					],
					"text": "meter~",
					"fontname": "Arial",
					"fontsize": 12.0,
					"outlettype": [
						"float"
					]
				}
			},
			{
				"box": {
					"id": "c8",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [
						20.0,
						575.0,
						620.0,
						20.0
					],
					"text": "⑤ 输出到 1–4 声道（记得在 Max 的 Audio Status 里把输出设成 4 声道）",
					"fontname": "Arial",
					"fontsize": 12.0
				}
			},
			{
				"box": {
					"id": "d1",
					"maxclass": "newobj",
					"numinlets": 4,
					"numoutlets": 0,
					"patching_rect": [
						20.0,
						600.0,
						120.0,
						22.0
					],
					"text": "dac~ 1 2 3 4",
					"fontname": "Arial",
					"fontsize": 12.0,
					"outlettype": []
				}
			}
		],
		"lines": [
			{
				"patchline": {
					"source": [
						"lb",
						0
					],
					"destination": [
						"m1",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"m1",
						0
					],
					"destination": [
						"n1",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"m1",
						0
					],
					"destination": [
						"n2",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"m1",
						0
					],
					"destination": [
						"n3",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"m1",
						0
					],
					"destination": [
						"n4",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"n1",
						0
					],
					"destination": [
						"g1",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"n2",
						0
					],
					"destination": [
						"g2",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"n3",
						0
					],
					"destination": [
						"g3",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"n4",
						0
					],
					"destination": [
						"g4",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"g1",
						0
					],
					"destination": [
						"p1",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"g2",
						0
					],
					"destination": [
						"p1",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"g3",
						0
					],
					"destination": [
						"p1",
						2
					]
				}
			},
			{
				"patchline": {
					"source": [
						"g4",
						0
					],
					"destination": [
						"p1",
						3
					]
				}
			},
			{
				"patchline": {
					"source": [
						"p1",
						0
					],
					"destination": [
						"v1",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"v1",
						0
					],
					"destination": [
						"u1",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"u1",
						0
					],
					"destination": [
						"k1",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"u1",
						0
					],
					"destination": [
						"d1",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"u1",
						1
					],
					"destination": [
						"k2",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"u1",
						1
					],
					"destination": [
						"d1",
						1
					]
				}
			},
			{
				"patchline": {
					"source": [
						"u1",
						2
					],
					"destination": [
						"k3",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"u1",
						2
					],
					"destination": [
						"d1",
						2
					]
				}
			},
			{
				"patchline": {
					"source": [
						"u1",
						3
					],
					"destination": [
						"k4",
						0
					]
				}
			},
			{
				"patchline": {
					"source": [
						"u1",
						3
					],
					"destination": [
						"d1",
						3
					]
				}
			}
		]
	}
}