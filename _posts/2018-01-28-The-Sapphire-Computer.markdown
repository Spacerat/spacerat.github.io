---
layout: post
title:  "Sapphire Yours is Turing Complete"
date:   2018-01-28 12:23:37 -0700
categories: tech
published: false
---

In this post I will show that it is theoretically possible to build a computer in my childhood favourite computer game: [Sapphire Yours](http://members.aon.at/sapphire/). Given that all you need to build a computer is logic gates and memory, all that is needed is to demonstrate that those things can be built in the level editor.

Sapphire yours is a remake of the classic game Baulder Dash, with added lasers. The player controls a miner, who has to navigate puzzles to collect the required number of diamonds, then exit.

[ TODO: picture of miner and exit ]

However, we will be ignoring the player and building the computer entirely with other components.

### Building blocks

In addition to the gems above, here are some of the most important pieces:

<div class="leftimg">
<img src="/images/sapp/rock.png" alt="Rock" />
    <span>
        Rocks fall down when there is nothing below them, and they roll off of anything which is not flat, such as other rocks. Some things can be crushed by rocks, such as sapphires, bombs, and yamyams.
    </span>
</div>

<div class="leftimg">
<img src="/images/sapp/dispenser.png" alt="Dispenser" />
    <span>
        Dispensers create a rock every N frames, where N is configurable in the level editor.
    </span>
</div>

<div class="leftimg">
<img src="/images/sapp/wall.png" alt="Wall" />
    <span>
        Walls do not fall and are flat, which means that rocks, bombs and gems can rest on top of them. Walls are not destroyed by explosions from bombs or YamYams.
    </span>
</div>

<div class="leftimg">
<img src="/images/sapp/bomb.png" alt="Bomb" />
    <span>
        Bombs can explode, destroying anything destructible in all adjacent and diagonal cells. If anything falls on them, or explodes near them, they explode. They also explode if they fall on anything, except for...
    </span>
</div>

<div class="leftimg">
<img src="/images/sapp/pillow.png" alt="Pillow" />
    <span>
        .. pillows, which are soft enough to catch bombs, but are not impervious to explosions. They are not flat, so rocks and bombs roll off of them.
    </span>
</div>

<div class="leftimg">
<img src="/images/sapp/yamyam.png" alt="YamYam" />
    <span>
        YamYams are monsters. Like bombs they explode when anything explodes near them, but their explosions can create new objects. The pattern of new objects created is configured in the level editor, and it can include new YamYams.
    </span>
</div>

When an explosion happens next to a ruby, a laser is generated. Using some of the pieces above, we can create a "clock" which repeatedly fires a laser. These lasers take the role of "electricity" in our computer components.

<video autoplay loop>
  <source src="/images/sapp/clock.mp4" type="video/mp4">
  <img src="/images/sapp/clock.gif" alt="Clock component." />
</video>

Note that the YamYam has been configured to create a new YamYam after it explodes. To the right of the ruby is "glass" - a wall which lasers can pass through. Lasers travel instantly and continue until they are stopped by an object. Bombs and YamYams explode when lasers hit them; rocks and pillows are destroyed when lasers hit them.

Sappires and emeralds can change the direction of lasers, allowing us to route lasers between components. The following image shows that sapphires rotate the direction of lasers clockwise, emeralds rotate them anticlockwise (TNT is used to set off the explosion which powers the laser).

<img src="/images/sapp/emeralds.png" alt="Emeralds and sapphires reflecting a laser" />

Because YamYams can recreate themselves, they are central to every component. The most basic example is just a YamYam with rubies next to it. This is a splitter: when a laser is fired in, it fires out more.

<video autoplay loop>
  <source src="/images/sapp/splitter.mp4" type="video/mp4">
  <img src="/images/sapp/splitter.gif" alt="Splitter." />
</video>


### Logic Gates and Memory

[TODO: OR GATE]

[TODO: AND GATE]

[TODO: NOT GATE]

[TODO: D FLIP FLOP]

[TODO: DISCUSSION OF COMPUTERS FROM THOSE THINGS]

[TODO: HOW COULD WE ACTUALLY GENERATE A COMPUTER LEVLE?]


### Turing completeness in other games

The phrase [Turing Complete](https://en.wikipedia.org/wiki/Turing_completeness) basically describes anything which can simulate a computer. In fact, the phrase describes any system which can simulate any 'Turing machine'. A Turing machine is a theoretical device which can be set up to run a computer program. Anything which can simulate _any_ Turing machine can thus run any program, and by extension, simulate a modern computer.

There are many examples of Turing complete games. [Minecraft](https://minecraft.net/en-us/article/deep-thought) may be one of the most obvious examples. Its redstone blocks can be [used to build logic gates](https://minecraft.gamepedia.com/Tutorials/Basic_logic_gates) which can be pieced together to build a computer in just the same way computers today's computers are. This approach, building logic gates inside the game, will be taken for Sapphire Yours, but there are others.

Braid is a platformer video game where the player navigates a maze of levers, one-way surfaces, cannons and so on to find an objective. The paper [Braid is undecidable](https://arxiv.org/pdf/1412.0784) shows that the player in Braid can be forced to simulate a computer by continually taking the only possible path through a level. They use the phrase "undecidable" because the [halting problem](https://en.wikipedia.org/wiki/Halting_problem) shows that it is impossible to write a computer program which could take in a Braid level (which could be any arbitrary computer program) and decide whether it is possible to complete.

Conway's Game of Life is a great example because it shows that complex phenomena can be constructed from very simple rules. In the game of life, cells exist on an infiniate grid. Live cells with two neighbours stay alive, cells with three neigbours become or stay alive, and with any other number of neighbours the cell dies. With these rules, Paul Randell first built a [Turing Machine](http://rendell-attic.org/gol/tm.htm) and then built a [Universal Turing Machine](http://rendell-attic.org/gol/utm/index.htm), capable of simulating his original creation - and thus - any computer.
