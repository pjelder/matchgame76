//
//  MatchGameViewController.m
//  matchgame76
//
//  Created by Paul on 1/18/14.
//
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
@property (strong, nonatomic) Grid *gameGrid;
@end

@implementation MatchGameViewController

#define NUMBER_OF_CARDS 16

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:0
                                                          usingDeck:[self createDeck]];
    return _game;
}

- (NSMutableArray *)cardViews
{
    if (!_cardViews) _cardViews = [[NSMutableArray alloc] init];
    return _cardViews;
}

- (Grid *)gameGrid
{
    if (!_gameGrid) {
        _gameGrid = [[Grid alloc] init];
        _gameGrid.size = self.gameBoardView.bounds.size;
        _gameGrid.cellAspectRatio = 0.75;  //width divided by height per cell
        _gameGrid.minimumNumberOfCells = NUMBER_OF_CARDS;
    }
    return _gameGrid;
}

- (NSMutableAttributedString *)gameHistory
{
    if (!_gameHistory) _gameHistory =
        [[NSMutableAttributedString alloc]initWithString:@"New Game!\n"];
    return _gameHistory;
}

- (void) viewDidLoad
{
    //[self updateUI];  //Not absolutely necessary but it makes the SetGame load more nicely
}
- (void)tapCard:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        int chosenCardIndex = [self.cardViews indexOfObject:recognizer.view];
        PlayingCardView *cardView  = (PlayingCardView *)recognizer.view;
        
        [UIView transitionWithView:cardView
                          duration:0.75
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{ cardView.faceUp = !cardView.faceUp; }
                        completion:nil];
        GameMatchEvent *event = [self.game chooseCardAtIndex:chosenCardIndex];
        [self logGameEventMessage:event];
        [self updateUI];
    }
}

- (IBAction)redeal:(id)sender
{

    //Cleanup old cards?
    for (PlayingCardView *cardView in self.cardViews) {
        [self removeCardViewFromGame:cardView];
    }
    
    self.game = nil;
    self.game.numCardsToMatch = [self cardsToMatch];
    self.gameHistory = nil;
    self.cardViews = nil;
    for (int i=0; i<NUMBER_OF_CARDS; i++) {
        //PlayingCard *card = (PlayingCard *)[self.game cardAtIndex:i];
        PlayingCard *card = (PlayingCard *)[self.game addNewCard];
        
        //Redeal add cards to grid
        //PlayingCardView *cardView =
        [self createPlayingCardViewFromPlayingCard:card
                                        withCenter:[self.gameGrid centerOfCellAtRow:i%4 inColumn:i/4]];
    }
    //[self updateUI];
}

- (Deck *)createDeck  //abstract
{
    return nil;
}

- (int)cardsToMatch //abstract
{
    return 0;
}



- (PlayingCardView *)createPlayingCardViewFromPlayingCard:(PlayingCard *)card
                                               withCenter:(CGPoint)cardCenter
{
    PlayingCardView *cardView = [[PlayingCardView alloc] init];
    cardView.rank = card.rank;
    cardView.suit = card.suit;
    cardView.inGame=YES;
    //cardView.faceUp=YES;
    
    CGRect cellBounds;
    cellBounds.size = [self.gameGrid cellSize];
    cardView.bounds = cellBounds;
    
    cardView.center = CGPointMake(-500, 0);  //Initialize outside of viewing area
    
    [UIView animateWithDuration:1.25
                          delay:1.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{ cardView.center = cardCenter; }
                     completion:nil];

    [self addTapGestureRecognizerToView:cardView];
    [self.cardViews addObject:cardView];
    [self.gameBoardView addSubview:cardView];
    
    return cardView;
}

- (void)addTapGestureRecognizerToView:(UIView *)targetView
{
    __weak MatchGameViewController *weakSelf = self;
    UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc]
                                     initWithTarget:weakSelf
                                     action:@selector(tapCard:)];
    tapgr.numberOfTapsRequired = 1;
    tapgr.numberOfTouchesRequired=1;
    [targetView addGestureRecognizer:tapgr];
}

- (void)removeCardViewFromGame:(PlayingCardView *)cardView
{
    cardView.inGame=NO;
    //Remove the old card
    [UIView animateWithDuration:1.25
                          delay:1.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{ cardView.center = CGPointMake(-500, 0); }
                     completion:^(BOOL fin) { if (fin) {[cardView removeFromSuperview];
                                                            cardView.hidden = YES;
    }}];
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
    
    for (int cardIndex=0; cardIndex<self.cardViews.count; cardIndex++) {
        PlayingCardView *cardView = self.cardViews[cardIndex];
        PlayingCard *card = (PlayingCard *)[self.game cardAtIndex:cardIndex];
        if ((!card.chosen) && (cardView.faceUp)) {
            [UIView transitionWithView:cardView
                              duration:0.75
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^{ cardView.faceUp = NO; }
                            completion:nil];
            
        }
        if ((card.matched) && (cardView.inGame)) {
            
            //TODO Check if the deck is empty
            PlayingCard *newCard = (PlayingCard *)[self.game addNewCard];
            if (newCard) {
                
                CGPoint oldCardCenter = cardView.center;
                
                //Remove the old card from the view
                //it's already matched in the game so will be ignored
                [self removeCardViewFromGame:cardView];
                
                //Add a new cardView
                //PlayingCardView *newCardView =
                [self createPlayingCardViewFromPlayingCard:newCard
                                                withCenter:oldCardCenter];
            } else {
                //Tell the user the deck is empty
            }
            
        }
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}


@end
