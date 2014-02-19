//
//  GameMatchEvent.m
//  matchgame76
//
//  Created by Paul on 1/27/14.
//
//

#import "GameMatchEvent.h"

@implementation GameMatchEvent

- (NSArray *)cards
{
    if (!_cards) _cards = [[NSArray alloc] init];
    return _cards;
}

@end
