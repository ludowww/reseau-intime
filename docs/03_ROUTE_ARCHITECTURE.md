# 03 — Architecture des routes

## Principe fondamental

Le jeu ne doit pas être un arbre infini. Il doit fonctionner avec :

```text
Tronc commun + route dominante + route secondaire + menace + mode relationnel
```

Cette structure reste validée, mais elle ne doit pas apparaître trop tôt au joueur. Les premiers jours doivent mesurer des postures et des priorités, pas annoncer immédiatement une route.

## Routes personnages

Les routes personnages répondent à la question :

> Qui devient central dans le désir, le manque ou la jalousie de Ludo ?

Routes principales :

- Marie ;
- Mathilde ;
- Sandra ;
- Raphaëlle ;
- Pauline ;
- Nico / Marie.

## Modes relationnels

Les modes relationnels répondent à la question :

> Dans quelles règles ce désir existe-t-il ?

Modes officiels :

```text
EXCLUSIF_REPARATION
SECRET_AFFAIR
LIBERTINE_NEGOTIATED
POLY_HONEST
NTR_SUBI
NTR_CONSENTED
HAREM_SECRET
HAREM_ASSUMED
CHAOS_EXPLOSION
```

Côté écriture, ils correspondent à :

- exclusif / réparation ;
- tromperie secrète ;
- libertinage négocié ;
- polyamour honnête ;
- NTR subi ;
- NTR consenti ;
- harem mensonger ;
- harem assumé ;
- chaos / explosion.

## Règle de conception

> Les personnages décident du désir. Le mode relationnel décide des règles.

Exemple : Mathilde peut exister dans plusieurs modes.

- Mathilde + tromperie : liaison interdite dans la maison.
- Mathilde + vérité : Ludo avoue son trouble à Marie.
- Mathilde + trio : Marie accepte d’entrer dans la tension.
- Mathilde + Nico : rivalité, jalousie ou quatuor.
- Mathilde + harem : limite rouge très instable.

## Émergence progressive des routes

Les routes ne doivent pas être détectées comme des choix de menu dès le début. Elles doivent émerger à partir de comportements répétés, de priorités et de traces.

```text
Jours 1–2 : postures de Ludo.
Jour 3 : priorités visibles.
Jour 4 : route probable.
Après pivot : route dominante / secondaire / menace / mode relationnel.
```

### Jours 1–2 — Postures

Les choix mesurent surtout la manière dont Ludo se comporte :

- présent ;
- évitant ;
- sincère ;
- mécanique ;
- curieux ;
- prudent ;
- fuyant ;
- tenté ;
- protecteur ;
- secret.

Ces choix peuvent nourrir des signaux comme `truth_tendency`, `lie_score`, `marie_attention_score`, `marie_neglect_score`, `sandra_priority_score` ou `sandra.attachment`, mais ils ne doivent pas verrouiller de route.

### Jour 3 — Priorités

Les choix deviennent plus structurants quand plusieurs fils existent en même temps.

Exemples :

- répondre à Marie ou laisser son message en attente ;
- ouvrir Sandra pendant un moment social ;
- répondre publiquement au groupe ou rester silencieux ;
- regarder une photo ;
- conserver ou supprimer une trace ;
- minimiser ou clarifier.

C’est à partir de ce type de priorité que les routes peuvent commencer à devenir lisibles.

### Jour 4 — Route probable

Une route probable peut émerger si plusieurs signaux convergent. Elle ne doit pas encore être une promesse définitive.

Exemple :

```text
Sandra devient probable si :
- Ludo lui donne une priorité répétée ;
- il se montre plus sincère avec elle qu’avec Marie ;
- il conserve ou regarde une trace liée à Sandra ;
- il accepte l’ambiguïté sans la forcer.
```

## Route Marie

### Question centrale

Est-ce que le couple survit, s’ouvre, se transforme ou se détruit ?

### Branches

```text
Marie
├── Réparation
├── Rupture
├── Couple ouvert
├── Marie reprend le pouvoir
├── Marie + Nico
├── Marie accepte Mathilde
└── Marie accepte Mathilde + Nico
```

### Compatibilités

- Compatible avec réparation.
- Compatible avec libertinage négocié.
- Compatible avec NTR consenti.
- Compatible avec trio Mathilde si confiance suffisante.
- Compatible avec polyamour si vérité précoce.

### Risques

- Rupture si mensonge élevé.
- Reprise de pouvoir si Marie découvre trop tard.
- NTR subi si Nico prend trop de place.

### Signaux précoces

- Ludo est présent dans les messages pratiques.
- Il clarifie au lieu de minimiser.
- Il ne transforme pas toutes les autres conversations en secrets.
- Il laisse Marie rester au centre du quotidien.

## Route Mathilde

### Question centrale

Est-ce que l’interdit domestique devient fantasme, faute, trio ou catastrophe ?

### Branches

```text
Mathilde
├── Fantasme contenu
├── Liaison secrète
├── Recul par loyauté
├── Catastrophe familiale
├── Trio fragile avec Marie
├── Quatuor avec Marie et Nico
└── Triangle trouble avec Nico
```

### Compatibilités

- Très compatible avec tromperie secrète.
- Possible avec ouverture négociée, mais seulement si Marie garde du pouvoir.
- Très instable avec harem.
- Compatible avec Nico comme rival ou complice.

### Incompatibilités / limites

- Très difficile si Marie a confiance basse.
- Catastrophique si Ludo a déjà menti longtemps.
- Mathilde ne doit jamais devenir une simple conquête interchangeable.

### Signaux précoces

- Jour 1 : Mathilde peut être seulement mentionnée par Marie.
- Jour 2 : sa présence domestique devient concrète.
- Jour 3 : elle observe Ludo dans un cadre social.
- La route ne doit pas naître d’un simple compliment, mais d’un regard répété sur une limite familiale.

## Route Sandra

### Question centrale

Est-ce que Sandra choisit Ludo ou entretient l’ambiguïté ?

### Branches

```text
Sandra
├── Confidente dangereuse
├── Liaison émotionnelle secrète
├── Contenu rare puis retrait
├── Sandra choisit enfin
├── Sandra fantôme
├── Sandra jalouse d’une autre route
└── Marie découvre l’infidélité émotionnelle
```

### Compatibilités

- Très compatible avec tromperie émotionnelle.
- Possible avec polyamour honnête, mais rare et difficile.
- Très forte comme route dominante.
- Peut rivaliser avec Raphaëlle.

### Incompatibilités / limites

- Supporte mal le harem.
- Supporte mal l’exposition.
- Supporte mal la logique libertine trop publique.

### Signaux précoces

- Sandra revient par une trace concrète, pas par flirt abstrait.
- Ludo lui montre qu’elle lui a manqué.
- Il accepte la prudence de Sandra.
- Il ne la force pas à clarifier trop vite.
- La photo de Sandra est une trace émotionnelle avant d’être un contenu de route.

## Route Raphaëlle

### Question centrale

Est-ce que Ludo accepte la clarté ou préfère le chaos ?

### Branches

```text
Raphaëlle
├── Collègue attentionnée
├── Refuge émotionnel
├── Désir clair
├── Refus du secret
├── Nouveau départ
├── Polyamour honnête
└── Elle coupe si Ludo ment trop
```

### Compatibilités

- Très compatible avec nouveau départ.
- Compatible avec polyamour honnête.
- Possible comme route dominante ou rivale de Sandra.

### Incompatibilités / limites

- Refuse la tromperie prolongée.
- Refuse le harem mensonger.
- Refuse d’être un pansement.

### Signaux précoces

- Elle ne doit pas être active au Jour 1 dans le nouveau rythme.
- Elle apparaît comme contrepoint de clarté après l’ancrage Marie/Sandra.
- Ses choix doivent mesurer l’honnêteté de Ludo, pas seulement son intérêt pour elle.

## Route Pauline

### Question centrale

Qui manipule qui ?

### Branches

```text
Pauline
├── Provocation à la soirée
├── Piège / preuve
├── Test pour Marie
├── Agit seule
├── Initiatrice libertine
├── Pauline renversée par Ludo
└── Pauline expose tout
```

### Compatibilités

- Compatible avec tromperie secrète.
- Très compatible avec libertinage.
- Compatible avec harem, mais instable.
- Peut être menace dans presque toutes les routes.

### Incompatibilités / limites

- Le renversement de Pauline doit rester consenti dans les scènes intimes.
- Pauline doit garder une forme d’agence narrative.

### Signaux précoces

- Pauline ne doit pas dominer le Jour 1.
- Elle peut être mentionnée avant d’activer le groupe.
- Sa force arrive quand il y a déjà des traces à exploiter.

## Route Nico / Marie

### Question centrale

Ludo supporte-t-il que Marie soit désirée par quelqu’un d’autre ?

### Branches

```text
Nico / Marie
├── Pote qui fantasme sur Marie
├── Rival caché
├── Confident de Marie
├── NTR subi
├── NTR consenti
├── Symétrie dans relation ouverte
├── Nico + Mathilde
└── Confrontation masculine
```

### Compatibilités

- Central en NTR.
- Compatible avec libertinage.
- Compatible avec quatuor Marie / Ludo / Mathilde / Nico.
- Compatible comme menace dans les routes où Ludo néglige Marie.

### Incompatibilités / limites

- Nico ne doit pas être seulement un méchant.
- Il doit révéler l’hypocrisie de Ludo.

### Signaux précoces

- Nico peut être évoqué avant d’être actif.
- Il devient dangereux quand Marie manque de regard et que Ludo regarde ailleurs.
- Son score ne devrait pas être la route principale par défaut au démarrage.

## Macro-routes

### Exclusif / réparation

Ludo choisit de sauver le couple.

Effets :

- Mathilde devient tentation refusée.
- Sandra doit être coupée ou apaisée.
- Raphaëlle respecte la décision.
- Pauline reste suspecte.
- Nico est écarté.

### Tromperie secrète

Ludo cache une ou plusieurs relations.

Effets :

- Débloque vite des contenus.
- Augmente les preuves.
- Renforce Nico auprès de Marie.
- Fait fuir Raphaëlle à long terme.
- Peut faire fuir Sandra si elle découvre qu’elle n’est pas unique.

### Libertinage négocié

Ludo et Marie parlent de désir et posent des règles.

Effets :

- Pauline devient souvent initiatrice.
- Nico peut devenir rival consenti.
- Mathilde reste une limite délicate.
- Sandra est souvent incompatible.
- Marie devient active.

### Polyamour honnête

Le désir devient relation assumée, pas seulement jeu sexuel.

Effets :

- Raphaëlle devient très compatible.
- Sandra est possible mais difficile.
- Marie doit conserver une place reconnue.
- Nico peut devenir une symétrie pour Marie.

### NTR subi

Marie se rapproche de Nico parce que Ludo l’a négligée ou trahie.

Effets :

- Ludo perd sa place.
- Nico devient central.
- Marie se sent vue ailleurs.
- Ludo vit en miroir ce qu’il a fait subir.

### NTR consenti

Marie et Ludo transforment la jalousie en jeu contrôlé.

Effets :

- Marie reste centrale.
- Nico devient rival accepté ou partenaire de tension.
- La question est de savoir si Ludo consent vraiment ou s’il accepte par peur.

### Harem mensonger

Ludo tente de tout garder en secret.

Effets :

- Galerie riche.
- Relations instables.
- Pauline a du pouvoir.
- Raphaëlle coupe.
- Sandra fuit si elle comprend.
- Marie/Nico deviennent dangereux.

### Harem assumé

Ludo tente une dynamique relationnelle ouverte et claire.

Effets :

- Tout le monde ne peut pas rester.
- Marie doit être respectée.
- Raphaëlle exige la clarté.
- Sandra supporte mal l’exposition.
- Mathilde reste la limite la plus explosive.
- Nico peut devenir la symétrie de Marie.

## Système dominante / secondaire / menace

À partir du milieu du jeu, chaque partie doit être qualifiée ainsi :

```text
Dominante : personnage ou axe principal.
Secondaire : relation qui complique.
Menace : élément qui peut faire exploser.
Mode : règle relationnelle dominante.
```

Exemples :

```text
Dominante : Sandra
Secondaire : Raphaëlle
Menace : Nico
Mode : SECRET_AFFAIR
```

```text
Dominante : Mathilde
Secondaire : Nico
Menace : Marie
Mode : SECRET_AFFAIR
```

## Règle anti-précipitation

Une route ne doit pas être lisible parce qu’un personnage a écrit une fois. Elle devient lisible quand le joueur répète un comportement et accepte les conséquences associées.
