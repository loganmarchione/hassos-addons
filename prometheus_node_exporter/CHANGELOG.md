# Changelog

## [4.0.0] - 2026-11-22

⚠️ BREAKING CHANGES ⚠️

- Replaced the deprecated `config` folder mapping with `app_config`.
  - This add-on no longer has access to your Home Assistant config folder. Instead, it gets its own config folder, which is included in the add-on's backups.
  - Inside the add-on, this folder is still mounted at `/config`. From other add-ons (e.g., File editor, Samba, or Terminal & SSH), it is at `/app_configs/<hash>_prometheus_node_exporter` (older versions of those add-ons show it as `/addon_configs/...`).
  - If you enabled TLS and your `cert_file`/`cert_key` point to files in your Home Assistant config folder (e.g., `/config/...`), the add-on will fail to start after upgrading. Move your certificates to `/ssl` (recommended) or to the add-on's config folder above, then update `cert_file`/`cert_key`. Certificates already in `/ssl` are not affected.
  - The web config file (`node_exporter_web.yml`) is now created in the add-on's config folder. After upgrading, you can safely delete the old `/homeassistant/prometheus_node_exporter/` folder (in Samba, it's `prometheus_node_exporter` in the `config` share). It only contains the old `node_exporter_web.yml`, which is no longer used and contains the bcrypt hash of your HTTP Basic Auth password.
  - This version requires Home Assistant Supervisor `2026.07.1` or newer, since that is the first version that supports `app_config`. Older Supervisors will skip the mapping, so the add-on's config folder will not be visible to you or included in backups. Check your version under Settings > About, and update the Supervisor before upgrading this add-on.
- Added `breaking_versions`, so Home Assistant won't auto-update to this version. You'll need to update manually after reading this changelog.

## [3.2.0] - 2026-07-27

- Pin GitHub Actions to digests instead of versions
- Upgraded Node Exporter to `1.12.1`
- Upgraded base image to `3.24`

## [3.1.0] - 2026-07-27

- No user-facing changes. Instead, start explicitly tagging releases on GitHub.

## [3.0.0] - 2026-04-19

⚠️ BREAKING CHANGES ⚠️

- Upgraded Node Exporter to `1.11.1`
- Upgraded base image from `ghcr.io/hassio-addons/base/<arch>:19.0.0` to `ghcr.io/home-assistant/base:3.22`
- Migrated app build to Docker BuildKit as per [this page](https://developers.home-assistant.io/blog/2026/04/02/builder-migration)
  - I'm not sure if this will show as an upgrade from `2.0.0` to `3.0.0` in user's Home Assistant instances since the URL to the image is changing

## [2.0.0] - 2025-12-07

⚠️ BREAKING CHANGES ⚠️

- Upgraded base image from `ghcr.io/hassio-addons/base/<arch>:18.2.1` to `19.0.0`, which drops support for `armv7` (since the base image for [19.0.0 drops support](https://github.com/hassio-addons/addon-base/releases/tag/v19.0.0) for `armhf`, `armv7`, and `i386`)

## [1.1.0] - 2025-11-28

- Upgraded Node Exporter to `1.10.2`
- Upgraded base image from `ghcr.io/hassio-addons/base/<arch>:18.1.1` to `18.2.1`
- This will probably be my last release with support for `armv7`, since the base image for [19.0.0 drops support](https://github.com/hassio-addons/addon-base/releases/tag/v19.0.0) for `armhf`, `armv7`, and `i386`

## [1.0.6] - 2025-09-19

- Upgraded base image from `ghcr.io/hassio-addons/base/<arch>:18.0.0` to `18.1.1`

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

I only started making tagged releases with v3.1.0. The version numbers before this were entirely made up, since this was a beta project.
