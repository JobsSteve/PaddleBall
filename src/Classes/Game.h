//
//  Game.h
//  AppScaffold
//

#import <Foundation/Foundation.h>
#import <UIKit/UIDevice.h>
#import "SPResizeEvent.h"
#import "SPOverlayView.h"
#import "Media.h"

@interface Game : SPSprite
{
  @private
    float mTargetPosition;
    CGPoint mDirection;
    float mGameWidth;
    float mGameHeight;
    SPImage *mPaddle;
    SPImage *mBall;
}

- (id)initWithWidth:(float)width height:(float)height;

@property (nonatomic, assign) SPImage *paddle;
@property (nonatomic, assign) SPImage *ball;
@property (nonatomic, assign) float targetPosition;
@property (nonatomic, assign) CGPoint direction;
@property (nonatomic, assign) float gameWidth;
@property (nonatomic, assign) float gameHeight;


@end
