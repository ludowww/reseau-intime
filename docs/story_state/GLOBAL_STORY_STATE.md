# État global de l’histoire — V0.85

> Résumé opérationnel après remplacement du J1 legacy actif.  
> Le runtime est jouable jusqu’au jeudi soir, avec ordre temporel autoritaire et mardi désormais cohérent avec le canon.

## 1. Hiérarchie actuelle

```text
canon personnages
+ V0.78 architecture
+ V0.79 ouverture
= vérité narrative large

V0.83 flux temporel et source J1 réconciliée
= vérité corrective

V0.84
= runtime temporel actif

V0.85
= contenu mardi canonique actif

legacy Chapter 1–9
= historique technique sauf référence active explicite
```

## 2. Visibilité initiale

Au lancement :

```text
Mardi = actif
Mercredi = verrouillé
Jeudi = verrouillé
Vendredi = absent
```

Les jours suivants sont chargés techniquement mais restent inaccessibles jusqu’à la fin de la journée précédente.

## 3. Mardi — J1 réconcilié

```text
18:12 Marie / dîner, pain et marche
-> M1 à trois choix

19:15 ou 19:35
-> dîner et marche hors ligne

22:57 Sandra / ancienne photo floue
-> S1 à trois choix

23:25 ou 23:28
-> retour final vers Marie hors ligne

fin Mardi
-> Mercredi
```

### M1

```text
présent
joueur mais présent
retardé / plat
```

Le pain est formulé comme une action future : Player s’engage à le prendre, puis revient réellement avec dans le beat hors ligne.

### S1

```text
chaleur sûre
observation précise
prudence
```

Sandra partage une seule trace concrète, pose elle-même une limite douce, puis quitte l’échange.

### Ce qui a disparu du J1 actif

- `On est mercredi` pendant Mardi ;
- heures `24:xx` ;
- timestamps qui reculent ;
- longue progression lac/roman/manque ;
- déclaration `Moi aussi / Toi` ;
- scores numériques de confiance, négligence, vérité, attachement ou priorité ;
- fin de journée sur Sandra ;
- dizaines de boutons à réponse unique.

## 4. États J1

Flags observables uniquement :

```text
j1_marie_present
j1_marie_playful_present
j1_marie_delayed_flat
j1_shared_evening_due
j1_shared_evening_completed
j1_marie_return_active / delayed
j1_sandra_safe_warmth
j1_sandra_precise_observation
j1_sandra_cautious
j1_sandra_trace_complete
j1_marie_final_return_present / delayed
j1_day_complete
```

Aucun score de route n’est écrit.

## 5. Moments hors ligne

V0.85 ajoute deux phases sans conversation :

- dîner et marche ;
- retour final vers Marie.

Elles :

- sont sélectionnées selon les flags précédents ;
- utilisent l’interstitiel temporel ;
- appliquent leurs flags une seule fois ;
- sont enregistrées dans le journal de la journée ;
- apparaissent une seule fois dans l’archive sous `Moments hors ligne` ;
- ne deviennent jamais des bulles Messenger artificielles.

## 6. Mercredi actuel

```text
12:10 Marie / faire de la place
-> 18:18 Marie / trace d'arrivée
-> 18:22 Mathilde / arrivée
-> installation hors ligne
-> Mercredi terminé
-> Jeudi
```

Mathilde termine mercredi en :

```text
R1 Ordinary Access
stay active
aucune intention sexuelle
```

## 7. Jeudi actuel

```text
09:10 Raphaëlle obligatoire
-> 13:50 Sandra optionnelle
-> avancer explicitement
-> Sandra vue ou expirée
-> 16:05 Marie obligatoire
-> une branche O5
-> 22:10 retour Marie obligatoire
-> Jeudi terminé
```

L’ordre temporel V0.84 reste inchangé.

## 8. Progression des journées

```text
fin Mardi
-> MARDI — FIN DE JOURNÉE
-> MERCREDI — MIDI
-> Mercredi déverrouillé et sélectionné

fin Mercredi
-> MERCREDI — FIN DE JOURNÉE
-> JEUDI — MATIN
-> Jeudi déverrouillé et sélectionné

fin Jeudi
-> JEUDI — FIN DE JOURNÉE
-> la suite n'est pas encore disponible
```

## 9. Archives

Une journée terminée :

- reste consultable ;
- n’affiche aucun badge pending ;
- ne produit aucune notification ;
- n’offre aucun nouveau choix ;
- ne réapplique aucun effet ;
- ne change pas l’heure actuelle ;
- ne réactive pas une scène expirée ;
- filtre les fils persistants par épisode source ;
- affiche ses beats hors ligne en lecture seule.

## 10. État narratif après jeudi

```text
Marie/Player = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE
Sandra J1 = soft trace seed only
Mathilde = R1 domestique
Raphaëlle = R1 travail
Sandra jeudi = continuité douce ou écho expiré
Pauline = inactive
Nico = inactive
hard secrets = none
adult frames = none
Friday = not implemented
```

## 11. Fichiers actifs mardi

```text
game/data/conversations/chapter_01_marie_opening.json
game/data/conversations/chapter_01_sandra_trace.json
```

Les anciens fichiers `chapter_01_marie.json` et `chapter_01_sandra.json` restent sur disque mais sont inactifs.

## 12. Runtime ajouté

```text
game/scripts/ui/PhonePrototypeV085.gd
```

Extension minimale de V0.84 pour les phases hors ligne sans conversation et leur journal d’archive.

## 13. Validation

Nouveau test :

```text
tests/test_v085_j1_reconciliation_static.py
```

Les commandes Python et Godot doivent être exécutées par Hermes/local/CI avant merge.

## 14. Prochaine version

```text
V0.86 — Friday Public Traces & Opening Completion
```

## 15. Résumé opérationnel

```text
Runtime : jouable jusqu'à jeudi, ordre imposé.
J1 : réconcilié et centré sur Marie.
Sandra : une trace douce seulement.
Vendredi : toujours absent.
Prochaine étape : terminer l'ouverture V0.79 avec Pauline, Nico et la respiration du foyer.
```
