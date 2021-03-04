 #!/bin/bash
FONT="/Users/leo/Library/Fonts/skyfonts-google/Oxygen regular.ttf"
SHOW_NAME="empowerapps.show"
LOGO_PATH=brightdigit.png
ANIMATED_LOGO_FORMAT=Logo-%d.png

mkdir -p .temp

yes | convert -gravity East -font "$FONT" \
  -pointsize 52 label:"$SHOW_NAME" \
  -pointsize 32 label:"episode $EPISODE_NO" \
  -pointsize 68 label:"$EPISODE_NAME" \
  -pointsize 64 label:"$GUEST_APPEND" \
  -append ".temp/$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.text.16x9.png"
yes | convert -size 1920x1080 xc:white \
  -gravity SouthEast -draw "image over 200,100, 0,0, '$LOGO_PATH'" \
  -gravity NorthEast -draw "image over 200,100, 0,0, '.temp/$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.text.16x9.png'" \
  -gravity West -draw "image over 200,100, 400,400, '$EP_IMG'" \
  ".temp/$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.background.16x9.png"
yes | ffmpeg -loop 1 -framerate 1 -i ".temp/$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.background.16x9.png" \
  -framerate 1 -f image2 -i $ANIMATED_LOGO_FORMAT \
  -filter_complex "[1:v]scale=iw/8:ih/8 [ovrl],[0:v][ovrl] overlay=200:100:shortest=1,format=yuv420p" \
  -vcodec libx264 -crf 25  -pix_fmt yuv420p -r 60 ".temp/$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.loop.16x9.mp4"
yes | ffmpeg -i "$AUDIO_FILE" -filter_complex movie=".temp/$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.loop.16x9.mp4":loop=0,setpts=N/FRAME_RATE/TB -shortest ".temp/$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.16x9.noloop.mp4"
ffmpeg -i ".temp/$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.16x9.noloop.mp4" -filter_complex \
 "[0:v]null[bg]; \
 [0:a]showwaves=mode=line:s=1350x800:colors=#00000099[fg]; \
 [bg][fg]overlay=x=600:y=250" "$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.16x9.mp4"