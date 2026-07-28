# Documentation Reading Order — Réseau Intime

> **Phase active : corpus J01–J21 signé, runtime portrait J01–J03 intégré, préparation de J04**

```text
Bible Narrative / North Star : autorité active
Corpus J01–J21 : consolidé et signé
Paquets NAR-PROD Actes I–V : READY
Runtime portrait : J01→J03 jouable et validé
UI commune : verrouillée à c27bd933
Prochaine intégration : J04 depuis la chaîne commune
Assets : spécifiés, non produits
```

---

# 0. Gouvernance

Lire avant toute modification :

```text
docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md
```

Ce document définit les sources autoritatives, les statuts actifs ou historiques, la séparation Canon / UI / Runtime et la règle anti-dispersion.

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
docs/canon/dialogues/J08_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J09_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J10_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J11_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J12_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J13_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J14_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J15_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J16_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J17_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J18_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J19_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J20_SCRIPT_NARRATIF_COMPLET.md
docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md
```

## Addenda adultes validés

Lire ensuite, dans cet ordre :

```text
docs/canon/dialogues/NAR_PROD_07_ADULT_PAYOFF_AUDIT_SPECIFICATION.md
docs/canon/dialogues/NAR_ADULT_01_PAYOFFS_J11_MARIE_MATHILDE.md
docs/canon/dialogues/NAR_ADULT_02_PAYOFF_SANDRA_J18.md
docs/canon/dialogues/NAR_ADULT_03_PAYOFFS_PAULINE_RAPHAELLE.md
```

Les addenda adultes ont été intégrés aux scripts, registres et paquets NAR-PROD. Ils restent des dossiers de décision actifs et ne remplacent pas les scripts consolidés.

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

Pour J14→J16, lire d’abord :

```text
docs/canon/dialogues/NAR_CANON_01_REPARATION_PROMESSES_ATTEIGNABILITE_J14_J16.md
```

Rappels structurants :

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

Audits et corrections conservés :

```text
docs/canon/dialogues/J01_J09_AUDIT_CONFORMITE_NARRATIVE.md
docs/canon/dialogues/J01_J21_AUDIT_GLOBAL_DIALOGUES_CONTINUITE.md
docs/canon/dialogues/J01_J21_LOT_A_CORRECTIONS_BLOQUANTES.md
docs/canon/dialogues/J07_J21_LOT_D_POLISH_VOIX_NATUREL.md
docs/canon/dialogues/NAR_PROD_01_AUDIT_PREPARATION_PRODUCTION_SAISON_1.md
```

Les audits restent des archives de décision. Les scripts consolidés, registres et sign-off final prévalent.

---

# 7. Plans détaillés et statut historique

```text
docs/canon/bible/12_PLANS_SCENES_AUDIT_RUNTIME_J01_J08.md
docs/canon/bible/12B_PLANS_SCENES_J09_J12.md
docs/canon/bible/12C_PLANS_SCENES_J13_J16.md
docs/canon/bible/12D_PLANS_SCENES_J17_J21.md
docs/canon/bible/12E_AUDIT_GLOBAL_COHERENCE_J01_J21.md
```

Ces documents restent utiles pour la traçabilité des scènes et des décisions. Toutefois :

```text
les observations runtime de 12A antérieures à la chaîne Season1RuntimeProvider
sont HISTORIQUES pour J01–J03
```

Elles sont supersédées techniquement par :

```text
docs/runtime/SEASON_1_J01_J03_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md
```

Les scripts consolidés, registres, paquets de production et sign-off prévalent sur toute classification ancienne `ADAPTABLE`, `RESTRUCTURE`, `RELOCATE` ou `REWRITE` déjà résolue.

---

# 8. Paquets de production

```text
docs/canon/dialogues/NAR_PROD_02_PAQUET_PRODUCTION_ACTE_I_J01_J04.md
docs/canon/dialogues/NAR_PROD_03_PAQUET_PRODUCTION_ACTE_II_J05_J08.md
docs/canon/dialogues/NAR_PROD_04_PAQUET_PRODUCTION_ACTE_III_J09_J12.md
docs/canon/dialogues/NAR_PROD_05_PAQUET_PRODUCTION_ACTE_IV_J13_J16.md
docs/canon/dialogues/NAR_PROD_06_PAQUET_PRODUCTION_ACTE_V_J17_J21.md
```

Statut :

| Acte | Journées | Narration | Runtime portrait |
|---|---|---|---|
| I | J01–J04 | READY | J01–J03 intégrés, J04 à intégrer |
| II | J05–J08 | READY | non intégré |
| III | J09–J12 | READY | non intégré |
| IV | J13–J16 | READY | non intégré |
| V | J17–J21 | READY | non intégré |

Ces paquets sont dérivés des sources autoritatives. Ils ne constituent ni une seconde carte de saison, ni un nouveau canon concurrent.

---

# 9. Production visuelle

```text
docs/canon/dialogues/ASSET_01_MANIFESTE_PRODUCTION_VISUELLE_SAISON_1_84_FICHIERS.md
docs/canon/dialogues/ASSET_02_CHARACTER_REFERENCES.md
docs/canon/dialogues/ASSET_03_LOCATION_REFERENCES_AND_PILOT_BATCH.md
```

Les assets sont spécifiés mais non produits. Les placeholders runtime ne deviennent pas des assets canoniques.

---

# 10. UX/UI

Lire :

```text
docs/canon/ui/README.md
docs/canon/ui/UI_01_VERTICAL_SMARTPHONE_SYSTEM.md
docs/canon/ui/UI_02_SCREEN_ARCHITECTURE_AND_STATES.md
docs/canon/ui/UI_03_INTEGRATION_HANDOFF_AND_MOCKUP_STATUS.md
```

Le checkpoint T-UI-03D reste la fondation canonique du cœur portrait. Les correctifs UI-MSG-04A à 04C sont des améliorations runtime validées qui respectent ce canon :

- bandeau conversation et heure narrative ;
- livraison progressive commune ;
- transitions unifiées ;
- notifications interactives ;
- séparateurs par `source_day` ;
- vitesse limitée aux messages et au typing.

Baseline technique actuelle :

```text
c27bd9331c01bed6c9a40c0c642d246cf26bb6cf
```

---

# 11. Runtime actif

Lire obligatoirement avant J04+ :

```text
docs/runtime/README.md
docs/runtime/SEASON_1_J01_J03_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md
```

Puis vérifier le code, les données et les tests sur `main`.

La chaîne actuelle :

```text
J01 → J02 → J03
```

Les corrections communes doivent être héritées par les journées suivantes via l’orchestrateur, les providers bornés, le schéma de présentation et les composants UI partagés. Aucun ancien index modulaire ne devient automatiquement le provider de J04.

---

# 12. Priorité courante

Lire :

```text
ROADMAP.md
```

Priorité actuelle :

```text
intégration runtime de J04
→ handoff depuis J03
→ non-régression J01–J03
→ validation visuelle
→ poursuite par blocs courts
```

---

# 13. Résumé de reprise

```text
NARRATION       J01–J21 signé et READY
RUNTIME NOUVEAU J01–J03 jouable
PROCHAINE ÉTAPE J04
UI COMMUNE      verrouillée à c27bd933
ASSETS          spécifiés, non produits
ANCIENS DOCS    historiques sauf lien explicite
```

Une reprise fiable ne dépend pas de connaître l’histoire du dépôt. Elle dépend de savoir immédiatement quelle source a autorité et quelle partie est déjà exécutée par le nouveau runtime.
