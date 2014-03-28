//
//  PlayingCardView.h
//  matchgame76
//
//  Created by Paul on 3/24/14.
//
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic, strong) NSString *suit;
@property (nonatomic) NSUInteger rank;
@property (nonatomic) BOOL faceUp;
@property (nonatomic) BOOL inGame;

@end
