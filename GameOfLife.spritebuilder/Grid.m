//
//  Grid.m
//  GameOfLife
//
//  Created by Junjia He on 1/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Creature.h"

static const int GRID_ROWS = 8;
static const int GRID_COLUMNS = 10;

@implementation Grid {
  NSMutableArray *_gridArray;
  float _cellWidth;
  float _cellHeight;
}

- (void)onEnter {
  [super onEnter];
  [self setupGrid];

  self.userInteractionEnabled = YES;
}

- (void)setupGrid {
  _cellHeight = self.contentSize.height / GRID_ROWS;
  _cellWidth = self.contentSize.width / GRID_COLUMNS;

  float x = 0, y = 0;

  _gridArray = [NSMutableArray array];

  for (int i = 0; i < GRID_ROWS; ++i) {
    _gridArray[i] = [NSMutableArray array];
    x = 0;

    for (int j = 0; j < GRID_COLUMNS; ++j) {
      Creature *creature = [[Creature alloc] initCreature];
      creature.anchorPoint = ccp(0, 0);
      creature.position = ccp(x, y);
      [self addChild:creature];

      _gridArray[i][j] = creature;

      x += _cellWidth;
    }
    y += _cellHeight;
  }
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
  CGPoint touchLocation = [touch locationInNode:self];

  Creature *creature = [self creatureForTouchPosition:touchLocation];

  creature.isAlive = !creature.isAlive;
}

- (Creature *)creatureForTouchPosition:(CGPoint)touchPosition {
  int row = touchPosition.y / _cellHeight,
      column = touchPosition.x / _cellWidth;
  return _gridArray[row][column];
}

- (void)evolveStep {
  [self countNeighbors];
  [self updateCreatures];
  _generation++;
}

- (void)countNeighbors {
  for (int i = 0; i < [_gridArray count]; ++i) {
    for (int j = 0; j < [_gridArray[i] count]; ++j) {
      Creature *currentCreature = _gridArray[i][j];
      currentCreature.livingNeighbors = 0;
      
      // count living neighbors
      for (int x = i-1; x <= i+1; ++x) {
        for (int y = j-1; y <= j+1; ++y) {
          if (x == i && y == j)
            continue;
          
          if (x >= 0 && y >= 0 && x < GRID_ROWS && y < GRID_COLUMNS) {
            Creature *neighbor = _gridArray[x][y];
            if (neighbor.isAlive)
              currentCreature.livingNeighbors += 1;
          }
        }
      }
    }
  }
}

- (void)updateCreatures {
  _totalAlive = 0;
  for (NSMutableArray *row in _gridArray) {
    for (Creature *c in row) {
      switch (c.isAlive) {
        case YES:
          _totalAlive++;
          if (c.livingNeighbors <= 1 || c.livingNeighbors >= 4)
            c.isAlive = NO;
          break;
          
        case NO:
          if (c.livingNeighbors == 3)
            c.isAlive = YES;
          break;
      }
    }
  }
}

@end
