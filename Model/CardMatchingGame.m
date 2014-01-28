//
//  CardMatchingGame.m
//  matchgame76
//
//  Created by Paul on 1/20/14.
//
//

#import "CardMatchingGame.h"
#import "GameMatchEvent.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; //of Card

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];  //super's designated initializer
    
    if (self) {
        for (int i=0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    self.numCardsToMatch = 2;
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index<[self.cards count]) ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = -2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (GameMatchEvent *)chooseCardAtIndex:(NSUInteger)index
{
    GameMatchEvent *matchEvent = [[GameMatchEvent alloc] init];
    Card *card = [self cardAtIndex:index];
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            matchEvent.matchAttempt = NO;
        } else {
            //match against other chosen cards
            NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [chosenCards addObject:otherCard];
                }
            }
            
            //We've collected the other selected cards;
            //to compute all matches, add the chosen card to this array
            //The size of the array should equal the playing mode
            [chosenCards addObject:card];
            matchEvent.cards = [[NSArray alloc] initWithArray:chosenCards];
            if ([chosenCards count] == (self.numCardsToMatch)) {
                int matchScore = 0;
                matchEvent.matchAttempt = YES;
                for (Card *chooseCard in chosenCards) {
                    //Construct an array of cards to match, excluding
                    //the calling card
                    //So we compute the match for N cards by calling
                    //match on each card with all other cards to match
                    //against
                    NSMutableArray *matchCards = [[NSMutableArray alloc] init];
                    [matchCards addObjectsFromArray:chosenCards];
                    [matchCards removeObject:chooseCard];
                    matchScore += [chooseCard match:matchCards];
                }
                if (matchScore) {
                    //Because we will end up N-counting all
                    //scoring matches, divide by number of cards
                    matchScore = matchScore / [chosenCards count];
                    matchScore = matchScore * MATCH_BONUS;
                    self.score += matchScore;
                    matchEvent.scoreChange = matchScore;
                    for (Card *choosecard in chosenCards) {
                        choosecard.matched = YES;
                    }
                } else {
                    self.score += MISMATCH_PENALTY;
                    matchEvent.scoreChange = MISMATCH_PENALTY;
                    for (Card *choosecard in chosenCards) {
                        choosecard.chosen = NO;
                    }
                }
            } else {
                matchEvent.matchAttempt = NO;
                matchEvent.scoreChange = 0;
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
    return matchEvent;
}

@end
