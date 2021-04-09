#!/bin/bash

# -------------------------------------------------------------------------------------------------------------------------
#  Author: André Alexander Pieper
# Version: 1.0
#    Date: 09.04.2021
# License: LGPLv3
#
# The main purpose of this script is the convertion of a bunch of .mp4 video files from the h.264 codec to the h.265 
# codec. It uses the ffmpeg (version 4.2.4-1ubuntu0.1) program for a linux environment. There is also the pssibility to 
# activate the GPU (only AMD | Linux) encoding / decoding, but I was not satisfied with the file size - video quality 
# rate. So, the activated convertion will be managed by the CPU. The configuration allows to have the same video quality
# with a muc smaller file. In average the convertion saves 80% of the used storage. 
#
# -------------------------------------------------------------------------------------------------------------------------

VIDEO_PATH_IN=${HOME}"/IN/"
VIDEO_PATH_OUT=${HOME}"/OUT/"

FILENAMES=$(find ${VIDEO_PATH_IN} -name "*.mp4" -type f -printf "%f\n")


# export VAAPI_MPEG4_ENABLED=1


for file in ${FILENAMES}; do
    echo ------------------------------------------------------------------------------------------------------------------
    echo Start compressing of video ${file} 
    echo ------------------------------------------------------------------------------------------------------------------
    
    ffmpeg -i ${VIDEO_PATH_IN}${file} -c:v libx265 -b:v 2600k -x265-params pass=2 -c:a copy ${VIDEO_PATH_OUT}${file}
    
    # Command for AMD GPU encoding. Pretty fast, but the quality is worse than the CPU encoding... I guess the reason is the hevc_vaapi library.
    # ffmpeg -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 -hwaccel_output_format vaapi -i ${VIDEO_PATH_IN}${file} -vf 'scale_vaapi=format=p010' -c:v hevc_vaapi -profile 2 -b:v 2600k -preset slow -c:a copy ${VIDEO_PATH_OUT}${file}
    
done
