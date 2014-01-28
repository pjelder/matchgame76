//
//  SetCard.m
//  matchgame76
//
//  Created by Paul on 1/27/14.
//
//

#import "SetCard.h"

@implementation SetCard

+ (NSArray *)validShapes
{
    return @[@"circle",@"triangle",@"square"];
}

+ (NSArray *)validColors
{
    return @[@"red",@"green",@"blue"];
}

+ (NSUInteger)maxNumber
{
    return 3;
}

+ (NSArray *)validShading
{
    return @[@"solid",@"striped",@"outline"];
}

- (int)match:(NSArray *)otherCards
{
    int score =0;
    
    //They all have the same number, or they have three different numbers.
    //They all have the same symbol, or they have three different symbols.
    //They all have the same shading, or they have three different shadings.
    //They all have the same color, or they have three different colors.
    
    //Set is 3 card matching, so array should always have only 2 otherCards to match
    if ([otherCards count]!=2) {
        return score;
    }
    SetCard *other1 = otherCards[0];
    SetCard *other2 = otherCards[1];
    if (self.number != other1.number != other2.number ||
        self.number == other1.number == other2.number) {
        
        if (([self.shape isEqualToString:other1.shape] &&
            [other1.shape isEqualToString:other2.shape]) ||
            (![self.shape isEqualToString:other1.shape] &&
             ![other1.shape isEqualToString:other2.shape] &&
             ![other2.shape isEqualToString:self.shape])) {
                
                if (([self.color isEqualToString:other1.color] &&
                     [other1.color isEqualToString:other2.color]) ||
                    (![self.color isEqualToString:other1.color] &&
                     ![other1.color isEqualToString:other2.color] &&
                     ![other2.color isEqualToString:self.color])) {
                        
                        if (([self.shading isEqualToString:other1.shading] &&
                             [other1.shading isEqualToString:other2.shading]) ||
                            (![self.shading isEqualToString:other1.shading] &&
                             ![other1.shading isEqualToString:other2.shading] &&
                             ![other2.shading isEqualToString:self.shading])) {
                                score = 1;
                }
            }
        }
    }
    
    return score;
    
}


@end
