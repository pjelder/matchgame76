//
//  SetCard.h
//  matchgame76
//
//  Created by Paul on 1/27/14.
//
//

#import "Card.h"

@interface SetCard : Card

@property (strong, nonatomic) NSString *shape;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *shading;
@property (nonatomic) NSUInteger number;

+ (NSArray *)validShapes;
+ (NSArray *)validColors;
+ (NSUInteger)maxNumber;
+ (NSArray *)validShading;


@end
