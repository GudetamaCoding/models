;; the following turtle variables refer to the colors of the 3 focal patches in a neighborhood
turtles-own [left-pcolor center-pcolor right-pcolor]

to setup
  clear-all
  make-turtles
  ask patch 0 max-pycor [ set pcolor yellow ]  ;; create initial yellow cell in the top center of the world
  reset-ticks
end

to make-turtles
  ask patches with [pycor = max-pycor]  ;; create turtles along the top of the world
  [
    sprout 1 ;; each patch sprouts a turtle
    [
      set heading 180 ;; face the turtle downwards
      hide-turtle     ;; make the turtle invisible
    ]
  ]
end

;; run the CA one view
to go
  if (not any? turtles)
    [ stop ]  ;; stop at the last row
  ask turtles
  [
    do-rule      ;; evaluate rule 30 for each turtle
    fd 1         ;; move down to the next row
    if pycor = min-pycor
      [ die ]    ;; if you've reached bottom, die
  ]
  tick
end

;; set the state of the patch below the turtle by applying rule 30
to do-rule  ;; turtle procedure
  set left-pcolor [pcolor] of patch-at -1 0
  set center-pcolor pcolor
  set right-pcolor [pcolor] of patch-at 1 0
  ifelse ((left-pcolor = yellow and center-pcolor = black and right-pcolor = black) or  ;; evaluate rule 30
          (left-pcolor = black and center-pcolor = yellow and right-pcolor = yellow) or
          (left-pcolor = black and center-pcolor = yellow and right-pcolor = black) or
          (left-pcolor = black and center-pcolor = black and right-pcolor = yellow))
    [ ask patch-at 0 -1 [ set pcolor yellow ] ]
    [ ask patch-at 0 -1 [ set pcolor black ] ]
end

;; setup to run the next view
to setup-continue
  ;; copy cells from the bottom to the top
  ask patches with [pycor = max-pycor]
    [ set pcolor ([pcolor] of patch pxcor min-pycor) ]
  ask patches with [pycor != max-pycor]  ;; clear the rest of the patches
    [ set pcolor black ]
  make-turtles  ;; sprout new turtles at the top of the world
end


; Copyright 2002 Uri Wilensky.
; See Info tab for full copyright and license.
@#$#@#$#@
GRAPHICS-WINDOW
161
11
651
262
-1
-1
2.0
1
10
1
1
1
0
1
0
1
-120
120
-60
60
1
1
1
ticks
30.0

BUTTON
17
88
123
121
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
18
251
123
284
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
16
185
123
218
NIL
setup-continue
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
23
45
113
81
Start from a\nsingle cell
11
0.0
0

TEXTBOX
21
139
146
174
Start from the end\nof the previous run
11
0.0
0

@#$#@#$#@
## WHAT IS IT?

This program models one particular one-dimensional cellular automaton -- the one known as 'rule 30'. It is intended to be a companion model to the CA 1D Rule 30 model and to show an alternate way of modeling a cellular automaton --- by using turtles to do the processing instead of patches.

A cellular automaton (aka CA) is a computational machine that performs actions based on certain rules.  It can be thought of as a "board" which is divided into cells (such as the square cells of a checkerboard). Each cell can be either on or off.  This is called the "state" of the cell. The board is initialized with some cells on and some off. A clock is then started and at each "tick" of the clock the rules are "fired" and this results in some cells turning "on" and some turning "off".

There are many kinds of cellular automata. In this model, we explore a one-dimensional CA --- the simplest type of CA. In this case of one-dimensional cellular automata, each cell checks the state of itself and its neighbors to the left and right, and then sets the cell below itself to either "on" or "off", depending upon the rule.  This is done in parallel and continues until the bottom of the board.

This model is one of a collection of 1D CA models. It is meant for the beginning user. If you have experience with CA, we suggest you check out a more sophisticated model such as CA 1D Elementary.

In his book, "A New Kind of Science", Stephen Wolfram argues that simple computational devices such as CA lie at the heart of nature's patterns and that CAs are a better tool than mathematical equations for the purpose of scientifically describing the world.

## HOW IT WORKS

As the turtles move forward, each turtle checks the color of its current patch and the patches directly to the left and right of it, and then paints the patch below it according to Rule 30:

```text
Y Y Y     Y Y B     Y B Y     Y B B
  B         B         B         Y

B Y Y     B Y B     B B Y     B B B
  Y         Y         Y         B
```

For example, if we have a Rule 30 CA, and the current cell is black and its left neighbor is yellow and its right neighbor is yellow, the cell below it is painted black.

## HOW TO USE IT

Initialization & Running:
- SETUP initializes the model with a single cell on in the center.
- SETUP-CONTINUE copies the last row of the previous run to the top so that you can continue running the model in "wrapped" mode when you click GO.
- GO begins running the model with the currently set rule. It continues until it reaches the last row of patches.

## THINGS TO NOTICE

Although the rules are very simple, extremely complex patterns emerge in Rule 30.  These patterns are not highly regular nor are they completely random.

Note that the pictures generated by this model do not exactly match the pictures in Wolfram's book, "A New Kind of Science". That's because Wolfram's book computes the CA as an infinite grid while the NetLogo model "wraps" around the horizontal edges of the world. To get pictures closer to the ones in the book, you may need to increase the size of the NetLogo world. You can increase the size of the world up to the available memory on your computer. However, the larger the world, the longer time it will take NetLogo to compute and display the results.

## THINGS TO TRY

Is there any consistent pattern to the way this CA evolves?

If you look at the middle vertical line, are there more yellow or black cells?

Can you predict what the color of the nth cell on that line will be?

## EXTENDING THE MODEL

What if you wanted to observe the behavior of a CA over many iterations without having to click continue every time it reaches the bottom of the view? Simply replace the `stop` with `setup-continue` in the go procedure:

      if (not any? turtles)
        [ stop ]

with

      if (not any? turtles)
        [ setup-continue ]

What if a cell's neighborhood was five --- two to the left, itself, and two to the right?

Classical CAs use an "infinite board". The CA shown here "wraps" around the edges of the world (sometimes known as a periodic CA or CA with periodic boundary condition). How would you implement in NetLogo a CA that comes closer to the infinite board?

Try making a two-dimensional cellular automaton.  The neighborhood could be the eight cells around it, or just the cardinal cells (the cells to the right, left, above, and below).

## NETLOGO FEATURES

The CA in this model uses turtles to process cells.  While this is functionally identical to the traditional CA, the turtles can be thought of as processors moving down each row, while the cells are used simply as a data set for the processors.  This differs from the patch-baed CA implementation in that the processor and data are decoupled from each other.

## RELATED MODELS

Life - an example of a two-dimensional cellular automaton
CA 1D Rule 30 - the basic rule 30 model
CA 1D Rule 90 - the basic rule 90 model
CA 1D Rule 110 - the basic rule 110 model
CA 1D Rule 250 - the basic rule 250 model
CA 1D Elementary - a model that shows all 256 possible simple 1D cellular automata
CA 1D Totalistic - a model that shows all 2,187 possible 1D 3-color totalistic cellular automata.

## CREDITS AND REFERENCES

Thanks to Eytan Bakshy for his help with this model.

The first cellular automaton was conceived by John Von Neumann in the late 1940's for his analysis of machine reproduction under the suggestion of Stanislaw M. Ulam. It was later completed and documented by Arthur W. Burks in the 1960's. Other two-dimensional cellular automata, and particularly the game of "Life," were explored by John Conway in the 1970's. Many others have since researched CA's. In the late 1970's and 1980's Chris Langton, Tom Toffoli and Stephen Wolfram did some notable research. Wolfram classified all 256 one-dimensional two-state single-neighbor cellular automata. In his recent book, "A New Kind of Science," Wolfram presents many examples of cellular automata and argues for their fundamental importance in doing science.

See also:

Von Neumann, J. and Burks, A. W., Eds, 1966. Theory of Self-Reproducing Automata. University of Illinois Press, Champaign, IL.

Toffoli, T. 1977. Computation and construction universality of reversible cellular automata. J. Comput. Syst. Sci. 15, 213-231.

Langton, C. 1984. Self-reproduction in cellular automata. Physica D 10, 134-144

Wolfram, S. 1986. Theory and Applications of Cellular Automata: Including Selected Papers 1983-1986. World Scientific Publishing Co., Inc., River Edge, NJ.

Bar-Yam, Y. 1997. Dynamics of Complex Systems. Perseus Press. reading, Ma.

Wolfram, S. 2002. A New Kind of Science.  Wolfram Media Inc.  Champaign, IL.
See chapters 2 and 3 for more information on 1 Dimensional CA
See index for more information specifically about Rule 30.

## HOW TO CITE

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the model itself:

* Wilensky, U. (2002).  NetLogo CA 1D Rule 30 Turtle model.  http://ccl.northwestern.edu/netlogo/models/CA1DRule30Turtle.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

Please cite the NetLogo software as:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT AND LICENSE

Copyright 2002 Uri Wilensky.

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.

Commercial licenses are also available. To inquire about commercial licenses, please contact Uri Wilensky at uri@northwestern.edu.

This model was created as part of the projects: PARTICIPATORY SIMULATIONS: NETWORK-BASED DESIGN FOR SYSTEMS LEARNING IN CLASSROOMS and/or INTEGRATED SIMULATION AND MODELING ENVIRONMENT. The project gratefully acknowledges the support of the National Science Foundation (REPP & ROLE programs) -- grant numbers REC #9814682 and REC-0126227.

<!-- 2002 -->
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.3-M3
@#$#@#$#@
setup
repeat world-height - 1 [ go ]
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
