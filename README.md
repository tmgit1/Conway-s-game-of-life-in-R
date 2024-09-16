# R implementation of Conway's game of life
# Conway's Game of Life - R Implementation

## Overview

Conway's Game of Life is a cellular automaton devised by mathematician John Conway. It consists of a grid of cells where each cell can be either alive or dead. The game progresses in discrete time steps, with the state of each cell evolving based on a set of simple rules. The Game of Life is known for its ability to generate complex patterns and behaviors from simple initial configurations.  
This implementation uses a grid that wraps on itself so that the patterns can continue to evolve when they hit the edge of the grid.

## Rules

The Game of Life operates according to four basic rules:

1. **Any live cell with fewer than two live neighbors dies as if caused by under-population.**
2. **Any live cell with two or three live neighbors lives on to the next generation.**
3. **Any live cell with more than three live neighbors dies, as if by over-population.**
4. **Any dead cell with exactly three live neighbors becomes a live cell, as if by reproduction.**

## Features

This R implementation of Conway's Game of Life includes the following features:

- **Step Forward:** Move to the next generation of the game.
- **Step Backward:** Revert to the previous generation of the game.
- **Interactive Grid:** Click on the cells in the grid to toggle their state between alive and dead.

## Libraries Required

To run this implementation, you will need the following R libraries:

- `shiny` - For creating the interactive web application.
- `ggplot2` - For visualizing the grid of cells.
