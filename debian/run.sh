wget -N https://archive.eclipse.org/technology/epp/downloads/release/mars/2/eclipse-cpp-mars-2-linux-gtk-x86_64.tar.gz
wget -N https://download.altera.com/akdlm/software/acdsinst/20.1std.1/720/ib_tar/Quartus-lite-20.1.1.720-linux.tar
docker build -t quartus .
docker run -e DISPLAY=192.168.0.104:0 --name quartus -d quartus --mac-address="12:34:de:b0:6b:61"
