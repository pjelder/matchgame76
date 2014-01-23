//
//  PlayingCard.m
//  matchgame76
//
//  Created by Paul on 1/18/14.
//
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] >= 1) {
        //Same scoring as the two card match, but applied for N
        //cards.  So you can get more points if all the suits
        //are the same, but less (because of the division) if
        //only a few cards match
        for (PlayingCard *card in otherCards) {
            if (card.rank == self.rank) {
                score += 4;
            } else if ([card.suit isEqualToString:self.suit]) {
                score += 1;
            }
        }
        score = score / [otherCards count];
    }
    
    return score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;  //because we provide setter AND getter

+ (NSArray *)validSuits
{
    return @[@"♠️",@"♥️",@"♣️",@"♦️"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank {return [[self rankStrings] count]-1; }

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}
@end
