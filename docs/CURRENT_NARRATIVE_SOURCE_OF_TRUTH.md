# Current Narrative Source of Truth

## Hiérarchie de lecture

1. **runtime JSON verrouillé = vérité jouable**
2. **source packs récents = vérité d’intention**
3. **V0.57 / V0.59 = macro-direction seulement**
4. **anciens day plans = historiques ou obsolètes s’ils contredisent la direction actuelle**

## Règles d’arbitrage

- Si un runtime JSON verrouillé contredit un doc, le runtime gagne.
- Si un source pack récent contredit un day plan ancien, le source pack récent gagne.
- Si V0.57 / V0.59 contredisent un lock runtime plus récent, ils ne servent qu’à lire la structure macro.
- Les vieux day plans gardent de la mémoire historique, mais ne doivent pas piloter une intégration jour par jour.

## Sources actives à consulter en priorité

- `docs/story_state/GLOBAL_STORY_STATE.md`
- `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md`
- les source packs récents V0.66+ / V0.67b / V0.68c / V0.69 lorsqu’ils existent
- les fichiers runtime verrouillés du jour concerné

## Ce document signifie

- les détails vieux ou contradictoires doivent être traités comme historiques ;
- les intégrations futures doivent partir de la vérité jouable actuelle, pas d’un plan macro ancien ;
- toute divergence entre histoire jouable et documentation doit être résolue par la source la plus récente et la plus verrouillée.
