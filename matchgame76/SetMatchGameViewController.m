//
//  SetMatchGameViewController.m
//  matchgame76
//
//  Created by Paul on 2/6/14.
//
//

#import "SetMatchGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@interface SetMatchGameViewController ()


@end

@implementation SetMatchGameViewController

- (Deck *) createDeck
{
    return [[SetCardDeck alloc] init];
}

- (int)cardsToMatch //abstract
{
    return 3;
}

- (NSString *)titleForCard:(SetCard *)card
{
    return card.isChosen ? card.shape : @"";
}

@end
