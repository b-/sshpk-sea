#!/usr/bin/env bash
set -euxo pipefail
W="$(pwd)"
T="$(mktemp -d)"
cd "${T}"
npm i @vercel/ncc sshpk postject
./node_modules/.bin/ncc build node_modules/.bin/sshpk-conv -o dist
printf '{ "main": "%s/dist/index.js", "disableExperimentalSEAWarning": true, "output": "sea-prep.blob" }' "${T}" > sea-config.json
node --experimental-sea-config sea-config.json
cp $(command -v node) sshpk-conv
npx postject sshpk-conv NODE_SEA_BLOB sea-prep.blob \
    --sentinel-fuse NODE_SEA_FUSE_fce680ab2cc467b6e072b8b5df1996b2
cp sshpk-conv "${W}"
pwd
