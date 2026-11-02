# UDO OTP API — reference notes & key check

Provider: **Unique Digital Outreach (UDO)**
Official developer portal: <https://developers.uniquedigitaloutreach.com>
OTP reference page: <https://developers.uniquedigitaloutreach.com/generate-and-verify>
Auth page: <https://developers.uniquedigitaloutreach.com/authentication>
Errors: <https://developers.uniquedigitaloutreach.com/errors>
Webhooks: <https://developers.uniquedigitaloutreach.com/webhooks>

> The marketing page (`uniquedigitaloutreach.in/otp-authentication/`) only links
> to the portal; it contains no endpoint details. `…/api-documentation/` is a 404.
> The portal never prints the host for the documented paths — it is
> `https://api.uniquedigitaloutreach.com` (verified by live requests).

---

## 1. Authentication

Every request is JSON and carries the API key in an `apikey` header:

```
Content-Type: application/json
apikey: <UDO_OTP_API_KEY>
```

- Keys are per account and are found in the dashboard under **Settings →
  API / Developer → API Key**.
- The **username** (`igurus_consultanc_services`) is only the dashboard login.
  It is *not* sent to the API — authentication is the `apikey` header alone.
- The docs advise keeping the key server-side and rotating it if exposed.

---

## 2. Generate and validate OTP

### 2.1 Generate OTP

```
POST https://api.uniquedigitaloutreach.com/v1/verify
Content-Type: application/json
apikey: <key>
```

| Field      | Type   | Required | Description                                                           |
|------------|--------|----------|-----------------------------------------------------------------------|
| `configId` | string | yes      | Verification-configuration ID — decides template, channel and expiry. |
| `to`       | string | yes      | Recipient MSISDN, country code + number, e.g. `919876543210`.         |

```bash
curl -X POST https://api.uniquedigitaloutreach.com/v1/verify \
  -H 'apikey: <key>' \
  -H 'Content-Type: application/json' \
  -d '{"configId":"<configId>","to":"919876543210"}'
```

`200 OK`

```json
{
  "data": "33888968-XXXX-XXXX-XXXX-3010e0069668",
  "error": null,
  "message": "OTP Generated Successfully!"
}
```

`data` is the **verifyId**; it is required by the validate call.

> The `configId` shown in the portal (`a73cd9xe-XXXX-XXXX-XXXX-7f731bcf4y64`)
> is a placeholder — it is rejected with `"Invalid Config ID"`. The real value
> must be copied from the dashboard.

### 2.2 Verify OTP

```
POST https://api.uniquedigitaloutreach.com/v1/verify/validate
Content-Type: application/json
apikey: <key>
```

| Field      | Type   | Required | Description                         |
|------------|--------|----------|-------------------------------------|
| `verifyId` | string | yes      | The value returned by Generate OTP. |
| `otp`      | string | yes      | The code the user entered.          |

```bash
curl -X POST https://api.uniquedigitaloutreach.com/v1/verify/validate \
  -H 'apikey: <key>' \
  -H 'Content-Type: application/json' \
  -d '{"verifyId":"33888968-XXXX-XXXX-XXXX-3010e0069668","otp":"123456"}'
```

`200 OK`

```json
{
  "data": "33888968-XXXX-XXXX-XXXX-3010e0069668",
  "error": null,
  "message": "OTP Verified Successfully!"
}
```

OTPs are single-use and expire after the window configured on `configId`.

---

## 3. SMS endpoints (same key)

Base path `/v1/sms`, body `{sender, to, text, type}` where `type` is
`TRANS` (transactional), `PROMO` (promotional) or `OTP`.

**`sender` is required on every `/v1/sms` call** (verified: omitting it returns
`{"error":true,"message":"Please Select Sender ID"}`), and `text` is required
too (`"Invalid massage Text"`). It must be an originator/alphanumeric ID —
for India, a DLT-registered header. `templateId` is optional unless the route
is a DLT template route.

`/v1/verify` is the opposite: it takes **only** `configId` + `to`. The sender,
template, channel and expiry all live inside the verification config, so an OTP
sent that way needs no sender at all.

| Purpose                 | Notes                                                    |
|-------------------------|----------------------------------------------------------|
| Single message          | `{sender, to, text, type}`                               |
| OTP SMS                 | Same shape with `type: "OTP"`                            |
| Bulk SMS                | Multiple recipients; `totalCount` in the response        |
| Unicode SMS             | `unicode` flag in the body                               |
| Flash SMS               | `flash: 1`                                               |
| Template SMS            | Adds `templateId`                                        |
| Template with variables | `{sender, to, templateId, custom: [...], type: "TRANS"}` |
| Short URL               | `shortenUrlData: {shortenUrl: true, targetUrl: [...]}`   |

Success:

```json
{
  "id": "58d63c02-…",
  "data": [{"recipient": "919876543210", "messageId": "58d63c02-…:1"}],
  "totalCount": 1,
  "message": "Message Sent Successfully!",
  "error": null
}
```

---

## 4. Errors

| HTTP | Body                                                            | Meaning                          |
|------|-----------------------------------------------------------------|----------------------------------|
| 200  | `{"error": null, "message": "... Successfully!"}`               | Success                          |
| 400  | `{"error": true, "message": "Enter a valid apikey in header"}`  | No `apikey` header               |
| 400  | `{"error": true, "message": "API Key is Invalid or Expired!"}`  | Key rejected                     |
| 400  | `{"error": true, "message": "Invalid Config ID"}`               | Unknown/missing `configId`        |
| 400  | `{"error": true, "message": "invalid Verify ID"}`               | Unknown/missing `verifyId`        |
| 400  | `{"error": true, "message": "Invalid or empty request body"}`   | Empty/invalid JSON                |
| 400  | `{"error": true, "message": "No Valid Numbers Found..!!"}`      | Recipient failed validation       |
| 400  | `{"error": true, "message": "Please Select Sender ID"}`         | `/v1/sms` without `sender`        |
| 400  | `{"error": true, "message": "Invalid massage Text"}`            | `/v1/sms` without `text` (sic)    |
| 500  | `{"error": true, "message": "..."}`                             | Provider-side failure             |

The docs list error types `error` (provider fault) and `invalid_request`
(caller fault). Always branch on the HTTP status **and** `error`.

Note the validation order: `/v1/verify` checks `configId` before the key, so a
bogus key can also return `"Invalid Config ID"`. Use `/v1/sms` with a
deliberately invalid recipient to test key validity (see §6).

---

## 5. Webhooks

Configured in the dashboard, not via API:

- **SMS DLR:** Message app → Utility Manager → DLR Push Configuration
- **WhatsApp:** Whatsapp → Wa Utility → Webhook

Events: messages received, messages sent (template/session), status
(sent / delivered / read).

---

## 6. Key check — result: ✅ VALID

Tested live on 2026-10-25 against `https://api.uniquedigitaloutreach.com`.
No message was sent: every request used an invalid recipient or empty body so
the provider stopped at validation.

| Request                                            | HTTP | Response                                                    |
|----------------------------------------------------|------|-------------------------------------------------------------|
| `POST /v1/sms` — real key, `to: "000"`             | 400  | `{"error":true,"message":"No Valid Numbers Found..!!"}`     |
| `POST /v1/sms` — bogus key, same body              | 400  | `{"error":true,"message":"API Key is Invalid or Expired!"}` |
| `POST /v1/verify` — real key, `configId: "0000…0"` | 400  | `{"error":true,"message":"Invalid Config ID"}`              |
| `POST /v1/verify` — bogus key, same body           | 400  | `{"error":true,"message":"API Key is Invalid or Expired!"}` |
| `POST /v1/verify/validate` — real key, `{}`        | 400  | `{"error":true,"message":"invalid Verify ID"}`              |
| `POST /v1/verify` — no `apikey` header             | 400  | `{"error":true,"message":"Enter a valid apikey in header"}` |
| `POST /v1/sms` — real key, `sender` omitted        | 400  | `{"error":true,"message":"Please Select Sender ID"}`        |
| `POST /v1/sms` — real key, `sender` but no `text`  | 400  | `{"error":true,"message":"Invalid massage Text"}`           |

The real key passed authentication (the provider moved on to payload
validation), while the control key was rejected. **The key works.**

Re-run the check any time (the helper lives in the backend repo, where the UDO
credentials belong — never in the Flutter app, whose `.env` ships inside the
built binary):

```bash
cd ../saath_khata_backend
chmod +x tools/check-otp-key.sh
./tools/check-otp-key.sh            # reads the backend .env
```

### What is still missing

A real **`configId`**. Without it the provider cannot generate an OTP
(`"Invalid Config ID"`). Copy it from the UDO dashboard (the OTP verification
configuration, or Developer → API Key area) into `UDO_OTP_CONFIG_ID` in the
**backend** `.env` (the app never talks to UDO directly).
A DLT-registered sender (`UDO_OTP_SENDER_ID`) is only needed if OTPs go out
over `/v1/sms`.

---

## 7. Where the credentials live

`UDO_OTP_*` variables belong to the **backend** (`saath_khata_backend/.env`,
git-ignored) — never to this Flutter app. The app's `.env` is bundled into the
APK/IPA, so any key stored there ships to every user. The app only calls
`POST /auth/otp/send` and `POST /auth/otp/verify`; the provider call is made by
the backend adapter (`src/infrastructure/sms/udoOtp.provider.ts`).

| Variable            | Purpose                                         |
|---------------------|-------------------------------------------------|
| `UDO_OTP_BASE_URL`  | `https://api.uniquedigitaloutreach.com`         |
| `UDO_OTP_API_KEY`   | `apikey` header value                           |
| `UDO_OTP_USERNAME`  | Dashboard login (informational)                 |
| `UDO_OTP_CONFIG_ID` | Verification config — **required** to send OTPs |
| `UDO_OTP_SENDER_ID` | DLT sender — required by `/v1/sms` only         |

The backend reads them through `src/infrastructure/sms/otpConfig.ts` and builds
the provider in `otpProvider.factory.ts`. Keep `OTP_PROVIDER=dummy` locally and
set `OTP_PROVIDER=udo` only in an environment where the values above exist — a
missing `configId` makes every send fail with `503 OTP_PROVIDER_ERROR`, and
`OTP_PROVIDER=dummy` against `NODE_ENV=production` refuses to boot.

### Do I need `UDO_OTP_SENDER_ID`?

**No — not for OTPs.** Only fill it if you also call `/v1/sms` directly.

| Flow | API | Needs sender? |
|------|-----|---------------|
| Generate + validate OTP | `POST /v1/verify`, `POST /v1/verify/validate` | ❌ sender/template/channel/expiry come from `configId` |
| Send SMS (incl. `type: "OTP"`) | `POST /v1/sms` | ✅ required, else `"Please Select Sender ID"` |

So leave `UDO_OTP_SENDER_ID` empty and the OTP flow still works end to end. In
India the sender must be a DLT-registered header, and DLT template rules apply
to `TRANS`/`PROMO` traffic.

## 8. Security caveat

`.env` is listed under `flutter.assets` in `pubspec.yaml`, so anything in it is
packaged inside the APK/IPA and can be extracted. That is why no provider
credentials are stored there: the former `UdoOtpService` /
`udo_otp_config.dart` direct client was removed, and OTP traffic now goes only
through the backend (`/auth/otp/send`, `/auth/otp/verify` — see
`lib/core/network/api_endpoints.dart`). Only publishable keys such as
`LOCATIONIQ_API_KEY` belong in the app `.env`.
