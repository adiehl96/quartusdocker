docker build -t quartus --platform linux/amd64 .
docker run -e DISPLAY=192.168.0.103:0 --name quartus -d quartus
wget -N https://archive.eclipse.org/technology/epp/downloads/release/mars/2/eclipse-cpp-mars-2-linux-gtk-x86_64.tar.gz
wget -N https://download.altera.com/akdlm/software/acdsinst/20.1std.1/720/ib_tar/Quartus-lite-20.1.1.720-linux.tar