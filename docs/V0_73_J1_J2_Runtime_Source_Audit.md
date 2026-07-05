# V0.73 — J1/J2 Runtime vs Canonical Source Audit

## 1. Décision de lecture

Le brut validé prime sur le JSON pour le texte, le ton, les beats et l’ordre émotionnel.
Le JSON reste l’implémentation technique.

## 2. Méthode

Catégories utilisées :
- conforme ;
- adaptation technique acceptable ;
- divergence mineure ;
- divergence importante ;
- bloquant.

Lecture appliquée :
- comparer chaque runtime audité à sa source canonique ;
- distinguer le contenu narratif du décor technique (`ids`, `choices`, `guided_reply`, `content_id`, métadonnées) ;
- signaler seulement les écarts qui changent le sens, le ton ou la vitesse de route.

## 3. J1 — Audit

### 3.1 Verdict global

**OK sans correction**.

J1 reste conforme au canon : Marie tient le centre émotionnel, Sandra revient comme ancienne présence douce et troublante, Mathilde reste indirecte, et rien ne pousse vers une séduction frontale ou une route active non canonique.

### 3.2 Conformités

- Marie est bien l’ancre du quotidien.
- Sandra revient à distance, avec une tonalité affective, nostalgique et retenue.
- Mathilde reste une présence domestique indirecte : sacs, raquette, chargeur, place à prendre.
- Nico, Pauline et Raphaëlle ne deviennent pas actifs dans les fichiers J1 audités.
- Pas de vocal, pas d’explicite, pas de photo non consentie, pas de route lock narratif.
- Le rythme reste respirable : messages courts, relances simples, silences, petites reprises.
- Les visuels J1 restent soft, non-proof et à faible risque.

### 3.3 Adaptations techniques acceptables

- Segmentation en fichiers JSON séparés plutôt qu’en bloc canonique unique.
- IDs techniques et `content_id` stabilisés pour les deux visuels J1 utiles.
- `choices` et `guided_reply` utilisés pour porter les réponses du Player.
- `chapter_01_index.json` garde une logique de seed/lock technique sans ouvrir de route active non canonique.
- `chapter_01_proofs.json` fonctionne comme banque de traces soft : rien de proof au sens narratif.

### 3.4 Divergences mineures

- Aucune divergence mineure bloquante n’a été relevée dans les fichiers J1 audités.
- Les beats pain / téléphone / chargeur / sacs sont tous compatibles avec le canon et servent bien la routine + la gêne domestique.

### 3.5 Divergences importantes

- Aucune.

### 3.6 Décision produit recommandée

J1 peut rester tel quel.

---

## 4. J2 — Audit

### 4.1 Verdict global

**OK avec vigilance**.

J2 colle bien au canon source : Marie reste le centre, Raphaëlle reste extérieure et utile, Mathilde est concrète et sportive, Sandra reste un écho doux, et les scènes de nuit jouent bien le rôle de pont plutôt que de pivot.

### 4.2 Conformités

- Marie matin correspond au canon : biscuits, petit-déjeuner, arrivée de Mathilde.
- Raphaëlle midi reste extérieure / pro / jeu vidéo, sans refuge romantique.
- Marie fin d’après-midi garde le centre affectif.
- Mathilde début de soirée reste sportive, gênée, domestique et non sexualisée dans l’action.
- Sandra soir reste en écho doux : lac, roman, calme, distance.
- Marie nuit reste un pont doux : Mathilde reste dormir, sans bascule de pivot.
- Mathilde nuit reste non-proof et de risque faible dans le fichier runtime.
- Aucun Nico / Pauline actif dans les fichiers J2 audités.
- Pas de vocal, pas d’explicite, pas de photo non consentie, pas de route lock narratif.
- Player répond via choix ; aucun sender Player automatique n’apparaît dans les messages renderisés.

### 4.3 Adaptations techniques acceptables

- Segmentation du jour en 7 fichiers runtime au lieu d’un pack monolithique.
- IDs séparés par moment de journée.
- `choices` / `guided_reply` / `content_id` gèrent correctement les réponses et les traces.
- `chapter_02_index.json` garde des garde-fous techniques de seed-lock pour Pauline/Nico sans les rendre actifs.
- `placeholders.json` agit comme banque partagée plus large que J2 ; les entrées J2 pertinentes restent conformes.

### 4.4 Divergences mineures

- `chapter_02_mathilde_night.json` : le selfie canapé est bien non-proof et à faible risque, mais la légende runtime est légèrement plus flatteuse que le libellé canonique “quotidien / non suggestif”. Cela reste une micro-variation de ton, pas une bascule de scène.
- `placeholders.json` : le fichier partagé contient aussi des placeholders de contexte plus large que J2. Ce n’est pas une erreur du slice J2, mais c’est un point à garder en tête si on veut un audit ultra-strict par chapitre.

### 4.5 Divergences importantes

- Aucune divergence importante sur les fichiers J2 audités.
- Pas de scène qui accélère trop une route.
- Pas de photo non consentie.
- Pas de vocal.
- Pas de fermeture canonique déplacée vers un pivot prématuré.

### 4.6 Décision produit recommandée

J2 peut rester tel quel, avec vigilance sur la scène de nuit de Mathilde si on veut encore baisser d’un cran la chaleur de la légende runtime.

---

## 5. Tableau de réalignement futur

| jour | fichier runtime | source canonique | type de divergence | gravité | recommandation | correction runtime nécessaire oui/non |
|---|---|---|---|---|---|---|
| J1 | `game/data/conversations/chapter_01_index.json` | `docs/V0_66_Narrative_Rewrite_Source_Pack_J1.md` | adaptation technique : route seed/lock interne | faible | conserver | non |
| J1 | `game/data/conversations/chapter_01_marie.json` | `docs/V0_66_Narrative_Rewrite_Source_Pack_J1.md` | conforme | n/a | conserver | non |
| J1 | `game/data/conversations/chapter_01_sandra.json` | `docs/V0_66_Narrative_Rewrite_Source_Pack_J1.md` | conforme | n/a | conserver | non |
| J1 | `game/data/visual_content/chapter_01_proofs.json` | `docs/V0_66_Narrative_Rewrite_Source_Pack_J1.md` | conforme | n/a | conserver | non |
| J2 | `game/data/conversations/chapter_02_index.json` | `docs/V0_72_Canonical_J2_Source_Pack.md` | adaptation technique : seed-lock interne / banque partagée | faible | conserver | non |
| J2 | `game/data/conversations/chapter_02_mathilde_night.json` | `docs/V0_72_Canonical_J2_Source_Pack.md` | divergence mineure : légende selfie un peu plus flatteuse que le canon non suggestif | faible | garder sous vigilance | oui, si réalignement tonal futur |
| J2 | `game/data/visual_content/placeholders.json` | `docs/V0_72_Canonical_J2_Source_Pack.md` | banque partagée plus large que J2 | faible | conserver | non |

## 6. Verdict final

- **J1 peut rester tel quel** : oui.
- **J2 peut rester tel quel** : oui, avec vigilance.
- **Une V0.74 de réalignement JSON est recommandée** : non, pas indispensable à ce stade.
- **Fichiers concernés si on veut micro-réaligner plus tard** : `game/data/conversations/chapter_02_mathilde_night.json` en priorité ; éventuellement `game/data/visual_content/placeholders.json` si l’on veut durcir la séparation stricte entre banque J2 et banque globale.

