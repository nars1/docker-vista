#!/usr/bin/env bash
#---------------------------------------------------------------------------
# Copyright 2011-2012 The Open Source Electronic Health Record Agent
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#---------------------------------------------------------------------------

# Import VistA Globals and Routines into GT.M


# Ensure presence of required variables
if [[ -z $instance && $gtmver && $gtm_dist ]]; then
    echo "The required variables are not set (instance, gtmver, gtm_dist)"
fi

if $devMode; then
  set -x
fi

# number of cores - 1
# (works also on MacOS; on FreeBSD, omit underscore)
cores=$(($(getconf _NPROCESSORS_ONLN) - 1))

if (( cores < 1 )); then cores=1; fi

# Import routines
echo "Copying routines using $cores cores"
find /usr/local/src/VistA-Source -name '*.m' -print0 |
  xargs -0 -I{} -n 1 -P $cores cp "{}" $basedir/r
echo "Done copying routines"

echo "Importing globals using $cores cores"
find /usr/local/src/VistA-Source -name '*.zwr' -print0 |
  xargs -0 -I{} -n 1 -P $cores $gtm_dist/mupip load \"{}\" >> \
  $basedir/log/loadGloabls.log 2>&1

echo "Done importing globals"
