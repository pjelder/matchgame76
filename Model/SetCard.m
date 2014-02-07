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

- (NSString *)shape
{
    return _shape ? _shape : @"?";
}

- (NSString *)contents
{
    return @"???";
}

- (int)match:(NSArray *)otherCards
{
    int score =0;
    
    //Set is 3 card matching, so array should always have only 2 otherCards to match
    if ([otherCards count]!=2) {
        return score;
    }
    //They all have the same number, or they have three different numbers.
    //They all have the same symbol, or they have three different symbols.
    //They all have the same shading, or they have three different shadings.
    //They all have the same color, or they have three different colors.
    NSMutableSet *numbers = [[NSMutableSet alloc] init];
    NSMutableSet *shapes = [[NSMutableSet alloc] init];
    NSMutableSet *shades = [[NSMutableSet alloc] init];
    NSMutableSet *colors = [[NSMutableSet alloc] init];
    
    [numbers addObject:[NSNumber numberWithInt:self.number]];
    [shapes addObject:self.shape];
    [shades addObject:self.shading];
    [colors addObject:self.color];
    for (SetCard *card in otherCards) {
         [numbers addObject:[NSNumber numberWithInt:card.number]];
         [shapes addObject:card.shape];
         [shades addObject:card.shading];
         [colors addObject:card.color];
    }
    
    
    //After adding all the attributes to the sets, check if
    //any of them are 2, which means on that attribute,
    //the cards can't be a set
    //Either all attributes must be the same (count=1)
    //or all different (count=3)
    if ([numbers count] == 2 ||
        [shapes count] == 2 ||
        [shades count] == 2 ||
        [colors count] == 2) {
        return score;  //Still 0
    } else {
        //A successful set!  Give some points and return
        score++;
        return score;
    }
    
    return score;
    
/* Alternate logic, probably also works but more confusing
 
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
*/

    
}


@end
