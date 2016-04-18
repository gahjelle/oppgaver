---
title: Jumpman, del 2 - Kollisjon
level: 4
author: Geir Arne Hjelle
---

# Introduksjon {.intro}

Før Super Mario fikk sine egne spill het han Jumpman. I dette
prosjektet skal vi lage et Super Mario-lignende plattformspill. Det er
ganske involvert, og vi vil derfor dele opp prosjektet i fire deler
som til sammen blir et spennende spill.

I denne andre delen skal vi fokusere på hvordan vi kan gjøre avansert
kollisjonsdeteksjon, og blant annet merke forskjellen på om Jumpman
står på en plattform eller hopper opp i en plattform nedenfra.

![](jumpman_2_kollisjon.png)

# Oversikt over prosjektet {.activity}

Dette prosjektet består av 4 deler hvor vi stadig videreutvikler
spillet vårt.

+ I [del 1](jumpman_1_animasjon.html) programmerte vi helten vår,
  Jumpman, og spesielt animerte vi ham alt etter som om han stod i ro,
  løp eller hoppet.

+ I denne delen vil vi se hvordan vi kan oppdage at Jumpman berører
  forskjellige ting, og spesielt hvordan vi kan se forskjellen på om
  han hopper opp i en plattform eller står på toppen av den.

+ I [del 3](jumpman_3_skrolling.html) skal vi utvide verdenen vår ved
  å flytte på bakgrunnen. Vi vil da kunne løpe rundt og oppdage
  plattformer utenfor skjermen.

+ I [fjerde og siste del](jumpman_4_design.html) vil vi lære hvordan
  vi lager flere nivåer, samt hvordan vi kan inkludere elementer som
  smarte fiender og bevegelige plattformer.

# Steg 1: Sensorer {.activity}

*Vi skal nå se hvordan vi kan få mer kontroll på hvordan Jumpman
 berører verden rundt seg. Til dette skal vi lage noen spesielle
 figurer som vi kaller sensorer.*

## Sjekkliste {.check}

+ Hent inn Jumpman-spillet som du laget i
  [del 1](jumpman_1_animasjon.html).

+ Tegn en ny figur som du kaller `Sensor - Fot`. La denne bestå av en
  kort vannrett strek, omtrent på størrelse med føttene til
  Jumpman-animasjonene.

  ![](sensor_fot.png)

+ Vi skal nå skrive kode som *limer* denne sensoren til føttene til
  Jumpman, på samme måte som vi lot `Animasjon`-figurene følge
  `Kontroller`-figuren. Lag først en ny variabel, `(sensor -
  fot)`{.b}, som gjelder *for alle figurer*. Skriv deretter:

  ```blocks
      når jeg mottar [oppdater sensor v]
      sett [sensor - fot v] til [nei]
      pek i retning ([retning v] av [Kontroller v])
      sett x til ([x-posisjon v] av [Kontroller v])
      sett y til ([y-posisjon v] av [Kontroller v])
  ```

+ Du la kanskje merke til at meldingen `oppdater sensor` var ny? Legg
  til både `send melding [oppdater sensor v]`{.b} og `send melding
  [sjekk sensor v]`{.b} øverst i `for alltid`{.blockcontrol}-løkken på
  scenen.

+ Test spillet ditt. Du skal nå ha en `Sensor - Fot`-figur som følger
  Jumpman rundt på skjermen. Om figuren ikke ligger ved føttene til
  Jumpman kan du flytte den ved hjelp av
  ![velg senterpunkt](../bilder/velg_senterpunkt.png)-knappen under
  `Drakter`-fanen.

+ Nå skal vi bruke sensoren. Legg til dette skriptet på `Sensor -
  Fot`-figuren:

  ```blocks
      når jeg mottar [sjekk sensor v]
      hvis <berører fargen [#009900]?>
          sett [sensor - fot v] til [ja]
      slutt
  ```

  Bytt deretter *alle* `<berører fargen [#009900]?>`{.b}-klosser på
  `Kontroller`-figuren med `<(sensor - fot) = (ja)>`{.b}-klosser.

+ Test spillet ditt igjen. Det skal fungere akkurat slik det gjorde
  før vi la til sensoren (i neste steg vil du se hvorfor det likevel
  er nyttig med denne sensor-figuren). Om du er fornøyd kan du skjule
  sensoren ved å gjøre den gjennomsiktig:

  ```blocks
      når grønt flagg klikkes
      sett [gjennomsiktig v] effekt til (100)
      begrens rotasjon [ikke roter v]
  ```

# Steg 2: Mursteiner {.activity}

*Vi skal nå lage mursteiner som vi både kan bruke som plattformer, og
 vi kan hoppe i dem nedenfra og få ting til å skje.*

+ Lag en ny sensor-figur, `Sensor - Hode`, som du gir det samme
  `oppdater sensor`-skriptet som `Sensor - Fot` (men med den nye
  variabelen `(sensor - hode)`{.b} som gjelder for alle
  figurer). Plasser denne figuren ved toppen av hodet til Jumpman.

# Steg 3: Fruktsalat og andre superkrefter! {.activity}

# Steg 4: Videreutvikling av spillet {.activity}

*Nå begynner spillet vårt å ta form, selv om vi vil fortsette
 utviklingen i [del 3](jumpman_3_skrolling.html). Nedenfor er forslag
 til hvordan du kan jobbe videre med spillet før neste del.*

## Ideer til videreutvikling {.check}

+ Legg til `Sensor - Venstre`- og `Sensor - Høyre`-figurer. Disse
  lager du på samme måte som `Sensor - Fot`- og `Sensor -
  Hode`-figurene. Bruk disse for å hindre `Kontroller`-figuren i å gå
  gjennom vegger ved å bytte for eksempel `<tast [pil høyre v]
  trykket?>`{.b} med `<<tast [pil høyre v] trykket?> og <(sensor -
  høyre) = [nei]>>`{.b}.

+ Det kan være nyttig med en `Sensor - Kne`-figur. Denne kan du bruke
  for å oppdage om Jumpman står inne i en plattform i stedet for oppå
  den. Lag figuren på vanlig måte. Legg deretter til denne testen inne
  i `hvis <(sensor - fot) = [ja]> :: reporter`{.b}-testen i `sjekk
  plattform`-skriptet på `Kontroller`:

  ```blocks
      hvis <(sensor - kne) = [ja]>
          endre y med (2)
      slutt
  ```
