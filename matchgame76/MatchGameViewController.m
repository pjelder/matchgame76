//
//  MatchGameViewController.m
//  matchgame76
//
//  Created by Paul on 1/18/14.
//
//

#import "MatchGameViewController.h"
#import "CardMatchingGame.h"
#import "Deck.h"

@interface MatchGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
- (IBAction)redeal:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSwitch;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@end

@implementation MatchGameViewController

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    return _game;
}

#define INDEX_OFFSET 2
- (IBAction)gameModeSwitch:(UISegmentedControl *)sender
{
    self.game.numCardsToMatch = sender.selectedSegmentIndex+INDEX_OFFSET;
}

- (IBAction)redeal:(id)sender
{
    self.game = nil;
    self.game.numCardsToMatch = self.gameModeSwitch.selectedSegmentIndex+INDEX_OFFSET;
    self.messageLabel.text = @"Welcome!";
    self.gameModeSwitch.enabled = YES;
    
    [self updateUI];
}

- (Deck *)createDeck  //abstract
{
    return nil;
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    GameMatchEvent *event = [self.game chooseCardAtIndex:chosenButtonIndex];
    self.messageLabel.text = [self logGameEventMessage:event];
    self.gameModeSwitch.enabled = NO;   //After you start the game can't change game mode
    [self updateUI];
}

- (NSString *)logGameEventMessage:(GameMatchEvent *)event
{
    NSString *message = @"";
    for (Card *card in event.cards) {
        message = [message stringByAppendingString:card.contents];
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

- (void)updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    }
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end
