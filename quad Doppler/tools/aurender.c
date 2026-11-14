// aurender — 把 AU 真正渲染一遍，验证四路输出是否都有正确信号与声像。
// 这是判断「DSP 到底有没有出四声道」的最终依据：auval 只看格式声明，
// 这个工具看实际样本。
//
// 构建:  clang -o aurender aurender.c -framework AudioToolbox -framework AudioUnit -framework CoreAudio
// 用法:  ./aurender Q3ST 4

#include <AudioToolbox/AudioToolbox.h>
#include <AudioUnit/AudioUnit.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define SR 44100.0
#define BLK 512

static double g_t = 0;

static OSStatus inCB(void *ref, AudioUnitRenderActionFlags *fl, const AudioTimeStamp *ts,
                     UInt32 bus, UInt32 nframes, AudioBufferList *io) {
    for (UInt32 b = 0; b < io->mNumberBuffers; b++) {
        float *p = (float *)io->mBuffers[b].mData;
        for (UInt32 k = 0; k < nframes; k++)
            p[k] = 0.35f * sinf(2 * M_PI * 220.0 * (g_t + k) / SR);
    }
    g_t += nframes;
    return noErr;
}

static void asbd(AudioStreamBasicDescription *f, UInt32 ch) {
    memset(f, 0, sizeof(*f));
    f->mSampleRate = SR;
    f->mFormatID = kAudioFormatLinearPCM;
    f->mFormatFlags = kAudioFormatFlagIsFloat | kAudioFormatFlagIsPacked | kAudioFormatFlagIsNonInterleaved;
    f->mChannelsPerFrame = ch;
    f->mFramesPerPacket = 1;
    f->mBitsPerChannel = 32;
    f->mBytesPerFrame = 4;
    f->mBytesPerPacket = 4;
}

/* 按名字找参数序号。不能写死 0/1：Singularity 的参数 0 是 fallTime，
   照抄会把 fallTime 覆盖成 x，测出来的数据全是假的。 */
static int findParam(AudioUnit au, const char *want) {
    UInt32 n = 0;
    if (AudioUnitGetProperty(au, kAudioUnitProperty_ParameterList,
                             kAudioUnitScope_Global, 0, NULL, &n) != noErr) return -1;
    if (n == 0 || n > 1024) return -1;
    AudioUnitParameterID ids[1024];
    UInt32 sz = n * sizeof(AudioUnitParameterID);
    if (AudioUnitGetProperty(au, kAudioUnitProperty_ParameterList,
                             kAudioUnitScope_Global, 0, ids, &sz) != noErr) return -1;
    for (UInt32 i = 0; i < n; i++) {
        AudioUnitParameterInfo info;
        UInt32 isz = sizeof(info);
        if (AudioUnitGetProperty(au, kAudioUnitProperty_ParameterInfo,
                                 kAudioUnitScope_Global, ids[i], &info, &isz) != noErr)
            continue;
        if (strcasecmp(info.name, want) == 0) return (int)ids[i];
    }
    return -1;
}

/* 把 x/y 参数设到指定位置后渲染一段时间，返回各通道 RMS */
static int g_blocks = 60;
static UInt32 g_ins = 0;    /* 0 = 自动（out>=4 用 4，否则 2）*/   /* 由命令行第 3 个参数换算，默认 60 块 ≈ 0.7 s */

static void run(AudioUnit au, float x, float y, UInt32 outs, double *rms) {
    int px = findParam(au, "x"), py = findParam(au, "y");
    if (px >= 0) AudioUnitSetParameter(au, px, kAudioUnitScope_Global, 0, x, 0);
    if (py >= 0) AudioUnitSetParameter(au, py, kAudioUnitScope_Global, 0, y, 0);

    float *out[8];
    for (UInt32 i = 0; i < outs; i++) out[i] = calloc(BLK, sizeof(float));
    AudioBufferList *ob = calloc(1, sizeof(AudioBufferList) + sizeof(AudioBuffer) * (outs - 1));
    ob->mNumberBuffers = outs;
    for (UInt32 i = 0; i < outs; i++) {
        ob->mBuffers[i].mNumberChannels = 1;
        ob->mBuffers[i].mDataByteSize = BLK * 4;
        ob->mBuffers[i].mData = out[i];
        rms[i] = 0;
    }

    for (int b = 0; b < g_blocks; b++) {
        for (UInt32 i = 0; i < outs; i++) memset(out[i], 0, BLK * 4);
        AudioTimeStamp ts; memset(&ts, 0, sizeof(ts));
        ts.mSampleTime = b * BLK; ts.mFlags = kAudioTimeStampSampleTimeValid;
        AudioUnitRenderActionFlags fl = 0;
        AudioUnitRender(au, &fl, &ts, 0, BLK, ob);
        if (b >= g_blocks / 2)      /* 前半段留给包络/混响稳定，只统计后半段 */
            for (UInt32 i = 0; i < outs; i++)
                for (int k = 0; k < BLK; k++) rms[i] += (double)out[i][k] * out[i][k];
    }
    for (UInt32 i = 0; i < outs; i++) rms[i] = sqrt(rms[i] / (BLK * (g_blocks / 2)));

    for (UInt32 i = 0; i < outs; i++) free(out[i]);
    free(ob);
}

int main(int argc, char **argv) {
    if (argc < 3) { printf("usage: aurender <4char subtype> <outChannels>\n"); return 2; }
    /* OSType 是大端四字符码：必须按字节移位拼，不能 memcpy（x86/ARM 上会得到反序） */
    OSType sub = ((OSType)(unsigned char)argv[1][0] << 24)
               | ((OSType)(unsigned char)argv[1][1] << 16)
               | ((OSType)(unsigned char)argv[1][2] << 8)
               |  (OSType)(unsigned char)argv[1][3];
    UInt32 outs = (UInt32)atoi(argv[2]);
    if (outs < 1 || outs > 8) { printf("outChannels 1..8\n"); return 2; }
    if (argc >= 4) {
        double sec = atof(argv[3]);
        if (sec > 0.1 && sec < 600) g_blocks = (int)(sec * SR / BLK);
    }
    if (argc >= 5) {
        int n = atoi(argv[4]);
        if (n >= 1 && n <= 8) g_ins = (UInt32)n;
    }
    printf("渲染 %.2f s（统计后半段）\n", g_blocks * BLK / SR);

    AudioComponentDescription d = { kAudioUnitType_Effect, sub, 'Cabb', 0, 0 };
    AudioComponent comp = AudioComponentFindNext(NULL, &d);
    if (!comp) { printf("component not found\n"); return 1; }

    AudioUnit au;
    AudioComponentInstanceNew(comp, &au);

    AudioStreamBasicDescription fi, fo;
    /* 输入必须与 CSD 的 nchnls_i 一致：现在 CSD 只写 nchnls = 4，
       Csound 让 nchnls_i = 4，所以 AU 要求 4 声道输入（设 2 声道会返回
       kAudioUnitErr_FormatNotSupported = -10868）。 */
    /* 输入声道数：第 4 个参数可指定（quad 版要 4，depth 版要 2）。
       不指定时按输出算，并夹到 1..2/4 的合理范围。 */
    UInt32 ins = g_ins ? g_ins : (outs >= 4 ? 4 : 2);
    asbd(&fi, ins); asbd(&fo, outs);
    OSStatus si = AudioUnitSetProperty(au, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &fi, sizeof(fi));
    if (si) { printf("SET IN %u ch FAILED (%d)\n", (unsigned)ins, (int)si); return 1; }
    OSStatus st = AudioUnitSetProperty(au, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 0, &fo, sizeof(fo));
    if (st) { printf("SET OUT %u ch FAILED (%d)\n", (unsigned)outs, (int)st); return 1; }

    AURenderCallbackStruct cb = { inCB, NULL };
    AudioUnitSetProperty(au, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &cb, sizeof(cb));
    UInt32 mx = BLK;
    AudioUnitSetProperty(au, kAudioUnitProperty_MaximumFramesPerSlice, kAudioUnitScope_Global, 0, &mx, sizeof(mx));
    AudioUnitInitialize(au);

    const char *nm[8] = { "FL", "FR", "RL", "RR", "ch5", "ch6", "ch7", "ch8" };
    struct { const char *label; float x, y; } cases[] = {
        { "左前  x=0.05 y=0.95", 0.05f, 0.95f },
        { "右后  x=0.95 y=0.05", 0.95f, 0.05f },
        { "正中  x=0.50 y=0.50", 0.50f, 0.50f },
    };

    int has_pos = (findParam(au, "x") >= 0 && findParam(au, "y") >= 0);
    printf("(位置参数 x/y: %s)\n", has_pos ? "有，三种位置各测一次" : "无，位置由 DSP 自己运动，三次结果相同属正常");
    for (int c = 0; c < 3; c++) {
        double rms[8];
        run(au, cases[c].x, cases[c].y, outs, rms);
        printf("%s\n", cases[c].label);
        for (UInt32 i = 0; i < outs; i++) printf("   %-4s = %.4f\n", nm[i], rms[i]);
        int bad = 0;
        for (UInt32 i = 0; i < outs; i++) if (!isfinite(rms[i]) || rms[i] > 50) bad = 1;
        if (bad) printf("   !! 有 NaN / 爆值\n");
    }

    AudioComponentInstanceDispose(au);
    return 0;
}
