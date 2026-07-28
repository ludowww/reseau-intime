# Réseau Intime — Baseline runtime Saison 1 J01–J03 et contrat d’intégration J04–J21

## Statut

**Catégorie : `ACTIVE_RUNTIME` — contrat technique actif**

**Base validée : `c27bd9331c01bed6c9a40c0c642d246cf26bb6cf`**

**Tag stable : `ui-msg-04c-interactive-notifications`**

**Périmètre : chaîne jouable portrait J01→J03, corrections runtime/UI validées et règles obligatoires pour l’intégration de J04 à J21**

**Autorité : le code, les données et les tests présents sur `main` restent la vérité d’exécution ; ce document en donne le contrat de continuité**

**Supersède : les descriptions de l’état runtime J01–J03 antérieures à la nouvelle chaîne `Season1RuntimeProvider`, notamment les observations runtime historiques du document `docs/canon/bible/12_PLANS_SCENES_AUDIT_RUNTIME_J01_J08.md`**

Ce document ne modifie ni la Bible Narrative, ni les dialogues signés, ni les registres, ni les paquets NAR-PROD. Il décrit comment le corpus canonique est exécuté dans le runtime portrait et comment les journées suivantes doivent prolonger cette architecture sans réintroduire les défauts corrigés.

---

# 1. État réel de la Saison 1

| Journées | Canon narratif | Nouveau runtime portrait | Statut technique |
|---|---|---|---|
| J01 | signé | intégré et validé | jouable |
| J02 | signé | intégré et validé après J01 | jouable |
| J03 | signé | intégré et validé après J02 | jouable |
| J04–J21 | signé et préparé par paquets de production | non intégré dans la nouvelle chaîne | à intégrer par blocs courts |

Les anciens matériaux runtime J04+ peuvent servir de repères historiques ou de localisation, mais ne sont jamais une source autoritative. Une future intégration repart du corpus signé, des registres, du contrat d’état et de la présente baseline.

---

# 2. Architecture désormais obligatoire

## 2.1 Orchestrateur de saison

`game/scripts/runtime/season_1/Season1RuntimeProvider.gd` est le point d’entrée de la chaîne jouable.

Il possède notamment :

- un `Season1State` partagé ;
- un provider borné par journée ;
- `active_day` et `active_provider` ;
- les handoffs entre journées ;
- l’exposition des présentations Messages et Galerie ;
- le temps narratif courant ;
- les transitions en attente ;
- le snapshot global et sa restauration.

J04 et les journées suivantes doivent être ajoutées à cet orchestrateur ou à une évolution explicitement compatible. Elles ne doivent pas créer une seconde chaîne de saison parallèle.

## 2.2 Provider borné par journée

Chaque journée intégrée possède :

```text
JXXRuntimeProvider.gd
jXX_runtime_map.json
sources narratives canoniques citées
smoke jouable dédié
test statique dédié
```

Le provider :

- charge uniquement les conversations nécessaires à la journée ;
- applique les choix au `Season1State` partagé ;
- produit les présentations UI ;
- gère ses phases bornées ;
- expose les transitions sans piloter directement l’interface ;
- fournit un snapshot versionné ;
- refuse les restaurations incohérentes.

Le `runtime_map` est une table d’adaptation bornée. Il ne devient pas une nouvelle source narrative.

## 2.3 Handoff cumulatif

À chaque changement de journée, les éléments suivants sont transmis sans reconstruction destructive :

```text
transcripts_by_thread
produced_message_ids
unlocked_thread_ids
gallery_asset_ids lorsque pertinent
Season1State partagé
snapshots des providers déjà traversés
```

Conséquences obligatoires :

- un fil conserve son historique sur plusieurs jours ;
- un message ne peut pas être produit deux fois ;
- un fil déjà débloqué reste disponible sauf règle canonique explicite ;
- une image déjà débloquée reste représentable selon son état ;
- la restauration reconstruit exactement le même parcours.

---

# 3. Corrections J01–J03 qui deviennent des règles communes

Les correctifs apportés pendant l’intégration J01–J03 et les lots UI-MSG-04A à 04C ne sont pas des exceptions locales. Ils constituent la baseline commune de toutes les journées futures.

## 3.1 Temps narratif autoritaire

- le provider possède `current_time_minutes` ;
- l’heure ne peut jamais reculer ;
- l’horodatage d’un choix Player est capturé au moment de son acceptation ;
- un message présenté peut faire avancer l’heure, jamais la faire régresser ;
- le bandeau de conversation affiche le contexte courant, pas le jour visible au scroll ;
- les transitions temporelles sont demandées par le runtime et rendues par l’UI.

Aucune journée future ne doit calculer une heure concurrente dans un composant visuel.

## 3.2 Historique et séparateurs de journée

Chaque présentation de message doit porter un `source_day` exact.

Le rendu commun garantit :

- un seul séparateur par `source_day` et par fil ;
- le séparateur avant le premier message de la journée ;
- les libellés historiques `Mardi`, `Mercredi`, `Jeudi`, puis les jours suivants selon le calendrier canonique ;
- aucun auteur ni timestamp sur le séparateur ;
- aucun `SYSTEM_DAY_DIVIDER` rendu comme bulle ;
- les anciens textes de type « FIN DE JOURNÉE » ignorés comme présentation visible.

Une future journée fournit `source_day`. Elle ne fabrique pas manuellement ses séparateurs dans le transcript.

## 3.3 Livraison des messages

Le flux commun Messages assure :

- ajout du choix Player comme message réel ;
- typing isolé par conversation ;
- livraison progressive des réponses ;
- remplacement atomique du typing par le message ;
- conservation du scroll et du focus ;
- absence de doublons lors d’un retour dans le fil ;
- reprise correcte après changement rapide de conversation ;
- drainage propre des coroutines dans les smokes.

Une future journée ne doit pas contourner la livraison commune en injectant directement des bulles dans l’UI.

## 3.4 Notifications interactives

Les notifications runtime :

- sont émises par un résultat ou une transition du provider ;
- apparaissent dans le bandeau de conversation ;
- ouvrent le fil concerné ;
- respectent le pending/unread réel ;
- ne déplacent pas durablement le contenu ;
- restent isolées par conversation ;
- sont nettoyées lors d’un changement de journée ou d’une invalidation du flux.

Les providers futurs fournissent des données de notification ; ils ne créent pas leur propre composant de notification.

## 3.5 Portée de la vitesse de lecture

`×1 / ×3 / ×8` contrôle uniquement :

- le `TypingIndicator` ;
- les délais de saisie ;
- les délais entre messages.

La vitesse ne contrôle jamais :

- `CLOCK` ;
- `OFF_PHONE` ;
- `NIGHT` ;
- `NEW_DAY` ;
- les transitions ;
- l’auto-dismiss des notifications ;
- `CONTENT_END` ;
- le `PhotoViewer`.

Les transitions restent en temps réel. Aucun provider futur ne doit réintroduire un multiplicateur de vitesse dans `TimePassageOverlay`.

## 3.6 Transitions unifiées

Les phases jouées par `TimePassageOverlay` sont exactement :

```text
CLOCK
OFF_PHONE
NIGHT
NEW_DAY
```

`DECISION` et `CONTENT_END` restent des flux de carte `DayTransition` hors overlay. Ils sont eux aussi indépendants de la vitesse de lecture.

Le provider expose une transition ou `pending_transition_flow`. L’UI route les phases vers l’overlay ou la carte appropriée, puis rappelle l’action de reprise autorisée.

Les journées futures doivent :

- décrire les phases dans les données runtime ;
- conserver une action de reprise explicite ;
- empêcher les choix pendant une transition active ;
- ne jamais muter la journée à moitié ;
- produire un état restaurable avant et après la transition.

---

# 4. Snapshot et restauration

La baseline globale utilise un snapshot de saison versionné contenant :

```text
active_day
Season1State
provider_snapshots
```

Règles obligatoires :

1. le `Season1State` partagé est restauré une seule fois ;
2. chaque provider possède son snapshot versionné ;
3. les providers précédents restent reconstruisibles pour préserver les transcripts cumulés ;
4. une phase restaurée doit être compatible avec sa transition en attente ;
5. les identifiants produits empêchent toute duplication ;
6. l’heure restaurée doit être valide et monotone ;
7. les animations et états purement visuels ne deviennent pas des faits narratifs persistés.

Toute intégration de journée doit étendre le snapshot global et ajouter un test de reprise avant d’être considérée comme terminée.

---

# 5. Contrat d’intégration obligatoire pour J04 et suivantes

## Avant le code

- identifier les dialogues consolidés autoritatifs ;
- lire le paquet NAR-PROD de l’acte ;
- lire les registres de traces, promesses, connaissances et atteignabilité ;
- lister les états `Season1State` réellement nécessaires ;
- distinguer texte, image de scène, photo diégétique et fait sans image ;
- définir les phases et horaires exacts ;
- confirmer les fils conservés, débloqués ou archivés.

## Dans le provider

- reprendre les transcripts cumulés ;
- reprendre `produced_message_ids` ;
- reprendre les fils débloqués ;
- reprendre les identifiants Galerie nécessaires ;
- utiliser le temps narratif partagé ;
- produire `source_day` sur chaque présentation ;
- passer par la livraison Messages commune ;
- passer par le flux de transitions commun ;
- utiliser les notifications communes ;
- fournir un snapshot versionné et validé ;
- ne créer aucun score de route, owner, candidate pool ou système parallèle.

## Dans l’orchestrateur

- ajouter le provider à la chaîne ;
- ajouter le handoff depuis la journée précédente ;
- ajouter le snapshot et la restauration ;
- ajouter les présentations de début et de fin de journée ;
- conserver les anciennes journées jouables ;
- ne pas casser une sauvegarde de la version courante sans migration explicitement décidée.

---

# 6. Validation minimale par nouvelle journée

Chaque nouvelle journée exige au minimum :

```text
1 test statique du provider et du runtime_map
1 smoke jouable de la journée
1 smoke de handoff depuis la journée précédente
1 test snapshot / restore aux phases sensibles
1 contrôle des transcripts cumulés et des doublons
1 contrôle du temps narratif et des source_day
1 contrôle des notifications et non-lus
1 contrôle des transitions en temps réel
1 contrôle responsive portrait
la gate globale comparée par identité exacte
```

Les smokes J01, J02, J03, 03B, 03C et UI-MSG-04A à 04C restent des non-régressions obligatoires. Une nouvelle journée ne peut être validée en ne testant que son écran final.

---

# 7. Sens exact de « répercuté automatiquement »

Les corrections communes sont automatiquement héritées lorsqu’une nouvelle journée :

- est branchée sur `Season1RuntimeProvider` ;
- produit le schéma de présentation attendu ;
- utilise `MessagesScreen`, `MessageTimeline`, `NotificationBanner` et `TimePassageOverlay` ;
- respecte le handoff cumulatif et le snapshot commun.

Elles ne sont pas automatiquement héritées si un provider :

- construit directement des bulles ;
- fabrique ses propres séparateurs ;
- possède une horloge concurrente ;
- accélère ses transitions avec la vitesse de lecture ;
- réinitialise les transcripts ;
- contourne le flux de notification ;
- reprend les anciens index historiques comme architecture active.

La règle de projet est donc :

```text
corriger une fois dans la couche commune
→ verrouiller par tests
→ obliger toutes les journées suivantes à passer par cette couche
```

---

# 8. Prochaine intégration

Le prochain bloc recommandé est J04 seul, depuis :

```text
main / ui-msg-04c-interactive-notifications
c27bd9331c01bed6c9a40c0c642d246cf26bb6cf
```

J04 doit prolonger J03 sans réécriture narrative, sans nouveau système global et sans réactivation automatique des anciens index modulaires. Une fois J04 verrouillé, l’intégration peut continuer par blocs courts alignés sur les actes : J05–J08, J09–J12, J13–J16, puis J17–J21, avec validation à chaque étape.
