# Choice Design Canon

> Canon rules for player choice count, complexity, and runtime conversion.  
> Applies to all future narrative writing and runtime planning unless a later canon update says otherwise.  
> No runtime, JSON, tests, assets, or playable content are changed here.

## 1. Core rule

The default number of player choices is:

```text
3 choices
```

Three choices is the ideal baseline because it keeps the conversation readable, playable, and emotionally focused.

A normal choice node should not offer four or more replies.

---

## 2. Why three choices

Three choices usually allow enough variation without overloading the player:

1. one present / sincere / engaged response;
2. one playful / evasive / ironic response;
3. one distant / cautious / flawed response.

This gives meaningful tone control while keeping the scene easy to read.

---

## 3. Four or more choices

Four or more choices are allowed only as an exception.

They require a clear design reason, for example:

- major route-defining decision;
- rare adult route branch where multiple fantasies or boundaries must be separated;
- irreversible or high-cost choice;
- tutorial / debug / validation need;
- exceptional scene where three choices cannot represent the meaningful possibilities.

If a node uses more than three choices, the document or runtime plan must explain why.

```text
4+ choices require explicit justification.
```

---

## 4. Authoring variants vs runtime choices

Draft documents may sometimes list more than three possible variants during writing.

This does not mean all variants should be integrated.

Before runtime integration, authoring variants must be collapsed to three final choices unless the node has an explicit exception.

Example:

```text
Draft variants: present / joke / flat / delayed
Runtime choices: present / joke-but-present / distant-or-delayed
```

---

## 5. J1 rule

J1 should use three choices per choice node in runtime.

If a J1 documentation draft shows four variants, treat them as authoring variants, not final runtime count.

For J1, the recommended collapse is:

```text
M1:
1. present
2. joking but present
3. flat / delayed

S1:
1. safe warmth
2. precise observation
3. playful or cautious

M2:
1. active return
2. awkward but sincere
3. joke / distant
```

Hermes should not integrate four-choice J1 nodes unless explicitly instructed in a later runtime plan.

---

## 6. NSFW route usage

The three-choice rule also applies to NSFW scenes.

Adult escalation should not automatically increase choice count.

For adult scenes, three choices can usually map to:

1. accept / intensify;
2. tease / negotiate / reframe;
3. refuse / slow down / set boundary.

For trio, quatuor, NTR/cuckold, sharing, cheating, or darker route scenes, more than three choices may be justified only if distinct consent, boundary, or route consequences cannot fit into three options.

---

## 7. Runtime planning rule

Every future runtime integration plan should include a choice-count check:

```text
- default max: 3 choices per node;
- list any node with 4+ choices;
- justify each 4+ exception;
- collapse authoring variants before JSON integration.
```

---

## 8. Final rule

```text
Three choices by default.
More only when the scene truly needs it, and only with explicit justification.
```
