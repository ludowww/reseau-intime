# Documentation Reading Order — Réseau Intime

> **Phase active : audit Saison 1 terminé, préparation du paquet de production Acte I**

```text
Bible Narrative / North Star : autorité active
Corpus J01–J21 : consolidé et signé
NAR‑PROD‑01 : terminé
Narration : 21 / 21 READY
Visuels finaux : 21 / 21 MISSING_SPEC
Extension UI et runtime : gelés
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

# 4. Plans détaillés et communication

```text
docs/canon/bible/12_PLANS_SCENES_AUDIT_RUNTIME_J01_J08.md
docs/canon/bible/12B_PLANS_SCENES_J09_J12.md
docs/canon/bible/12C_PLANS_SCENES_J13_J16.md
docs/canon/bible/12D_PLANS_SCENES_J17_J21.md
docs/canon/bible/12E_AUDIT_GLOBAL_COHERENCE_J01_J21.md
docs/canon/TEXT_ONLY_MESSAGING_CANON.md
```

`12E` est historique. Le rapport NAR‑PROD‑01 signale également que certains diagnostics et cases d’acceptation de `12A–12D` précèdent le sign-off final. Les scripts consolidés, registres et sign-off prévalent.

---

# 5. Sources narratives consolidées

```text
docs/canon/dialogues/J01_J06_SOURCE_CANON_CONSOLIDE.md
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

---

# 6. Contrats pré-runtime

```text
docs/canon/dialogues/J01_J21_TRACE_REGISTRY.md
docs/canon/dialogues/J01_J21_PROMISE_REGISTRY.md
docs/canon/dialogues/J01_J21_KNOWLEDGE_REGISTRY.md
docs/canon/runtime/SEASON_1_NARRATIVE_STATE_CONTRACT.md
docs/canon/dialogues/J01_J21_REACHABILITY_MATRIX.md
```

---

# 7. Audits, corrections et sign-off

```text
docs/canon/dialogues/J01_J09_AUDIT_CONFORMITE_NARRATIVE.md
docs/canon/dialogues/J01_J21_AUDIT_GLOBAL_DIALOGUES_CONTINUITE.md
docs/canon/dialogues/J01_J21_LOT_A_CORRECTIONS_BLOQUANTES.md
docs/canon/dialogues/J07_J21_LOT_D_POLISH_VOIX_NATUREL.md
docs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md
docs/canon/dialogues/NAR_PROD_01_AUDIT_PREPARATION_PRODUCTION_SAISON_1.md
```

Les anciens audits et lots correctifs restent des archives de décision. Les scripts consolidés et le sign-off final ont autorité. NAR‑PROD‑01 ne redéfinit pas le canon ; il classe sa préparation à la production.

---

# 8. UX/UI active

```text
docs/canon/ui/README.md
docs/canon/ui/UI_01_VERTICAL_SMARTPHONE_SYSTEM.md
docs/canon/ui/UI_02_SCREEN_ARCHITECTURE_AND_STATES.md
docs/canon/ui/UI_03_INTEGRATION_HANDOFF_AND_MOCKUP_STATUS.md
```

Ordre d’autorité :

```text
UI_01 système visuel et responsive
→ UI_02 écrans et états canoniques
→ UI_03 intégration, état implémenté et différé
```

Le cœur UI prototype est implémenté et gelé. Les maquettes conceptuelles ne sont pas des assets finaux.

---

# 9. Runtime

Après lecture du canon et de l’UI :

```text
docs/runtime/README.md
code + données + tests sur main
```

Le runtime historique et le cœur UI portrait additif coexistent. Aucun des deux ne redéfinit le canon produit.

---

# 10. Documents historiques

Sont `HISTORICAL` sauf lien explicite depuis un index actif :

```text
docs/V0_*.md
docs/NN_*.md à la racine de docs/
docs/narrative/
docs/story_state/
anciens rapports et plans de branche
```

`docs/01_NARRATIVE_BIBLE.md` et `docs/03_ROUTE_ARCHITECTURE.md` ne sont pas des sources actuelles.

---

# 11. Ordre de production actuel

```text
corpus narratif signé
→ cœur UI portrait verrouillé
→ NAR‑PROD‑01 terminé
→ décisions de budget et granularité visuelle
→ NAR‑PROD‑02 paquet Acte I / J01–J04
→ paquets Actes II à V
→ production des assets validés
→ adaptation runtime seulement lorsque nécessaire
```

Aucun ancien lot UI ou runtime n’est automatiquement la prochaine action.

---

# 12. Autorité synthétique

```text
Vision et structure : docs/canon/bible/
Personnages : docs/canon/characters/
Narration J01–J21 : scripts consolidés + registres + sign-off
Audit de préparation : NAR_PROD_01_AUDIT_PREPARATION_PRODUCTION_SAISON_1.md
UI/UX : docs/canon/ui/
Runtime réel : code, données et tests sur main
Statut et priorité : README.md + ROADMAP.md
Historique : anciens rapports, plans V0.xx et fichiers racine non indexés
```

Aucun résumé ne doit redéfinir la source de son domaine.
