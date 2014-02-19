//
//  MatchGameViewController.m
//  matchgame76
//
//  Created by Paul on 1/18/14.
//
//   Still seems to be a weird bug when switching between games, the number of cards
//   to match may be weird.
//

#import "MatchGameViewController.h"
#import "CardMatchingGame.h"
#import "Deck.h"

@interface MatchGameViewController ()

@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@end

@implementation MatchGameViewController

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    return _game;
}

- (NSMutableAttributedString *)gameHistory
{
    if (!_gameHistory) _gameHistory = [[NSMutableAttributedString alloc]initWithString:@"New Game!\n"];
    
    return _gameHistory;
}

- (void) viewDidLoad
{
    [self updateUI];  //Not absolutely necessary but it makes the SetGame load more nicely
}

- (IBAction)redeal:(id)sender
{
    self.game = nil;
    self.game.numCardsToMatch = [self cardsToMatch];
    self.messageLabel.text = @"Welcome!";
    self.gameHistory = nil;
    [self updateUI];
}

- (Deck *)createDeck  //abstract
{
    return nil;
}

- (int)cardsToMatch //abstract
{
    return 0;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender; //abstract
{}

- (IBAction)touchCardButton:(UIButton *)sender
{
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    GameMatchEvent *event = [self.game chooseCardAtIndex:chosenButtonIndex];
    self.messageLabel.attributedText = [self logGameEventMessage:event];
    [self updateUI];
}

- (NSAttributedString *)logGameEventMessage:(GameMatchEvent *)event
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
    NSAttributedString *attributedMessage = [[NSAttributedString alloc] initWithString:message];
    [self.gameHistory appendAttributedString:attributedMessage];
    [self.gameHistory appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    return attributedMessage;
    
}

- (void)updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    }
}

- (NSAttributedString *)titleForCard:(Card *)card
{
    return card.isChosen ? [[NSAttributedString alloc] initWithString:card.contents]  : [[NSAttributedString alloc] initWithString:@""];
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end
