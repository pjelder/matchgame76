//
//  MatchGameViewController.h
//  matchgame76
//
//  Created by Paul on 1/18/14.
//
// Abstract class must implement below

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"
#import "GameHistoryViewController.h"


@interface MatchGameViewController : UIViewController

@property (strong, nonatomic) NSMutableAttributedString *gameHistory;

- (Deck *)createDeck;  //abstract
- (int)cardsToMatch; //abstract
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender; //abstract

@end
