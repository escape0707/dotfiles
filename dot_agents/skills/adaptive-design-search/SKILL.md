---
name: adaptive-design-search
description: Use when a visual or interaction design goal is under-specified, the user can judge rendered alternatives more reliably than specify design parameters, and the agent should explore a latent design space through diverse candidate batches, human preference feedback, and iterative search.
---

# Adaptive Design Search

Explore under-specified design spaces by combining LLM priors, quality-diverse candidate generation, human preference feedback, and iterative black-box search.

The user judges rendered outcomes. The agent owns search-space construction, candidate generation, preference inference, diversity preservation, and convergence.

## Core Invariants

1. **Humans judge phenotypes; the agent manages genotypes.**
   - A phenotype is the rendered design the user sees.
   - A genotype is the structured design rationale, parameters, component choices, layout decisions, and ancestry that produced it.

2. Treat the task as **Preference-Based Black-Box Optimization**, not as direct parameter tuning.
   The true objective is latent human preference and cannot be assumed to have an explicit formula, scalar score, or usable gradient.

3. Use an **LLM Prior** and **Warm Start**.
   Do not begin with uniform random search across every technically possible design. Use learned design knowledge, project context, existing brand evidence, implementation constraints, and prior user choices to propose promising design families and search hotspots.

4. Preserve **Quality-Diversity**, not just predicted quality.
   A candidate batch should contain meaningfully different high-quality directions. Avoid mode collapse into many cosmetically different versions of one idea.

5. Prefer **multi-candidate batch selection** over forced pairwise comparison.
   For visual work, default to roughly 12–20 concurrently viewable candidates when the medium permits it. Let the user rapidly identify favorites, acceptable candidates, rejected candidates, and interesting subparts. Do not require evaluation of every candidate.

6. Treat preference feedback as a **partial order**, not a total ranking.
   Feedback such as:
   - `A07` is the clear favorite;
   - `A03`, `A09`, and `A14` are also good;
   - `A02` and `A12` are strongly disliked;
   - the header from `A05` is good but the rest is not;
   is sufficient. Do not force exact numeric ratings or a complete ranking.

7. Human visual inspection is the default fast-loop evaluator.
   Do not insert AI vision, screenshot analysis, or automated aesthetic critique into every generation unless the user requests it or a targeted diagnostic requires it.

8. Search dimensions are hypotheses, not a fixed schema.
   The agent may invent, split, merge, retire, rename, or reinterpret dimensions as feedback reveals what actually controls preference.

9. Separate exploration code from production code.
   Experimental implementations may be disposable and permissive. Production implementations must be deliberately promoted and normalized rather than blindly copied from experiments.

10. Search algorithms are a toolbox, not a rigid implementation requirement.
    Use their established concepts to guide reasoning. Do not implement a formal optimizer, statistical model, neural network, or reinforcement-learning system merely because the terminology is applicable.

## When to Use

Use this skill when:

- the user knows what looks good more reliably than they can specify why;
- the important design dimensions are partially unknown;
- several credible visual directions exist;
- rapid visual exploration is cheaper than prolonged verbal specification;
- an LLM can generate executable candidates faster than a human can manually design them;
- the task benefits from iterative divergence and convergence;
- visual design needs to be discovered rather than merely implemented.

Typical tasks include:

- page visual direction;
- component appearance;
- layout exploration;
- design-system direction;
- brand expression in UI;
- section composition;
- interaction presentation;
- redesigning an existing interface when the desired destination is not yet specified.

Do not use this skill merely for:

- implementing an already settled design;
- a deterministic CSS correction;
- reproducing an exact reference;
- routine responsive fixes;
- mechanical refactoring;
- architectural or semantic decisions whose alternatives are already explicit and hard to reverse.

Use `interactive-decision-review` for material architectural, semantic, contract, ownership, or hard-to-reverse decisions that require explicit deliberation rather than design-space search.

## Algorithmic Model

Use the following classical concepts as compact reasoning primitives.

### Black-Box Optimization

Assume the mapping

`design genotype -> rendered phenotype -> human preference`

is an expensive, noisy, subjective black-box objective.

Do not pretend that a precise analytical fitness function exists.

### Preference Learning

Infer latent preferences from incomplete human judgments.

Prefer coarse set-level signals:

- elite / favorite;
- like / keep;
- neutral / unjudged;
- reject / avoid;
- component-specific preference;
- family-level preference.

Derive pairwise constraints internally when useful, but do not require the user to perform repeated pairwise comparisons.

Silence about a candidate means **unjudged**, not rejected.

### Interactive Evolutionary Computation

Use the human as the external evaluator while the agent performs iterative search.

A generation may use:

- **selection**: preserve successful candidates or families;
- **crossover / recombination**: combine meaningful traits from different successful candidates;
- **mutation**: vary selected traits;
- **elitism**: preserve important winners unchanged;
- **diversity injection**: deliberately introduce candidates outside the current basin.

Perform recombination at meaningful design boundaries such as layout, typography, hierarchy, image treatment, component anatomy, or surface treatment. Do not treat arbitrary CSS declarations as biologically meaningful genes.

### Quality-Diversity Optimization

Optimize for both:

- design quality;
- meaningful behavioral or stylistic diversity.

Maintain multiple promising design families instead of converging immediately on one family.

A generation that contains twelve near-duplicates is a failed generation even if all twelve are individually competent.

### MAP-Elites-Inspired Archive

When useful, maintain a conceptual archive of the strongest known candidate in distinct regions of the design space.

The dimensions may be provisional, for example:

- sparse ↔ dense;
- neutral ↔ expressive;
- product-led ↔ editorial;
- flat ↔ layered;
- restrained ↔ playful.

Do not force every experiment into a fixed grid. The archive is a diversity-preservation model, not a UI requirement.

### Active Learning

Human attention is expensive.

Choose some candidates because evaluating them would provide high **Information Gain**, not merely because they have the highest predicted quality.

When an important preference is uncertain, construct strong contrasting candidates that make the distinction easy for the user to judge.

Do not waste a generation on candidates that answer questions already settled by prior feedback.

### Bayesian-Optimization-Inspired Acquisition

Maintain a lightweight belief about:

- promising regions;
- rejected regions;
- uncertain regions;
- underexplored dimensions.

Balance expected design quality against uncertainty when deciding what to generate next.

A formal probabilistic surrogate model is not required. The LLM may maintain this belief semantically unless stronger machinery is justified.

### Exploration–Exploitation Trade-off

Every generation should deliberately balance:

- **exploitation**: refine known successful regions;
- **nearby exploration**: test uncertain variations around them;
- **diversity / wildcards**: probe materially different regions that protect against premature convergence.

Adapt the balance to evidence. Do not use fixed percentages as a universal rule.

### Simulated-Annealing-Inspired Temperature

Use **temperature** as a control over search scope and willingness to depart from current winners.

High temperature permits changes to major structural choices.

Medium temperature explores component anatomy, hierarchy, proportions, typography, surfaces, and composition.

Low temperature focuses on spacing, scale, weight, radius, rhythm, and other local refinements.

As confidence rises, lower temperature.

Increasing temperature again is valid when the search appears trapped in a local optimum or when the user rejects the converged family.

### Multi-Objective Optimization

Do not optimize aesthetics alone.

Relevant objectives may include:

- visual appeal;
- brand fit;
- commercial clarity;
- usability;
- accessibility;
- responsive robustness;
- merchant or operator editability;
- performance;
- implementation complexity;
- maintainability.

Preserve meaningful **Pareto-optimal** trade-offs instead of collapsing every objective into one arbitrary score.

## Build the Initial Search Model

Before generating candidates:

1. Establish the design target, context, constraints, and known non-goals.
2. Inspect existing implementation, design tokens, brand assets, references, production constraints, and previous user choices when available.
3. Separate:
   - fixed constraints;
   - known preferences;
   - assumed preferences;
   - unresolved preferences;
   - dimensions worth exploring.
4. Use the LLM prior to propose several credible **design families** or search hotspots.
5. Identify dimensions whose exploration would create meaningful visual differences.
6. Identify dimensions that should remain fixed so the batch does not confound every variable at once.
7. Choose an appropriate temperature and abstraction level.

Do not require the user to design the search dimensions unless they want to.

Explain the proposed search model briefly when its assumptions materially affect the experiment. Do not burden the user with internal genotype detail that is not needed to judge outcomes.

## Generate a Candidate Population

Generate a population large enough for rapid visual scanning.

For browser-based visual exploration, prefer roughly 12–20 candidates by default when they can be viewed together comfortably. Adjust the count to the scale of the artifact and the user's requested pace.

A useful generation normally contains several roles:

- preserved elites;
- refinements of successful candidates;
- recombinations of successful traits;
- targeted probes designed for information gain;
- candidates from other quality-diverse families;
- occasional high-temperature wildcards.

Candidates must be visibly distinguishable at normal human inspection speed.

Do not generate a full Cartesian product of all dimensions. Choose combinations that maximize useful coverage and information.

Assign every candidate a stable identifier such as:

`G03-A07`

where the identifier survives discussion and feedback.

Optional seeds: generated mockup images may seed a high-temperature generation. Treat them as inspiration: reproduce them as live code candidates; never ship or evaluate the images themselves.

## Represent Candidate DNA

Track enough genotype information to explain and reproduce each candidate.

Useful fields include:

- candidate ID;
- generation;
- design family;
- parent candidates, when applicable;
- relevant dimension values;
- structural choices;
- fixed constraints;
- notable mutations;
- implementation reference.

Dimensions may be categorical, ordinal, continuous, structural, or semantic.

Do not overformalize candidate DNA merely to create metadata. Record what materially supports search, reproduction, comparison, and preference inference.

Keep the generation archive (DNA, feedback, rejected families) in the project's agent-notes location, not in the product repository.

The human does not need to inspect candidate DNA unless it helps discussion.

## Render the Design Lab

For web and UI work, prefer executable browser-native candidates using the project's natural frontend medium, commonly HTML, CSS, JavaScript, or the real component stack.

Create an aggregate Design Lab view where the user can inspect the population directly.

Prefer:

- one browser page containing the current candidate population;
- real DOM and real CSS rather than screenshots;
- stable visible candidate IDs;
- consistent content fixtures when content is not itself under exploration;
- browser zoom and responsive viewport inspection;
- direct interaction when interaction matters;
- optional filtering, enlargement, hiding, or comparison controls only when they materially improve review.

Do not build a miniature Figma.

Do not require Playwright screenshots or contact sheets merely for human browsing when an aggregate live page is simpler.

Do not make AI visual inspection a prerequisite for iteration.

## Collect Human Preference Feedback

Accept natural, incomplete feedback.

Strong examples include:

- `A07 is clearly best.`
- `A03, A07, and A14 are the ones I would keep.`
- `Reject A02, A06, and A12.`
- `A05 has the best header, but A07 is better overall.`
- `These are all too similar; explore further away.`
- `Keep the structure, but reduce the SaaS feeling.`
- `I cannot choose between these; show me a more informative next batch.`

Do not force:

- binary A/B comparisons;
- exact scores;
- ranking every candidate;
- feedback on candidates the user has no opinion about.

When several humans review the same generation, preserve distinct preferences when they conflict. Do not silently average them into a fictional consensus.

## Update the Search Belief

After feedback:

1. Identify traits shared by strong favorites.
2. Identify traits concentrated in rejected candidates.
3. Distinguish strong evidence from weak evidence.
4. Look for interactions between dimensions rather than assuming independent effects.
5. Update which design families remain promising.
6. Identify unresolved or newly discovered dimensions.
7. Retire dimensions that no longer explain useful variation.
8. Split broad dimensions when feedback reveals a more precise distinction.
9. Introduce new dimensions when the old coordinate system fails to explain preference.
10. Preserve uncertainty instead of inventing certainty.

Maintain a lightweight semantic preference model such as:

- strongly supported;
- weakly supported;
- rejected;
- unresolved;
- unexplored.

Treat this as a working hypothesis, not as ground truth.

## Generate the Next Generation

Use accumulated preference evidence to produce the next population.

Preserve important elites unless the user asks to discard them.

Refine promising families while protecting quality-diversity.

Use targeted mutation and recombination to test hypotheses.

Include information-gain candidates when important uncertainties remain.

Retain occasional meaningful exploration outside the current winner family until the user has clearly committed to convergence.

Avoid premature mode collapse.

Do not interpret one successful generation as proof that all unexplored alternatives are inferior.

## Change Search Scale Deliberately

Use three broad search scales.

### Macro Search

Explore design families and major structural choices:

- page composition;
- navigation model;
- hierarchy;
- design language;
- typography category;
- image strategy;
- density;
- overall visual character.

Use high temperature.

### Meso Search

Explore a selected family:

- component anatomy;
- section composition;
- type scale;
- card treatment;
- surface hierarchy;
- image proportions;
- spacing rhythm.

Use medium temperature.

### Micro Search

Refine an accepted direction:

- spacing;
- radius;
- line height;
- font weight;
- button size;
- alignment;
- local proportions;
- subtle color relationships.

Use low temperature.

When the user prefers, hand micro search to the user in browser DevTools. Capture the changed computed values and encode them into tokens or code; do not ask the user to transcribe numbers.

Do not mutate macro structure during micro refinement without evidence that the current basin is wrong.

## Converge and Promote

Convergence is appropriate when:

- the same design family remains favored across generations;
- important preference dimensions are sufficiently understood;
- new generations provide little information gain;
- remaining differences are implementation-level refinements;
- the user explicitly chooses a direction.

Once a candidate or family is selected:

1. extract the principles that made it successful;
2. normalize arbitrary experimental values into the production design-token system;
3. rebuild or clean the implementation according to production conventions;
4. validate accessibility, responsiveness, performance, and maintainability;
   4a. record the chosen design as a target contract and protect it with rendering-engine checks (geometry, computed styles, contrast, target size), not screenshot comparison;
5. move component-level refinement into the real component environment;
6. move integration-level refinement into the real application or product environment.

For web projects this may mean moving from:

`Design Lab -> Storybook/component environment -> real application integration`

or the project's equivalent.

**Promote the design; do not blindly promote the experimental code.**

Experimental code may contain duplication, magic numbers, temporary fixtures, or candidate-specific hacks that are acceptable during search but unacceptable in production.

## Raster Media

For image-generated media such as logos, put many small numbered candidates in each generated image (single-candidate images came out too complex and too similar). Keep numbering stable across batches.

## Interaction With `interactive-decision-review`

This skill owns search when:

- alternatives are not yet known;
- important dimensions are latent;
- human preference is discovered through examples;
- multiple generations are useful.

Use `interactive-decision-review` when exploration exposes a material explicit decision involving:

- architecture;
- semantics;
- ownership;
- contracts;
- public interfaces;
- hard-to-reverse implementation boundaries;
- scope with lasting consequences.

A design search may narrow an unknown space into a small number of explicit alternatives, after which decision review becomes the better mode.

Do not turn every visual preference into a formal decision-review gate.

## Fast Loop

When the user wants rapid iteration:

1. keep explanations short;
2. generate the next population;
3. render it in the aggregate Design Lab;
4. let the user visually scan it;
5. accept terse feedback by candidate ID;
6. infer preference changes from candidate DNA;
7. immediately generate the next informative population.

The fast loop is:

`LLM prior -> candidate population -> browser phenotype -> human selection -> preference inference -> next population`

AI vision is not part of the fast loop by default.

## Failure Modes

Avoid these patterns:

- uniform-random initial search despite strong prior knowledge;
- exhaustive Cartesian-product generation;
- repeated forced pairwise comparisons;
- requiring scalar scores for subjective preference;
- interpreting unjudged candidates as rejected;
- generating many near-duplicates;
- collapsing prematurely onto the first acceptable family;
- letting fixed search dimensions prevent discovery of better dimensions;
- changing too many unrelated dimensions without a reason;
- using AI vision in every generation when human inspection is faster;
- replacing a live aggregate Design Lab with unnecessary screenshot pipelines;
- optimizing aesthetics while ignoring implementation or product objectives;
- implementing formal Bayesian optimization, reinforcement learning, neural training, or other machinery before the task requires it;
- editing production code freely during high-temperature exploration;
- copying experimental code directly into production;
- treating algorithm names as procedures that must be followed literally.

## Completion

At completion, report:

- the selected design family or candidate;
- the strongest inferred preferences;
- meaningful rejected directions;
- unresolved preferences that still matter;
- production constraints exposed by the search;
- what was promoted into the production design system;
- what experimental material remains disposable.

Do not manufacture a single universal design preference profile from one narrow experiment. Preferences are contextual and may differ across products, brands, page types, or future tasks.
