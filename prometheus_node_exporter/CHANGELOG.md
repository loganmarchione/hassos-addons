# Changelog

## [1.0.5] - 2025-07-01

- Upgraded Node Exporter to `1.9.1`
- Upgraded base image from `ghcr.io/hassio-addons/base/<arch>:17.2.1` to `18.0.0`

## [1.0.4] - 2025-03-02

- Upgraded Node Exporter to `1.9.0`
- Upgraded base image from `ghcr.io/hassio-addons/base/<arch>:17.1.0` to `17.2.1`

## [1.0.3] - 2025-01-20

- Upgraded base image from `ghcr.io/hassio-addons/base/<arch>:16.3.5` to `17.1.0`

## [1.0.2] - 2024-11-10

- Upgraded Node Exporter to `1.8.2`
- Upgraded base image from `ghcr.io/hassio-addons/base/<arch>:16.3.0` to `16.3.5`

## [1.0.1] - 2024-09-11

- Upgraded base image from `ghcr.io/hassio-addons/base/<arch>:16.1.2` to `16.3.0`

## [1.0.0] - 2024-07-01

⚠️ BREAKING CHANGES ⚠️

- Upgraded Node Exporter to `1.8.1`
- Upgraded base image from `ghcr.io/hassio-addons/base/<arch>:15.0.8` to `16.1.2`
- Removes the default username/password
- Now requires a plaintext password instead of a bcrypt string (the container will bcrypt the password for you)
  - If you're upgrading from `0.9.1` or any earlier version, you will **NEED** to go to the "Configuration" tab and enter the plaintext version of your password (if you leave the bcrypt hash in the password field, the container will try to hash your already-hashed password)

## [0.9.1] - 2024-05-14

- Upgraded base image from `ghcr.io/hassio-addons/base/<arch>:15.0.4` to `15.0.8`
- Added [CONTRIBUTING.md](https://github.com/loganmarchione/hassos-addons/blob/main/prometheus_node_exporter/CONTRIBUTING.md)

## [0.9.0] - 2024-05-13

- Upgraded Node Exporter to `1.8.0` thanks to [@b-reich](https://github.com/b-reich) in https://github.com/loganmarchione/hassos-addons/pull/49

## [0.8.2] - 2024-01-16

- Upgraded base image from `ghcr.io/hassio-addons/base/<arch>:15.0.1` to `15.0.4`

## [0.8.1] - 2024-01-11

- Published pre-built image to GHCR thanks to [@wozz](https://github.com/wozz) in https://github.com/loganmarchione/hassos-addons/pull/47

## [0.8.0] - 2023-12-13

- Upgraded Node Exporter to `1.7.0`
- Upgraded base image from `ghcr.io/hassio-addons/base/<arch>:14.1.0` to `15.0.1`

## [0.7.0] - 2023-08-18

- Upgraded Node Exporter to `1.6.1`
- Upgraded base image from `ghcr.io/hassio-addons/base/<arch>:14.0.0` to `14.1.0`

## [0.6.0] - 2023-05-18

- Upgraded base image from `ghcr.io/hassio-addons/base/<arch>:13.1.3` to `14.0.0`
- Added support for Prometheus Node Exporter command-line arguments thanks to [@falzm](https://github.com/falzm) in https://github.com/loganmarchione/hassos-addons/pull/34

## [0.5.0] - 2023-03-16

- Upgraded Node Exporter to `1.5.0`
- Upgraded base image from `ghcr.io/hassio-addons/base/<arch>:12.2.4` to `13.1.3`

## [0.4.0] - 2022-10-20

- Upgraded base image from `ghcr.io/hassio-addons/base/<arch>:12.2.0` to `12.2.4`

## [0.3.0] - 2022-09-26

- Upgraded Node Exporter to `1.4.0`

## [0.2.1] - 2022-08-05

- Added more logging around TLS

## [0.2.0] - 2022-08-05

- Added TLS support thanks to [@Quedale](https://github.com/Quedale) in https://github.com/loganmarchione/hassos-addons/pull/7
- Mapped Node Exporter config files from `/etc` to `/config`, to allow editing via the [File editor add-on](https://github.com/home-assistant/addons/tree/master/configurator)

## [0.1.1] - 2022-08-05

- Added configuration option descriptions

## [0.1.0] - 2022-07-11

- Upgraded base image from `ghcr.io/hassio-addons/base/<arch>:11.1.2` to `12.2.0` (Alpine Linux 3.16), but also disabled the s6 init system because of [this issue](https://github.com/home-assistant/supervisor/issues/3642)
- Added CI from [here](https://github.com/hassio-addons/addon-glances/blob/main/.github/workflows/ci.yaml)

## [0.0.7] - 2022-06-07

- Upgraded base image from `ghcr.io/hassio-addons/base/<arch>:11.1.0` to `11.1.2` (this is the last without s6 v3)

## [0.0.6] - 2022-05-17

- Fixed S6-overlay v3 problems
- Added build.json file to better control base image versions
- Small formatting fixes and readability changes

## [0.0.5] - 2022-02-13

- Added HTTP Basic Auth

## [0.0.4] - 2021-12-29

- Upgraded Node Exporter to `1.3.1`

## [0.0.3] - 2021-12-12

- Built for `armv7` (Raspberry Pi 3B) thanks to [@jaredacox](https://github.com/jaredacox) in https://github.com/loganmarchione/hassos-addons/pull/1

## [0.0.2] - 2021-11-16

- Built for `aarch64` (Raspberry Pi 4B)

## [0.0.1] - 2021-11-03

- Initial release

## Note

I'm not making numbered GitHub releases/tags, since this is still a beta project. These release numbers are purely made up.
