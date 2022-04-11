# KEA

This repo builds a docker image with ISC's kea, which
 * fetches its configuration from MySQL (credentials configured via env vars)
 * expects two servers to run (`kea-0` and `kea-1`) (K8S StatefulSet)