//
//  GameHistoryViewController.m
//  matchgame76
//
//  Created by Paul on 2/18/14.
//
//

#import "GameHistoryViewController.h"

@interface GameHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *history;

@end


@implementation GameHistoryViewController


- (void) viewDidLoad
{
    self.history.attributedText = self.data;
}

@end
