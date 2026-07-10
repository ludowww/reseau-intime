# Act I Opening Windows Source Pack — V0.79

> Canon line and content source for the first concrete post-J1 narrative slice.  
> Implements the opening of Act I — `La place qu'on laisse` — through smartphone-first windows, exact three-choice nodes, authored traces, return anchors, conditions, and fallbacks.  
> Documentation only: no runtime, JSON, Godot scene, script, test, asset, or playable content is changed by this file.

## 1. Status and authority

This source pack is current canon for the **opening band of Act I**.

Read it after:

```text
docs/canon/NARRATIVE_CANON_STATUS.md
docs/canon/CHOICE_DESIGN_CANON.md
docs/canon/MODULAR_NARRATIVE_ARC_BLUEPRINT.md
docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md
```

Then read the relevant full character canon files.

This source pack supersedes old J2 opening assumptions where they conflict, including:

- a fixed `J2` day order;
- Player being forced to remain physically outside the home until a later day;
- Mathilde entering through the old canapé selfie;
- a mandatory badge photo for Raphaëlle;
- Pauline and Nico being excluded from all early ordinary access by day-number rule;
- four fixed visual contents because an old day plan required them;
- route progression attached to one calendar day.

It does not invalidate reusable technical support from old runtime.

It does not yet authorize runtime integration.

---

## 2. Narrative scope

The pack covers the opening band from the first post-J1 practical change through the first La Verrière event and its immediate follow-up.

Expected diegetic duration:

```text
roughly 3–5 in-game days
```

The exact calendar labels remain open.

The referenced `petit événement jeudi` from J1 becomes the first `MOVEMENT_OFFERED` anchor.

The pack includes:

- Mathilde's water-damage emergency;
- the couple making room for her;
- Mathilde's direct ordinary access;
- Raphaëlle's ordinary work access;
- Sandra's restrained continuity echo;
- Marie's first topology-changing invitation;
- three concrete topology branches;
- a mandatory return to Marie / shared life;
- Pauline's legitimate public-image relay;
- Nico's ordinary saved-seat / friendship follow-up;
- a household breather confirming the new routine.

The pack does not include:

- a full J2 script label;
- explicit adult content;
- a hidden affair;
- an active photo pact;
- Pauline's private alternate crop;
- Nico requesting a domestic image;
- Raphaëlle's private creative account;
- Mathilde deliberately selecting an outfit for Player;
- a new Sandra photo;
- a group chat as a required visible thread;
- any route stage beyond `R1 Ordinary Access` plus soft non-runtime tension signals.

---

## 3. Opening goals

The opening band must accomplish all of the following.

### 3.1 Household change

Mathilde becomes a real temporary resident because a water leak makes her bedroom and part of her bathroom unusable.

The stay is expected to last around ten to fifteen days.

Player's choice concerns **how he participates in making room**, not whether Marie abandons her cousin during a practical emergency.

### 3.2 Marie remains desirable and active

Marie:

- handles a real family problem;
- consults Player rather than treating him as furniture;
- remains funny and practical;
- creates the La Verrière movement;
- goes whether Player joins or not;
- receives a mandatory return / consequence scene.

### 3.3 Ordinary access before tension

By the end of the opening band:

- Mathilde has direct ordinary access through the household;
- Raphaëlle has direct ordinary access through work;
- Pauline has direct ordinary access through a legitimate public image relay;
- Nico has direct ordinary access through friendship and the social event;
- Sandra remains present without escalating;
- Marie remains the central relationship.

### 3.4 First topology choice

Player chooses what he does around Marie's event:

```text
join Marie early
stay at the shared home
finish a real work obligation and promise to join later
```

The choice does not display character names as route buttons.

### 3.5 No premature route lock

The opening band may create:

- presence tendency;
- missed-opportunity tendency;
- ordinary access;
- a public trace;
- a promise kept or missed;
- a soft observation signal.

It may not create:

- an affair;
- consent to adult play;
- a permanent route;
- a hard couple crisis;
- a secret-load count;
- a private image breach.

---

## 4. Smartphone-first delivery rule

`Réseau Intime` is delivered primarily through:

- Messenger-style threads;
- notifications;
- social posts;
- photographs;
- screenshots;
- short cross-thread echoes.

Offline activity may be implied through messages sent:

- just before;
- during practical separation in the same location;
- from another room;
- while one person is working across the venue;
- immediately after;
- on the way home.

The source pack does not require prose cutscenes.

When two characters are physically together, smartphone messages need a credible reason:

- one is across the room;
- one is in another room;
- the message contains a task, photo, link, or private aside;
- the conversation occurs before or after the offline moment.

Do not have characters text full emotional speeches while standing face to face without reason.

---

## 5. Relative opening order

The opening band uses relative windows, not day numbers.

```text
O0 — J1 carry-over
O1 — Marie / make room
O2 — Mathilde arrival
O3 — Work and restrained continuity
O4 — Marie offers movement
O5 — Topology branch
O6 — Return to Marie
O7 — Pauline public trace
O8 — Nico follow-up + household breather
```

### Fixed vs variable

Fixed foreground windows:

- O1;
- O2;
- O3;
- O4;
- O6;
- O7;
- O8 unless it mutates into a shorter variant because Nico was already foregrounded naturally.

Variable foreground window:

- O5, selected by the topology choice.

Conditional echo:

- Sandra continuity in O3 or the next compatible private-message window.

Spacing may expand if ordinary breathers are needed.

The order of O7 and O8 may invert when context requires it, but both must occur before the opening band closes.

---

# 6. O0 — J1 carry-over

## 6.1 Canon state

Start from:

```text
couple mode = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE
all optional routes = R0 or soft trace seed only
```

J1 soft signals may be read:

- `player_present_with_marie`;
- `player_joking_but_present`;
- `player_flat_or_delayed`;
- `sandra_safe_warmth`;
- `sandra_precise_observation`;
- `sandra_playful_light`;
- `sandra_distant_cautious`.

These names are conceptual documentation labels, not final runtime variable names.

## 6.2 Optional Mathilde J1 seed compatibility

If the optional J1 line about Mathilde visiting the installation was shown, O1 may add:

```text
Marie : Elle devait juste passer voir l'installation demain.
Marie : Apparemment elle va aussi tester notre capacité d'hébergement.
```

If the seed was not shown, omit those lines.

No other content changes.

---

# 7. O1 — Marie / make room

## 7.1 Scene identity

```text
scene_id: marie_mathilde_emergency_make_room_01
window: PRIVATE_MESSAGE / PLAYER_WORK_OR_TRANSIT
primary relationship: Player / Marie
function: S1 household change + Player participation
route stage: couple baseline; Mathilde R0
intensity: ordinary
```

## 7.2 Entry conditions

Required:

- J1 complete;
- Mathilde stay not yet active;
- couple not in explicit crisis;
- Marie can receive Mathilde's emergency call.

Excluded:

- old canapé-selfie continuity treated as canon;
- Mathilde already sleeping regularly at the apartment;
- Player already refusing the stay in an earlier approved scene.

## 7.3 Canon line source

```text
Marie : Petit changement de programme.
Marie : Mathilde vient de m'appeler.
Marie : Dégât des eaux chez elle.
Marie : Sa chambre et une partie de la salle de bain ont décidé de devenir une piscine municipale.

Player : sérieux ?

Marie : Très.
Marie : L'appartement du dessus a fui toute la nuit.
Marie : Elle peut sauver son ordinateur et probablement six paires de chaussures, donc l'essentiel va bien.
Marie : Je lui ai dit qu'on pouvait l'héberger quelques jours.
Marie : Enfin...
Marie : Je lui ai dit qu'on allait vérifier ensemble.
```

If the optional J1 seed was used, insert the compatibility lines from O0 here.

## 7.4 Choice M0 — How Player makes room

### M0A — Proactive participation

```text
Player : oui
Player : je vide le bureau ce soir et je récupère des draps

Marie : Merci.
Marie : C'est exactement le genre de oui qui fait bouger des objets.
Marie : Je prends les serviettes et je lui confirme.
```

Conceptual writes:

- Player presence tendency up;
- household-preparation obligation accepted and paid proactively;
- Marie feels consulted and joined;
- Mathilde arrival variant uses active-help tone.

### M0B — Playful but present

```text
Player : oui
Player : mais elle a droit à une valise
Player : pas à une annexion complète du bureau

Marie : Je vais lui transmettre la clause.
Marie : Elle va la contester.
Marie : Tu peux quand même libérer l'étagère du bas ?

Player : accord provisoire

Marie : Très juridique.
Marie : Elle va adorer.
```

Conceptual writes:

- Player playful-present tendency;
- household-preparation obligation accepted;
- Marie feels joined through humor;
- Mathilde arrival variant may reference the `annexion` joke once.

### M0C — Passive assent

```text
Player : si tu penses que c'est le mieux

Marie : Je pense qu'elle a besoin d'un lit.
Marie : Je vais lui dire oui.
Marie : Essaie juste de ne pas avoir l'air surpris quand elle arrive avec trois fois trop d'affaires.
```

Conceptual writes:

- Player passive-assent tendency;
- Marie carries the decision and most preparation;
- no couple crisis;
- arrival variant makes Player less central;
- soft `parallel_drift_candidate` signal only.

## 7.5 Exit state

- Mathilde's stay is confirmed;
- expected duration: ten to fifteen days;
- arrival is due in the next compatible evening window;
- Player's participation quality is known;
- Marie remains warm but reads the difference between action and assent.

---

# 8. O2 — Mathilde arrival

## 8.1 Scene identity

```text
scene_id: mathilde_arrival_too_much_luggage_01
window: COUPLE_HOME / PRIVATE_MESSAGE / TRACE_OR_IMAGE
primary relationship: Player / Mathilde
secondary relationship: Player / Marie
function: Mathilde R1 Ordinary Access + household topology activation
intensity: ordinary
```

## 8.2 Delivery context

Player is not yet in the spare room when Mathilde arrives.

Depending on M0:

- he may be returning with sheets;
- finishing work;
- buying one practical item;
- or simply elsewhere in the apartment / building.

Marie sends the arrival visual.

Mathilde then opens or reactivates her direct thread with Player.

## 8.3 Visual V1 — `mathilde_arrival_room`

Origin:

- taken by Marie;
- sent to Player;
- ordinary private couple/family context.

Composition:

- open spare-room door;
- overfilled suitcase;
- garment bag;
- legal tote bag;
- two or three visible pairs of shoes, not six arranged for display;
- Mathilde partly in frame, dressed in ordinary arrival clothes such as fitted jeans and a crop top or fitted knit;
- emphasis on clutter and temporary occupation, not a body crop;
- no bed, couch, lingerie, or erotic pose.

Intended audience:

- Player only, as household update.

Consent:

- Mathilde sees Marie taking the picture and allows the practical photo;
- no forwarding permission is implied.

## 8.4 Canon line source — Marie thread

```text
Marie : Le bureau n'est plus un bureau.
Marie : Preuve jointe.

[VISUAL: mathilde_arrival_room]

Marie : Elle dit que c'est pour dix jours.
Marie : Son nombre de chaussures n'est pas cohérent avec cette déclaration.
```

## 8.5 Canon line source — Mathilde thread

```text
Mathilde : Je tiens à préciser que la photo est à charge.
Mathilde : Il y a un angle qui multiplie les sacs.
Mathilde : Et probablement les chaussures.

Player : probablement

Mathilde : Promis je prends très peu de place.
Mathilde : Cette phrase est déjà contredite par la pièce à conviction.
Mathilde : Super arrivée.
```

## 8.6 Choice MT0 — How Player receives her presence

### MT0A — Practical welcome

```text
Player : j'arrive dans vingt minutes
Player : laisse le reste, je porterai les cartons et le bureau

Mathilde : Très bien.
Mathilde : Tu es terriblement utile.
Mathilde : Je vais essayer de ne pas m'y habituer.
```

Writes:

- Mathilde ordinary trust up;
- Player household participation confirmed;
- practical-help follow-up available;
- no gaze signal.

### MT0B — Teasing welcome

```text
Player : j'ai compté quatre paires de chaussures
Player : l'enquête continue

Mathilde : Objection.
Mathilde : Méthode de comptage hostile.
Mathilde : Mais tu peux quand même m'aider avec le portant.
```

Writes:

- Mathilde ordinary complicity up;
- one legal joke used;
- practical-help follow-up available;
- no sexual route state.

### MT0C — Distant welcome

```text
Player : installe-toi
Player : je rentrerai plus tard

Mathilde : D'accord.
Mathilde : Marie m'a montré où tout était.
Mathilde : Je vais essayer de ne pas déclarer le bureau territoire indépendant avant ton retour.
```

Writes:

- Mathilde access established but warmer follow-up deferred;
- Player distance signal;
- Marie carries household welcome;
- no route penalty beyond cooler tone.

## 8.7 Couple echo after arrival

Use one variant according to M0 / MT0.

Warm variant:

```text
Marie : Elle a déjà perdu son chargeur.
Marie : Nous sommes officiellement au complet.
Marie : Merci d'avoir fait de la place.
```

Neutral variant:

```text
Marie : Elle est installée.
Marie : Enfin, le mot est généreux.
Marie : On finira demain.
```

Distant variant:

```text
Marie : Elle est installée.
Marie : Je lui ai montré le reste.
Marie : On parlera logistique demain.
```

No choice is required in this echo.

## 8.8 Exit state

- `mathilde_temporary_stay_active` conceptually true;
- Mathilde R1 ordinary access established;
- no sexual intention;
- no domestic image may circulate;
- household topology now includes Marie / Player / Mathilde;
- first morning and spare-room engines become eligible later.

---

# 9. O3 — Work and restrained continuity

O3 contains one fixed foreground scene for Raphaëlle and one optional Sandra echo.

## 9.1 Raphaëlle scene identity

```text
scene_id: raphaelle_blue_folder_review_01
window: PLAYER_WORK
primary relationship: Player / Raphaëlle
function: Raphaëlle R1 Ordinary Access
intensity: ordinary
```

## 9.2 Entry conditions

Required:

- normal workday;
- Raphaëlle and Player are collaborating as peers;
- no private Raphaëlle route exists;
- no urgent adult consequence is due.

## 9.3 Optional visual V2 — `raphaelle_blue_folder`

A visual is optional rather than mandatory.

If used:

- photo or screenshot of the blue project folder beside a prototype screen;
- Raphaëlle's dark-teal notebook partly visible;
- no body-focused image;
- work-channel appropriate;
- no personal creative-account clue yet.

## 9.4 Canon line source

```text
Raphaëlle : Tu as laissé « à vérifier » sur la seule section déjà vérifiée.
Raphaëlle : Trois fois, pour être précise.

Player : c'est une méthode

Raphaëlle : Je crains que le mot soit généreux.
Raphaëlle : Tu corriges avant le point client ?
```

## 9.5 Choice R0 — How Player handles an ordinary mistake

### R0A — Accountable

```text
Player : j'ai copié la mauvaise note
Player : je corrige maintenant

Raphaëlle : Merci.
Raphaëlle : Je préfère une erreur corrigée à un mystère bien présenté.
```

Writes:

- Raphaëlle work trust up;
- no attraction state;
- task completed.

### R0B — Dry humor, then action

```text
Player : je testais la résistance de ton calme
Player : je corrige

Raphaëlle : Mon calme facture les tests non sollicités.
Raphaëlle : Mais il accepte la correction.
```

Writes:

- Raphaëlle ordinary humor access;
- work trust stable/up;
- task completed.

### R0C — Delay

```text
Player : je le reprends après le point client

Raphaëlle : D'accord.
Raphaëlle : Je te le laisse.
Raphaëlle : Mais pas jusqu'à demain.
```

Writes:

- small work obligation due before end of day;
- Raphaëlle work trust neutral;
- no emotional diagnosis.

## 9.6 Ordinary closing beat

```text
Raphaëlle : Et mange quelque chose avant le point.
Raphaëlle : Ce n'est pas une analyse.
Raphaëlle : Tu as oublié ton sandwich sur l'imprimante.
```

This line is ordinary observation, not therapist framing.

## 9.7 Exit state

- Raphaëlle R1 ordinary work access established;
- professional trust variant recorded;
- no outside-work invitation;
- no garment bag, creative account, costume photo, or private frame yet;
- the after-hours branch in O5C may reuse the work relationship without repeating this engine.

---

## 9.8 Sandra conditional echo — `sandra_poste_matin_continuity_01`

Window:

- `PRIVATE_MESSAGE` echo;
- after a poste du matin;
- no foreground cost;
- no new image.

Base lines:

```text
Sandra : Poste du matin terminé.
Sandra : Le bouton est revenu.
Sandra : J'hésite entre miracle et menace.

Player : journée sauvée alors

Sandra : N'allons pas jusque-là.
```

If J1 used `sandra_precise_observation`, add:

```text
Sandra : Et la photo est toujours floue.
Sandra : Très stable, elle.
```

If J1 used safe warmth or playful-light, optionally add:

```text
Sandra : Je l'ai remise dans mon sac.
Sandra : C'est très organisé pour moi.
```

If J1 used distant/cautious and Player has not re-engaged, omit the photo lines and allow the echo to end after `N'allons pas jusque-là.`

Writes:

- Sandra trace continuity remains alive;
- no route stage increase;
- no second photo;
- no Thursday promise is created by this source pack.

---

# 10. O4 — Marie offers movement

## 10.1 Event canon

The first meaningful event is the `petit événement jeudi` already mentioned in J1.

Concrete event:

- small opening evening for a collective local illustration exhibition at La Verrière;
- modest buffet;
- around thirty-five expected guests, likely more;
- Pauline and Bastien invited as part of Marie's social circle;
- Nico has agreed to keep a table at L'Annexe for people who continue after closing;
- Mathilde is invited but independently chooses to stay at the apartment because the insurance / building follow-up may call and she is tired from the move;
- Élodie remains work-color support, not a route.

Mathilde's choice to remain home is not made by Player.

## 10.2 Scene identity

```text
scene_id: marie_thursday_movement_offer_01
window: PRIVATE_MESSAGE / COUPLE_HOME
primary relationship: Player / Marie
function: S2 Movement Offered + topology choice
intensity: ordinary
```

## 10.3 Canon line source

```text
Marie : Jeudi, le petit événement dont je te parlais.
Marie : Vernissage local.
Marie : Trente-cinq personnes annoncées, donc probablement cinquante.
Marie : Le traiteur a confirmé « oui ».
Marie : Avec un vrai oui cette fois.

Player : progrès historique

Marie : Immense.
Marie : J'ai besoin de deux bras à 18h.
Marie : Et j'ai envie que tu viennes.
Marie : Ce sont deux raisons différentes.
```

## 10.4 Choice M1 — First topology choice

### M1A — Join Marie early

```text
Player : je viens à 18h
Player : donne-moi la liste et évite-moi seulement le traiteur

Marie : Marché conclu.
Marie : Je te garde les chaises, les rallonges et les décisions de dernière minute.
Marie : Arrive vraiment à 18h et je serai impressionnée.
```

Topology:

```text
PLAYER_WITH_MARIE_SOCIAL
```

Creates:

- event-arrival obligation at 18h;
- branch O5A;
- strong chance of Marie active-reconnection signal;
- ordinary Pauline and Nico visibility.

### M1B — Stay at the shared home

```text
Player : vas-y sans moi
Player : je reste ici, je termine la chambre et je souffle un peu

Marie : D'accord.
Marie : Moi j'y vais quand même.
Marie : Mathilde m'a dit qu'elle restait pour l'appel de l'assurance.
Marie : Demande-lui quand même ce dont elle a besoin avant de décider que vous êtes deux ermites autonomes.
```

Topology:

```text
HOME_WITHOUT_MARIE
```

Creates:

- branch O5B;
- Marie independent social action;
- Mathilde practical household foreground eligibility;
- no automatic Mathilde route tension.

### M1C — Finish work and promise to join later

```text
Player : j'ai la revue d'accessibilité à finir
Player : je passe après

Marie : Ok.
Marie : Mais « je passe après » est une promesse.
Marie : Pas une ambiance.

Player : reçu

Marie : Je note l'heure pour le plaisir de te juger proprement.
```

Topology:

```text
PLAYER_WORK -> MARIE_SOCIAL_RETURN_DUE
```

Creates:

- branch O5C;
- explicit `join_after_work` obligation;
- expiry: before the event's final public beat;
- kept, honestly amended, or missed outcome.

## 10.5 Choice-design note

The node does not offer an outright refusal of Mathilde's emergency stay and does not ask Player to select a character route.

The decision axis is:

```text
Where and how will Player be present for Marie's meaningful movement?
```

---

# 11. O5A — Topology A: Player joins Marie

## 11.1 Scene identity

```text
scene_id: marie_laverriere_setup_joined_01
window: PLAYER_WITH_MARIE_SOCIAL / GROUP_EVENT
primary relationship: Player / Marie
function: active participation + Marie social visibility
intensity: ordinary with soft charge
```

## 11.2 Smartphone context

Player and Marie are in the same venue but moving through different parts of the room.

Messages carry:

- practical tasks;
- a photo;
- short private asides across the space.

## 11.3 Canon line source

```text
Marie : Tu es où ?

Player : derrière les chaises

Marie : Réponse inquiétante.
Marie : J'ai besoin de la rallonge noire côté scène.
Marie : Pas la grise.
Marie : La grise est maudite.
```

## 11.4 Choice MA0 — Quality of participation

### MA0A — Take initiative

```text
Player : je l'ai
Player : et j'ai déjà déplacé les deux tables du fond

Marie : Très bien.
Marie : Je retire provisoirement toutes mes critiques sur ta vitesse de réaction.
Marie : Provisoirement.
```

Writes:

- couple presence up;
- active-reconnection candidate;
- Marie feels joined before asking twice.

### MA0B — Joke and help

```text
Player : je négocie avec la rallonge noire
Player : elle demande une pause et un meilleur salaire

Marie : Refuse.
Marie : Elle a déjà de meilleurs horaires que nous.
Marie : Et apporte-la, s'il te plaît.
```

Writes:

- playful-present couple signal;
- task paid;
- Marie remains warm.

### MA0C — Physically present, attention delayed

```text
Player : deux minutes
Player : je finis un message

Marie : D'accord.
Marie : Mais tu es venu pour être là.
Marie : Pas pour déplacer ton absence dans une autre pièce.
```

Writes:

- presence strained;
- no crisis;
- Marie must ask again;
- `parallel_drift_candidate` signal.

## 11.5 Visual V3 — `marie_laverriere_setup`

Origin:

- taken by Élodie or Pauline with Marie's knowledge;
- ordinary La Verrière / event documentation.

Composition:

- Marie near the exhibition wall or guest table;
- one practical object in hand;
- alive, busy, smiling or about to solve something;
- event clothing appropriate but not the later black-dress reconquest signature;
- no body crop designed only for jealousy;
- Player may be visible in the background only on MA0A/B if useful.

Function:

```text
make Player want to join Marie's life
not merely control who sees her
```

## 11.6 Pauline ordinary echo

```text
Pauline : Marie m'a dit que tu tenais le téléphone pour la photo de groupe.
Pauline : Ne la crois pas quand elle dit « deux secondes ».
Pauline : Elle veut dire « jusqu'à ce que tout le monde ait l'air humain ».
```

No choice required.

No private crop.

## 11.7 Nico ordinary echo

```text
Nico : J'ai gardé une table à L'Annexe après.
Nico : Pas pour les chaises.
Nico : Pour les survivants.
```

No attraction or voyeurism language yet.

## 11.8 Exit beat with Marie

Warm version for MA0A/B:

```text
Marie : Merci d'être venu tôt.
Marie : J'ai eu moins l'impression de porter la soirée toute seule.
```

Strained version for MA0C:

```text
Marie : Merci d'être venu.
Marie : La prochaine fois, essaie aussi d'arriver dans la soirée avec le reste de toi.
```

## 11.9 Exit state

- Marie social life is concretely desirable;
- Player's participation quality is recorded;
- Pauline and Nico have ordinary social visibility;
- public group photo is due;
- no external route is active.

---

# 12. O5B — Topology B: Player stays home

## 12.1 Scene identity

```text
scene_id: mathilde_spare_room_charger_01
window: HOME_WITHOUT_MARIE / PRIVATE_MESSAGE
primary relationship: Player / Mathilde
function: practical domestic access
intensity: ordinary
```

## 12.2 Agency condition

Mathilde stays home because:

- she is tired from the move;
- an insurer / building follow-up may call;
- she independently declines Marie's invitation.

Player does not keep her home.

## 12.3 Canon line source

Mathilde messages from the spare room while Player is elsewhere in the apartment.

```text
Mathilde : Question urgente.
Mathilde : Enfin juridiquement discutable.
Mathilde : Tu as vu mon chargeur ?

Player : celui que tu as posé sur la table ?

Mathilde : Non.
Mathilde : Celui que j'ai posé sur la table et qui n'y est plus parce que Marie a rangé.
Mathilde : Ce qui est une agression très organisée.
```

Optional visual:

```text
[VISUAL: cable pile + corner of legal tote bag; no body-focused framing]
```

## 12.4 Choice MH0 — Practical domestic posture

### MH0A — Help directly

```text
Player : boîte bleue sous le bureau
Player : j'arrive

Mathilde : Tu sais déjà où sont mes affaires.
Mathilde : C'est rapide et légèrement inquiétant.
Mathilde : Mais merci.
```

Writes:

- Mathilde practical trust up;
- ordinary household complicity;
- no gaze state.

### MH0B — Playful help

```text
Player : je peux ouvrir une enquête
Player : mais mes tarifs sont élevés

Mathilde : Objection.
Mathilde : Abus de position domestique.
Mathilde : Mais viens quand même.
```

Writes:

- playful ordinary access;
- one legal-joke beat;
- no sexual route state.

### MH0C — Keep distance

```text
Player : regarde dans tes sacs
Player : je finis un truc

Mathilde : Message reçu.
Mathilde : Je vais survivre seule avec mes six sacs et ma dignité.
Mathilde : Enfin l'un des deux.
```

Writes:

- Mathilde access remains R1 but cools;
- no repeated request in this window;
- Player distance signal.

## 12.5 Marie social echo

```text
Marie : On survit.
Marie : Pauline a sauvé la photo de groupe.
Marie : Nico a sauvé une table après.
Marie : Vous survivez ?
```

This echo keeps Marie active and reminds Player that she has a life outside the apartment.

## 12.6 Exit state

- Mathilde is established as ordinary household presence;
- no deliberate outfit or gaze scene has occurred;
- Marie's event continues independently;
- public group photo is due;
- couple return consequence is due in O6.

---

# 13. O5C — Topology C: Player finishes work

## 13.1 Scene identity

```text
scene_id: raphaelle_accessibility_review_late_01
window: PLAYER_WORK
primary relationship: Player / Raphaëlle
secondary relationship: Player / Marie through an external promise
function: work obligation + promise pressure
intensity: ordinary
```

## 13.2 Entry conditions

Required:

- M1C chosen;
- work review genuinely incomplete;
- Raphaëlle remains a peer;
- `join_after_work` obligation active.

## 13.3 Canon line source

```text
Raphaëlle : Nous avons deux options.
Raphaëlle : Envoyer une version correcte à 18h40.
Raphaëlle : Ou inventer un quatrième écran et détester notre vie à 20h.
Raphaëlle : Je vote pour la première.
```

## 13.4 Choice RW0 — How Player handles the promise

### RW0A — Decide and leave on time

```text
Player : on envoie la version correcte
Player : je dois rejoindre Marie

Raphaëlle : Décision prise.
Raphaëlle : J'approuve le concept.
Raphaëlle : Je verrouille le prototype.
```

Writes:

- work task complete;
- `join_after_work` obligation kept;
- Raphaëlle work trust up;
- Player may appear in the final part of the event.

### RW0B — Honest limited delay

```text
Player : on termine le dernier point
Player : je la préviens que j'aurai vingt minutes

Raphaëlle : Très bien.
Raphaëlle : Préviens-la maintenant.
Raphaëlle : Pas quand les vingt minutes seront devenues une heure.
```

Writes:

- work task complete later;
- Marie informed before expiry;
- promise amended honestly;
- Player arrives very late or misses the public beat without concealment.

### RW0C — Remain vague and let work absorb the evening

```text
Player : on voit combien de temps ça prend

Raphaëlle : Non.
Raphaëlle : « On voit » est exactement comme on finit ici à vingt heures.
Raphaëlle : Je t'envoie le fichier et je pars après ma partie.
```

Writes:

- Raphaëlle does not carry Player's indecision;
- Player continues alone if he chooses;
- `join_after_work` obligation likely missed;
- work becomes shelter through Player's choice, not Raphaëlle's invitation.

## 13.5 Ordinary personal-detail echo

A garment bag is visible near Raphaëlle's desk because she has an appointment with Maud after work.

If the conversation has room, use:

```text
Player : et la housse ?

Raphaëlle : Essayage.
Raphaëlle : Version encore très incomplète.
Raphaëlle : Donc non, tu n'auras pas de photo de preuve.
```

Function:

- ordinary creative-life seed;
- no creative-account access;
- no attraction or image invitation;
- no route stage increase.

## 13.6 Exit state

- Raphaëlle remains R1 ordinary access;
- Player's promise outcome is determined;
- Marie consequence is due in O6;
- no private Raphaëlle frame exists.

---

# 14. O6 — Mandatory return to Marie

## 14.1 Scene identity

```text
scene_id: marie_after_first_event_return_01
window: COUPLE_HOME / PRIVATE_MESSAGE / AFTERMATH_LIGHT
primary relationship: Player / Marie
function: pay topology consequence and recenter shared life
intensity: ordinary emotional consequence
```

No new route opportunity may replace this scene.

No new choice node is required.

The result uses the previous choice history.

## 14.2 Return variant A — Player joined early

If MA0A/B:

```text
Marie : Merci pour ce soir.
Marie : Et je ne parle pas seulement des rallonges.

Player : de quoi alors ?

Marie : D'être venu avant que j'aie besoin de te rattraper.
Marie : Garde cette version de toi.
Marie : Elle me plaît bien.
```

If MA0C:

```text
Marie : Merci d'être venu.
Marie : Tu étais là.
Marie : Pas toujours avec moi, mais là.

Player : je sais

Marie : Je ne fais pas un procès.
Marie : Je note juste la différence.
```

Writes:

- active-reconnection candidate for MA0A/B;
- presence strain for MA0C;
- no immediate couple-mode transition from one event alone.

## 14.3 Return variant B — Player stayed home

If MH0A:

```text
Marie : Je rentre.
Marie : Vous avez trouvé le chargeur ?

Player : oui
Player : et la chambre ressemble presque à une chambre

Marie : Très bien.
Marie : Tu as été là autrement, alors.
Marie : Ça compte aussi.
```

If MH0B:

```text
Marie : Je rentre.
Marie : Vous avez trouvé le chargeur ?

Player : oui
Player : l'accusée a coopéré

Marie : Je refuse de vous laisser seuls avec du vocabulaire judiciaire.
Marie : Mais merci d'avoir aidé.
```

If MH0C:

```text
Marie : Je rentre.
Marie : Vous avez trouvé le chargeur ?

Player : je sais pas
Player : elle s'est débrouillée

Marie : D'accord.
Marie : Je te raconterai demain.
Marie : Là je suis crevée.
```

Writes:

- household participation up / playful / down;
- Marie's independent evening remains positive;
- no jealousy state;
- soft drift only on MH0C.

## 14.4 Return variant C — Work promise

If RW0A:

```text
Marie : Tu as dit « après ».
Marie : Et tu es vraiment venu après.
Marie : Ça devrait être normal.
Marie : Ce soir ça m'a fait plaisir quand même.
```

If RW0B:

```text
Marie : Merci d'avoir prévenu.
Marie : J'aurais préféré te voir davantage.
Marie : Les deux phrases sont vraies.
```

If RW0C:

```text
Marie : Je crois que ton « je passe après » a pris un autre chemin.

Player : désolé

Marie : Je ne te demande pas une dissertation.
Marie : Juste d'éviter les promesses décoratives.
```

Writes:

- promise kept / honestly amended / missed;
- first missed-opportunity trace only on RW0C;
- no open crisis;
- `parallel_drift_candidate` may be strengthened on RW0C.

## 14.5 Exit state

- the topology choice has returned to the couple;
- Marie has not disappeared behind the branch character;
- public event image remains due;
- no external route is active;
- couple remains `HABITUAL_WARMTH` unless future repeated actions justify transition.

---

# 15. O7 — Pauline public group-photo relay

## 15.1 Scene identity

```text
scene_id: pauline_public_group_photo_relay_01
window: TRACE_OR_IMAGE / PRIVATE_MESSAGE
primary relationship: Player / Pauline
secondary relationship: Marie / Pauline
function: Pauline R1 Ordinary Access + legitimate trace origin
intensity: ordinary
```

## 15.2 Image origin

Pauline used her compact remote shutter for an authorized group photo near the end of the La Verrière event.

Possible visible adults:

- Marie;
- Pauline;
- Bastien;
- Nico, who passed through before the L'Annexe continuation;
- Élodie;
- Player if he joined or arrived before the photo.

Mathilde is not in this first group photo because she stayed home for the insurance follow-up and move fatigue.

The photos are intended for:

- Marie;
- La Verrière's event archive / possible public post;
- the photographed group.

They are not adult images.

## 15.3 Canon line source

```text
Pauline : Marie m'a demandé de t'envoyer les trois versions.
Pauline : Elle conduit.
Pauline : Et tu es apparemment devenu comité de sélection.

Player : j'ai signé aucun contrat

Pauline : Personne n'a signé.
Pauline : C'est la méthode La Verrière.
Pauline : La 2 pour le public.
Pauline : La 3 si on veut prouver que Nico ferme les yeux sur commande.
```

## 15.4 Choice P0 — Public selection only

### P0A — Practical selection

```text
Player : la 2
Player : on voit mieux l'affiche et personne n'a l'air otage

Pauline : Enfin quelqu'un de raisonnable.
Pauline : Je vais préserver cette minute.
```

Writes:

- Pauline practical trust up;
- public photo 2 selected;
- no private version.

### P0B — Dry joke

```text
Player : la 3
Player : la vérité sur Nico doit sortir

Pauline : Tentant.
Pauline : Mais Marie me tuerait avec un mail poli.
Pauline : La 2 survivra.
```

Writes:

- Pauline ordinary dry complicity;
- public photo 2 selected;
- no route tension.

### P0C — Defer to Marie

```text
Player : demande à Marie
Player : c'est son événement

Pauline : Je lui demanderai.
Pauline : Réponse prudente, Player.
Pauline : Pas mauvaise.
```

Writes:

- Pauline access established;
- Marie remains decision owner;
- no private selection.

## 15.5 Trace record

```text
trace_id: laverriere_public_group_photo_set_01
origin: Pauline remote shutter
intended audience: photographed group + La Verrière public archive
actual audience: same at creation
consent level: authorized social image
save rule: ordinary social saving allowed
forward rule: public/event context only
adult function: none in V0.79
future mutation: may later become socially charged only through new context
```

## 15.6 Explicit exclusions

V0.79 does not allow:

- a private alternate crop;
- a one-view image;
- body-focused recropping;
- Nico forwarding a Pauline image;
- Player requesting another version;
- Pauline asking Player what he noticed about her body.

## 15.7 Exit state

- Pauline R1 ordinary access established;
- Bastien exists visibly in the social world;
- public image origin is canonically known;
- no double-life route is active.

---

# 16. O8 — Nico saved-seat follow-up

## 16.1 Scene identity

```text
scene_id: nico_saved_seat_followup_01
window: PRIVATE_MESSAGE
primary relationship: Player / Nico
function: Nico R1 Ordinary Access + social mirror seed
intensity: ordinary
```

## 16.2 Entry variants

Use one opening according to topology.

### Player joined early

```text
Nico : T'as survécu aux rallonges.
Nico : Je suis presque déçu.
```

### Player stayed home

```text
Nico : Je t'avais gardé une chaise.
Nico : Elle a fini avec le manteau de Pauline dessus.
```

### Player arrived very late

```text
Nico : Arrivée de fin de générique.
Nico : Très conceptuel.
```

### Player missed after promising

```text
Nico : La chaise a demandé de tes nouvelles.
Nico : J'ai menti pour la protéger.
```

The last line is a joke, not a real alibi.

## 16.3 Choice N0 — Ordinary male friendship response

### N0A — Honest

```text
Player : j'aurais dû venir plus tôt

Nico : Oui.
Nico : La prochaine fois, viens avant que les manteaux prennent toutes les places.
```

If Player did join early, replace with:

```text
Player : j'ai fait un effort historique

Nico : J'ai vu.
Nico : Ne t'inquiète pas, je ne vais pas te féliciter trop longtemps.
```

Writes:

- Nico friendship trust up;
- no rivalry state;
- missed opportunity acknowledged if relevant.

### N0B — Playful

```text
Player : la chaise avait de meilleurs horaires que moi

Nico : Elle était ponctuelle, elle.
Nico : Et beaucoup moins de mauvaise foi.
```

Writes:

- ordinary banter established;
- no route stage beyond R1.

### N0C — Ask about Marie's evening

```text
Player : Marie avait l'air bien ?

Nico : Oui.
Nico : Dans son élément.
Nico : Ça lui va bien quand elle n'attend pas que la soirée commence.
```

Writes:

- Nico social-mirror seed;
- Player's attention to Marie remains central;
- no sexual compliment or rivalry yet.

## 16.4 Optional Mathilde knowledge echo

Use only after Nico has a credible source such as Marie, Pauline, or Player mentioning the stay.

```text
Nico : Et Mathilde s'installe vraiment chez vous ?

Player : pour dix jours environ

Nico : Courage pour les prises électriques.
Nico : Et pour les chaussures, visiblement.
```

This establishes knowledge only.

It does not yet activate:

- domestic-access envy;
- voyeuristic request;
- a photo pact;
- attraction commentary.

Those belong to Act II after ordinary access.

## 16.5 Exit state

- Nico R1 ordinary access established;
- saved-seat social trace resolved;
- Nico knows or may know Mathilde's stay;
- no photo pact, alibi, jealousy, or adult frame exists.

---

# 17. Household breather after O8

Use short cross-thread echoes rather than a mandatory group chat.

## 17.1 Marie echo

```text
Marie : Rapport du foyer.
Marie : Mathilde a pris la salle de bain vingt-sept minutes.
Marie : Nous sommes officiellement trois adultes très organisés.
```

## 17.2 Mathilde echo

```text
Mathilde : Marie dramatise.
Mathilde : Vingt-deux minutes maximum.
Mathilde : Et il y avait une urgence capillaire.
```

If MT0C and MH0C both occurred, Mathilde's echo may be omitted or shortened to:

```text
Mathilde : J'ai retrouvé le chargeur.
Mathilde : Fin de crise nationale.
```

Function:

- confirm ordinary household rhythm;
- close the opening band on life rather than temptation;
- make future morning / spare-room / outfit windows plausible;
- no route stage change.

---

# 18. Coverage matrix

| Character | Opening access source | Minimum result by pack end | Not yet allowed |
|---|---|---|---|
| Marie | O1, O4, O5, O6 | central couple action and topology consequence | crisis speech, jealousy-only function |
| Sandra | O3 conditional echo | trace continuity remains available | new photo, confession, pressure |
| Mathilde | O2 fixed; O5B branch; household breather | R1 Ordinary Access; stay active | deliberate seduction, adult image, hidden route |
| Raphaëlle | O3 fixed; O5C branch if chosen | R1 Ordinary Work Access | creative-account reveal, personal photo, refuge role |
| Pauline | O5A echo; O7 fixed | R1 Legitimate Social Access | alternate crop, reciprocal proof, secret compartment |
| Nico | O5A echo; O8 fixed | R1 Ordinary Friendship / Social Access | voyeur request, photo pact, rivalry, NTR framing |
| Player | all windows | participation topology and promise history | direct route selection menu |

## 18.1 Coverage guarantee

By the end of O8:

- every principal character has either appeared directly or remained deliberately present through a current, defensible echo;
- Mathilde, Raphaëlle, Pauline, and Nico have ordinary access established;
- Sandra has not been overused;
- Marie has at least three central beats;
- no route has skipped ordinary characterization.

---

# 19. Conceptual state writes

These are documentation concepts, not final runtime variable names.

## 19.1 Household

- Mathilde stay active;
- Player household participation quality;
- Mathilde ordinary trust / coolness;
- first morning and spare-room windows eligible.

## 19.2 Couple

- presence tendency: proactive / playful-present / passive;
- first event topology;
- promise kept / amended / missed;
- active-reconnection candidate;
- parallel-drift candidate;
- no hard trust damage;
- frame remains assumed exclusive.

## 19.3 Ordinary access

- Raphaëlle work access established;
- Pauline social/public-image access established;
- Nico friendship/social access established;
- Sandra trace continuity active or cooled;
- Mathilde household access established.

## 19.4 Traces

- Mathilde arrival room photo exists, private household audience;
- La Verrière setup photo may exist, authorized event context;
- public group photo set exists, authorized social context;
- no adult image exists;
- no image has been forwarded outside its intended context.

## 19.5 Obligations

Created and resolved inside pack:

- make room;
- arrive / help;
- work correction;
- event attendance or stay-home choice;
- `join after work` promise;
- public photo selection;
- saved-seat follow-up.

No major unresolved obligation should remain at pack end except intentionally deferred future opportunities.

---

# 20. Selection and mutation rules

## 20.1 O5 branch exclusivity

Only one O5 foreground scene occurs:

```text
O5A OR O5B OR O5C
```

The other branch scenes become `MISSED` for this opening event.

They may later reappear only as new context-specific engines, not as the exact same event.

## 20.2 O7 / O8 order

O7 Pauline and O8 Nico may swap if:

- Nico writes immediately after the event;
- Pauline sends photos the following morning;
- pacing makes the order more natural.

Their content and state effects remain the same.

## 20.3 Sandra echo mutation

If Sandra's echo is not eligible because the J1 branch was distant or the thread recently closed:

- do not force it;
- mark Sandra as cooled but available;
- use a later Act I work-afterglow window.

## 20.4 Raphaëlle O5C mutation

If O5C is not chosen:

- Raphaëlle remains established through O3;
- the after-hours / garment-bag engine remains eligible later with a different deadline;
- do not replay the exact Thursday promise context.

## 20.5 Nico and Pauline no-escalation rule

Their event access cannot mutate immediately into:

- private crop;
- body comment;
- photo request;
- alibi;
- jealousy diagnosis;
- secret-message test.

At least one later compatible cycle is required.

---

# 21. Image and visual inventory

## V1 — Mathilde arrival room

- required conceptual visual;
- ordinary private household image;
- no erotic framing;
- no forwarding.

## V2 — Raphaëlle blue folder

- optional work visual;
- no personal body focus;
- may be omitted without continuity loss.

## V3 — Marie La Verrière setup

- required if O5A occurs;
- otherwise may appear as Marie's social echo in O5B/O5C;
- shows Marie active and desirable through life, not sexual posing.

## V4 — Pauline public group photo set

- required trace for O7;
- authorized social/public function;
- composition varies with attendance topology;
- no private crop in V0.79.

## Explicitly absent

- Mathilde canapé selfie;
- Mathilde adult or deliberately provocative image;
- second Sandra image;
- Raphaëlle personal / costume image;
- Pauline private alternate;
- Nico-supplied private image;
- hidden capture;
- sexual video.

---

# 22. Act and route ceilings

This pack remains inside:

```text
Act I opening
R0–R1
soft pre-R2 signals only
```

Allowed:

- ordinary attraction background;
- Marie social visibility;
- Mathilde ordinary fitted clothing in visual continuity;
- Nico knowing Mathilde is staying;
- Raphaëlle creative-life object seed;
- Pauline public image competence;
- Sandra trace continuity;
- Player noticing differences in presence.

Not allowed:

- acknowledged sexual attraction;
- deliberate adult image;
- reciprocal proof;
- secret compartment;
- voyeuristic request;
- hidden affair;
- open-couple negotiation;
- NTR/cuckold discussion;
- trio/group proposition;
- explicit adult language;
- route lock.

---

# 23. Player-choice audit

All foreground nodes use three choices.

| Node | Decision axis | Choice 1 | Choice 2 | Choice 3 |
|---|---|---|---|---|
| M0 | How Player makes room | proactive | playful-present | passive assent |
| MT0 | How Player welcomes Mathilde | practical | teasing-helpful | distant |
| R0 | How Player handles ordinary work error | accountable | humorous + acts | delays |
| M1 | Where/how Player is present for Marie's event | joins early | stays home | works then promises to join |
| MA0 | Quality of event participation | initiative | joke + help | present but delayed |
| MH0 | Domestic posture with Mathilde | help | playful help | distance |
| RW0 | Work vs promise | decide and leave | honest limited delay | vague absorption |
| P0 | Public photo selection | practical | dry joke | defer to Marie |
| N0 | Nico friendship response | honest | playful | ask about Marie |

No node requires a four-choice exception.

The return scene has no fake choice because it pays the topology already chosen.

---

# 24. Pack end state

At the end of V0.79 opening content:

```text
Mathilde stay = active
Marie event = completed
first topology choice = remembered
public group photo = exists
Raphaëlle ordinary access = established
Pauline ordinary access = established
Nico ordinary access = established
Sandra trace = active or intentionally cooled
adult routes = inactive
hard secrets = none
relationship frame = ASSUMED_EXCLUSIVE
```

Couple mode remains:

```text
HABITUAL_WARMTH
```

Possible tendencies:

- `ACTIVE_RECONNECTION` candidate after repeated active presence;
- `PARALLEL_DRIFT` candidate after repeated passive/missed participation.

One opening event alone cannot finalize the transition.

---

# 25. Acceptance criteria

The source pack is valid if:

- J1 exact canon remains unchanged;
- the water-damage stay replaces old casual sleepover logic;
- Mathilde enters as family and person before tension;
- Marie consults Player and remains active;
- the event mentioned in J1 becomes a meaningful movement anchor;
- the three topology choices are actions, not route names;
- each topology has exactly one foreground scene;
- every topology returns to Marie;
- Raphaëlle enters through ordinary work;
- Pauline enters through an authorized public image;
- Nico enters through ordinary friendship and saved-seat logic;
- Sandra continues without a new photo or escalation;
- visual origins and audiences are explicit;
- no route exceeds the opening Act I ceiling;
- every choice has a documented consequence;
- no support character is promoted into a route;
- runtime remains untouched.

---

# 26. Runtime boundary

This source pack does not decide:

- final JSON filenames;
- whether all relative windows map to one or several runtime days;
- exact scheduler implementation;
- final conceptual-state variable names;
- final image asset paths;
- notification timing in seconds;
- migration of old J2 runtime;
- whether old technical data is edited, replaced, or bypassed.

Those decisions belong to:

```text
V0.80 — First Modular Runtime Integration Plan
```

Before runtime integration, V0.80 must:

- inspect current conversation data and thread indexes;
- map only the states used by this vertical slice;
- preserve one visible thread per character;
- decide how topology and return anchors fit the existing smartphone UI;
- identify old J2 data that must be deprecated or replaced;
- avoid a large refactor;
- define validation and rollback.

---

# 27. Final rule

```text
The opening does not ask Player which route he wants.

It asks whether he makes room,
whether he joins Marie,
whether he keeps a promise,
and how he treats ordinary access to other people.

The routes begin later,
when those remembered actions acquire desire and consequence.
```
