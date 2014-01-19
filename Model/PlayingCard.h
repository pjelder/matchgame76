//
//  PlayingCard.h
//  matchgame76
//
//  Created by Paul on 1/18/14.
//
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
