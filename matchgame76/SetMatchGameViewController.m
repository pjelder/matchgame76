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

- (NSString *)logGameEventMessage:(GameMatchEvent *)event
{
    NSString *message = @"";
    for (SetCard *card in event.cards) {
        message = [message stringByAppendingString:[self printableSetCard:card]];
    }
    if (event.isMatchAttempt) {
        if (event.scoreChange > 0) {
            message = [message stringByAppendingString:
                       [NSString stringWithFormat:@" matched for %d points!", event.scoreChange]];
        } else {
            message = [message stringByAppendingString:
                       [NSString stringWithFormat:@" don't match! %d point penalty!", event.scoreChange]];
        }
    }
    
    return message;
    
}

- (NSAttributedString *)titleForCard:(SetCard *)card
{
    return [self printableSetCard:card];
}

                   
                   
- (NSAttributedString *)printableSetCard:(SetCard *)card
{
    return [self applyAttributesToCardCharacters:[self getCharactersForCard:card]ofCard:card];

}

- (NSAttributedString *)applyAttributesToCardCharacters:(NSString *)string ofCard:(SetCard *)card
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:string];
    
    //    return @[@"solid",@"striped",@"outline"];
    BOOL isStrikeThrough = [card.shading isEqualToString:@"striped"];
    BOOL isSolid = [card.shading isEqualToString:@"solid"];
    //BOOL isOutline = [card.shading isEqualToString:@"outline"];
    
    [title addAttributes:@{ NSStrokeWidthAttributeName : isSolid ? @-5 : @5,
                            //NSUnderlineStyleAttributeName : isStrikeThrough ? @(NSUnderlineStyleSingle) : @(NSUnderlineStyleNone),
                            NSStrokeColorAttributeName : [self colorForCard:card],
                            NSStrikethroughStyleAttributeName : isStrikeThrough ? @(NSUnderlineStyleDouble) : @(NSUnderlineStyleNone),
                            NSStrikethroughColorAttributeName : [self colorForCard:card],
                            NSForegroundColorAttributeName : isSolid ? [self colorForCard:card] : [UIColor whiteColor]
                            }
                   range:NSMakeRange(0, [title length])];
    
    return [[NSAttributedString alloc] initWithAttributedString:title];
}

- (NSString *)getCharactersForCard:(SetCard *)card
{
   NSString *character;
   if ([card.shape isEqualToString:@"circle"]) {
       character = @"●";
   } else if ([card.shape isEqualToString:@"triangle"]) {
       character = @"▲";
   } else if ([card.shape isEqualToString:@"square"]) {
       character =  @"◼︎";
   } else {
       character = @"?";
   }
   NSString *totalCharacters = @"";
   for (int i=1; i<=card.number; i++) {
       totalCharacters = [totalCharacters stringByAppendingString:character];
   }
    return totalCharacters;
}

- (UIColor *)colorForCard:(SetCard *)card
{
    UIColor *cardColor;
    if ([card.color isEqualToString:@"red"]) {
        cardColor = [UIColor redColor];
    } else if ([card.color isEqualToString:@"blue"]) {
        cardColor = [UIColor blueColor];
    } else if ([card.color isEqualToString:@"green"]) {
        cardColor = [UIColor greenColor];
    } else {
        cardColor = [UIColor blackColor];
    }
    return cardColor;
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"setCardSelected" : @"cardfront"]; //Set cards are always face up
}


@end
