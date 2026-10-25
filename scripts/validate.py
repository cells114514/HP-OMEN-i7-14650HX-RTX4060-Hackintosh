#!/usr/bin/env python3
"""Validate the distributable template or a locally completed EFI. No disk writes."""
from pathlib import Path
import plistlib, argparse, sys, hashlib, json
parser=argparse.ArgumentParser();parser.add_argument('--ready',action='store_true');args=parser.parse_args()
root=Path(__file__).resolve().parents[1];oc=root/'EFI/OC'
config=oc/('config.plist' if args.ready else 'config.sample.plist')
c=plistlib.loads(config.read_bytes());missing=[]
for item in c['Kernel']['Add']:
 if not item.get('Enabled'):continue
 bundle=oc/'Kexts'/item['BundlePath']
 for key in ['PlistPath','ExecutablePath']:
  if item.get(key) and not (bundle/item[key]).is_file():missing.append(str((bundle/item[key]).relative_to(root)))
for item in c['ACPI']['Add']:
 if item.get('Enabled') and not (oc/'ACPI'/item['Path']).is_file():missing.append('ACPI/'+item['Path'])
for item in c['UEFI']['Drivers']:
 if isinstance(item,dict) and item.get('Enabled') and not (oc/'Drivers'/item['Path']).is_file():missing.append('Drivers/'+item['Path'])
g=c['PlatformInfo']['Generic']
if args.ready:
 for key in ['SystemSerialNumber','SystemUUID','MLB']:
  if not g.get(key):missing.append('PlatformInfo/Generic/'+key)
 if not any(g.get('ROM',b'')):missing.append('PlatformInfo/Generic/ROM')
else:
 assert all(not g.get(k) for k in ['SystemSerialNumber','SystemUUID','MLB']) and not any(g['ROM']), 'Public template contains identity data'
 expected='EFI/OC/Kexts/AMFIPass.kext/'
 assert missing and all(x.startswith(expected) for x in missing), 'Unexpected missing dependencies: '+repr(missing)
print(json.dumps({'mode':'ready' if args.ready else 'public-template','missing':missing,'note':'AMFIPass intentionally external; fill identity and validate your local config before boot.'},indent=2))
if args.ready and missing:sys.exit(1)
