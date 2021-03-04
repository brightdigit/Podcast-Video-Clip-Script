 #!/bin/bash
FONT="/Users/leo/Library/Fonts/skyfonts-google/Oxygen regular.ttf"
SHOW_NAME="empowerapps.show"
FCLIP_NAME=${CLIP_NAME//,}

LOGO_PATH=brightdigit.png
ANIMATED_LOGO_FORMAT=Logo-%d.png

mkdir -p .temp

yes | convert -gravity East -font "$FONT" \
  -pointsize 96 label:"$SHOW_NAME" \
  -pointsize 64 label:"episode $EPISODE_NO" \
  -pointsize 104 label:"$EPISODE_NAME" \
  -pointsize 84 label:"$GUEST_APPEND" \
  -pointsize 112 label:"$CLIP_NAME" \
  -append ".temp/$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.$FCLIP_NAME.text.16x9.png"
yes | convert -size 3840x2160 xc:white \
 -gravity SouthEast -draw "image over 400,200, 0,0, '$LOGO_PATH'" \
 -gravity NorthEast -draw "image over 400,200, 0,0, '.temp/$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.$FCLIP_NAME.text.16x9.png'" \
 -gravity West -draw "image over 400,200, 800,800, '$EP_IMG'" \
 ".temp/$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.$FCLIP_NAME.background.16x9.png"
yes | ffmpeg -loop 1 -framerate 1 -i ".temp/$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.$FCLIP_NAME.background.16x9.png" \
  -framerate 1 -f image2 -i $ANIMATED_LOGO_FORMAT \
  -filter_complex "[1:v]scale=iw/4:ih/4 [ovrl],[0:v][ovrl] overlay=400:200:shortest=1,format=yuv420p" \
  -vcodec libx264 -crf 25  -pix_fmt yuv420p -r 60 ".temp/$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.$FCLIP_NAME.loop.16x9.mp4"
yes | ffmpeg -i "$AUDIO_FILE" \
 -filter_complex movie=".temp/$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.$FCLIP_NAME.loop.16x9.mp4":loop=0,setpts=N/FRAME_RATE/TB \
 -shortest ".temp/$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.$FCLIP_NAME.16x9.noloop.mp4"
ffmpeg -i ".temp/$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.$FCLIP_NAME.16x9.noloop.mp4" -filter_complex \
 "[0:v]null[bg]; \
 [0:a]showwaves=mode=line:s=2840x1600:colors=#00000099[fg]; \
 [bg][fg]overlay=x=1000:y=480" "$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.$FCLIP_NAME.16x9.mp4"