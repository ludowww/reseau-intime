#!/usr/bin/env python3
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(rel: str) -> str:
    return (ROOT / rel).read_text(encoding="utf-8")


def write(rel: str, text: str) -> None:
    (ROOT / rel).write_text(text.rstrip() + "\n", encoding="utf-8")


def identifiers(text: str) -> dict[str, set[str]]:
    return {
        key: set(re.findall(rf"\b{key}:\s*([A-Za-z0-9_]+)", text))
        for key in ("trace_id", "promise_id", "fact_id")
    }


def replace_once(rel: str, old: str, new: str) -> None:
    before = read(rel)
    count = before.count(old)
    if count != 1:
        raise RuntimeError(f"{rel}: expected one match, found {count}: {old[:100]!r}")
    before_ids = identifiers(before)
    after = before.replace(old, new, 1)
    if identifiers(after) != before_ids:
        raise RuntimeError(f"{rel}: canonical identifiers changed")
    write(rel, after)


# J10 — Sandra and Mathilde.
rel = "docs/canon/dialogues/J10_SCRIPT_NARRATIF_COMPLET.md"
replace_once(rel,
"""**12:24 — Sandra**

> Si je ne confirme pas, on ne garde pas le café vivant par principe.""",
"""**12:24 — Sandra**

> Si je ne confirme pas, ne garde pas ta matinée pour ça.""")
replace_once(rel,
"""**Sandra**

> Je refuse d’en faire une victoire personnelle.""",
"""**Sandra**

> J’ai eu le train.

**Sandra**

> On ne va pas en faire un événement.""")
replace_once(rel,
"""**Sandra**

> Moi aussi.

**Sandra**

> Simple me va bien pour aujourd’hui.

**Sandra**

> On n’est pas obligés de décider tout de suite pourquoi ça comptait.""",
"""**Sandra**

> Moi aussi.

**Sandra**

> C’était bien.

**Sandra**

> On peut laisser ça comme ça pour aujourd’hui.""")
replace_once(rel,
"""**Sandra**

> Ça ne rend pas le café faux.

**Sandra**

> Ça lui donne juste une place.""",
"""**Sandra**

> Le café reste le café.

**Sandra**

> Ça me va.""")
replace_once(rel,
"""**17:14 — Mathilde**

> Question objectivement vestimentaire.

**17:14 — Mathilde**

> Inès me rejoint dans une heure.

**17:15 — Mathilde**

> J’hésite entre deux versions.

**17:15 — Mathilde**

> Et non, ce n’est pas un piège.

**17:15 — Mathilde**

> Enfin pas juridiquement.""",
"""**17:14 — Mathilde**

> Question vêtement.

**17:14 — Mathilde**

> Inès me rejoint dans une heure.

**17:15 — Mathilde**

> J’hésite entre deux.

**17:15 — Mathilde**

> Je t’envoie avant de lui demander.

**17:15 — Mathilde**

> C’est probablement une mauvaise idée.""")
replace_once(rel,
"""**Mathilde**

> Réponse dangereusement correcte.

**Mathilde**

> J’avais changé la veste après ce matin-là.

**Mathilde**

> Je voulais voir si tu remarquerais la différence.

**Mathilde**

> Je précise : remarquer. Pas décider de la suite du dossier.""",
"""**Mathilde**

> Bon.

**Mathilde**

> C’est exactement ce que je pensais.

**Mathilde**

> J’avais changé la veste après l’autre matin.

**Mathilde**

> Je voulais voir si tu le remarquerais.

**Mathilde**

> Ne prends pas trop confiance.""")
replace_once(rel,
"""**Mathilde**

> Et avant que ton cerveau rédige une jurisprudence : ce n’est pas une permission générale.

**Mathilde**

> Mais oui. Je l’avais un peu choisie pour l’effet.""",
"""**Mathilde**

> Et ne pars pas trop loin avec ça.

**Mathilde**

> Mais oui. Je l’avais un peu choisie pour l’effet.""")
replace_once(rel,
"""> Je le précise pour préserver l’indépendance de l’expertise.""",
"""> Donc tu n’étais pas complètement perdu.""")

# J11 — Sandra, Mathilde, Raphaëlle, Nico.
rel = "docs/canon/dialogues/J11_SCRIPT_NARRATIF_COMPLET.md"
replace_once(rel, "> Une image précise. Pas une règle générale.", "> Celle-là seulement.")
replace_once(rel,
"""**21:07 — Mathilde**

> Ce n’est pas un accident logistique.

**21:07 — Mathilde**

> Je préfère le préciser avant que ton visage fasse le travail à ta place.""",
"""**21:07 — Mathilde**

> Oui, exprès.

**21:07 — Mathilde**

> Je préfère te prévenir avant de voir ta tête.""")
replace_once(rel,
"""**21:08 — Mathilde**

> Non.

**21:08 — Mathilde**

> Tu as compris que je veux produire un effet.

**21:09 — Mathilde**

> Tu n’as pas encore compris ce que j’accepte avec.""",
"""**21:08 — Mathilde**

> Tu as compris une partie.

**21:08 — Mathilde**

> Je veux que tu regardes.

**21:09 — Mathilde**

> Le reste, je ne l’ai pas décidé.""")
replace_once(rel,
"> j’ai compris que tu veux que je regarde. je regarde. je ne fais rien de plus",
"> j’ai compris. tu veux que je regarde. je garde mes mains")
replace_once(rel,
"> Et maintenant je dois vivre avec le fait que c’était quand même excitant.",
"> Et c’était quand même... enfin. oui. excitant.")
replace_once(rel,
"> Et tu ne transformes pas demain matin en procès ou en victoire.",
"> Et demain tu ne me fais pas un débrief de trois pages.")
replace_once(rel,
"> Près. Pas dessus. Je précise pour le dossier.",
"> Près. Pas collé. Voilà.")
replace_once(rel,
"> Je ne vais pas transformer ce message en permission générale.",
"> Je ne vais pas décider la suite dans ce message.")
replace_once(rel,
"> Et parce que je voulais vérifier si tu savais t’arrêter à cette information.",
"> Et je voulais voir si tu savais t’arrêter là.")
replace_once(rel,
"> Samedi, il faudra agir comme des personnes qui savent ça.",
"> Samedi, on ne fera pas comme si ça n’avait pas eu lieu.")
replace_once(rel,
"> Garde-fou réciproque. Pas confession permanente.",
"> On se le dit quand ça dérape. Pas besoin d’un rapport quotidien.")
replace_once(rel,
"""**Nico**

> Mais elles ne sont pas le terrain sur lequel on règle ça.

**Nico**

> Samedi, je parle pour moi. Pas contre toi.""",
"""**Nico**

> Mais on ne règle rien entre nous avec elles.

**Nico**

> Samedi, je parle pour moi. C’est tout.""")
replace_once(rel,
"> Je garde la confidence. Je ferme le commentaire.",
"> Ce que tu m’as dit reste ici. Le commentaire, j’arrête.")

# J13 — Pauline and Raphaëlle.
rel = "docs/canon/dialogues/J13_SCRIPT_NARRATIF_COMPLET.md"
replace_once(rel,
"> Et ne transforme pas Bastien en personne absente parce qu’il n’est pas dans le cadre.",
"> Bastien était là. Ne l’efface pas parce qu’il n’est pas sur la photo.")
replace_once(rel,
"""**11:22 — Pauline**

> Ce n’est pas une invitation à improviser le reste.

**11:22 — Pauline**

> C’est une information privée.""",
"""**11:22 — Pauline**

> Ça ne va pas plus loin tout seul.

**11:22 — Pauline**

> Je te l’envoie, c’est tout.""")
replace_once(rel,
"""**11:23 — Pauline**

> La version publique reste vraie.

**11:23 — Pauline**

> Je ne vais pas la punir parce que l’autre n’existe pas entre nous.""",
"""**11:23 — Pauline**

> La photo du groupe reste.

**11:23 — Pauline**

> Elle n’a rien fait.""")
replace_once(rel,
"> Tu viens de déplacer l’image hors de la raison pour laquelle je l’ai envoyée.",
"> Ce n’était pas pour ça.")
replace_once(rel,
"> Je te l’envoie parce que tu as respecté le cadre public hier.",
"> Je te l’envoie parce qu’hier tu n’as pas insisté.")
replace_once(rel,
"""**12:39 — Raphaëlle**

> C’est pour cela que j’ai gardé celle-ci plutôt que la plus spectaculaire.

**12:40 — Raphaëlle**

> Tu vois encore le travail quand l’effet fonctionne.""",
"""**12:39 — Raphaëlle**

> C’est pour ça que j’ai gardé celle-là.

**12:40 — Raphaëlle**

> La plus spectaculaire cachait le travail.""")
replace_once(rel,
"""**12:36 — Raphaëlle**

> Hier, tu as essayé d’obtenir une définition pendant que je maintenais un cadre public.

**12:37 — Raphaëlle**

> Je ne vais pas répondre aujourd’hui avec une image plus privée.""",
"""**12:36 — Raphaëlle**

> Hier, tu m’as demandé de trancher alors qu’on était en public.

**12:37 — Raphaëlle**

> Je ne vais pas répondre avec une photo plus privée.""")

# J14 — Marie, Pauline, Mathilde.
rel = "docs/canon/dialogues/J14_SCRIPT_NARRATIF_COMPLET.md"
replace_once(rel, "> Alors ne me présente pas ça comme un cadre propre.", "> Alors ne me dis pas que tout est clair.")
replace_once(rel,
"""**Marie**

> Donc ce n’est pas seulement une photo.

**Marie**

> C’est une place secrète que vous êtes en train de fabriquer.""",
"""**Marie**

> Alors vous avez commencé quelque chose derrière nous.""")
replace_once(rel,
"""**Marie**

> Tu as demandé la règle de l’image.

**Marie**

> Tu n’as pas demandé la règle de la relation.""",
"""**Marie**

> Tu as demandé ce que tu pouvais faire de la photo.

**Marie**

> Pas ce que ça faisait à votre relation.""")
replace_once(rel,
"""**20:19 — Marie**

> Ce n’est pas une preuve de ce qu’elle voulait.

**20:19 — Marie**

> C’est une information sur ce que toi tu savais.""",
"""**20:19 — Marie**

> Je ne sais pas ce qu’elle voulait.

**20:19 — Marie**

> Je sais que toi, tu savais assez pour fermer l’écran.""")
replace_once(rel,
"> je ne peux pas te montrer ni raconter son image sans son accord. mais je ne vais pas faire comme si tu n’avais rien vu. je te réponds ce soir à 21 h 30 après l’avoir prévenue",
"> je ne peux pas raconter sa photo sans lui demander. mais je te réponds à 21 h 30, après l’avoir prévenue")
replace_once(rel,
"""**Pauline**

> Dis-lui que je l’ai choisie pour une autre audience.

**Pauline**

> Et que Bastien ne le sait pas si tu décides de lui dire la vérité complète.""",
"""**Pauline**

> Dis-lui que je l’ai envoyée pour toi, pas pour le groupe.

**Pauline**

> Et que Bastien ne le sait pas, si tu choisis de lui dire.""")
replace_once(rel,
"> Pas pour me dénoncer. Pour qu’elle sache que son audience a changé pendant trois secondes.",
"> Pas pour me citer. Juste pour qu’elle sache que j’ai vu.")
replace_once(rel,
"> Je te demande de ne pas me transformer en personne qui couvre sans savoir.",
"> Je veux juste pas me retrouver à couvrir un truc que je connais pas.")
replace_once(rel,
"""**19:03 — Marie**

> Je ne vais pas inventer le reste.

**19:03 — Marie**

> Mais je ne vais pas faire semblant que cette phrase est ordinaire.""",
"""**19:03 — Marie**

> Je ne vais pas inventer le reste.

**19:03 — Marie**

> Mais cette phrase n’est pas normale.""")

# J17 — Marie.
rel = "docs/canon/dialogues/J17_SCRIPT_NARRATIF_COMPLET.md"
replace_once(rel,
"""**19:18 — Marie**

> Je ne veux pas un inventaire de tous tes messages.

**19:18 — Marie**

> Je ne veux pas les photos.

**19:19 — Marie**

> Je ne veux pas non plus une phrase où tu me dis que tu m’aimes et où tout le reste devient un problème de formulation.

**19:20 — Marie**

> Je veux savoir ce que tu veux réellement tenir maintenant.""",
"""**19:18 — Marie**

> Je ne veux pas lire tes fils.

**19:18 — Marie**

> Je ne veux pas les photos.

**19:19 — Marie**

> Et je ne veux pas qu’on résume tout à `je t’aime`.

**19:20 — Marie**

> Je veux savoir ce qui change demain.""")
replace_once(rel,
"""**19:25 — Marie**

> Ça ne veut pas dire que tu dois me transmettre la vie privée des autres.

**19:26 — Marie**

> Ça veut dire que tu ne décides plus seul quand une chose qui change notre accord devient assez importante pour exister.""",
"""**19:25 — Marie**

> Je ne te demande pas la vie privée des autres.

**19:26 — Marie**

> Je te demande de ne plus me laisser apprendre après.""")
replace_once(rel,
"""**Marie**

> Jeudi 20 h 30.

**Marie**

> Une heure réelle.

**Marie**

> Le dimanche d’après n’existe pas encore comme récompense.

**Marie**

> On le confirme jeudi si on est toujours capables de tenir la même règle.""",
"""**Marie**

> Jeudi 20 h 30.

**Marie**

> Le dimanche, on en parle jeudi.

**Marie**

> Je ne bloque pas une journée maintenant pour me rassurer.""")
replace_once(rel,
"""**19:24 — Marie**

> Cette phrase n’a pas d’heure, pas de lieu et pas de comportement.

**19:25 — Marie**

> Je ne peux pas vivre dans `mieux`.""",
"""**19:24 — Marie**

> Ça ne me dit pas ce que tu fais demain.

**19:25 — Marie**

> `Mieux`, je ne sais pas quoi en faire.""")
replace_once(rel,
"> Est-ce que tu veux construire une autre règle avec moi, ou garder toutes les portes ouvertes sans que j’aie de prise dessus ?",
"> Est-ce que tu veux qu’on essaie autrement ? Ou tu veux garder toutes les portes ouvertes ?")
replace_once(rel,
"""**19:27 — Marie**

> Ça ne veut pas dire que j’accepte rétroactivement ce qui a déjà été caché.

**19:27 — Marie**

> Ça veut dire que je refuse de décider sous la menace de la prochaine découverte.""",
"""**19:27 — Marie**

> Ça ne rend pas le passé acceptable.

**19:27 — Marie**

> Je ne vais juste pas attendre le prochain truc pour savoir où on en est.""")
replace_once(rel,
"> Je ne maintiens pas notre ancien accord pendant que tu décides tranquillement ce qu’il t’empêche de faire.",
"> Je ne vais pas continuer comme avant pendant que tu réfléchis à ce que tu veux garder.")
replace_once(rel,
"""**19:24 — Marie**

> C’est une réponse.

**19:25 — Marie**

> Pas une solution.

**19:25 — Marie**

> On peut partir de là si tu acceptes qu’entre-temps rien ne redevienne automatique.""",
"""**19:24 — Marie**

> D’accord.

**19:25 — Marie**

> Ce n’est pas réglé.

**19:25 — Marie**

> Mais au moins je sais que tu es encore là. Jusqu’à notre point, rien ne redevient automatique.""")
replace_once(rel,
"> Je ne vais pas rendre la phrase plus grande pour te faire changer d’avis.",
"> Je ne vais pas te faire répéter pour que ça fasse moins mal.")
replace_once(rel,
"""> Ce ne sont pas `quelques horaires`.

> Ce sont les moments où tu as décidé ce que j’avais le droit de savoir pour continuer à t’attendre.""",
"""> Ce n’étaient pas juste des heures.

> C’était chaque fois où j’attendais avec une version incomplète.""")

# J18 — Sandra.
rel = "docs/canon/dialogues/J18_SCRIPT_NARRATIF_COMPLET.md"
replace_once(rel, "> C’est précisément le problème.", "> Voilà.")
replace_once(rel,
"> Maintenant je dois décider si je la mets dans le livre avec les autres ou si je la laisse dans l’enveloppe.",
"> Je ne sais pas si je la mets dans le livre ou si je la laisse dans l’enveloppe.")
replace_once(rel,
"> Je veux décider si je garde encore une place pour toi autour de celle-ci.",
"> Je veux savoir si je te laisse encore une place là-dedans.")
replace_once(rel,
"""**19:06 — Sandra**

> Pas parce qu’elle annonce quelque chose.

**19:06 — Sandra**

> Parce que ce déjeuner a existé et qu’il était bien.""",
"""**19:06 — Sandra**

> Pas pour annoncer quoi que ce soit.

**19:06 — Sandra**

> Juste parce que ce déjeuner était bien.""")
replace_once(rel,
"""**19:02 — Sandra**

> Une image précise.

**19:03 — Sandra**

> Pas une règle générale.""",
"""**19:02 — Sandra**

> Celle-là.

**19:03 — Sandra**

> Pas les suivantes.""")
replace_once(rel,
"""**19:07 — Sandra**

> Ce que je garde surtout, c’est que tu as demandé avant.

**19:08 — Sandra**

> Ça semble très bas comme standard quand je l’écris.

**19:08 — Sandra**

> Et pourtant ça change tout.""",
"""**19:07 — Sandra**

> J’ai surtout remarqué que tu as demandé avant.

**19:08 — Sandra**

> C’est peu, dit comme ça.

**19:08 — Sandra**

> Mais je l’ai remarqué.""")
replace_once(rel,
"> Je ne vais pas faire semblant que la photo récente était seulement une expérience raisonnable.",
"> La photo récente n’était pas très raisonnable.")

# J19 — Pauline.
rel = "docs/canon/dialogues/J19_SCRIPT_NARRATIF_COMPLET.md"
replace_once(rel,
"""**16:45 — Pauline**

> La version publique est vraie.

**16:45 — Pauline**

> La version privée l’était aussi.

**16:46 — Pauline**

> Mon problème est que j’ai traité leur séparation comme une solution.

Silence.

**16:47 — Pauline**

> Je dois décider si je ferme le compartiment.

**16:47 — Pauline**

> Ou si j’arrête de prétendre qu’il est sans conséquence.""",
"""**16:45 — Pauline**

> La photo du groupe était vraie.

**16:45 — Pauline**

> L’autre aussi.

**16:46 — Pauline**

> Et j’ai fait comme si les séparer réglait le reste.

Silence.

**16:47 — Pauline**

> Je dois décider si je ferme ce fil.

**16:47 — Pauline**

> Ou si j’arrête de dire que ce n’est rien.""")
replace_once(rel,
"> Le réflexe de t’écrire une phrase différente de celle que je peux assumer dans la pièce où je suis.",
"> J’arrête de t’écrire des choses que je ne pourrais pas assumer si Bastien entrait dans la pièce.")
replace_once(rel,
"""**16:54 — Pauline**

> La version publique ne devient pas plus vraie grâce à ça.

**16:54 — Pauline**

> Elle était déjà vraie.

**16:55 — Pauline**

> Je vais simplement arrêter de lui construire une pièce cachée à côté.""",
"""**16:54 — Pauline**

> La photo du groupe était déjà vraie.

**16:55 — Pauline**

> J’arrête juste de lui construire une pièce cachée à côté.""")
replace_once(rel,
"""**16:52 — Pauline**

> Alors on enlève le mot `test`.

**16:52 — Pauline**

> Et le mot `accident`.

**16:53 — Pauline**

> Ce fil existe parce qu’on veut qu’il existe.""",
"""**16:52 — Pauline**

> Alors on arrête de dire que c’était un test.

**16:53 — Pauline**

> Ce fil existe parce qu’on l’ouvre.""")
replace_once(rel,
"""**16:57 — Pauline**

> Je ne vais pas appeler ça un cadre propre.

**16:57 — Pauline**

> C’est un compartiment conscient.

**16:58 — Pauline**

> Le risque est justement qu’il fonctionne.""",
"""**16:57 — Pauline**

> Je ne vais pas appeler ça propre.

**16:57 — Pauline**

> On sait ce qu’on fait.

**16:58 — Pauline**

> Le pire, c’est que ça peut marcher.""")
replace_once(rel,
"""**16:57 — Pauline**

> Comme trace.

**16:57 — Pauline**

> Le mot `preuve` donne une impression de sécurité que nous n’avons pas.""",
"""**16:57 — Pauline**

> Comme trace.

**16:57 — Pauline**

> `Preuve` ferait croire qu’on est protégés.""")
replace_once(rel, "> Voilà notre très mauvaise égalité.", "> Voilà notre mauvaise idée.")
replace_once(rel,
"""> Non.

> Tu acceptes.

> Ce n’est pas tout à fait pareil.""",
"""> Non.

> Tu acceptes.

> C’est pas pareil.""")
replace_once(rel, "> Et je ne te donnerai pas une attestation d’oubli.", "> Et je ne vais pas te promettre d’oublier.")
replace_once(rel, "> Là tu viens de transformer une dette en menace.", "> Là, tu viens de me menacer.")
replace_once(rel, "> Et je continue quand même à créer un endroit privé avec toi.", "> Et je continue quand même à t’écrire ici.")

# J20 — Nico.
rel = "docs/canon/dialogues/J20_SCRIPT_NARRATIF_COMPLET.md"
replace_once(rel, "> Je vais te dire le morceau moins noble.", "> Je vais te dire le truc moins joli.")
replace_once(rel,
"""**18:48 — Nico**

> Voilà ce que je peux faire.

**18:48 — Nico**

> Si tu me demandes si tu déconnes, je réponds.

**18:49 — Nico**

> Si tu me dis que tu as peur, je reste.

**18:49 — Nico**

> Si tu me demandes de rendre un mensonge crédible, je sors du fil.

**Player**

> compris

**18:50 — Nico**

> Et si quelqu’un me demande un fait auquel j’étais présent, je donne le fait.

**18:50 — Nico**

> Pas ton résumé.

**18:51 — Nico**

> Pas le mien.

**18:51 — Nico**

> Le fait.""",
"""**18:48 — Nico**

> Si tu me demandes si tu déconnes, je réponds.

**18:49 — Nico**

> Si tu as peur, je reste.

**18:49 — Nico**

> Mais pas d’alibi.

**Player**

> compris

**18:50 — Nico**

> Et si on me demande une heure où j’étais là, je donne l’heure.

**18:51 — Nico**

> Pas ton histoire autour.""")
replace_once(rel,
"""**18:48 — Nico**

> Tu peux me dire que tu la veux.

**18:49 — Nico**

> Tu peux me dire que tu as menti.

**18:49 — Nico**

> Tu peux me dire que tu ne sais pas ce que tu veux.

**18:50 — Nico**

> Tu ne m’envoies pas ses photos pour m’expliquer.

**18:50 — Nico**

> Tu ne me donnes pas ses messages comme pièces à conviction.

**18:51 — Nico**

> Et tu ne me demandes pas de parler à une femme ou à son mec à ta place.""",
"""**18:48 — Nico**

> Tu peux me dire que tu la veux, que tu as menti ou que tu ne sais pas.

**18:50 — Nico**

> Mais tu ne m’envoies pas ses photos ou ses messages pour plaider ton dossier.

**18:51 — Nico**

> Et tu ne me demandes pas de parler à quelqu’un à ta place.""")
replace_once(rel, "> Le reste n’appartient pas à celui qui demande juste parce qu’il demande fort.", "> Le reste, je le garde pour moi.")
replace_once(rel,
"""**18:49 — Nico**

> Marie me plaît.

**18:49 — Nico**

> Pas uniquement quand elle porte la robe noire.

**18:50 — Nico**

> Pas uniquement quand elle est en colère contre toi.

**18:50 — Nico**

> Elle me plaît aussi quand elle déplace six chaises et insulte poliment un prestataire.""",
"""**18:49 — Nico**

> Marie me plaît.

**18:50 — Nico**

> Pas seulement avec la robe noire ou quand elle t’en veut.

**18:50 — Nico**

> Même quand elle déplace six chaises et engueule poliment un prestataire.""")
replace_once(rel,
"> Je ne vais pas lui parler derrière ton dos pendant que votre règle est encore active.",
"> Je ne vais pas lui parler derrière ton dos pendant que vous êtes encore ensemble.")
replace_once(rel,
"> Mais je ne vais pas non plus prétendre que je ne veux rien pour rendre notre amitié plus confortable.",
"> Mais je ne vais pas faire comme si je ne voulais rien juste pour te rassurer.")

# J21 — Marie, Sandra, Mathilde, Raphaëlle.
rel = "docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md"
replace_once(rel,
"""**07:44 — Marie**

> Voilà.

**07:44 — Marie**

> Une décision exploitable.""",
"""**07:44 — Marie**

> Voilà.

**07:44 — Marie**

> C’est déjà mieux.""")
replace_once(rel,
"""**07:44 — Marie**

> Pour nous : aucune nouvelle étape avant jeudi 20 h 30.

**07:45 — Marie**

> Je préfère le réécrire un matin normal.

**07:45 — Marie**

> Pas uniquement quand quelqu’un nous oblige à en parler.""",
"""**07:44 — Marie**

> Pour nous : aucune nouvelle étape avant jeudi 20 h 30.

**07:45 — Marie**

> Je te le redis maintenant, pendant qu’on parle juste d’une réunion.

**07:45 — Marie**

> Pas après un nouveau problème.""")
replace_once(rel,
"""**11:20 — Marie**

> Je l’avais regardée au début en me demandant si tu voyais encore quelque chose quand tu me regardais.

Silence.

**11:21 — Marie**

> Maintenant je me demande surtout si tu rejoins la vie qui est sur la photo.""",
"""**11:20 — Marie**

> Au début, je la regardais surtout pour voir si tu me voyais encore.

Silence.

**11:21 — Marie**

> Maintenant je regarde si tu viens.""")
replace_once(rel,
"""> Cette image n’autorise rien.

> Elle me rappelle seulement que notre vie existe aussi hors de nos règles écrites.""",
"""> La photo ne décide rien pour nous.

> Elle me rappelle juste qu’on a aussi une vie en dehors de nos discussions.""")
replace_once(rel,
"""**Sandra**

> La photo ressemble toujours à un déjeuner.

**Sandra**

> Je sais maintenant qu’elle ne raconte pas seulement ça pour moi.

**Sandra**

> Je la garde quand même.""",
"""**Sandra**

> La photo ressemble toujours à un déjeuner.

**Sandra**

> Moi, je ne la vois plus seulement comme ça.

**Sandra**

> Je la garde.""")
replace_once(rel,
"""**Mathilde**

> Je ne supprime pas ce qui existait avant.

> Je ne le transforme pas non plus en permission pour après.""",
"""**Mathilde**

> Je ne vais pas effacer ce qui était vrai.

> Mais ça ne veut pas dire qu’on recommence.""")
replace_once(rel,
"""> Je garde la version.

> Je garde aussi la limite.

> Ce ne sont pas deux décisions opposées.""",
"""> Je garde l’image.

> La limite aussi.""")

# Guide result.
rel = "docs/canon/dialogues/J07_J21_LOT_D_POLISH_VOIX_NATUREL.md"
text = read(rel)
text += """

---

# 6. Résultat appliqué

La passe modifie directement les scripts suivants :

```text
J10
J11
J13
J14
J17
J18
J19
J20
J21
```

J07–J09, J12, J15 et J16 ont été relus mais conservés : leur rythme actuel ne nécessitait pas une nouvelle modification après la consolidation du lot C.

Les changements concernent uniquement la formulation des messages. Les identifiants canoniques ont été comparés avant et après chaque remplacement et sont inchangés.

Statut final :

```text
LOT D APPLIQUÉ
CORPUS NARRATIF CONSOLIDÉ
AUCUNE MODIFICATION RUNTIME
PROCHAINE ÉTAPE : VALIDATION FINALE AVANT REPRISE TECHNIQUE
```
"""
write(rel, text)

# Governance documents.
for rel in [
    "docs/canon/dialogues/README.md",
    "docs/canon/DOCUMENTATION_READING_ORDER.md",
    "docs/canon/NARRATIVE_CANON_STATUS.md",
]:
    data = read(rel)
    data = data.replace("lot D : polish des voix", "lot D : polish des voix validé")
    data = data.replace("Lot D | prochaine étape", "Lot D | validé")
    data = data.replace("Voice polish lot D: next", "Voice polish lot D: validated")
    data = data.replace("Prochaine étape — lot D : polish des voix", "Lot D — validé\nProchaine étape — validation finale avant reprise technique")
    data = data.replace("Current phase: long-form voice polish — lot D", "Current phase: final narrative sign-off before technical resumption")
    data = data.replace("La prochaine étape est la passe de naturel et de distinction des voix sur le corpus consolidé.", "La prochaine étape est la validation finale du corpus narratif avant toute reprise technique.")
    data = data.replace("The next phase is the long-form naturalness and voice-distinction polish on the consolidated corpus.", "The next phase is final narrative sign-off before any technical resumption.")
    write(rel, data)

print("Lot D dialogue polish completed successfully.")
