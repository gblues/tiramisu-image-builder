FROM ubuntu:jammy

RUN apt-get update && \
    apt-get install -y curl unzip dosfstools

# ubuntu doesn't have a package for htmlq, so we download it
ADD https://github.com/mgdm/htmlq/releases/latest/download/htmlq-x86_64-linux.tar.gz /tmp/htmlq.tgz

# Copy the scripts in bin/ into /usr/local/bin
COPY bin /usr/local/bin

# Unpack htmlq, install other dependencies, and download Tiramisu & sigpatches
RUN tar zxf /tmp/htmlq.tgz -C /usr/local/bin && \
  chmod u+x /usr/local/bin/htmlq && \
  /usr/local/bin/download_latest_github_release.sh wiiu-env/Tiramisu /root/tiramisu.zip && \
  /usr/local/bin/download_latest_github_release.sh marco-calautti/SigpatchesModuleWiiU /root/01_sigpatches.rpx && \
  /usr/local/bin/download_latest_github_release.sh GaryOderNichts/UFDiine /root/ufdiine.zip && \
  /usr/local/bin/download_latest_github_release.sh GaryOderNichts/Bloopair /root/bloopair.zip && \
  curl --location -s https://github.com/fortheusers/hb-appstore/releases/download/2.2/wiiu-extracttosd.zip -o /root/appstore.zip

# container entrypoint script
ENTRYPOINT ["/usr/local/bin/build_image"]
