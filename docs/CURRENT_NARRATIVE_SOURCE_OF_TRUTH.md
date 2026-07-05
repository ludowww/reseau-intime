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

## J4+ quarantine / statut post-J3

- J1 / J2 / J3 récents priment sur tout ancien day plan.
- J4+ peut encore exister techniquement dans le vertical slice, mais ne constitue pas la vérité narrative actuelle tant qu’il n’a pas été réécrit et verrouillé après V0.70.
- Les anciens J4 / J5 / J7 / J9 doivent être lus comme prototype legacy ou historique tant qu’ils ne sont pas réalignés.
- Aucun document ancien ne doit réactiver l’ancien J3 « soirée / panel / Pauline / Nico / photo canapé ».

## Ce document signifie

- les détails vieux ou contradictoires doivent être traités comme historiques ;
- les intégrations futures doivent partir de la vérité jouable actuelle, pas d’un plan macro ancien ;
- toute divergence entre histoire jouable et documentation doit être résolue par la source la plus récente et la plus verrouillée.
