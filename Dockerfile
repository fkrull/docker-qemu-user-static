FROM ubuntu:18.04 AS binaries

RUN apt-get update && \
    apt-get install -y \
        python3 \
        qemu-user-static

RUN mkdir -p /binaries /formats

COPY scripts/convert-formats.py /convert-formats.py
RUN python3 /convert-formats.py /var/lib/binfmts /formats qemu-
COPY scripts/copy-binaries.py /copy-binaries.py
RUN python3 /copy-binaries.py /formats /usr/bin /binaries

FROM busybox
COPY --from=binaries /binaries/* /usr/bin/
COPY --from=binaries /formats/* /formats/
COPY scripts/qemu-enable.sh /qemu-enable.sh
RUN chmod 0755 /qemu-enable.sh
ENTRYPOINT ["/qemu-enable.sh"]
LABEL maintainer="Felix Krull <f_krull@gmx.de>"
LABEL url="https://github.com/fkrull/docker-qemu-user-static"
