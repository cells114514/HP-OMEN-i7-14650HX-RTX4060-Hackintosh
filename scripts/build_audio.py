#!/usr/bin/env python3
"""Fetch pinned AppleALC/Lilu/SDK inputs and build; never installs a kext."""
from pathlib import Path
import urllib.request, tarfile, zipfile, io, shutil, hashlib, subprocess
root=Path(__file__).resolve().parents[1]
build=root/'build/audio'
build.mkdir(parents=True,exist_ok=True)
source=build/'AppleALC'
if source.exists():raise SystemExit('Use a fresh build/audio directory; existing source left unchanged.')
url='https://api.github.com/repos/acidanthera/AppleALC/tarball/ff01db21749271916d44605503499ceaa61d94b2'
req=urllib.request.Request(url,headers={'User-Agent':'OMEN-reference-build'})
raw=urllib.request.urlopen(req).read()
with tarfile.open(fileobj=io.BytesIO(raw),mode='r:gz') as archive:
 for member in archive.getmembers():
  parts=Path(member.name).parts[1:]
  if not parts:continue
  target=source.joinpath(*parts)
  if not target.resolve().is_relative_to(source.resolve()):raise SystemExit('Unsafe archive path')
  if member.isdir():target.mkdir(parents=True,exist_ok=True)
  elif member.isfile():
   target.parent.mkdir(parents=True,exist_ok=True)
   with archive.extractfile(member) as src,target.open('wb') as dst:shutil.copyfileobj(src,dst)
for name in ['layout11.xml','Platforms11.xml']:shutil.copy2(root/'Sources/AppleALC-ALC245'/name,source/'Resources/ALC245'/name)
shutil.copytree(root/'Sources/AirportItlwm/MacKernelSDK',source/'MacKernelSDK',dirs_exist_ok=True)
lilu=urllib.request.urlopen('https://github.com/acidanthera/Lilu/releases/download/1.7.2/Lilu-1.7.2-DEBUG.zip').read()
assert hashlib.sha256(lilu).hexdigest()=='e95df95d82e8b151047abf359ecd9c853755c59293e19dfcc3907da8fbd8cf89', 'Lilu release hash mismatch'
with zipfile.ZipFile(io.BytesIO(lilu)) as archive:
 for name in archive.namelist():
  parts=Path(name).parts
  if not parts or parts[0]!='Lilu.kext':continue
  target=source.joinpath(*parts)
  if not target.resolve().is_relative_to(source.resolve()):raise SystemExit('Unsafe zip path')
  if name.endswith('/'):target.mkdir(parents=True,exist_ok=True)
  else:target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes(archive.read(name))
subprocess.run(['xcodebuild','-project',str(source/'AppleALC.xcodeproj'),'-scheme','AppleALC','-configuration','Release','-derivedDataPath',str(build/'DerivedData'),'ARCHS=x86_64','ONLY_ACTIVE_ARCH=NO','CODE_SIGNING_ALLOWED=NO','build'],check=True)
print('Build only: see build/audio/DerivedData/Build/Products/Release. Nothing installed.')
