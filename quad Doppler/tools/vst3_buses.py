import ctypes, sys
IID_COMP = bytes.fromhex('e831ff31f2d54301928ebbee25697802')
class PClassInfo(ctypes.Structure):
    _fields_=[('cid',ctypes.c_char*16),('card',ctypes.c_int32),('cat',ctypes.c_char*32),('name',ctypes.c_char*64)]
# 真实布局：mediaType, direction, channelCount, name[128](UTF-16), busType, flags
class BusInfo(ctypes.Structure):
    _fields_=[('mediaType',ctypes.c_int32),('direction',ctypes.c_int32),('channelCount',ctypes.c_int32),
              ('name',ctypes.c_uint16*128),('busType',ctypes.c_int32),('flags',ctypes.c_uint32)]
def slot(obj,idx,res,*a):
    vt=ctypes.cast(obj, ctypes.POINTER(ctypes.POINTER(ctypes.c_void_p)))[0]
    return ctypes.CFUNCTYPE(res, ctypes.c_void_p, *a)(ctypes.cast(vt[idx], ctypes.c_void_p).value)
exe=sys.argv[1]
lib=ctypes.CDLL(exe, mode=ctypes.RTLD_LOCAL); lib.GetPluginFactory.restype=ctypes.c_void_p
f=lib.GetPluginFactory(); ci=PClassInfo()
slot(f,5,ctypes.c_int32,ctypes.c_int32,ctypes.POINTER(PClassInfo))(f,0,ctypes.byref(ci))
create=slot(f,6,ctypes.c_int32,ctypes.c_void_p,ctypes.c_void_p,ctypes.POINTER(ctypes.c_void_p))
comp=ctypes.c_void_p(); create(f, ctypes.create_string_buffer(ci.cid,16), ctypes.create_string_buffer(IID_COMP,16), ctypes.byref(comp))
print('class:', ci.cat.decode(errors='replace'), '/', ci.name.decode(errors='replace'), flush=True)
slot(comp,3,ctypes.c_int32,ctypes.c_void_p)(comp, None)
gbc=slot(comp,7,ctypes.c_int32,ctypes.c_int32,ctypes.c_int32)
gbi=slot(comp,8,ctypes.c_int32,ctypes.c_int32,ctypes.c_int32,ctypes.c_int32,ctypes.POINTER(BusInfo))
for d,lbl in ((0,'IN '),(1,'OUT')):
    n=gbc(comp,0,d)
    print(f'{lbl}: {n} audio bus', flush=True)
    for i in range(n):
        bi=BusInfo(); rc=gbi(comp,0,d,i,ctypes.byref(bi))
        nm=bytes(bi.name).decode('utf-16-le',errors='replace').split('\x00')[0]
        print(f'   [{i}] rc={rc} type={"MAIN" if bi.busType==0 else "AUX "} '
              f'ch={bi.channelCount} flags=0x{bi.flags:x} name={nm!r}', flush=True)
