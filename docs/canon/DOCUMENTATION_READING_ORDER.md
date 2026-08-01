# Documentation Reading Order — Réseau Intime

> **Phase active : corpus J01–J21 signé, runtime Saison 1 J01–J21 présent, J11 A5 verrouillé**

```text
Bible Narrative / North Star : autorité active
Corpus J01–J21 : consolidé et signé
Paquets NAR-PROD Actes I–V : READY
Runtime portrait : J01→J21 présent dans la chaîne commune
Baseline runtime : fa2880c1ad168569b148ed85bedf4774324f87dd
Tag : runtime-s1-11e-j11-a5-scene-presentation
Dernier jalon verrouillé : J11 A5
Assets J11 A5 : six enfants finaux non livrés
```

---

# 0. Gouvernance

Lire avant toute modification :

```text
docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md
```

Ce document définit les autorités, les statuts documentaires et la séparation Canon / UI / Runtime.

---

# 1. Vision produit

```text
docs/canon/bible/00_NORTH_STAR.md
docs/canon/bible/01_EXPERIENCE_JOUEUR.md
docs/canon/bible/02_FANTASMES_CENTRAUX.md
```

---

# 2. Personnages et voix

```text
docs/canon/characters/CHARACTER_CANON_INDEX.md
docs/canon/characters/*_CANON_FULL.md
docs/canon/CHARACTER_VOICE_DISTINCTION_CANON.md
docs/canon/bible/13_BIBLE_VOIX_MESSAGERIE_ET_TESTS_DISTINCTION.md
docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md
```

---

# 3. Architecture narrative

```text
docs/canon/bible/03_GRAMMAIRE_NARRATIVE.md
docs/canon/bible/04_TRAME_PRINCIPALE_ET_ACTES_SAISON_1.md
docs/canon/bible/05_ROUTES_MACRO_SAISON_1.md
docs/canon/bible/06_EVOLUTION_EROTIQUE_DES_ROUTES.md
docs/canon/bible/07_BIBLIOTHEQUE_DE_SEQUENCES_SAISON_1.md
docs/canon/bible/08_REGLES_DES_SCENES_MODULAIRES.md
docs/canon/bible/09_PROGRESSION_VISUELLE_ET_PHOTOGRAPHIQUE.md
docs/canon/bible/10_CARTE_CONSEQUENCES_DETTES_SECRETS_OBLIGATIONS.md
docs/canon/bible/11_DISTRIBUTION_SEQUENCES_SCENES_IMAGES_CONSEQUENCES_JOURNEES.md
```

Hiérarchie :

```text
North Star
→ routes macro
→ actes
→ séquences
→ scènes modulaires
→ dialogues et photos
→ journées
→ runtime
```

---

# 4. Sources narratives consolidées

## J01–J06

```text
docs/canon/dialogues/J01_J06_SOURCE_CANON_CONSOLIDE.md
```

## J07–J21

```text
docs/canon/dialogues/J07_SCRIPT_NARRATIF_COMPLET.md
...
docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md
```

## Addenda adultes validés

```text
docs/canon/dialogues/NAR_PROD_07_ADULT_PAYOFF_AUDIT_SPECIFICATION.md
docs/canon/dialogues/NAR_ADULT_01_PAYOFFS_J11_MARIE_MATHILDE.md
docs/canon/dialogues/NAR_ADULT_02_PAYOFF_SANDRA_J18.md
docs/canon/dialogues/NAR_ADULT_03_PAYOFFS_PAULINE_RAPHAELLE.md
```

Les scripts consolidés prévalent. Les addenda conservent la traçabilité des décisions.

`NAR_PROD_05_AMENDEMENT_COHERENCE_J10_J12.md` conserve son statut historique
`CANDIDAT À VALIDATION PRODUIT`. Ses décisions applicables ont ensuite été absorbées
ou confirmées par les scripts signés J10–J12, les registres, le contrat d’état, le
runtime et les tests de la baseline. Ces sources plus récentes priment : l’amendement
n’est plus une source bloquante autonome. Le rapport de readiness qu’il cite n’est
pas présent dans le dépôt.

---

# 5. Contrats pré-runtime

Lire ensemble :

```text
docs/canon/dialogues/J01_J21_TRACE_REGISTRY.md
docs/canon/dialogues/J01_J21_PROMISE_REGISTRY.md
docs/canon/dialogues/J01_J21_KNOWLEDGE_REGISTRY.md
docs/canon/dialogues/J01_J21_REACHABILITY_MATRIX.md
docs/canon/runtime/SEASON_1_NARRATIVE_STATE_CONTRACT.md
```

Rappels :

- aucun score de route ;
- états relationnels bornés ;
- promesses structurées ;
- traces avec créateur, audience et permanence ;
- connaissances sourcées ;
- conséquences dues ;
- aucune progression adulte automatique.

---

# 6. Sign-off et audits

Autorité finale :

```text
docs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md
```

Audits utiles :

```text
docs/canon/dialogues/J01_J09_AUDIT_CONFORMITE_NARRATIVE.md
docs/canon/dialogues/J01_J21_AUDIT_GLOBAL_DIALOGUES_CONTINUITE.md
docs/canon/dialogues/J01_J21_LOT_A_CORRECTIONS_BLOQUANTES.md
docs/canon/dialogues/J07_J21_LOT_D_POLISH_VOIX_NATUREL.md
docs/canon/dialogues/NAR_PROD_01_AUDIT_PREPARATION_PRODUCTION_SAISON_1.md
```

Les audits sont des archives de décision ; les scripts, registres et sign-off prévalent.

---

# 7. Plans détaillés et statut historique

```text
docs/canon/bible/12_PLANS_SCENES_AUDIT_RUNTIME_J01_J08.md
docs/canon/bible/12B_PLANS_SCENES_J09_J12.md
docs/canon/bible/12C_PLANS_SCENES_J13_J16.md
docs/canon/bible/12D_PLANS_SCENES_J17_J21.md
docs/canon/bible/12E_AUDIT_GLOBAL_COHERENCE_J01_J21.md
```

Les observations runtime de ces plans antérieures à l’orchestration J01–J21 actuelle
sont historiques.

La fondation J01–J04 est conservée pour la traçabilité dans :

```text
docs/runtime/SEASON_1_J01_J04_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md
```

---

# 8. Paquets de production

```text
docs/canon/dialogues/NAR_PROD_02_PAQUET_PRODUCTION_ACTE_I_J01_J04.md
docs/canon/dialogues/NAR_PROD_03_PAQUET_PRODUCTION_ACTE_II_J05_J08.md
docs/canon/dialogues/NAR_PROD_04_PAQUET_PRODUCTION_ACTE_III_J09_J12.md
docs/canon/dialogues/NAR_PROD_05_PAQUET_PRODUCTION_ACTE_IV_J13_J16.md
docs/canon/dialogues/NAR_PROD_06_PAQUET_PRODUCTION_ACTE_V_J17_J21.md
```

| Acte | Journées | Narration | Runtime portrait |
|---|---|---|---|
| I | J01–J04 | READY | présent sur la baseline |
| II | J05–J08 | READY | présent sur la baseline |
| III | J09–J12 | READY | providers, données et tests dédiés présents |
| IV | J13–J16 | READY | présent sur la baseline |
| V | J17–J21 | READY | présent sur la baseline |

La présence runtime ne signifie pas que tous les jours partagent le même niveau de
polish ou que tous les tests globaux sont verts.

---

# 9. Production visuelle

```text
docs/canon/dialogues/ASSET_01_MANIFESTE_PRODUCTION_VISUELLE_SAISON_1_84_FICHIERS.md
docs/canon/dialogues/ASSET_02_CHARACTER_REFERENCES.md
docs/canon/dialogues/ASSET_03_LOCATION_REFERENCES_AND_PILOT_BATCH.md
```

L’architecture visuelle commune utilise `VisualMediaResolver` et `ResourceLoader`.
Les placeholders et prototypes ne deviennent pas des assets canoniques. J11 A5
contient deux parents Galerie et six enfants de séquence ; aucun des six assets
finaux n’est livré et **« Visuel non livré »** reste le fallback attendu.

---

# 10. UX/UI

```text
docs/canon/ui/README.md
docs/canon/ui/UI_01_VERTICAL_SMARTPHONE_SYSTEM.md
docs/canon/ui/UI_02_SCREEN_ARCHITECTURE_AND_STATES.md
docs/canon/ui/UI_03_INTEGRATION_HANDOFF_AND_MOCKUP_STATUS.md
```

Le checkpoint T-UI-03D reste la fondation canonique du cœur portrait. Les lots UI-MSG-04A à 04C et les correctifs J04 restent des améliorations runtime conformes :

- bandeau jour/heure ;
- livraison progressive ;
- transitions unifiées ;
- notifications interactives neutres ;
- séparateurs `source_day` ;
- vitesse limitée ;
- règle commune des non-lus via `RuntimeUnread` ;
- aucun badge numérique.

---

# 11. Runtime actif

Lire obligatoirement avant tout travail runtime :

```text
docs/runtime/README.md
docs/canon/runtime/SEASON_1_NARRATIVE_STATE_CONTRACT.md
```

Puis vérifier le code, les données et les tests sur `main`.

Chaîne présente :

```text
J01 → J02 → … → J21
```

L’ancien contrat J01–J04 reste une fondation historique. Le code, les données et
les tests de la baseline décrivent l’état exécuté courant.

---

# 12. Priorité courante

Lire :

```text
ROADMAP.md
```

Priorité :

```text
préparation future des six assets enfants J11 A5
→ pipeline visuel commun
→ validation avant retrait du fallback
→ aucun manifeste Acte III complet dans ce lot
```

---

# 13. Résumé de reprise

```text
NARRATION       J01–J21 signé et READY
RUNTIME PRÉSENT J01–J21 dans la chaîne commune
BASELINE        fa2880c1ad168569b148ed85bedf4774324f87dd
JALON VERROUILLÉ J11 A5
UI COMMUNE      verrouillée, extension gelée par défaut
ASSETS J11 A5   six enfants finaux absents
ANCIENS DOCS    historiques sauf lien explicite
```

Une reprise fiable commence par les autorités actives, pas par l’historique du dépôt.
