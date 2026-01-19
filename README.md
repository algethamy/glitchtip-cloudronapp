# GlitchTip for Cloudron

This is a custom package for running [GlitchTip](https://glitchtip.com) on [Cloudron](https://cloudron.io).

GlitchTip is an open-source error tracking system that is compatible with the Sentry SDK. This package allows you to easily host your own instance on Cloudron.

## Features

- **Sentry Compatible**: Works with existing Sentry SDKs.
- **Lightweight**: Uses PostgreSQL and Redis (via Cloudron Addons).
- **Automated Updates**: Includes a GitHub Action to track upstream releases.

## Installation

1. Install the [Cloudron CLI](https://docs.cloudron.io/custom-apps/tutorial/#installing-cloudron-cli).
2. Clone this repository.
3. Build and install:

```bash
cloudron build
cloudron install
```

## Configuration

The app is automatically configured with:
- **Database**: Cloudron PostgreSQL addon.
- **Cache/Queue**: Cloudron Redis addon.
- **Email**: Cloudron Sendmail addon.

## Automatic Updates

This repository is configured with a GitHub Action that checks for new tags on the `glitchtip/glitchtip` Docker Hub repository daily.

If a new version is found:
1. It updates the `version` in `CloudronManifest.json`.
2. It commits the change to this repository.

To deploy the update to your Cloudron instance, you can use the Cloudron Build Service or manually pull and redeploy.

## License

This package is open source. GlitchTip itself is licensed under the MIT License.
