# Réseau Intime — Baseline runtime Saison 1 J01–J04 et contrat d’intégration J05–J21

## Statut

**Catégorie : `ACTIVE_RUNTIME` — contrat technique actif**

**Base validée : `5a6a832c148c68ee69d8991474ec778f33bc456d`**

**Tag de verrouillage : `runtime-s1-04-j04-playable`**

**Périmètre : chaîne portrait jouable J01→J04, règles communes validées et contrat obligatoire pour J05→J21**

**Autorité d’exécution : code, données et tests présents sur `main`**

**Supersède : `docs/runtime/SEASON_1_J01_J03_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md`**

Ce document ne modifie ni la Bible Narrative, ni les dialogues signés, ni les registres, ni les paquets NAR-PROD. Il décrit l’état réellement exécuté et les règles de continuité imposées aux prochaines journées.

---

# 1. État réel de la Saison 1

| Journées | Canon narratif | Runtime portrait | Statut |
|---|---|---|---|
| J01 | signé | intégré et validé | jouable |
| J02 | signé | intégré après J01 | jouable |
| J03 | signé | intégré après J02 | jouable |
| J04 | signé | intégré après J03 | jouable |
| J05–J21 | signé et préparé par paquets | non intégré dans la chaîne active | à intégrer par lots courts |

La chaîne jouable active est :

```text
J01 → J02 → J03 → J04
```

L’Acte I J01–J04 est donc jouable dans le nouveau runtime portrait. Les anciens index, JSON ou rapports couvrant J05+ restent historiques tant qu’ils ne sont pas explicitement adaptés dans cette chaîne.

---

# 2. Architecture active obligatoire

## 2.1 Orchestrateur de saison

`game/scripts/runtime/season_1/Season1RuntimeProvider.gd` reste l’unique point d’entrée de la Saison 1.

Il possède :

- le `Season1State` partagé ;
- le provider actif de la journée ;
- les handoffs J01→J04 ;
- les transcripts, messages produits, fils et contenus Galerie cumulatifs ;
- le temps narratif courant ;
- les transitions en attente ;
- le snapshot global et sa restauration.

J05 et les journées suivantes doivent prolonger cet orchestrateur. Elles ne créent jamais une seconde chaîne de saison.

## 2.2 Provider borné par journée

Chaque journée intégrée possède au minimum :

```text
JXXRuntimeProvider.gd
jXX_runtime_map.json
sources canoniques citées
test statique dédié
smoke jouable dédié
handoff depuis la journée précédente
snapshot / restore
```

Le `runtime_map` adapte le canon au runtime. Il ne devient pas une source narrative concurrente.

## 2.3 Handoff cumulatif

À chaque changement de journée sont transmis sans reconstruction destructive :

```text
transcripts_by_thread
produced_message_ids
unlocked_thread_ids
gallery_asset_ids lorsque pertinent
Season1State partagé
snapshots des providers traversés
```

Conséquences :

- les fils gardent leur historique ;
- aucun message n’est produit deux fois ;
- un fil débloqué reste disponible sauf règle canonique explicite ;
- les contenus Galerie déjà acquis restent représentables ;
- la restauration reproduit le même parcours.

---

# 3. Règles communes verrouillées

## 3.1 Temps narratif

- le provider possède `current_time_minutes` ;
- l’heure ne peut jamais reculer ;
- le choix Player prend l’heure au moment de son acceptation ;
- un message présenté peut avancer l’heure, jamais la faire régresser ;
- l’UI affiche le contexte courant sans posséder une horloge concurrente ;
- les transitions restent en temps réel.

## 3.2 Historique et séparateurs

Chaque présentation porte un `source_day` exact.

Le rendu commun garantit :

- un seul séparateur par journée et par fil ;
- le séparateur avant le premier message de la journée ;
- les libellés calendaires continus à partir de J01 mardi ;
- aucun auteur ni timestamp sur le séparateur ;
- aucun `SYSTEM_DAY_DIVIDER` rendu comme bulle.

## 3.3 Livraison des messages

Le flux commun assure :

- ajout du choix Player comme message réel ;
- typing isolé par conversation ;
- livraison progressive ;
- remplacement atomique du typing ;
- conservation du scroll et du focus ;
- absence de doublon ;
- reprise correcte après changement de fil ;
- teardown propre des coroutines dans les smokes.

## 3.4 Règle commune des non-lus

`game/scripts/runtime/season_1/RuntimeUnread.gd` est l’autorité technique commune pour J01–J04 et les futures journées.

Un message entrant ajouté dans un fil fermé ou avant l’ouverture du fil est non lu jusqu’à sa présentation effective.

Dans la liste des conversations :

### Fil non lu

- nom en `TEXT_PRIMARY` ;
- nom en gras fort ;
- aperçu remplacé par **« Nouveau message ! »** ;
- aperçu en `TEXT_PRIMARY` et gras fort ;
- `variation_embolden = 1.5` ;
- heure réelle conservée ;
- aucun badge ni compteur.

### Fil lu

- nom en graisse normale ;
- véritable `last_preview` restauré ;
- aperçu en `TEXT_SECONDARY` ;
- aucun badge.

Règles :

- fermer une notification ne marque rien comme lu ;
- une transition `NEW_DAY` ne marque rien comme lu ;
- ouvrir un autre fil ne change pas l’état du fil non lu ;
- un lot devient lu après présentation complète ;
- un message livré dans le fil déjà ouvert devient lu après présentation ;
- plusieurs messages en attente restent un état booléen visible, jamais un compteur.

## 3.5 Notifications neutres

Les notifications narratives utilisent :

```text
Titre : nom du contact ou du groupe
Corps : Nouveau message !
```

Le corps est en gras. Aucun extrait narratif ni nombre de messages n’est affiché.

Le clic ouvre le bon fil. Le dismissal conserve l’état non lu. La règle `latest pending wins`, l’isolation inter-fil et la durée réelle indépendante de `×1 / ×3 / ×8` restent obligatoires.

## 3.6 Vitesse de lecture

`×1 / ×3 / ×8` contrôle uniquement :

- le typing ;
- les délais de saisie ;
- les délais entre messages.

La vitesse ne contrôle jamais :

- `CLOCK` ;
- `OFF_PHONE` ;
- `NIGHT` ;
- `NEW_DAY` ;
- `CONTENT_END` ;
- les notifications ;
- le `PhotoViewer`.

## 3.7 Transitions

Les phases overlay sont :

```text
CLOCK
OFF_PHONE
NIGHT
NEW_DAY
```

`DECISION` et `CONTENT_END` restent des cartes hors overlay. Le provider expose la transition ; l’UI la rend puis rappelle l’action de reprise autorisée.

---

# 4. Spécificités J04 verrouillées

## 4.1 Fils et handoff

J04 ajoute Pauline et Nico sans perdre Marie, Sandra, Mathilde ou Raphaëlle.

Après la séquence Pauline :

- le joueur reste dans Pauline ;
- Nico est débloqué ;
- une notification neutre permet d’ouvrir Nico.

Après la séquence Nico :

- le joueur reste dans Nico ;
- Marie et Mathilde reçoivent leurs lots indépendants ;
- seule la notification Marie est affichée ;
- l’ordre Marie→Mathilde ou Mathilde→Marie reste valide ;
- la fermeture J04 exige la présentation complète des deux lots.

## 4.2 PHOTO_SET Pauline

Le contenu Pauline est un seul `PHOTO_SET` avec trois enfants :

```text
FRAME_01
FRAME_02
FRAME_03
```

Le placeholder affiche **« Set de 3 photos non produit »**.

La frame 1 est explicitement écartée dans le dialogue :

```text
La 1, on regarde tous la télécommande.
```

Les choix restent :

- frame 2 retenue ;
- frame 3 demandée, mais frame 2 finalement conservée ;
- sélection laissée à Marie, donc résultat non établi à ce stade.

Aucun quatrième choix pour la frame 1 n’est ajouté.

---

# 5. Snapshot et restauration

La baseline globale persiste :

```text
active_day
Season1State
provider_snapshots
```

Chaque intégration doit :

1. versionner son snapshot ;
2. restaurer un état cohérent ;
3. préserver les providers précédents ;
4. préserver messages, fils, heure, Galerie et non-lus ;
5. empêcher toute duplication ;
6. migrer explicitement une version précédente lorsqu’elle reste supportée.

---

# 6. Contrat d’intégration J05–J21

Avant le code :

- lire les dialogues consolidés ;
- lire le paquet NAR-PROD de l’acte ;
- lire les registres de traces, promesses, connaissances et atteignabilité ;
- lister uniquement les états nécessaires ;
- distinguer texte, image de scène, photo diégétique et fait sans image ;
- définir les fils, horaires et transitions exacts.

Dans le provider :

- reprendre les données cumulatives ;
- produire `source_day` ;
- utiliser `RuntimeUnread` ;
- passer par les flux communs Messages, notifications et transitions ;
- fournir snapshot et restauration ;
- ne créer aucun score, owner, candidate pool ou système parallèle.

Dans l’orchestrateur :

- ajouter le provider ;
- ajouter le handoff depuis la journée précédente ;
- préserver J01–J04 ;
- étendre snapshot et restauration ;
- conserver les présentations de début et de fin de journée.

---

# 7. Validation minimale d’une nouvelle journée

```text
validation des données
simulation des routes
test statique du provider et du runtime_map
smoke jouable de la journée
handoff depuis la journée précédente
snapshot / restore
transcripts cumulés et absence de doublons
temps narratif et source_day
non-lus et notifications
transitions en temps réel
responsive portrait
teardown sans ObjectDB / leaked / orphan
gate globale comparée par identité exacte
validation visuelle utilisateur
```

Les non-régressions J01, J02, J03, J04, 03B, 03C et UI-MSG-04A à 04C restent obligatoires.

---

# 8. Prochaine intégration

Le prochain lot recommandé est J05 seul depuis :

```text
main
5a6a832c148c68ee69d8991474ec778f33bc456d
runtime-s1-04-j04-playable
```

Branche recommandée :

```text
work/runtime-s1-05-j05-playable
```

J05 doit ouvrir l’Acte II sans rouvrir le cœur UI, sans réécriture narrative générale et sans migration simultanée de J06–J21.