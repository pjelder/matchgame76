//
//  PlayingCardMatchGameViewController.m
//  matchgame76
//
//  Created by Paul on 2/4/14.
//
//

#import "PlayingCardMatchGameViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardMatchGameViewController ()

@end

@implementation PlayingCardMatchGameViewController

- (Deck *) createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (int)cardsToMatch //abstract
{
    return 2;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PlayingCardGameHistory"]) {
        if ([segue.destinationViewController isKindOfClass:[GameHistoryViewController class]]) {
            GameHistoryViewController *ghvc = (GameHistoryViewController *)segue.destinationViewController;
            ghvc.data = self.gameHistory;
        }
    }
}

@end
