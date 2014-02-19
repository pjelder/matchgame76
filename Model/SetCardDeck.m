//
//  SetCardDeck.m
//  matchgame76
//
//  Created by Paul on 1/27/14.
//
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        for (NSString *shape in [SetCard validShapes]) {
            for (NSString *color in [SetCard validColors]) {
                for (int number=1; number<=[SetCard maxNumber]; number++) {
                    for (NSString *shading in [SetCard validShading]) {
                        SetCard *card = [[SetCard alloc] init];
                        card.shape = shape;
                        card.color = color;
                        card.number = number;
                        card.shading = shading;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    return self;
}

@end
