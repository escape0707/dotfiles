# Advisory Consultation

Use a capable advisor for a difficult problem, unfamiliar concepts, independent
analysis, or a user-led side discussion during another agent's task. A worker,
Main, or the user can originate the question. Use existing consultation authority;
do not ask again for every question already covered by it.

## Context and Routing

Give the advisor the question, relevant original evidence, current approach,
settled decisions, uncertainty, and requested reasoning scope. Distinguish
explanation or recommendations from authorization to implement. Allow direct
user discussion when needed, and choose the transport accordingly.

Task-relevant consultation returns only to root Main:

```text
Main → worker → advisory question → advisor → Main → affected workers if needed
```

For a formal consultation, Main establishes a Main–advisor channel and round.
A worker can prepare the question and context, but does not become the advisor's
steering authority or result recipient. Notify Main of a worker-originated
request through its existing channel. Main handles the relay setup without
requiring another user approval when consultation is already authorized.

The advisor publishes its original findings, evidence, uncertainties, and any
task-relevant user decisions to Main. Include exact branch, round, and commit
references when notifying Main. Do not route the result through the originating
worker's paraphrase or directly instruct other workers to change course.

Main reads the original report, reconciles it with the overall task, and decides
what to relay to which owners. Decisions made by the user remain authorized
within their actual scope; ask the user about conflicts or newly exposed
consequences, not for duplicate approval. Main can relay the answer back to the
worker that raised the question.

## Explanation and Closure

A pure explanation can end locally with no implementation change and no report
to Main. Do not require a formal result-producing round for that conversation.
Use the available conversation context and permitted references; if transferring
task context between independent agents, the normal transport rules still apply.

If the conversation produces task-relevant findings or steering, report those
to Main through the permitted coordination mechanism. Keep the original advisor
report accessible so a weaker worker is not the sole interpreter.

Close a formal consultation according to its bounded outcome and report any
remaining question. Further task assignments come from Main; do not silently
turn an advisor into an implementation worker. Apply the normal channel cleanup
suggestion when its overall task is finished.
