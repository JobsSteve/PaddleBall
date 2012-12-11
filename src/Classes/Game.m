//
//  Game.m
//  AppScaffold
//

#import "Game.h" 

// --- private interface ---------------------------------------------------------------------------

@interface Game ()

- (void)setup;
- (void)onImageTouched:(SPTouchEvent *)event;
- (void)onResize:(SPResizeEvent *)event;

@end


// --- class implementation ------------------------------------------------------------------------

@implementation Game

@synthesize targetPosition  = mTargetPosition;
@synthesize direction = mDirection;
@synthesize gameWidth  = mGameWidth;
@synthesize gameHeight = mGameHeight;
@synthesize paddle = mPaddle;
@synthesize ball = mBall;

- (id)initWithWidth:(float)width height:(float)height
{
    if ((self = [super init]))
    {
        mGameWidth = width;
        mGameHeight = height;
        mDirection = CGPointMake(31.0f, 8.0f);
        
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    // release any resources here
    [mPaddle release];
    [Media releaseAtlas];
    [Media releaseSound];
    
    [super dealloc];
}

- (void)setup
{
    // This is where the code of your game will start. 
    // In this sample, we add just a few simple elements to get a feeling about how it's done.
    
    [SPAudioEngine start];  // starts up the sound engine
    
    
    // The Application contains a very handy "Media" class which loads your texture atlas
    // and all available sound files automatically. Extend this class as you need it --
    // that way, you will be able to access your textures and sounds throughout your 
    // application, without duplicating any resources.
    
    [Media initAtlas];      // loads your texture atlas -> see Media.h/Media.m
    [Media initSound];      // loads all your sounds    -> see Media.h/Media.m
    
    
    // Create a background image. Since the demo must support all different kinds of orientations,
    // we center it on the stage with the pivot point.
    
    SPImage *background = [[SPImage alloc] initWithContentsOfFile:@"background.jpg"];
    background.pivotX = background.width / 2;
    background.pivotY = background.height / 2;
    background.x = mGameWidth / 2;
    background.y = mGameHeight / 2;
    [self addChild:background];
    
    
    // Display the Sparrow egg
    
    mPaddle = [[SPImage alloc] initWithTexture:[Media atlasTexture:@"paddle"]];
    mPaddle.pivotX = (int)mPaddle.width / 2;
    mPaddle.pivotY = 0;
    mPaddle.x = mGameWidth / 2;
    mPaddle.y = mGameHeight - 100;
    [self addChild:mPaddle];
    
    mBall = [[SPImage alloc] initWithTexture:[Media atlasTexture:@"ball"]];
    mBall.pivotX = (int)mBall.width / 2;
    mBall.pivotY = (int)mBall.height / 2;
    mBall.x = mGameWidth / 2;
    mBall.y = 50;
    [self addChild:mBall];
    
    // play a sound when the image is touched
    //[mPaddle addEventListener:@selector(onImageTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
    
    // Create a text field
    
    NSString *text = @"Deflect the ball by moving the paddle " \
                     @"to the left and right";
    
    SPTextField *textField = [[SPTextField alloc] initWithWidth:280 height:80 text:text];
    textField.x = (mGameWidth - textField.width) / 2;
    textField.y = mPaddle.y - 175;
    [self addChild:textField];
    

    // The scaffold autorotates the game to all supported device orientations. 
    // Choose the orienations you want to support in the Target Settings ("Summary"-tab).
    // To update the game content accordingly, listen to the "RESIZE" event; it is dispatched
    // to all game elements (just like an ENTER_FRAME event).
    // 
    // To force the game to start up in landscape, add the key "Initial Interface Orientation" to
    // the "App-Info.plist" file and choose any landscape orientation.
    
    [self addEventListener:@selector(onResize:) atObject:self forType:SP_EVENT_TYPE_RESIZE];
    
    [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    
    [mPaddle addEventListener:@selector(onTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];

    //SPTween *tween = [SPTween tweenWithTarget:textField time:0.2];
    //[tween animateProperty:@"alpha" targetValue:0.0f];
    //[[[SPStage mainStage].juggler delayInvocationAtTarget:self byTime:2.0f] addObject:tween];
    //[[[SPStage mainStage].juggler delayInvocationAtTarget:textField byTime:2.0f] removeFromParent];
    
    
    // We release the objects, because we don't keep any reference to them.
    // (Their parent display objects will take care of them.)
    // 
    // However, if you don't want to bother with memory management, feel free to convert this
    // project to ARC (Automatic Reference Counting) by clicking on 
    // "Edit - Refactor - Convert to Objective-C ARC".
    // Those lines will then be removed from the project.
    
    [background release];
    //
    [textField release];
    
    
    // Per default, this project compiles as a universal application. To change that, enter the 
    // project info screen, and in the "Build"-tab, find the setting "Targeted device family".
    //
    // Now choose:  
    //   * iPhone      -> iPhone only App
    //   * iPad        -> iPad only App
    //   * iPhone/iPad -> Universal App  
    // 
    // To support the iPad, the minimum "iOS deployment target" is "iOS 3.2".
}

- (void)onTouch:(SPTouchEvent *)event {
    SPTouch *touch = [event.touches anyObject];
     mTargetPosition = touch.globalX;
    if (touch.phase == SPTouchPhaseBegan) {
        NSLog(@"begin");
    }
    if (touch.phase == SPTouchPhaseMoved) {
        NSLog(@"move");
        
    }
    if (touch.phase == SPTouchPhaseEnded) {
        NSLog(@"end");
    }
    
    
    
    SPTween *tween = [SPTween tweenWithTarget:mPaddle time:0.2];
    [tween animateProperty:@"x" targetValue:mTargetPosition];
    [[SPStage mainStage].juggler addObject:tween];
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event
{
    
    //for (SPDisplayObject *child in mContainer)
        //child.rotation += 0.05f;
    
    float adj = sin(mDirection.x * (M_PI / 180)) * mDirection.y;
    float opp = cos(mDirection.x * (M_PI / 180)) * mDirection.y;
    
    mBall.x += adj;
    mBall.y += opp;
    
    if(mBall.x + mBall.height / 2 > mGameWidth || mBall.x - mBall.width /2 < 0)
    {
        mDirection.x = [self getAngle:-adj opp:opp];
    }else if(mBall.y + mBall.height /2 > mGameHeight || mBall.y - mBall.height / 2 < 0)
    {
        mDirection.x = [self getAngle:adj opp:-opp];
    }
    
    if(mBall.y + mBall.height / 2 > mPaddle.y && mBall.x > mPaddle.x - mPaddle.width/ 2 && mBall.x < mPaddle.x + mPaddle.width/2)
    {
        mDirection.x = [self getAngle:adj opp:-opp];
        [Media playSound:@"sound.caf"];
    }
    // Check for collision detection
    
}

- (float)getAngle:(float)adj opp:(float)opp
{
    float result = 0.0;
    if(adj <= 0 && opp <= 0){
        result = 180 + ( atan( abs(adj) / abs(opp) ) /(M_PI/180) );
    }else if(adj >= 0 && opp <= 0){
        result = 90 + ( atan( abs(opp) / abs(adj) ) /(M_PI/180) );
    }else if(adj <= 0 && opp >= 0){
        result = 270 + ( atan( abs(opp) / abs(adj) ) /(M_PI/180) );
    }else{
        result = ( atan( abs(adj) / abs(opp) ) /(M_PI/180) );
    }
    return result;
}

- (void)onImageTouched:(SPTouchEvent *)event
{
    NSSet *touches = [event touchesWithTarget:self andPhase:SPTouchPhaseEnded];
    if ([touches anyObject])
    {
        [Media playSound:@"sound.caf"];
    }
}

- (void)onResize:(SPResizeEvent *)event
{
    NSLog(@"new size: %.0fx%.0f (%@)", event.width, event.height, 
          event.isPortrait ? @"portrait" : @"landscape");
}

@end
