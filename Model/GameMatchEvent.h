//
//  GameMatchEvent.h
//  matchgame76
//
//  Created by Paul on 1/27/14.
//
//

#import <Foundation/Foundation.h>

@interface GameMatchEvent : NSObject

@property (nonatomic, strong) NSArray *cards;  //of Card
@property (nonatomic, getter=isMatchAttempt) BOOL matchAttempt;
@property (nonatomic) NSInteger scoreChange;

@end
