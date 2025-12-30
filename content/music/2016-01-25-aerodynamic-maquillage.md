---
categories:
- aero
- music
date: "2016-01-25T00:00:00Z"
icon: music
title: un peu de maquillage
disable_listing: true
---

*Cet article fait partie de la série <a href="/music/2016-01-21-aerodynamic.html">Aerodynamic</a>.*

*Daft Punk* est reconnu en partie pour son utilisation de samples :
une grande partie de l'album Discovery est fait à partir d'extraits de
chansons disco des années 80. *Aerodynamic* n'échappe pas à cette
règle puisque la partie `funk` du morceau est construite à partir du
morceau du groupe *Sister Sledge*,
[Il macquillage lady](https://www.youtube.com/watch?v=tJWPZuFsdrk), en
particulier cet extrait :

<center>
   <audio controls="controls">
      <source src="/misc/il-macquillage-lady.wav" type="audio/wav" />
   </audio>
</center>

L'extrait dure 7.78'' et comprend 16 temps, il est donc à `60 / (7.780
* 16)` BPM, soit 123.4 BPM, c'est très proche du morceau
*Aerodynamic* qui lui est à 123 BPM. On va voir comment partir de ça
pour arriver à quelque chose proche de :

<center>
   <audio controls="controls">
       <source src="/misc/funk.wav" type="audio/wav" />
   </audio>
</center>

On remarque quelques similitudes, mais il est assez difficile de
s'imaginer comment tout s'enchaîne, même après plusieurs écoutes.

## Préparation de l'extrait

On va commencer par préparer et découper l'extrait des *Sister
Sledge*, puis on piochera les petits morceaux (samples) qui nous
intéressent pour ensuite reconstruire le funk de *Daft Punk*. Une fois
l'[extrait original](/misc/il-macquillage-lady.wav) et
[celui des Daft-Punk](/misc/funk.wav) téléchargés, on peut les
charger dans *Sonic Pi* à l'aide de l'instruction `load_sample` et les
jouer ainsi :

```ruby
maquillage = "~/il-macquillage-lady.wav"
load_sample maquillage
sample maquillage
```

Ce qui se traduit par:

* met dans `maquillage` le chemin vers le fichier
* charge ce fichier son dans *Sonic Pi* avec `load_sample`
* joue ce fichier son avec `sample`

Comme on l'a précedemment vu, *Aerodynamic* a un tempo de 123 BPM, ce
qui n'est pas le cas de l'extrait des *Sister Sledge*, on le
redimensionne donc pour qu'il le soit:

```ruby
use_bpm 123

maquillage = "~/il-maquillage-lady.wav"
load_sample maquillage
sample maquillage, beat_stretch: 16
```

L'appel à `use_bpm` est maintenant familier, en revanche le
`beat_stretch` est quelque peu magique : il a pour effet de caller
l'extrait `maquillage` sur 16 temps à 123 BPM, soit exactement comme
l'extrait d'*Aerodynamic*. À présent, on peut jouer un petit morceau
de cet extrait à l'aide des paramètres `start` et `finish` :

```ruby
use_bpm 123

maquillage = "~/il-maquillage-lady.wav"
load_sample maquillage
sample maquillage, beat_stretch: 16, start: 0.0, finish: 1/16.0
```

`start` et `finish` prennent un indice en paramètre, qui a une valeur
comprise entre 0.0 et 1.0 :

- 0.0 est le début de l'extrait
- 1.0 est la fin de l'extrait

Comme l'extrait est sur 16 temps, on joue ici son premier temps en
partant de 0.0 pour aller à 1/16.0. Quelques autres exemples :

* `start: 6.0 / 16.0`: commence à jouer au temps 6
* `start: 2.5 / 16.0`: commence à jouer au temps 2.5
* `end: 0.5 / 16.0`: fini de jouer au temps 0.5

Une technique est donc de prendre une par une les sections
d'*Aerodynamic* et de trouver la section correspondante dans l'extrait
d'*Il Macquillage Lady*.

## Let's funk

Pour simplifier la tâche, voici une fonction *Sonic Pi* qui va nous
aider:

```ruby
use_bpm 123

maquillage = "~/il-macquillage-lady.wav"
load_sample maquillage

aerodynamic = "~/funk.wav"
load_sample aerodynamic

define :sample_chunk do |what, beat, dur, delay|
    beat = beat / 16.0
    dur = dur / 16.0
    sample what, beat_stretch: 16, start: beat, finish: beat + dur
	sleep delay
end

sample_chunk(maquillage, 4.0, 1.0, 0.0)
```

L'instruction `define` permet de créer une nouveau mot clef dans *Sonic Pi* que
l'on apelle `sample_chunk` et qui prend quatres paramètres :

* `what` : le sample à jouer
* `beat` : le temps à jouer
* `dur` : la durée à jouer en temps
* `delay` : le temps à attendre avant de continuer

Ainsi, si l'on veut jouer l'extrait de *Il Macquillage Lady* au temps 4
pour une durée de 1 temps, on peut faire :

```ruby
sample_chunk(maquillage, 4.0, 1.0, 0.0)
```

Un autre exemple, jouer le premier demi-temps de l'extrait
d'*Aerodynamic* puis faire une pause de 2 temps :

```ruby
sample_chunk(aerodynamic, 0.0, 0.5, 2.0)
```

On peut à présent jouer facilement n'importe quel morceau des deux
extraits ! Après quelques heures d'écoutes et de bricolage, voici
ce qu'on peut obtenir :

```ruby
use_bpm 123

maquillage = "~/il-macquillage-lady.wav"
aerodynamic = "~/funk.wav"

load_sample maquillage
load_sample aerodynamic

define :sample_chunk do |what, beat, dur, delay|
    beat = beat / 16.0
    dur = dur / 16.0
    sample what, beat_stretch: 16, start: beat, finish: beat + dur
    sleep delay
end

define :funk do
    # sample_chunk(aerodynamic, 0.0, 4.0, 4.0)

    sample_chunk(maquillage, 0.0, 0.5, 0.5)
    sample_chunk(maquillage, 2.5, 1.0, 0.25)
    sample_chunk(maquillage, 3.5, 0.5, 0.75)
    sample_chunk(maquillage, 0.0, 0.5, 0.5)
    sample_chunk(maquillage, 8.5, 0.5, 0.5)
    sample_chunk(maquillage, 2.5, 1.0, 1.0)
    sample_chunk(maquillage, 7.5, 0.5, 0.5)

    # sample_chunk(aerodynamic, 4.0, 4.0, 4.0)

    sample_chunk(maquillage, 3.5, 0.5, 0.5)
    sample_chunk(maquillage, 2.5, 1.0, 1.0)
    sample_chunk(maquillage, 7.5, 0.5, 0.5)
    sample_chunk(maquillage, 8.5, 0.5, 0.5)
    sample_chunk(maquillage, 2.5, 1.0, 1.0)
    sample_chunk(maquillage, 7.5, 0.5, 0.5)

    # sample_chunk(aerodynamic, 8.0, 4.0, 4.0)

    sample_chunk(maquillage, 0.0, 0.5, 0.5)
    sample_chunk(maquillage, 2.5, 1.0, 0.25)
    sample_chunk(maquillage, 3.5, 0.5, 0.75)
    sample_chunk(maquillage, 0.0, 0.5, 0.5)
    sample_chunk(maquillage, 8.5, 0.5, 0.5)
    sample_chunk(maquillage, 2.5, 1.0, 1.0)
    sample_chunk(maquillage, 7.5, 0.5, 0.5)

    # sample_chunk(aerodynamic, 12.0, 4.0, 4.0)

    sample_chunk(maquillage, 3.5, 0.5, 0.5)
    sample_chunk(maquillage, 8.5, 0.25, 0.0)
    sample_chunk(maquillage, 2.5, 1.0, 0.25)
    sample_chunk(maquillage, 3.5, 0.5, 0.5)
    sample_chunk(maquillage, 8.5, 0.25, 0.25)
    sample_chunk(maquillage, 3.5, 0.5, 0.5)
    sample_chunk(maquillage, 8.5, 0.5, 0.5)
    sample_chunk(maquillage, 2.5, 1.0, 1.0)
    sample_chunk(maquillage, 7.5, 0.5, 0.5)
end

funk
```

On met tout dans la fonction `funk`, que l'on peut jouer avec un
simple appel sans paramètres. On remarque au passage que si l'on
additionne les valeurs de delay, on obtient 16, ce qui est rassurant
vu que l'extrait fait 16 temps.

C'est presque ça !

## Un peu de maquillage

Il manque quelques effets pour se rapprocher d'*Aerodynamic*, il y a
notamment un effet cyclique tous les 8 temps, qui se rapproche de
l'effet `ixi_techno` de Sonic Pi :

```ruby
live_loop :funk do
    with_fx :ixi_techno, mix: 0.1, phase: 8, cutoff_min: 90 do
        funk
    end
end
```

`live_loop` est un nouveau mot clef qui permet d'encadrer du son dans
une boucle : arrivé à la fin du bloc, on va repartir au tout début en
prenant en compte les changements du bloc. C'est très pratique car
l'on peut ainsi éditer en live le son et découvrir l'influence de
chaque paramètre. Il faut appeler `Run` pour prendre en compte les
modifications.

On peut par exemple tenter de voir l'influence du paramètre `mix`
ainsi :

* on évalue une première fois avec `Run`
* on change la valeur de `mix` à 0.5
* on évalue une seconde fois avec `Run`

À la prochaine itération de la boucle, on entend les
modifications. Cette approche permet d'éditer en live le morceau et de
le faire évoluer petit à petit !

<a href="/music/2016-01-26-aerodynamic-solo.html">La suite par ici...</a>

<hr />

*Cet article fait partie de la série <a href="/music/2016-01-21-aerodynamic.html">Aerodynamic</a>.*
