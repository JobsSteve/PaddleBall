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
    float mGameWidth;
    float mGameHeight;
    SPImage *mPaddle;
}

- (id)initWithWidth:(float)width height:(float)height;

@property (nonatomic, assign) SPImage *paddle;
@property (nonatomic, assign) float gameWidth;
@property (nonatomic, assign) float gameHeight;

@end
