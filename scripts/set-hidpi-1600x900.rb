require 'fiddle/import'
# Select and persist the existing 1600x900 HiDPI @60Hz mode on the reference BOE panel.
module ScreenAPI
 extend Fiddle::Importer
 dlload '/System/Library/Frameworks/CoreGraphics.framework/CoreGraphics'
 extern 'unsigned int CGMainDisplayID()'
 extern 'int CGGetOnlineDisplayList(unsigned int, void*, void*)'
 extern 'unsigned int CGDisplayVendorNumber(unsigned int)'
 extern 'unsigned int CGDisplayModelNumber(unsigned int)'
 extern 'unsigned int CGDisplayMirrorsDisplay(unsigned int)'
 extern 'void CGSGetNumberOfDisplayModes(unsigned int, void*)'
 extern 'void CGSGetDisplayModeDescriptionOfLength(unsigned int, int, void*, int)'
 extern 'int CGSGetCurrentDisplayMode(unsigned int, void*)'
 extern 'int CGBeginDisplayConfiguration(void*)'
 extern 'int CGSConfigureDisplayMode(void*, unsigned int, int)'
 extern 'int CGCompleteDisplayConfiguration(void*, int)'
 extern 'int CGCancelDisplayConfiguration(void*)'
 extern 'void* CGDisplayCopyDisplayMode(unsigned int)'
 extern 'int CGDisplaySetDisplayMode(unsigned int, void*, void*)'
 extern 'void CFRelease(void*)'
 extern 'void* CFBundleGetMainBundle()'
 extern 'void* CFBundleGetValueForInfoDictionaryKey(void*, void*)'
 extern 'void* CFStringCreateWithCString(void*, const char*, unsigned int)'
 extern 'unsigned char CFBooleanGetValue(void*)'
end
out=File.join(ARGV.fetch(0),'OMEN-保存默认HiDPI-'+Time.now.strftime('%Y%m%d-%H%M%S')+'.txt')
report=[]
record=lambda{|s| puts s;report<<s;File.write(out,report.join("\n")+"\n")}
api=ScreenAPI
k=api.CFStringCreateWithCString(nil,'NSHighResolutionCapable',0x08000100)
v=api.CFBundleGetValueForInfoDictionaryKey(api.CFBundleGetMainBundle,k)
capable=!v.null? && api.CFBooleanGetValue(v)!=0
api.CFRelease(k)
record.call("进程NSHighResolutionCapable=#{capable}")
abort '测试程序没有声明高分辨率支持，停止测试。' unless capable
ids=Fiddle::Pointer.malloc(64);ids[0,64]="id=api.CGMainDisplayID"*64
n=Fiddle::Pointer.malloc(4);n[0,4]=[0].pack('I')
abort '无法读取在线显示器。' unless api.CGGetOnlineDisplayList(16,ids,n)==0
count=n[0,4].unpack1('I')
physical=ids[0,count*4].unpack('I*').select{|x|api.CGDisplayVendorNumber(x)==2533 && api.CGDisplayModelNumber(x)==2941}
abort '未唯一识别到BOE内屏，未更改显示。' unless physical.size==1
id=physical.first
abort '内屏正在镜像其他屏幕，请先断开虚拟屏幕并退出BetterDisplay，再测试。' unless api.CGDisplayMirrorsDisplay(id)==0


abort '无法读取主显示器，未更改显示。' if id==0
original=api.CGDisplayCopyDisplayMode(id)
abort '无法保存原模式，未更改显示。' if original.null?
countbuf=Fiddle::Pointer.malloc(4)
countbuf[0,4]=[0].pack('i')
api.CGSGetNumberOfDisplayModes(id,countbuf)
count=countbuf[0,4].unpack1('i')
abort '模式数异常，未更改显示。' unless count.between?(1,4096)
readmode=lambda do |idx|
 p=Fiddle::Pointer.malloc(212);p[0,212]="\0"*212
 api.CGSGetDisplayModeDescriptionOfLength(id,idx,p,212)
 num,flags,w,h,depth=p[0,20].unpack('L5')
 {index:idx,number:num,flags:flags,width:w,height:h,depth:depth,hz:p[190,2].unpack1('S'),density:p[208,4].unpack1('f')}
end
getcurrent=lambda do
 p=Fiddle::Pointer.malloc(4);p[0,4]=[-1].pack('i')
 r=api.CGSGetCurrentDisplayMode(id,p)
 r==0 ? p[0,4].unpack1('i') : -1
end
oldindex=getcurrent.call
record.call("原模式索引：#{oldindex}；内部模式数：#{count}")
entries=(0...count).map{|i| readmode.call(i)}
entries.each{|m| record.call(m.inspect)}
# 只选择现有内部模式，不新增时序；优先验证无需付费软件的高刷新率HiDPI。
priorities=[[1600,900,60]]
kept_any=false
priorities.each do |w,h,hz|
 matches=entries.select{|m|m[:width]==w && m[:height]==h && m[:hz]==hz && m[:density].finite? && (m[:density]-2.0).abs<0.01}
 if matches.empty?
  record.call("无此现有HiDPI档：#{w}×#{h}@#{hz}");next
 end
 target=matches.max_by{|m|m[:depth]}
 record.call("测试目标：#{target.inspect}；恢复1600×900 HiDPI@60Hz，5秒后核对，不成功则恢复原模式。")
 attempted=false;kept=false
 begin
  ptr=Fiddle::Pointer.malloc(Fiddle::SIZEOF_VOIDP);ptr[0,Fiddle::SIZEOF_VOIDP]=[0].pack('J')
  r=api.CGBeginDisplayConfiguration(ptr);record.call("begin=#{r}")
  if r==0
   cfg=Fiddle::Pointer.new(ptr[0,Fiddle::SIZEOF_VOIDP].unpack1('J'))
   r=api.CGSConfigureDisplayMode(cfg,id,target[:index]);record.call("configure=#{r}")
   if r==0
    attempted=true
    r=api.CGCompleteDisplayConfiguration(cfg,2);record.call("complete=#{r}")
    sleep 2
    actual=getcurrent.call
    record.call("2秒后实际索引：#{actual}；目标：#{target[:index]}")
    if r==0 && actual==target[:index]
     sleep 3
     kept=true
     confirmed=getcurrent.call;record.call("确认后实际索引：#{confirmed}")
     kept=kept && confirmed==target[:index]
    end
   else
    api.CGCancelDisplayConfiguration(cfg)
   end
  end
 ensure
  if attempted && !kept
   restore_ptr=Fiddle::Pointer.malloc(Fiddle::SIZEOF_VOIDP)
   restore_ptr[0,Fiddle::SIZEOF_VOIDP]=[0].pack('J')
   restore_rc=api.CGBeginDisplayConfiguration(restore_ptr)
   if restore_rc==0
    restore_cfg=Fiddle::Pointer.new(restore_ptr[0,Fiddle::SIZEOF_VOIDP].unpack1('J'))
    restore_rc=api.CGSConfigureDisplayMode(restore_cfg,id,oldindex)
    if restore_rc==0
     restore_rc=api.CGCompleteDisplayConfiguration(restore_cfg,1)
    else
     api.CGCancelDisplayConfiguration(restore_cfg)
    end
   end
   sleep 1
   record.call("恢复后实际索引：#{getcurrent.call}；原索引：#{oldindex}")
   restore_rc=1000 if restore_rc==0 && getcurrent.call!=oldindex

   record.call("恢复原模式：#{restore_rc}")
   abort '恢复返回错误，已停止后续测试。请使用显示设置恢复原生分辨率。' unless restore_rc==0
  end
 end
 if kept
  kept_any=true
  record.call("已按用户请求切换并核对：#{w}×#{h} HiDPI @#{hz}Hz（已请求系统永久保存，待重启验证）")
  break
 end
end
record.call('1600×900 HiDPI@60Hz未保持成功，原模式已恢复；未更改EFI或覆盖表。') unless kept_any
api.CFRelease(original)
puts "结果已保存：#{out}"
