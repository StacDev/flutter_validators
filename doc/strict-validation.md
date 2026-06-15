# Strict Validation

Version 1.3 preserves 1.2 defaults. Strict checks are opt-in so an upgrade does
not unexpectedly reject stored data.

| Validator | Compatibility default | Strict/configurable option |
|---|---|---|
| Date | `DateTime.tryParse` | `isISO8601Date` |
| JWT | segment structure | decoded JSON objects, unsigned-token rule |
| Base32 | alphabet and padding shape | legal encoded lengths |
| Credit card | length and Luhn | known network shape, repeated digits |
| URL | HTTP/HTTPS authority | protocols, TLD, localhost, underscores |
| Email | historical ASCII regex | Unicode, TLD, IP domain, max length |
| FQDN | historical labels/TLD | trailing dot, underscores, total length |
| UUID | versions 1, 3, 4, 5 | select a version |

Strict JWT checks do not verify cryptographic signatures. Credit-card checks do
not contact an issuer. Use authentication and payment providers for those jobs.
