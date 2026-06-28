# AGENTS.md - steamworks4j fork for OxRox

This fork is owned for OxRox co-op. Its main purpose is exposing the modern SteamNetworkingSockets API that the stock steamworks4j release does not provide.

## Current contract

- Current consumed version in `../oxrox-client` is `1.11.0-oxrox2` from the client's in-repo Maven repo at `vendor/maven`.
- OxRox calls these fork-only methods directly: `SteamNetworkingSockets.initRelayNetworkAccess()` and `SteamNetworkingSockets.getConnectionPing(...)`.
- Keep every Maven module on the same version. Use `mvn versions:set -DnewVersion=<version> -DprocessAllModules=true` and then check for explicit dependency versions it missed.
- Do not rely on JitPack for this fork. The native/JNI build and signing profile make it a poor fit.

## Native build flow

The authoritative native build is `.github/workflows/main.yml`:

1. Checkout the public `rlabrecque/SteamworksSDK` mirror at the pinned `SDK` commit.
2. Run the full Maven reactor so inter-module dependencies resolve locally.
3. Run jnigen to regenerate native C++ from Java `/*JNI*/` comments.
4. Build natives on Linux, Windows, and macOS.
5. Open a PR committing rebuilt wrapper/server natives plus `steam_api` redistributables.

The Steam SDK pin must stay recent enough for the wrapper APIs used here. SDK 1.57 is too old for this fork; SDK 1.60 or newer is required by current native calls.

## Consuming from oxrox-client

After the binaries PR is merged, package locally from this repo:

```bash
mvn -pl java-wrapper,loader/gdx -am install -DskipTests -Dgpg.skip=true -DnoLibs
```

Then copy the `steamworks4j` and `steamworks4j-gdx` jar, pom, and sources jar from `~/.m2/repository/com/code-disaster/steamworks4j/...` into `../oxrox-client/vendor/maven/...`, bump the version in `../oxrox-client/core/build.gradle`, and run the OxRox compile/tests.

Use `-DnoLibs` for this packaging step: the workflow commits the `steam_api` redistributables into resources, so a local SDK checkout is not needed just to package the merged binaries.

## When adding bindings

- Add the Java API and native `/*JNI*/` declaration first.
- Let jnigen regenerate the C++ in CI; committed native C++ can be stale before the workflow runs.
- Bump the version for every JNI surface change so Gradle does not reuse a cached jar.
- Rebuild and merge natives for every platform you intend to ship or live-test.
- Verify OxRox still starts without Steam running; client-side Steam calls must stay guarded there because unguarded native calls can crash the JVM.
