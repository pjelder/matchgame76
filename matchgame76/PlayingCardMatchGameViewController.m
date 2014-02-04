//
//  PlayingCardMatchGameViewController.m
//  matchgame76
//
//  Created by Paul on 2/4/14.
//
//

#import "PlayingCardMatchGameViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardMatchGameViewController ()

@end

@implementation PlayingCardMatchGameViewController

- (Deck *) createDeck {
    return [[PlayingCardDeck alloc] init];
}

@end
