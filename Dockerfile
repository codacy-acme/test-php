# Dummy image for a CVE-detection test.
#
# Debian trixie ships PHP 8.4.26 as a distro package (8.4.26-1~deb13u1), the
# latest 8.4 release still affected by CVE-2026-109618 / CVE-2026-109619
# ("php2shell"). Installing it from apt, instead of using the official php:8.4
# image (which compiles PHP from source), makes the interpreter visible to
# Trivy's dpkg analyzer so a container scan can report the CVE.
FROM debian:trixie-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends php8.4-cli=8.4.26-1~deb13u1 \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY test.php .

CMD ["php", "test.php"]
