# Architecture overview

Phase 0 is the monorepo scaffold and the `core` package. Authentication, organizations, and the app shell are later phases. `app/` is an empty placeholder and is not a workspace package.

## Package map

```text
app shell (later)
  -> feature packages (later)
    -> package:core/core.dart
         -> domain (Failure, Result)
         -> network (Dio)
         -> secure token storage
         -> localization and design system
```

`core` is the shared kernel. Feature packages may depend on it. It must not depend on them. The app shell, when it exists, is the only composition root: it wires environment defines, token storage, and the organization id into `createDio`.

## Network

`createDio` registers interceptors in this order:

1. `X-Request-Id` — a new UUID on every request.
2. `X-Organization-Id` — omitted when the current organization id is null or empty.
3. `Authorization: Bearer` — omitted when no access token is stored. Skipped on the single retry after a refresh, so the refreshed token is not overwritten.
4. Refresh on HTTP 401 — calls `TokenRefresher`, retries the original request once, then rejects with `UnauthorizedFailure`.
5. Idempotent GET retry — one extra attempt for connection failures and HTTP 502, 503, and 504.
6. Logging — non-production only. The `Authorization` header is redacted. Bodies are not logged.

Dio runs `onError` in reverse registration order. The GET retry therefore sees an error before the 401 refresher. It does not retry HTTP 401, so the refresh interceptor still owns that status.

`mapDioException` is the single mapping from `DioException` to `Failure`. If `DioException.error` is already a `Failure`, that value is returned unchanged. That is how the refresh interceptor publishes `UnauthorizedFailure`.

## Retry policy

Only idempotent GET requests are retried automatically, and only once, and only for connection failures or HTTP 502, 503, and 504.

POST, PUT, PATCH, DELETE, and auth requests are not retried. They are not idempotent: a second POST can create a duplicate record, and a second login or token refresh can rotate credentials twice. The 401 path is a separate, explicit refresh-and-retry-once flow, not part of the GET retry policy.

## Token refresh

`TokenRefresher.refreshAccessToken` is the seam for the later auth package. The interceptor behavior is implemented now:

1. A request fails with HTTP 401.
2. The interceptor calls `TokenRefresher` once.
3. On a new access token, it retries the original request once.
4. On a null token, a thrown error, or a second 401, it rejects with `UnauthorizedFailure` so the app can force logout.

The HTTP call that exchanges a refresh token is intentionally not implemented in `core`.

## Failures and copy

`Failure` carries a `FailureCode`, optional `technicalDetails` for logs, and `retryable`. User-visible strings live in ARB files and `failureMessage`. Domain types do not contain English copy.

## Design system

`AppTheme.light()` is the theme to use now. `AppTheme.dark()` is built from the same tokens so a later phase can switch brightness without restructuring widgets. Layout uses `EdgeInsetsDirectional`, `AlignmentDirectional`, and `TextAlign.start` so Arabic RTL works without left/right insets.

Breakpoints: compact below 600, medium below 1024, expanded at 1024 and above.
