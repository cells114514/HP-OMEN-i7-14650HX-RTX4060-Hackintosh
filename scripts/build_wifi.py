#!/usr/bin/env python3
"""Build without installing: Xcode 16.4, x86_64, Sequoia scheme."""
from pathlib import Path
import os, subprocess, hashlib, json
root=Path(__file__).resolve().parents[1]
project=root/'Sources/AirportItlwm'
build=root/'build/wifi'
build.mkdir(parents=True,exist_ok=True)
flags='$(inherited) -ffile-prefix-map='+str(Path.home())+'=/build -fdebug-prefix-map='+str(Path.home())+'=/build'
args=['xcodebuild','-project',str(project/'itlwm.xcodeproj'),'-scheme','AirportItlwm-Sequoia','-configuration','Release','-jobs','3','ARCHS=x86_64','ONLY_ACTIVE_ARCH=NO','SYMROOT='+str(build/'products'),'OBJROOT='+str(build/'obj'),'CODE_SIGNING_ALLOWED=NO','GIT_COMMIT=_738d4c6_omen_eapnotify1','OTHER_CFLAGS='+flags,'OTHER_CPLUSPLUSFLAGS='+flags,'build']
with (build/'build.log').open('w') as log: subprocess.run(args,stdout=log,stderr=subprocess.STDOUT,check=True)
binary=build/'products/Release/Sequoia/AirportItlwm.kext/Contents/MacOS/AirportItlwm'
subprocess.run(['strip','-S',str(binary)],check=True)
print(json.dumps({'binary':str(binary),'sha256':hashlib.sha256(binary.read_bytes()).hexdigest(),'installed':False},indent=2))
