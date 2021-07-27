---
categories:
- aero
- music
date: "2016-01-24T00:00:00Z"
icon: music
title: quelque chose qui cloche
disable_listing: true
---

*Cet article fait partie de la série <a href="/music/2016-01-21-aerodynamic">Aerodynamic</a>.*

On va maintenant s'intéresser en détail à la première partie du
morceau : `bell`, soit les 4 sons de cloche au début du morceau ;
voici ce que donne cette partie une fois importée dans *Sonic Visualizer* :

<img data-action="zoom" src="/img/aerodynamic/cloche-sonic-visualizer-1.jpg" />

Il s'agit d'un spectrogramme, en abcisse on a le temps, en ordonnée
les fréquences sonores. On voit 4 zones distinctes, qui correspondent
aux sons des cloches. On voit également des bandes horizontales à
différentes hauteurs: elles correspondent aux fréquences sonores du
son de la cloche, plus elles tendent vers le rouge, plus la fréquence
est intense. Un instrument de musique joue généralement une note qui
se traduit par la bande la plus intense, les autres bandes
correspondent au *timbre* de l'instrument: chaque instrument possède
sa propre signature plus ou moins élaborée. Ici, la bande la plus
intense est à 220 Hz (vers le bas de l'image), soit, la note `A3`.

La version simple de ces 4 bouts de cloche correspond dans *Sonic Pi*
à:

```ruby
use_bpm 123
use_synth :pretty_bell

4.times do
    play :A3
    sleep 8
end
```

Ce qui veut dire:

* utilise un BPM de 123
* utilise l'instrument `pretty_bell` (une des cloches de *Sonic Pi*)
* effectue 4 fois ce qui se trouve entre `do` et `end`
* dans le bloc, joue la note `A3`, puis attend 8 temps

Lorsque l'on execute ce code, on entend donc un son de cloche tous
les 8 temps, 4 fois de suite.

Premier soucis, la durée de nos sons de cloche ne correspond pas
vraiment à ce que l'on cherche. Pas de problèmes, les instruments de
Sonic Pi se configurent avec des paramètres, certains concernent la
durée des notes.

Si on reprend le spectrogramme de tout à l'heure, on voit que
l'intensité de chaque fréquence diminue dans le temps : les fréquence
actives tendent vers le rouge au début du son de cloche (intensité
forte) pour progressivement tendre vers le vert (intensité faible).
De plus, à la fin des 8 temps, certaines fréquences sont toujours
actives, à vue d'oeil on a l'impression que chaque son de cloche
s'étale sur 9 temps. Ces deux caractéristiques de la note peuvent
s'obtenir avec le paramètre `release`, qui étire une note sur une
durée donnée et qui, progressivement, diminue son intensité :

```ruby
use_synth :pretty_bell
use_synth_defaults release: 9

4.times do
    play :A3
    sleep 8
end
```

On se rapproche du but! Mais ce n'est toujours pas très convainquant
car le timbre de l'instrument de cloche de *Sonic Pi* n'est pas le même
que celui que l'on recherche. Cela veut dire que les bandes
horizontales produites par la cloche de Sonic Pi, mêmes si elles ont
pour note principale `A3`, sont différentes. Voici ce que donne notre
cloche une fois passée sous Sonic Visualizer:

<img src="/img/aerodynamic/cloche-sonic-visualizer-2.jpg" data-action="zoom" />

En haut, on voit la cloche originale, en bas, notre version :
effectivement, on en est loin, il nous manque du timbre! On peut en
ajouter en superposant plusieurs sons de cloches, avec des amplitudes
réduites sur les octaves autours de `A3` :

```ruby
use_bpm 123

use_synth :pretty_bell
use_synth_defaults release: 9

4.times do
    play :A1, amp: 0.125
    play :A2, amp: 0.25
    play :A3, amp: 0.75
    play :A4, amp: 0.40
    play :A5, amp: 0.25
    sleep 8
end
```

Le fait de faire plusieurs appels à `play` à la suite a pour
conséquence de jouer tout en parallèle, c'est l'appel à `sleep` qui
introduit la pause entre chaque coup de cloche, on a donc à chacune des
4 itérations :

* un coup de cloche `A1` avec une amplitude de 12.5%
* un coup de cloche `A2` avec une amplitude de 25%
* un coup de cloche `A3` avec une amplitude de 75%
* un coup de cloche `A4` avec une amplitude de 40%
* un coup de cloche `A5` avec une amplitude de 25%

Cela a pour effet de remplir un peu plus la plage des fréquences
actives et à se rapprocher du timbre original, ce n'est pas exactement
le même mais c'est satisfaisant.

Il manque un brin de profondeur et de distance, que l'on peut obtenir
à l'aide de l'effet `gverb`, que l'on applique autours de nos
instructions `play` :

```ruby
use_bpm 123

use_synth :pretty_bell
use_synth_defaults release: 9

4.times do
    with_fx :gverb, room: 20 do
        play :A1, amp: 0.25
    	play :A2, amp: 0.5
        play :A3, amp: 1.5
        play :A4, amp: 0.75
        play :A5, amp: 0.5
 	sleep 8
    end
end
```

L'effet `gverb` s'applique au bloc qui suit, on l'utilise ici avec le
paramètre `room` à 20 (sa valeur par défault est de 10) pour augmenter
l'effet de distance.

*Sonic Pi* propose tout une collection d'effets dont le nombre
augmente avec chaque mise à jour, qu'il est possible de parcourir via
l'aide en bas à gauche, dans l'onglet `Fx` ; chaque effet possède sa
propre documentation, avec les différents paramètres possibles :

<img src="/img/aerodynamic/help-fx.png" data-action="zoom" />

<a href="/music/2016-01-25-aerodynamic-maquillage">La suite par ici...</a>

<hr />

*Cet article fait partie de la série <a href="/music/2016-01-21-aerodynamic">Aerodynamic</a>.*
