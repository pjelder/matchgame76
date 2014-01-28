//
//  CardMatchingGame.h
//  matchgame76
//
//  Created by Paul on 1/20/14.
//
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"
#import "GameMatchEvent.h"

@interface CardMatchingGame : NSObject

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

- (GameMatchEvent *)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readwrite) NSUInteger numCardsToMatch;


@end
