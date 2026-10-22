# Dummy image for a CVE-detection test.
#
# Installs PHP 8.4.26 as a Debian trixie distro package (8.4.26-1~deb13u1), the
# last 8.4 release affected by CVE-2026-109618 / CVE-2026-109619 ("php2shell").
# Installing it from apt, instead of using the official php:8.4 image (which
# compiles PHP from source), makes the interpreter visible to Trivy's dpkg
# analyzer so `codacy-cli container-scan` can report the CVE.
#
# Debian replaced the package with 8.4.27-1~deb13u1 on 2026-10-21, so the
# current archive no longer carries 8.4.26. The apt sources below point at a
# snapshot.debian.org timestamp from before the fix, which keeps this image
# reproducibly vulnerable.
FROM debian:trixie-slim

ARG SNAPSHOT=20261021T000000Z

RUN printf '%s\n' \
      'Types: deb' \
      "URIs: http://snapshot.debian.org/archive/debian/${SNAPSHOT}" \
      'Suites: trixie' \
      'Components: main' \
      'Check-Valid-Until: no' \
      'Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg' \
      '' \
      'Types: deb' \
      "URIs: http://snapshot.debian.org/archive/debian-security/${SNAPSHOT}" \
      'Suites: trixie-security' \
      'Components: main' \
      'Check-Valid-Until: no' \
      'Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg' \
      > /etc/apt/sources.list.d/debian.sources \
 && apt-get -o Acquire::Retries=3 update \
 && apt-get -o Acquire::Retries=3 install -y --no-install-recommends php8.4-cli=8.4.26-1~deb13u1 \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY test.php .

CMD ["php", "test.php"]
