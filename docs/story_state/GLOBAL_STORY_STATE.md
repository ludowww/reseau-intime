# État global de l’histoire — V0.83

> Résumé opérationnel après audit du flux temporel et de J1.  
> V0.82 reste le runtime jouable actuel. V0.83 est documentaire et suspend l’intégration du vendredi.

## 1. Hiérarchie actuelle

```text
canon personnages
+ V0.78 architecture
+ V0.79 ouverture
= vérité narrative large

V0.83 flux temporel
+ V0.83 source J1 réconciliée
= vérité corrective actuelle

V0.81–V0.82
= runtime jouable mardi–jeudi

V0.84–V0.85
= prochaines implémentations

legacy Chapter 1–9
= historique technique inactif sauf référence explicite
```

## 2. Runtime actuellement jouable

```text
Mardi
Mercredi
Jeudi
```

État après jeudi :

```text
Mathilde = R1 domestique
Raphaëlle = R1 travail
Sandra = continuité douce
Marie/Player = HABITUAL_WARMTH
hard secrets = none
adult frames = none
Friday = not implemented
```

## 3. Dette temporelle confirmée

Le runtime actuel présente les trois jours dès le lancement.

Le joueur peut donc :

- ouvrir Mercredi avant de terminer Mardi ;
- ouvrir Jeudi avant de terminer Mercredi ;
- revenir dans un ancien jour sans distinction claire entre archive et présent ;
- voir plusieurs heures disponibles simultanément.

Cible V0.84 :

```text
Mardi actif
Mercredi verrouillé
Jeudi verrouillé

fin Mardi
-> interstitiel
-> Mercredi déverrouillé et sélectionné

fin Mercredi
-> interstitiel
-> Jeudi déverrouillé et sélectionné
```

## 4. Interstitiels temporels

Transition de jour :

```text
MARDI — FIN DE JOURNÉE

MERCREDI — MIDI
Faire de la place
```

Transition intrajournalière :

```text
JEUDI — DÉBUT D'APRÈS-MIDI
13:50
```

ou :

```text
JEUDI — FIN D'APRÈS-MIDI
16:05
```

Ces cartes doivent être courtes, lisibles, skippables après un délai minimal, et bloquer l’accès aux conversations futures tant qu’elles ne sont pas terminées.

## 5. Phases temporelles

Jour :

```text
LOCKED
AVAILABLE
ACTIVE
COMPLETE
ARCHIVED
```

Phase :

```text
LOCKED
CURRENT
COMPLETE
SKIPPED
EXPIRED
```

Règle :

```text
les timestamps décrivent le temps
les phases autorisent l'accès
```

## 6. Correction du jeudi

Comportement actuel :

```text
Raphaëlle terminée
-> Sandra 13:50 et Marie 16:05 disponibles ensemble
```

Cible V0.84 :

```text
09:10 Raphaëlle obligatoire
-> 13:50 Sandra optionnelle
-> avancer explicitement
-> Sandra vue ou expirée
-> 16:05 Marie obligatoire
-> une branche O5
-> 22:10 retour Marie obligatoire
-> jeudi terminé
```

Si Sandra est ignorée, elle ne reste pas répondable après 16:05.

## 7. Dette J1 confirmée

Le Mardi actif utilise encore deux gros fichiers legacy, simplement filtrés.

Problèmes confirmés :

- une ligne dit `On est mercredi` pendant Mardi ;
- les heures reculent dans les fils ;
- la soirée se termine sur Sandra ;
- le dîner et la marche ne sont pas représentés hors ligne ;
- Sandra va trop loin émotionnellement ;
- anciens scores numériques actifs ;
- trop de clics à choix unique ;
- le texte diverge du source V0.69.

## 8. J1 cible

```text
18:12 Marie à distance
-> dîner / pain / marche
-> M1 trois postures
-> La Verrière / Mathilde indirecte

19:15 dîner et marche hors ligne

22:57 Sandra / photo floue
-> S1 trois postures
-> limite douce

23:25 retour final Marie / vie commune hors ligne

fin Mardi
-> transition
-> Mercredi
```

M1 :

```text
présent
joueur-présent
retardé/plat
```

S1 :

```text
chaleur sûre
observation précise
prudence
```

Aucun score d’attachement, désir, priorité ou négligence.

## 9. État des personnages après la future correction J1

### Marie

- ouverture domestique concise ;
- La Verrière visible ;
- action hors ligne réellement accomplie ;
- dernier beat obligatoire de la journée.

### Sandra

- une seule trace ;
- une limite douce ;
- aucune scène lac/roman/manque profond ;
- aucune route R2.

### Mathilde

- indirecte mardi ;
- urgence et arrivée mercredi inchangées.

### Raphaëlle

- jeudi travail inchangé.

### Pauline / Nico

- toujours absents du runtime ;
- vendredi reporté à V0.86.

## 10. Prochaines versions

```text
V0.84 — Day & Moment Flow Runtime Foundation
V0.85 — J1 Canon Runtime Reconciliation
V0.86 — Friday Public Traces & Opening Completion
```

## 11. Périmètre V0.84

- verrouillage/déverrouillage des jours ;
- phases ;
- interstitiels ;
- archives en lecture seule ;
- expiration des scènes optionnelles ;
- correction Sandra 13:50 -> Marie 16:05 ;
- aucun nouveau dialogue.

## 12. Périmètre V0.85

- nouveaux fichiers J1 actifs ;
- deux choix à trois réponses ;
- deux beats hors ligne ;
- flags seulement ;
- fin obligatoire sur Marie ;
- aucun changement mercredi/jeudi.

## 13. Résumé opérationnel

```text
Runtime actuel : jouable jusqu'à jeudi, mais temps réarrangeable.
J1 actuel : jouable, mais non cohérent avec le canon consolidé.
V0.83 : correction documentaire.
V0.84 : rendre le temps autoritaire.
V0.85 : reconstruire mardi.
V0.86 : reprendre vendredi.
```
