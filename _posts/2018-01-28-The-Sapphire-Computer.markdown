---
layout: post
title:  "Sapphire Yours is Turing Complete"
date:   2018-01-28 12:23:37 -0700
categories: tech
---

I recently figured out that it's possible to build a computer in childhood favourite computer game: [Sapphire Yours](http://members.aon.at/sapphire/). In this post I will describe how.

## Turing completeness in other games

The phrase [Turing Complete](https://en.wikipedia.org/wiki/Turing_completeness) basically describes anything which can simulate a computer. In fact, the phrase means that the system can simulate a 'Turing machine', a simple computational model named after and invented by Alan Turing which itself can simulate computers. Anything which can simulate a turing machine or any other Turing complete system is thus able to simulate a modern computer.

There are many examples of turing complete games. [Minecraft](https://minecraft.net/en-us/article/deep-thought) may be one of the most obvious examples. Its redstone blocks can be [used to build logic gates](https://minecraft.gamepedia.com/Tutorials/Basic_logic_gates) which can be pieced together to build a computer in just the same way computers today's computers are. This approach, building logic gates inside the game, will be taken for Sapphire Yours, but there are others.

Braid is a platformer video game where the player navigates a maze of levers, one-way surfaces, cannons and so on to find an objective. The paper [Braid is undecidable](https://arxiv.org/pdf/1412.0784) shows that the player in Braid can be forced to simulate a computer by continually taking the only possible path through a level. They use the phrase "undecidable" because the (halting problem)[https://en.wikipedia.org/wiki/Halting_problem] shows that it is impossible to write a computer program which could take in a Braid level (which could be any arbitrary computer program) and decide whether it is possible to complete.

Conway's Game of Life is a great example because it shows that complex phenomena can be constructed from very simple rules. In the game of life, cells exist on an infiniate grid. Live cells with two neighbours stay alive, cells with three neigbours become or stay alive, and with any other number of neighbours the cell dies. With these rules, Paul Randell first built a [Turing Machine](http://rendell-attic.org/gol/tm.htm) and then built a [Universal Turing Machine](http://rendell-attic.org/gol/utm/index.htm), capable of simulating his original creation - and thus - any computer.

## Sapphire Yours

