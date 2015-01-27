//
//  Creature.h
//  GameOfLife
//
//  Created by Junjia He on 1/26/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Creature : CCSprite

@property (nonatomic, assign) BOOL isAlive;

@property (nonatomic, assign) NSInteger livingNeighbors;

-(instancetype) initCreature;

@end
