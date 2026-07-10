# Choice Design Canon

> Canon rules for player choice count, meaning, modular topology, and runtime conversion.  
> Applies to all future narrative writing and runtime planning unless a later canon update says otherwise.  
> Updated for V0.78 modular narrative architecture.  
> No runtime, JSON, tests, assets, or playable content are changed here.

## 1. Core rule

The default number of player choices is:

```text
3 choices
```

Three choices is the ideal baseline because it keeps a conversation readable, playable, and emotionally focused.

A normal choice node should not offer four or more replies.

---

## 2. What a choice is for

A choice should reveal or change at least one of the following:

- Player's posture;
- Player's action;
- location;
- availability;
- privacy;
- route access;
- boundary;
- knowledge;
- consent;
- obligation;
- consequence;
- relationship frame.

A choice should not exist only to provide three differently worded versions of the same answer.

```text
A meaningful choice changes how the story can continue,
not only how one sentence sounds.
```

---

## 3. Default three-posture pattern

Three choices usually allow enough variation without overloading the player:

1. present / sincere / engaged;
2. playful / evasive / negotiating;
3. distant / cautious / flawed / refusing.

This is a baseline, not a mandatory moral ordering.

The third choice must not always be `bad`.

A refusal, slowdown, or boundary may be the healthiest and most route-consistent choice.

Adult scenes often use:

1. accept / intensify;
2. tease / negotiate / reframe;
3. refuse / slow down / set boundary.

---

## 4. Topology choices

In the modular architecture, some choices change the narrative topology rather than only the reply tone.

A topology choice may change:

- who is physically present;
- whether Marie and Player are together or apart;
- whether Player remains home;
- whether a social or work hub opens;
- which characters are plausibly available;
- whether a scene is public, private, or secret;
- whether an image or message can exist;
- which return consequence becomes due.

Example architecture:

```text
Marie proposes an evening

1. Player joins Marie
   -> social / couple window

2. Marie goes; Player stays home
   -> domestic / private-message window

3. Player chooses a separate responsibility or outing
   -> work / Nico / independent window
```

The exact third topology and exact dialogue belong to the validated source pack.

```text
The UI must not ask:
“Choose Marie / Mathilde / Sandra / Raphaëlle.”

It asks what Player does.
The context determines who becomes available.
```

---

## 5. One decision axis per node

A choice node should normally decide one primary question.

Good:

```text
Does Player join Marie tonight?
```

Good:

```text
Does Player ask before saving the image?
```

Bad:

```text
Does Player desire Pauline,
tell Marie,
leave the couple,
save the photo,
and propose a trio?
```

When several decisions are genuinely distinct, distribute them across:

- a scene;
- a consequence window;
- a later frame conversation.

This keeps choices readable and prevents one click from replacing character progression.

---

## 6. Route emergence rule

Player choices do not directly select routes.

Routes emerge from accumulated decisions involving:

- ordinary access;
- repeated attention;
- respected or broken boundaries;
- promises;
- traces;
- secrecy;
- disclosure;
- consent;
- consequences;
- couple state.

One flirt choice should not activate a route.

One refusal should not always destroy a route.

One adult choice should not create permanent permission.

```text
A route is a pattern the characters recognize,
not a menu item the Player clicks once.
```

---

## 7. Choice consequence rule

Every foreground choice must define at least one concrete consequence.

Possible consequences:

- scene topology changes;
- a character opens or closes access;
- trust changes;
- a question becomes owed;
- a promise is created;
- an invitation is accepted or missed;
- a trace is created;
- an image rule is established;
- a lie or alibi is created;
- Marie acts independently;
- a route advances, pauses, closes, or mutates;
- an aftermath becomes due.

Not every consequence must be immediately visible.

But it must be recorded in the authoring contract.

---

## 8. Choices and character agency

A Player choice does not control another character's feelings or consent.

Bad implication:

```text
Player chooses “Seduce Mathilde”
-> Mathilde is seduced
```

Correct model:

```text
Player sends a direct message
-> Mathilde reads it through current trust, intention, Marie context, and boundary state
-> Mathilde chooses her response
```

The resulting scene must preserve:

- what the character wants;
- what they know;
- what they refuse;
- whether they act independently;
- whether they withdraw.

---

## 9. Choices and Marie centrality

External-route choices must not remove Marie from the story.

A choice involving another character may create:

- Marie consequence due;
- independent Marie action;
- changed return-home scene;
- truth or secrecy pressure;
- social visibility;
- couple repair opportunity;
- couple-frame discussion.

```text
A choice away from Marie
must still exist inside the life Player shares with Marie
until the relationship is explicitly changed.
```

---

## 10. Four or more choices

Four or more choices are allowed only as an exception.

They require a clear design reason, for example:

- major route-defining decision;
- rare consent frame where distinct activities or participants cannot be collapsed safely;
- irreversible or high-cost choice;
- tutorial / debug / validation need;
- exceptional scene where three choices cannot represent the meaningful possibilities.

If a node uses more than three choices, the document or runtime plan must explain:

```text
exception_reason
why three choices would merge distinct consent or consequence states
```

```text
4+ choices require explicit justification.
```

Adult intensity alone is not a justification.

---

## 11. Authoring variants vs runtime choices

Draft documents may list more than three possible variants during writing.

This does not mean all variants should be integrated.

Before runtime integration, authoring variants must be collapsed to three final choices unless the node has an explicit exception.

Example:

```text
Draft variants:
present / joke / flat / delayed

Runtime choices:
present / joke-but-present / distant-or-delayed
```

Context variants are not automatically additional choices.

A scene may select the correct authored variant before presenting the same three-choice structure.

---

## 12. J1 rule

J1 uses three choices per runtime choice node.

If a J1 documentation draft shows four variants, treat them as authoring variants.

Recommended collapse:

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

J1 choices color attention.

They do not lock routes.

---

## 13. Modular-scene rule

Every future scene card should include a choice-count check:

```text
- number of choice nodes;
- choices per node;
- primary decision axis;
- posture or topology represented by each choice;
- state write for each choice;
- route advance / pause / closure;
- consequence due;
- explicit justification for any 4+ node.
```

A scene with no choice may still be valid when it is:

- mandatory consequence;
- short spine transition;
- character-initiated action;
- aftermath;
- echo;
- a result already chosen by an earlier topology decision.

Do not add fake choices merely to make every scene interactive.

---

## 14. NSFW route usage

The three-choice rule applies to NSFW scenes.

For trio, quatuor, NTR/cuckold, sharing, cheating, roleplay, voyeurism, image circulation, or dark routes, choices must distinguish:

- desire;
- consent;
- audience;
- activity;
- saving / forwarding;
- secrecy;
- refusal;
- aftermath.

Do not collapse materially different consent states into one choice for convenience.

Do not create five choices merely to enumerate fantasy positions that could be negotiated across several beats.

---

## 15. Choice anti-patterns

Avoid:

- character-selection menus;
- moral labels instead of real Player messages;
- three synonyms;
- always presenting one obviously correct choice;
- route lock from one early answer;
- choice labels that promise another character's consent;
- one node deciding an entire relationship;
- using four choices because four draft variants exist;
- adult escalation increasing choice count automatically;
- hiding an irreversible choice in an echo;
- offering a choice after the consequence is already unavoidable;
- choices whose consequences are not documented;
- making Player passive while other characters decide everything;
- making every scene interactive when a consequence should simply happen.

---

## 16. Runtime planning rule

Every runtime integration plan must include:

```text
- default max: 3 choices per node;
- list any node with 4+ choices;
- justify each exception;
- identify topology-changing choices;
- map each choice to state writes;
- identify consequence windows;
- collapse authoring variants before JSON integration;
- preserve real Player messages;
- do not expose internal route names as choice labels.
```

---

## 17. Final rule

```text
Three choices by default.

Each choice must make Player do, say, allow, refuse, hide, reveal, join, or leave something meaningful.

The route emerges afterward from what the characters remember.
```
