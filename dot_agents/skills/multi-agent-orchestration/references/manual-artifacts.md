# Manual Artifacts

Use Git for suitable text, compact data, scripts, source references, and reports.
A private repository alone is not a reason to prepare a ZIP or ask for uploads.

Manual transfer is for necessary artifacts that are sensitive, large, binary,
awkward for Git, or otherwise unsuitable for durable Git history. It is not an
alternative coordination protocol when GitHub access is unavailable.

Never commit passwords, private keys, tokens, or credentials. Manual transfer
also requires permission to disclose the content to its destination. If data
must stay in a restricted environment, leave it there and return only permitted
evidence. Repository privacy does not remove that boundary.

## Prepare and Deliver

When a round requires a manual return, prepare at most one self-contained ZIP
containing the response and all required manually transferred artifacts. Include
a manifest only when it adds useful identification or integrity information.
A useful filename is `round-0001-return-<slug>.zip`.

Prepare the package before publishing the terminal response. The relay can name
the package, purpose, and checksum when those details are safe to publish.
Record a ZIP checksum outside the ZIP after creation; do not require the response
inside it to contain the ZIP's own checksum.

Publishing `response.md` makes the round terminal even while manual delivery is
pending. Main tracks that delivery in the conversation and does not rerun the
round. Manual artifacts accompany the relay; they do not replace its durable
prompt, response, and status history.
