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


@interface MatchGameViewController : UIViewController


- (Deck *)createDeck;  //abstract
- (int)cardsToMatch; //abstract

@end
