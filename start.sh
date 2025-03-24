docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v ~/.Xauthority:/home/matlabuser/.Xauthority -v /mnt/data/matlab:/data --network host matlab:R2024a -desktop
