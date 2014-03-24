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
#import "GameBoardView.h"
#import "PlayingCardView.h"
#import "PlayingCard.h"
#import "Deck.h"
#import "Grid.h"

@interface MatchGameViewController ()

@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet GameBoardView *gameBoardView;
@property (strong, nonatomic) NSMutableArray *cardViews;
@end

@implementation MatchGameViewController

#define NUMBER_OF_CARDS 16

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:NUMBER_OF_CARDS
                                                          usingDeck:[self createDeck]];
    return _game;
}

- (NSMutableArray *)cardViews
{
    if (!_cardViews) _cardViews = [[NSMutableArray alloc] init];
    return _cardViews;
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
- (void)tapCard:(UITapGestureRecognizer *)recognizer
{
    if ((recognizer.state == UIGestureRecognizerStateEnded)) {
        int chosenButtonIndex = [self.cardViews indexOfObject:recognizer.view];
        GameMatchEvent *event = [self.game chooseCardAtIndex:chosenButtonIndex];
        [self logGameEventMessage:event];
        [self updateUI];
    }
}

- (IBAction)redeal:(id)sender
{
    Grid *grid = [[Grid alloc] init];
    grid.size = self.gameBoardView.bounds.size;
    grid.cellAspectRatio = 0.5;  //width divided by height per cell
    grid.minimumNumberOfCells = 16;
    
    
    self.game = nil;
    self.game.numCardsToMatch = [self cardsToMatch];
    self.gameHistory = nil;
    for (int i=0; i<NUMBER_OF_CARDS; i++) {
        PlayingCard *card = (PlayingCard *)[self.game cardAtIndex:i];
        PlayingCardView *cardView = [[PlayingCardView alloc] init];
        CGRect cellBounds;
        cellBounds.size = [grid cellSize];
        cardView.bounds = cellBounds;
        cardView.rank = card.rank;
        cardView.suit = card.suit;
        cardView.center = [grid centerOfCellAtRow:i%4 inColumn:i/4];
        __weak MatchGameViewController *weakSelf = self;
        UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc]
                                         initWithTarget:weakSelf
                                         action:@selector(tapCard:)];
        tapgr.numberOfTapsRequired = 1;
        tapgr.numberOfTouchesRequired=1;
        [cardView addGestureRecognizer:tapgr];
        [self.cardViews addObject:cardView];
        [self.gameBoardView addSubview:cardView];
        
    }
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
    
    for (PlayingCardView *cardView in self.cardViews) {
        //[cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
        //[cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        //cardView.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
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
