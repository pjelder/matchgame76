//
//  MatchGameViewController.m
//  matchgame76
//
//  Created by Paul on 1/18/14.
//
//

#import "MatchGameViewController.h"

@interface MatchGameViewController ()

@end

@implementation MatchGameViewController

- (IBAction)touchCardButton:(UIButton *)sender
{
    if ([sender.currentTitle length]) {
        [sender setBackgroundImage:[UIImage imageNamed:@"cardback"]
                          forState:UIControlStateNormal];
        [sender setTitle:@"" forState:UIControlStateNormal];
    } else {
        [sender setBackgroundImage:[UIImage imageNamed:@"cardfront"]
                          forState:UIControlStateNormal];
        [sender setTitle:@"A spade" forState:UIControlStateNormal];
    }

}


@end
