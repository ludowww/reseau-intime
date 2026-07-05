# Current Narrative Source of Truth

## Hiérarchie de lecture

1. **Brut narratif validé / source pack canonique = vérité narrative**
2. **runtime JSON verrouillé = vérité jouable, mais comme implémentation technique**
3. **si le brut et le JSON divergent, le brut validé prime pour la narration**
4. **le JSON peut adapter la structure technique : IDs, segments, choices, guided_reply, content_id**
5. **le JSON ne doit pas réécrire, condenser, ajouter ou supprimer des beats sans validation produit**
6. **anciens day plans = historiques ou obsolètes s’ils contredisent la direction actuelle**

## Règles d’arbitrage

- Le brut narratif validé prime sur toute réécriture runtime.
- Le runtime JSON verrouillé décrit l’état jouable actuel, pas la hiérarchie canonique du texte.
- Si un runtime JSON verrouillé contredit un doc, on crée d’abord un audit avant correction.
- Les source packs récents restent utiles comme références d’intention, mais ils ne remplacent pas le brut validé.
- Les vieux day plans gardent de la mémoire historique, mais ne doivent pas piloter une intégration jour par jour.

## Sources actives à consulter en priorité

- `docs/story_state/GLOBAL_STORY_STATE.md`
- `docs/story_state/CHARACTER_CONTINUITY_MATRIX.md`
- les brut / source packs canonisés récents lorsqu’ils existent
- les fichiers runtime verrouillés du jour concerné

## J4+ quarantine / statut post-J3

- J1 / J2 / J3 récents priment sur tout ancien day plan.
- J4+ peut encore exister techniquement dans le vertical slice, mais ne constitue pas la vérité narrative actuelle tant qu’il n’a pas été réécrit et verrouillé après V0.70.
- Les anciens J4 / J5 / J7 / J9 doivent être lus comme prototype legacy ou historique tant qu’ils ne sont pas réalignés.
- Aucun document ancien ne doit réactiver l’ancien J3 « soirée / panel / Pauline / Nico / photo canapé ».

## Ce document signifie

- les détails vieux ou contradictoires doivent être traités comme historiques ;
- les intégrations futures doivent partir du brut canonique, pas d’une version runtime réécrite ;
- toute divergence entre histoire jouable et documentation doit être résolue par le brut validé, avec audit si nécessaire.
