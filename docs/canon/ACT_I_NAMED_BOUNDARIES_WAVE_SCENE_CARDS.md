# Act I Named Boundaries Wave Scene Cards — V0.93

> Reconciled visual-first scene contracts for the V0.93 wave.
> Companion to `ACT_I_NAMED_BOUNDARIES_WAVE_SOURCE_PACK.md`.
> Documentation only: no runtime, JSON, tests, or final assets are created here.

## 1. Global card rules

Every card must preserve:

```text
3 choices maximum at a normal node
one primary decision axis
real Player messages
adult character agency
clear visual reward
clear route opportunity
clear risk
character-specific voice and fantasy
```

Every playable day must unlock at least three female-focused gallery images.

Every route card must define:

```text
visual set
visual intensity
public/private/secret/shared status
origin and audience
what choice unlocks or withholds
what future pornographic fantasy is promised
```

A route is not advanced by an internal flag alone.

The player must see a visible difference in the gallery or in the access promised by the route.

---

# 2. Marie black-dress real-plan card

## Identity

```text
scene_id: marie_black_dress_real_plan_01
working_title: La robe noire
primary_function: visual reconquest + concrete topology
primary_relationship: Player / Marie
principal_character: Marie
```

## Visual set

```text
marie_tuesday_black_dress_mirror_01
marie_tuesday_black_dress_turn_02
marie_tuesday_black_dress_close_03
```

Intensity:

```text
V1 -> V2
```

Visual content:

1. full-body mirror image, black dress and heels or ankle boots;
2. turned pose emphasizing back, waist, legs, and gold earrings;
3. closer image with lipstick, neckline, and direct gaze.

Origin:

```text
Marie takes the images herself while choosing Wednesday's look.
```

Audience:

```text
Player only at send time
```

Saving rule:

```text
normal gallery unlock
no forwarding permission inferred
```

## Concrete trigger

Marie needs to decide the final look before Wednesday.

She also needs a real answer about Player's place in the evening.

Opening rhythm:

```text
photo
short joke
second photo
clear desire for reaction
third photo
real plan question
```

Do not front-load a relationship speech.

## M4 choice node

### M4A — Join and claim the movement

Player message:

```text
garde la noire
je viens t'aider à fermer et je repars avec toi
```

Writes:

```text
social_hub_topology_joined
marie_wednesday_shared_presence = SCHEDULED
marie_reconquest_public_join_seed
```

Visual consequence:

- possible fourth selected-look image;
- Thursday Marie route payoff eligible if the obligation is paid.

Fantasy signal:

```text
join Marie's visible life
reclaim the woman others can see
```

### M4B — Make her visible and take responsibility

Player message:

```text
porte-la
je gère la table et je vous rejoins à 20 h 45
```

Writes:

```text
social_hub_topology_precise_arrival
marie_wednesday_arrival = SCHEDULED
marie_public_visibility_accepted
```

Visual consequence:

- Marie remains publicly visible without Player beside her;
- a sharper reminder image can unlock before the deadline;
- jealousy and social-risk futures become readable.

Fantasy signal:

```text
let others see her
still prove Player can act
```

### M4C — Claim the private continuation

Player message:

```text
porte ce que tu veux demain
jeudi je veux la version que tu ne mets pas pour les autres
je réserve
```

Writes:

```text
social_hub_topology_marie_independent
marie_thursday_couple_time = SCHEDULED
marie_private_reconquest_seed
```

Visual consequence:

- the most private continuation remains locked until Thursday payment;
- Marie lingerie or undressing set becomes eligible.

Fantasy signal:

```text
private couple access
first erotic reconquest image
```

## Agency and failure

Marie may:

- wear the dress without Player;
- enjoy the social evening;
- refuse a late vague amendment;
- keep or withdraw the private continuation;
- choose a different image than Player expected.

## Anti-patterns

Reject:

- `join / join later / do not join` as three flat variants;
- all three answers producing the same photos;
- Marie asking whether Player still loves her;
- dress photos treated as neutral wardrobe documentation;
- Player automatically owning the private image because he is her partner.

---

# 3. Mathilde last-days deliberate-set card

## Identity

```text
scene_id: mathilde_last_days_deliberate_set_01
working_title: Les derniers jours ici
primary_function: domestic visual intention + taboo risk
primary_relationship: Player / Mathilde
principal_character: Mathilde
```

## Eligibility

Preferred:

```text
first_repetition.charged_access_owner = mathilde
```

Possible fallback:

```text
Mathilde historical foreground = RESOLVED
and no stronger route consequence is due
```

Required world change:

```text
Mathilde receives a credible repair date.
Her stay at Marie and Player's apartment now has an end.
```

This gives urgency without inventing a crisis.

## Visual set

```text
mathilde_wednesday_homewear_mirror_01
mathilde_wednesday_outfit_choice_02
mathilde_wednesday_deliberate_pose_03
```

Intensity:

```text
V2 -> V3
```

Image content:

1. fitted homewear or mini-shorts and crop top in the mirror;
2. tight going-out dress or fitted jeans/crop-top option;
3. deliberate pose clearly directed toward Player's gaze.

Origin:

```text
Mathilde takes the images while deciding what to wear before the social evening or another outing.
```

Audience:

```text
image 1 may be defensible/ordinary
image 2 sent to Player for opinion
image 3 private and conditional
```

## Opening rhythm

Use:

- repair-date message;
- one irritated joke;
- first image;
- practical outfit question;
- second image;
- Player response;
- Mathilde admits there is a third.

Do not start with `we need to define our boundary`.

## MT2 choices

### MT2A — Encourage deliberate provocation

Player message:

```text
la troisième n'est pas une question de tenue
et tu sais très bien l'effet qu'elle me fait
```

Writes:

```text
mathilde_deliberate_visual_access
mathilde_domestic_taboo_risk
primary_visual_route = mathilde
```

Visual consequence:

- image 3 unlocks private;
- possible fourth V3 image;
- Thursday underwear set eligible.

Future fantasy:

```text
lingerie in Marie's apartment
hidden domestic route
discovery or confession
future sex in shared space
```

### MT2B — Create costly distance

Player message:

```text
oui, elle me fait de l'effet
alors tant que tu es ici on arrête les photos privées et les tête-à-tête
```

Writes:

```text
mathilde_attraction_named
mathilde_costly_distance
```

Visual consequence:

- third private image remains locked;
- route stays charged but does not advance;
- the approaching end of the stay makes the distance meaningful.

### MT2C — Minimize

Player message:

```text
tu donnes trop de sens à trois photos de tenue
```

Writes:

```text
mathilde_feels_gaze_denied
mathilde_access_cooled
```

Visual consequence:

- third image withheld;
- Mathilde may use a colder public version elsewhere;
- no punishment seduction.

## Distinct voice

Mathilde uses:

- speed;
- irritation at the repair process;
- embarrassment;
- bad faith;
- at most one legal joke.

She does not speak like Sandra's hesitant confession or Pauline's audience management.

---

# 4. Sandra one-more-chosen-image card

## Identity

```text
scene_id: sandra_one_more_chosen_image_01
working_title: Celle que je n'envoie pas
primary_function: chosen private exposure + repetition decision
primary_relationship: Player / Sandra
principal_character: Sandra
```

## Eligibility

```text
Sandra Monday foreground = RESOLVED
charged owner is empty
Sandra is the selected historical consequence
no pressure or route closure
```

## Visual set

```text
sandra_wednesday_fitted_outfit_01
sandra_wednesday_mirror_hesitation_02
sandra_wednesday_private_extra_03
```

Intensity:

```text
V1 -> V3
```

Image content:

1. fitted blouse or dress, elegant and protected;
2. mirror image with more body and visible hesitation;
3. extra private version with stronger neckline, legs, robe, or intimate framing.

Origin:

```text
Sandra is choosing an outfit for a real lunch, family visit, or evening.
```

Audience:

```text
image 1 sent safely
image 2 sent after hesitation
image 3 exists but is conditional
```

## Opening rhythm

Sandra begins with:

- a café or end-of-post detail;
- a line about needing an opinion she should ask someone else;
- first image;
- minimization;
- second image;
- admission that there is another.

## S3 choices

### S3A — Ask for a real meeting and the extra image

Player message:

```text
garde la tenue
jeudi midi, même café, vraie date
et envoie-moi celle que tu hésites à envoyer
```

Writes:

```text
sandra_next_meeting_concrete
sandra_private_exposure_access
primary_visual_route = sandra
```

Visual consequence:

- Sandra independently decides whether to unlock image 3;
- Thursday satin/lingerie set becomes eligible;
- emotional-affair risk becomes explicit.

### S3B — Keep rare contact without demand

Player message:

```text
garde l'autre pour toi ce soir
j'aime mieux quand tu choisis sans que je réclame
```

Writes:

```text
sandra_contact_kept_rare
sandra_choice_respected
```

Visual consequence:

- image 2 is the guaranteed ceiling;
- Sandra may later surprise Player, but no reward is promised.

### S3C — Reduce the moment

Player message:

```text
la première suffit
on ne va pas transformer une tenue en événement
```

Writes:

```text
sandra_reads_reduction
sandra_access_cooled
```

Visual consequence:

- image 3 remains locked;
- Sandra withdraws rather than arguing.

## Distinct voice

Sandra uses:

- a concrete trace;
- minimization;
- small message splits;
- warmth that embarrasses her;
- one soft closure.

She does not use Mathilde's legal humor or Pauline's language of versions and recipients.

---

# 5. L'Annexe visual social-hub card

## Identity

```text
scene_id: lannexe_visual_social_hub_01
working_title: La table jusqu'à 20 h 45
primary_function: social visibility + obligation payment + Pauline opportunity
primary_relationship: Player / Marie
principal_characters: Marie, Pauline
supporting: Bastien, Nico
```

## Concrete incident

```text
Nico can hold the good table only until 20 h 45.
A late booking is waiting.
Pauline counted one seat too few.
Bastien has already ordered a shared plate.
```

This incident makes Player's timing visibly change the evening.

## Guaranteed visual set

```text
marie_wednesday_lannexe_social_01
pauline_wednesday_green_dress_02
marie_pauline_wednesday_duo_03
```

Intensity:

```text
V2 social
```

Image functions:

- Marie: sexy, alive, socially visible;
- Pauline: controlled elegance and fitted green dress;
- duo: comparison, friendship, and route fantasy;
- Bastien remains real in the story but need not dominate the erotic composition.

Origin:

```text
legitimate social photos taken at L'Annexe
```

Base audience:

```text
group / normal social sharing
```

## Topology outcomes

### Joined

Player helps Marie close La Verrière and enters with her.

### Precise arrival paid

Player saves or reaches the table at the promised time.

### Precise arrival failed

Nico releases the table or changes seating; Marie orders and continues without Player.

### Marie independent

Player receives no minute-by-minute report. Thursday remains due.

## Pauline P2 choice

### P2A — Keep public

```text
la verte est la meilleure
garde celle-là pour le groupe
```

- Pauline legitimate cycle completes;
- no private route.

### P2B — Ask for the alternate crop

```text
tu as cadré la robe trois fois
il y en a forcément une que tu n'as pas mise dans le groupe
```

- Pauline may independently send a private alternate;
- possible secondary risk seed;
- Thursday Pauline set eligible.

### P2C — Refuse the compartment

```text
si tu en as une autre, garde-la
je ne veux pas être le deuxième destinataire caché
```

- private route refused in this context;
- Pauline remains attractive and socially legitimate.

## Pauline private visual family

Conditional images:

```text
pauline_thursday_public_green_dress_01
pauline_thursday_private_crop_02
pauline_thursday_double_address_03
```

The private crop is a chosen cheating seed between Pauline and Player.

It is not Bastien's consent.

---

# 6. Nico image-selection card

## Identity

```text
scene_id: nico_what_do_you_want_to_see_01
working_title: Les trois plus dangereuses
primary_function: male desire + image recontextualization
primary_relationship: Player / Nico
principal_character: Nico
```

## Eligibility

- social set exists;
- Nico friendship access active;
- no magical private archive;
- no severe prohibited capture.

## Opening trigger

Nico has seen the legitimate public images.

He says which frame he looked at twice.

He admits attraction rather than pretending to be neutral.

## N2 choices

### N2A — Make Nico name his desire

```text
arrête de parler de mon regard
laquelle tu veux vraiment voir autrement ?
```

Writes:

```text
nico_desire_named
nico_rivalry_or_shared_gaze_visible
```

No image unlock is automatic.

### N2B — Accept the sexualized selection

```text
choisis les trois plus dangereuses
pas celles que le groupe choisirait
```

Writes:

```text
nico_private_erotic_selection
secondary_risk_seed = nico_recontextualization
```

Gallery selection:

```text
nico_selection_marie_social_01
nico_selection_pauline_social_02
nico_selection_route_woman_03
```

The underlying images may be legitimate.

The erotic recontextualization may not be authorized.

The player must see the risk marker.

### N2C — Refuse women as currency

```text
tu peux me dire que tu les désires
tu ne les transformes pas en monnaie entre nous
```

Writes:

```text
nico_gaze_boundary_set
```

No private selection unlock.

## Distinct voice

Nico uses:

- table and room observations;
- blunt body language;
- direct attraction;
- silence after the joke;
- his own envy.

He does not become a therapist, porn narrator, or consent manual.

---

# 7. Thursday dominant visual-payoff card

## Identity

```text
scene_id: named_boundaries_visual_payoff_01
primary_function: route-specific visual advancement
foreground_cost: 1 dominant route family
```

Exactly one main set dominates the run.

A secondary risk seed may coexist, but must not replace the primary payoff.

## Marie set

```text
marie_thursday_private_dress_01
marie_thursday_lingerie_tease_02
marie_thursday_reconquest_private_03
```

Eligibility:

- Marie action paid or strongly amended;
- Player chose visible or private reconquest.

Intensity:

```text
V2 -> V4 teaser
```

## Mathilde set

```text
mathilde_thursday_private_homewear_01
mathilde_thursday_underwear_choice_02
mathilde_thursday_for_your_eyes_03
```

Eligibility:

- MT2A;
- no cooling or boundary break.

Intensity:

```text
V3 -> V4 teaser
```

## Sandra set

```text
sandra_thursday_evening_dress_01
sandra_thursday_satin_private_02
sandra_thursday_chosen_exposure_03
```

Eligibility:

- S3A or strong chosen exposure;
- no pressure route.

Intensity:

```text
V2 -> V4 teaser
```

## Pauline set

```text
pauline_thursday_public_green_dress_01
pauline_thursday_private_crop_02
pauline_thursday_double_address_03
```

Eligibility:

- P2B;
- Pauline independently chooses the private alternate.

Intensity:

```text
V2 -> V3
```

## Nico risk track

Uses selected legitimate images with a new private erotic meaning.

It is a route/risk overlay, not a replacement for female-focused images.

## Raphaëlle teaser

```text
raphaelle_thursday_office_full_01
raphaelle_thursday_workshop_fit_02
raphaelle_thursday_partial_costume_03
```

May be an additional teaser when production scope permits.

It must not dilute the chosen main payoff.

---

# 8. Marie obligation-return card

## Identity

```text
scene_id: marie_named_boundary_return_01
primary_function: pay, amend, or fail Player's earlier action
primary_relationship: Player / Marie
```

The visual payoff does not erase the obligation.

Terminal outcomes:

```text
PAID
AMENDED
FAILED
```

Paid:

- active-reconnection evidence;
- Marie private payoff may unlock;
- shared time happens offline.

Amended:

- must contain a new concrete action;
- cannot become infinite postponement.

Failed:

- Marie continues her evening;
- drift evidence recorded;
- another route payoff may still exist;
- couple consequence remains real.

No grand breakup speech is required.

---

# 9. Internal closure card

## Identity

```text
scene_id: named_boundaries_wave_close_01
primary_function: guarded silent completion
```

No:

- conversation;
- Player choice;
- notification;
- visible system summary;
- route selection UI.

Closure requires:

```text
M4 obligation terminal
carry-over route terminal or absent
social hub terminal
Nico scene terminal or deferred
Thursday visual payoff resolved
no pending unowned obligation
```

Recommended completion fact:

```text
named_boundaries_wave_complete
```

The close is idempotent.

---

# 10. Cross-card product matrix

| Card | Guaranteed photos | Conditional photos | Main fantasy | Strong risk |
|---|---:|---:|---|---|
| Marie Tuesday | 3 | 1 | reconquest / visibility | jealousy / private claim |
| Mathilde W15 | 3 when selected | 1 | domestic taboo | hidden route / discovery |
| Sandra W15 | 3 when selected | 0–1 | chosen private exposure | emotional affair |
| Social hub | 3 | Pauline alternate | Marie/Pauline visibility | double address |
| Nico | 0 new women required | 3-image erotic selection | shared gaze | unauthorized recontextualization |
| Thursday payoff | 3 | Raphaëlle teaser | selected route fantasy | route-specific |

Minimum per day:

```text
Tuesday = 3
Wednesday = 3, often 6
Thursday = 3
```

---

# 11. Choice-pattern audit

The final JSON must not reduce the cards to the same structure.

```text
Marie = choose how her visibility and private continuation are handled
Mathilde = encourage provocation / create costly distance / deny
Sandra = ask for repetition and extra exposure / preserve rarity / reduce
Pauline = keep public / ask private alternate / refuse compartment
Nico = force his desire into the open / accept sexualized selection / forbid currency
```

The route identities must be visible before clicking.

---

# 12. Final card rule

```text
A strong adult-game scene does not hide the opportunity.

It shows the woman.
It reveals what kind of access may open.
It lets Player choose the fantasy or the risk.
It records a visibly different gallery consequence.
```
