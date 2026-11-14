// auprobe — 不依赖宿主，直接向 AU 询问声道能力并尝试配置多声道输出。
// Cabbage 3 的包装器把默认总线格式固定成 2 声道，auval 会因此报错；
// 但宿主（Live / Reaper / Logic）会主动按 SupportedNumChannels 配置，
// 所以判断「能不能出四声道」要看这个工具，而不是看 auval 的 green light。
//
// 构建:  clang -o auprobe auprobe.c -framework AudioToolbox -framework AudioUnit -framework CoreAudio
// 用法:  ./auprobe Q3ST 4        (4 字符 subtype + 期望的输出通道数)

#include <AudioToolbox/AudioToolbox.h>
#include <AudioUnit/AudioUnit.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv) {
    if (argc < 3) { printf("usage: auprobe <4char subtype> <wantedOutChannels>\n"); return 2; }
    /* OSType 是大端四字符码：必须按字节移位拼，不能 memcpy（x86/ARM 上会得到反序） */
    OSType sub = ((OSType)(unsigned char)argv[1][0] << 24)
               | ((OSType)(unsigned char)argv[1][1] << 16)
               | ((OSType)(unsigned char)argv[1][2] << 8)
               |  (OSType)(unsigned char)argv[1][3];
    UInt32 want = (UInt32)atoi(argv[2]);

    AudioComponentDescription d = { kAudioUnitType_Effect, sub, 'Cabb', 0, 0 };
    AudioComponent comp = AudioComponentFindNext(NULL, &d);
    if (!comp) { printf("component not found\n"); return 1; }

    AudioUnit au;
    AudioComponentInstanceNew(comp, &au);

    UInt32 size = 0;
    OSStatus st = AudioUnitGetPropertyInfo(au, kAudioUnitProperty_SupportedNumChannels,
                                           kAudioUnitScope_Global, 0, &size, NULL);
    if (!st && size) {
        int n = size / sizeof(AUChannelInfo);
        AUChannelInfo *info = malloc(size);
        AudioUnitGetProperty(au, kAudioUnitProperty_SupportedNumChannels,
                             kAudioUnitScope_Global, 0, info, &size);
        for (int i = 0; i < n; i++)
            printf("caps[%d]: in %d, out %d\n", i, info[i].inChannels, info[i].outChannels);
        free(info);
    }

    AudioStreamBasicDescription asbd; size = sizeof(asbd);
    AudioUnitGetProperty(au, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 0, &asbd, &size);
    printf("default OUT bus0: %u ch\n", (unsigned)asbd.mChannelsPerFrame);
    AudioUnitGetProperty(au, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &asbd, &size);
    printf("default IN  bus0: %u ch\n", (unsigned)asbd.mChannelsPerFrame);

    AudioUnitGetProperty(au, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 0, &asbd, &size);
    asbd.mChannelsPerFrame = want;
    st = AudioUnitSetProperty(au, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 0, &asbd, sizeof(asbd));
    printf("SET OUT %u ch -> %d %s\n", (unsigned)want, (int)st, st ? "FAILED" : "OK");
    if (!st) {
        AudioStreamBasicDescription g; size = sizeof(g);
        AudioUnitGetProperty(au, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 0, &g, &size);
        printf("  readback: %u ch\n", (unsigned)g.mChannelsPerFrame);
    }

    AudioComponentInstanceDispose(au);
    return 0;
}
