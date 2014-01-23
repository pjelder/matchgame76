//
//  MatchGameViewController.m
//  matchgame76
//
//  Created by Paul on 1/18/14.
//
//

#import "MatchGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

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

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    self.messageLabel.text = [self.game chooseCardAtIndex:chosenButtonIndex];
    self.gameModeSwitch.enabled = NO;   //After you start the game can't change game mode
    [self updateUI];
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
