---
categories:
- aero
date: "2016-01-26T00:00:00Z"
icon: music
title: solo électrique
---

*Cet article fait partie de la série [Aerodynamic]({% post_url music/2016-01-21-aerodynamic %}).*

On passe à présent au `solo` guitare, dont voici l'extrait une fois
importé dans *Sonic Visualizer* :

<img src="/public/img/aerodynamic/solo.png" data-action="zoom" />

Là encore c'est un spectrogramme avec en abcisse le temps, et en
ordonnée les fréquences sonores.  On voit des bandes horizontales
composées de tâches (les fréquences sonores actives) : ce sont les
différentes notes. Elles sont regroupées en plusieurs phases, chaque
phase étant composée de 3 lignes horizontables ayant une durée de 16
temps. En zoomant sur une de ces phases, on se rend compte qu'il
s'agit d'une répétition de notes de la manière suivante:

<img src="/public/img/aerodynamic/solo-notes.png" data-action="zoom" />

On peut récupérer la note derrière chaque bande de fréquence active avec
*Sonic Visualizer* et recomposer ainsi le premier temps :

1. joue la note `Ré` pendant 1/4 de temps
2. joue la note `Fa majeur` pendant 1/4 de temps
3. joue la note `Mi` pendant 1/4 de temps
4. joue la note `Fa majeur` pendant 1/4 de temps

Ce qui donne dans *Sonic Pi*, avec un instrument ayant un timbre
electrique :

```ruby
use_bpm 123

use_synth :zawa
use_synth_defaults attack: 0.05, sustain: 0.15, release: 0.125

live_loop :solo do
    play :D4
    sleep 0.25
    play :Fs3
    sleep 0.25
    play :B3
    sleep 0.25
    play :Fs3
    sleep 0.25
end
```

Comme précedemment, on exprime les notes en notation anglaise :

* *Ré* devient *D4*
* *Fa majeur* devient *Fs3*
* *Si* devient *B3*

Aussi, on configure l'instrument *zawa* avec les paramètres `attack`,
`sustain` et `release`. Ces paramètres forment ce que l'on apelle plus
couramment l'*enveloppe sonore* d'une note (ou `ADSR`) ; ils
définissent la manière dont évolue le volume de la note au cours du
temps :

<img src="/public/img/aerodynamic/solo-adsr.png" data-action="zoom" />

Chaque lettre correspond à une de ces phases (**A**ttack, **D**ecay,
que nous n'utilisons pas ici, **S**ustain, et **R**elease). Pour
mieux comprendre l'impact de ces valeurs, le plus simple est de les
éditer en live et d'écouter la différence (en modifiant le code et en
faisant un `Run` à chaque fois).

## Factorisation

Plutôt que de demander à *Sonic Pi* de jouer une note, puis de faire
une pause, puis d'en jouer une seconde, puis de faire à nouveau une
pause, …, on peut le formuler de manière plus courte ainsi :

```ruby
use_bpm 123

use_synth :zawa
use_synth_defaults attack: 0.05, sustain: 0.15, release: 0.125

notes = [:D4, :Fs3, :B3, :Fs3]

live_loop :solo do
  notes.each do |n|
      play n
      sleep 0.25
  end
end
```

Cela se lit de la manière suivante :

* utilise un BPM de 123, utilise l'instrument *zawa*, configure l'*ADSR* de l'instrument
* met dans la liste `notes` les 4 notes *D4*, *Fs3*, *B3* et *Fs3*
* crée une boucle live dans laquelle…
* pour chaque note `n` de la liste `notes`…
* joue la note `n`, puis attend 0.25 temps

On obtient ainsi la même chose et on peut faire évoluer en live le
morceau en éditant directement les notes, sans avoir à se soucier de
la partie logique.

## Un peu plus loin

En suivant la même approche, on peut récupérer les 32 temps de la
partie `solo`:

| Phase | Note 1 | Note 2 | Note 3 | Note 4 |
|-------|--------|--------|--------|--------|
| #1    |  D4    |  Fs3   |  B3    |  Fs3   |
| #2    |  D4    |  Gs3   |  B3    |  Gs3   |
| #3    |  G4    |  B3    |  E4    |  B3    |
| #4    |  E4    |  A3    |  Cs4   |  A3    |
| #5    |  D4    |  Fs4   |  B3    |  Fs4   |
| #6    |  D4    |  Gs4   |  B3    |  Gs4   |
| #7    |  G4    |  B3    |  E4    |  B3    |
| #8    |  E4    |  A3    |  Cs4   |  A3    |

De la même manière que pour les notes, on peut itérer sur un tableau
comprenant chacune de ces phases, puis les jouer 4 fois :

```ruby
live_loop :solo do
    use_synth :zawa
    use_synth_defaults attack: 0.05, sustain: 0.15, release: 0.125

    phases = [
        [:D4, :Fs3, :B3, :Fs3],
        [:D4, :Gs3, :B3, :Gs3],
        [:G4, :B3, :E4, :B3],
        [:E4, :A3, :Cs4, :A3],

        [:D4, :Fs4, :B3, :Fs4],
        [:D4, :Gs4, :B3, :Gs4],
        [:G4, :B3, :E4, :B3],
        [:E4, :A3, :Cs4, :A3],
    ]

    phases.each do |notes|
        4.times do
            notes.each do |n|
                play n
                sleep 0.25
            end
        end
    end
end
```

[La suite par ici...]({% post_url music/2016-01-27-aerodynamic-tout-ensemble %})

<hr />

*Cet article fait partie de la série [Aerodynamic]({% post_url music/2016-01-21-aerodynamic %}).*
