 #!/bin/bash
FONT="/Users/leo/Library/Fonts/skyfonts-google/Cardo 700.ttf"
SHOW_NAME="empowerapps.show"
FCLIP_NAME=${CLIP_NAME//,}
LOGO_PATH=brightdigit.png
ANIMATED_LOGO_FORMAT=Logo-%d.png

convert -gravity East -font "$FONT" -pointsize 48 label:"$SHOW_NAME" -pointsize 32 label:"episode $EPISODE_NO" -pointsize 52 label:"$EPISODE_NAME" -pointsize 42 label:"$GUEST_APPEND" -pointsize 56 label:"$CLIP_NAME" -append "$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.$FCLIP_NAME.text.16x9.png"
convert -size 1920x1080 xc:white -gravity SouthEast -draw "image over 200,100, 0,0, '$LOGO_PATH'" -gravity NorthEast -draw "image over 200,100, 0,0, '$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.$FCLIP_NAME.text.16x9.png'" "$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.$FCLIP_NAME.background.16x9.png"
ffmpeg -loop 1 -framerate 1 -i "$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.$FCLIP_NAME.background.16x9.png" -framerate 1 -f image2 -i $ANIMATED_LOGO_FORMAT -filter_complex "[1:v]scale=iw/2:ih/2 [ovrl],[0:v][ovrl] overlay=200:(H-h)/2:shortest=1,format=yuv420p" -vcodec libx264 -crf 25  -pix_fmt yuv420p -r 60 "$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.$FCLIP_NAME.loop.16x9.mp4"
ffmpeg -i "$AUDIO_FILE" -filter_complex movie="$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.$FCLIP_NAME.loop.16x9.mp4":loop=0,setpts=N/FRAME_RATE/TB -shortest "$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.$FCLIP_NAME.16x9.mp4"

convert -gravity East -font "$FONT" -pointsize 36 label:"$SHOW_NAME" -pointsize 28 label:"episode $EPISODE_NO" -pointsize 36 label:"$EPISODE_NAME" -pointsize 32 label:"$GUEST_APPEND" -pointsize 52 label:"$CLIP_NAME" -append "$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.$FCLIP_NAME.text.1x1.png"
convert -size 1080x1080 xc:white -gravity SouthEast -draw "image over 100,100, 0,0, '$LOGO_PATH'" -gravity NorthEast  -gravity NorthEast -draw "image over 100,100, 0,0, '$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.$FCLIP_NAME.text.1x1.png'" "$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.$FCLIP_NAME.background.1x1.png"
ffmpeg -loop 1 -framerate 1 -i "$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.$FCLIP_NAME.background.1x1.png" -framerate 1 -f image2 -i $ANIMATED_LOGO_FORMAT -filter_complex "[1:v]scale=iw/3:ih/3 [ovrl],[0:v][ovrl] overlay=(W-w)/2:(H-h)/2+50:shortest=1,format=yuv420p" -vcodec libx264 -crf 25  -pix_fmt yuv420p -r 60 "$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.$FCLIP_NAME.loop.1x1.mp4"
ffmpeg -i "$AUDIO_FILE" -filter_complex movie="$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.$FCLIP_NAME.loop.1x1.mp4":loop=0,setpts=N/FRAME_RATE/TB -shortest "$SHOW_NAME.$EPISODE_NO.$EPISODE_NAME.$FCLIP_NAME.1x1.mp4"