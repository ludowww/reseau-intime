# Matrice de continuité personnages — V0.79

> Résumé opérationnel du premier source pack modulaire post-J1.  
> Les fiches complètes, le blueprint V0.78, le source pack V0.79 et les cartes de scènes restent prioritaires.  
> Cette matrice ne crée aucun état runtime autonome.

## 1. Règle de lecture

```text
J1 = canon actuel et runtime aligné
ouverture Acte I = canon documentaire V0.79, runtime non intégré
suite Acte I / Actes II–V = architecture V0.78, contenu exact encore à écrire
anciens J2–J10 = historiques / techniques si contradiction
```

Avant une scène, vérifier :

- le mode du couple ;
- le stade de route ;
- la fenêtre ;
- les personnages réellement disponibles ;
- les connaissances ;
- les obligations ;
- l’origine et le public des images ;
- les conséquences dues ;
- la fonction spécifique du personnage.

## 2. Matrice de l’ouverture V0.79

| Personnage | État après J1 | Première présence V0.79 | Choix / variations | État à la fin du pack | Prochaine progression permise | Interdit dans V0.79 |
|---|---|---|---|---|---|---|
| **Marie** | Couple en `HABITUAL_WARMTH`, demande de petites présences concrètes. | O1 urgence Mathilde, O4 proposition La Verrière, O5A possible, O6 retour obligatoire. | Player fait de la place de manière proactive, joueuse ou passive ; il rejoint Marie, reste au foyer ou promet de venir après le travail ; la qualité de présence est mémorisée. | Couple toujours `HABITUAL_WARMTH`, avec candidat reconnexion ou dérive seulement. Marie a agi pour sa famille et son événement. | Nouvelle scène positive de vie commune, première mutation d’occasion manquée, autre cycle Acte I. | Grand discours de crise, jalousie comme seule fonction, pardon automatique, route externe remplaçant le retour vers elle. |
| **Sandra** | Photo floue J1, lien doux et non verrouillé. | Écho O3 possible après poste du matin. | Variante selon lecture J1 : ancienne photo mentionnée, remise dans le sac ou pas mentionnée si branche distante. | Trace active ou volontairement refroidie ; aucun nouveau visuel ; aucune obligation forte. | Autre scène work-afterglow ou trace concrète dans une fenêtre compatible. | Seconde photo, confession, rendez-vous forcé, impatience, pression, Jeff exposé trop tôt. |
| **Player** | Aime Marie, présence inégale, peut avoir lu Sandra précisément. | Tous les O1–O8 selon topologie. | Fait de la place ; accueille Mathilde ; gère une correction de travail ; choisit où être ; tient, modifie ou manque une promesse ; répond à Pauline et Nico. | Historique de présence, promesse et participation ; aucun secret ; aucune route choisie. | Accumulation de comportements, première répétition privée, premier R2 plus tard. | Menu de femmes, séducteur parfait, caméra passive, annulation d’une conséquence par un nouveau choix. |
| **Mathilde** | Indirecte seulement. Séjour non actif. | O2 arrivée obligatoire ; O5B si Player reste ; respiration foyer. | Accueil pratique, joueur ou distant ; aide avec la chambre ou le chargeur ; aucune intention sexuelle. | Séjour actif 10–15 jours ; R1 domestique ; confiance ordinaire variable ; Marie reste le pont familial. | Cuisine du matin, chambre d’appoint, travail, anecdote familiale, première différence entre regard ordinaire et attention chargée. | Selfie canapé, provocation choisie, photo adulte, tenue interprétée comme consentement, secret avec Player. |
| **Raphaëlle** | Collègue connue, aucun canal intime. | O3 revue du dossier bleu ; O5C possible autour d’une vraie obligation. | Player corrige, plaisante puis agit, ou reporte ; plus tard il tient, modifie ou manque sa promesse à Marie. | R1 travail ; confiance professionnelle variable ; aucun accès privé. | Marche ordinaire, détail de housse, autre collaboration, puis seulement plus tard version hors bureau. | Badge/photo personnelle obligatoire, thérapeute, refuge, compte créatif, séduction après une seule confidence. |
| **Pauline** | Absente active ; couple avec Bastien et ancienne infidélité en background. | O5A écho possible ; O7 relais de photos publiques autorisées. | Player choisit pratiquement, plaisante ou rend la décision à Marie. | R1 social ; Bastien visible ; set photo public connu ; aucun compartiment privé. | Nouveau relais social ou logistique ; private selectivity seulement après un autre cycle et de nouvelles conditions. | Crop privé, one-view, preuve réciproque, flirt secret, Bastien effacé, photo publique sexualisée sans permission. |
| **Nico** | Ami réel en background ; attirances existantes mais non actives. | O5A écho possible ; O8 suivi de la place gardée. | Player répond honnêtement, plaisante ou demande comment allait Marie. Nico peut apprendre le séjour de Mathilde. | R1 amitié/social ; aucune rivalité ou complicité voyeuriste active. | Scène ordinaire L’Annexe ou billard ; plus tard seulement envie domestique et regard partagé. | Commentaire sexuel, demande d’image, alibi, pacte photo, NTR/cuckold, contact Nico/Player supposé. |

## 3. Fenêtres et priorités

```text
O1 — Marie / faire de la place
O2 — Mathilde / arrivée
O3 — Raphaëlle / travail + écho Sandra possible
O4 — Marie / proposition topologique
O5A — Marie social
OU O5B — Mathilde foyer
OU O5C — Raphaëlle travail
O6 — conséquence Marie obligatoire
O7 — Pauline photo publique
O8 — Nico place gardée + respiration foyer
```

Priorité locale :

```text
ancrage du tronc
-> branche topologique
-> retour vers Marie
-> accès ordinaire Pauline / Nico
-> échos / respiration
```

La conséquence O6 ne peut pas être remplacée par une nouvelle opportunité.

## 4. État du couple

### Dimensions lues par V0.79

- présence ;
- promesse ;
- participation domestique ;
- initiative sociale ;
- vérité encore implicite ;
- cadre exclusif supposé.

### Modes

Mode actuel :

```text
HABITUAL_WARMTH
```

Candidats possibles :

```text
ACTIVE_RECONNECTION
PARALLEL_DRIFT
```

Aucun candidat ne devient un mode final dans ce pack.

### Exemples

```text
faire de la place activement
+ venir tôt
+ aider sans seconde demande
= candidat reconnexion

assentiment passif
+ absence sociale
+ promesse décorative
= candidat dérive
```

Un événement isolé ne suffit pas.

## 5. Traces actuelles

| Trace | Origine | Public prévu | Fonction actuelle | Risque actuel |
|---|---|---|---|---|
| `mathilde_arrival_room_01` | Marie, photo ouverte | Player uniquement | preuve pratique de l’installation | faible tant qu’elle n’est ni transmise ni sexualisée |
| `raphaelle_blue_folder` | travail, optionnel | Player / contexte professionnel | couleur UX et dossier | nul hors mauvaise utilisation du canal |
| `marie_laverriere_setup_01` | Élodie ou Pauline avec accord | événement / Player / archive | Marie active dans sa vie | faible ; ne prouve aucune route |
| `laverriere_public_group_photo_set_01` | Pauline via télécommande | groupe photographié + La Verrière | accès public Pauline, mémoire sociale | faible ; transmission adulte non autorisée |
| photo floue Sandra J1 | Sandra | Player | continuité douce | aucune nouvelle diffusion |

Aucune trace adulte n’existe.

## 6. Connaissances après V0.79

### Marie

Sait :

- Mathilde séjourne chez eux ;
- qualité de participation de Player ;
- présence ou absence de Player au vernissage ;
- Pauline a créé les photos publiques ;
- Nico a gardé une table.

Ne sait pas parce que cela n’existe pas encore :

- route externe ;
- pacte photo ;
- secret adulte.

### Mathilde

Sait :

- Marie et Player l’hébergent ;
- qualité de l’accueil de Player ;
- Marie a envoyé la photo d’arrivée à Player.

Ne sait pas / n’a pas encore à savoir :

- attraction active de Nico ;
- circulation d’image ;
- tension sexuelle avec Player.

### Raphaëlle

Sait :

- Player travaille avec elle ;
- éventuellement qu’il doit rejoindre Marie, uniquement s’il le dit en O5C.

Ne sait pas :

- détails privés du couple ;
- autres routes ;
- séjour de Mathilde sauf conversation professionnelle ordinaire ultérieure.

### Pauline

Sait :

- Marie organise l’événement ;
- qui apparaît sur les photos publiques ;
- Player participe ou choisit une photo selon sa branche.

Ne sait pas :

- désir privé de Player ;
- photo pact Nico ;
- route active, car aucune n’existe.

### Nico

Sait :

- déroulement social général ;
- présence ou absence de Player ;
- éventuellement que Mathilde séjourne au foyer via source crédible.

Ne sait pas :

- détails de vêtements domestiques ;
- images privées ;
- désir reconnu par Player.

### Sandra

Sait :

- la qualité du dernier échange J1 ;
- que le fil est encore ouvert ou refroidi.

Ne sait rien des nouvelles présences du foyer sauf information future crédible.

## 7. Consentement et images

V0.79 ne crée aucun cadre adulte.

Images :

- photographiées avec connaissance ;
- fonctions pratiques, professionnelles ou sociales ;
- publics explicitement limités ;
- aucune permission implicite de sexualisation ou transfert.

```text
Une photo publique n'est pas une permission de recadrage sexuel.
Une photo de foyer n'est pas une permission de transmission.
```

## 8. Interactions transversales

### Marie / Mathilde

- urgence familiale et hébergement ;
- confiance active ;
- Mathilde choisit elle-même de rester au foyer lors du vernissage ;
- aucune menace sexuelle installée.

### Marie / Pauline

- confiance sociale ;
- Pauline aide au set photo ;
- aucun second public privé.

### Marie / Nico

- Nico soutient l’après-événement ;
- son regard extérieur reste en background ;
- aucune jalousie canonisée.

### Player / Raphaëlle / Marie

- le travail est une vraie obligation ;
- Raphaëlle ne retient pas Player ;
- la promesse à Marie appartient à Player ;
- Raphaëlle ne devient pas une excuse.

### Player / Mathilde / Marie

- la branche foyer teste la présence pratique ;
- elle ne transforme pas Mathilde en récompense d’avoir décliné Marie ;
- le retour O6 garde Marie centrale.

## 9. Personnages secondaires

| Personnage | Usage V0.79 | Garde-fou |
|---|---|---|
| Bastien | visible dans le groupe / la photo publique | reste partenaire réel de Pauline ; pas d’ignorance sexualisée |
| Élodie | couleur La Verrière, possible photographe du setup | pas de route, pas de réseau omniscient |
| Jeff | non requis dans cette ouverture | reste humain dans Sandra canon ; aucune exposition forcée |

## 10. Ancien J2 — statut

Les anciennes continuités suivantes sont historiques :

- Player hors maison toute la journée ;
- retour physique réservé à J3 ;
- quatre visuels fixes ;
- Raphaëlle badge/photo obligatoire ;
- Mathilde selfie canapé ;
- Pauline/Nico interdits par numéro de jour ;
- fil linéaire unique Marie → Raphaëlle → Mathilde → Sandra → canapé.

Elles ne doivent pas être utilisées comme contraintes du plan runtime V0.80.

## 11. Prochaine utilisation

Avant V0.80, relire :

```text
docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_OPENING_SCENE_CARDS.md
docs/canon/MODULAR_NARRATIVE_ARC_BLUEPRINT.md
docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md
docs/canon/CHOICE_DESIGN_CANON.md
```

Prochaine étape :

```text
V0.80 — First Modular Runtime Integration Plan
```
