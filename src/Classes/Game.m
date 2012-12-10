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

@synthesize gameWidth  = mGameWidth;
@synthesize gameHeight = mGameHeight;
@synthesize paddle = mPaddle;

- (id)initWithWidth:(float)width height:(float)height
{
    if ((self = [super init]))
    {
        mGameWidth = width;
        mGameHeight = height;
        
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
    
    mPaddle = [[SPImage alloc] initWithTexture:[Media atlasTexture:@"sparrow"]];
    mPaddle.pivotX = (int)mPaddle.width / 2;
    mPaddle.pivotY = (int)mPaddle.height / 2;
    mPaddle.x = mGameWidth / 2;
    mPaddle.y = mGameHeight / 2 + 40;
    [self addChild:mPaddle];
    
    // play a sound when the image is touched
    [mPaddle addEventListener:@selector(onImageTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
    
    // Create a text field
    
    NSString *text = @"To find out how to create your own game out of this scaffold, " \
                     @"have a look at the 'First Steps' section of the Sparrow website!";
    
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
    if (touch.phase == SPTouchPhaseBegan) {
        NSLog(@"begin");
    }
    if (touch.phase == SPTouchPhaseMoved) {
        NSLog(@"move");
        mPaddle.x = touch.globalX;
        mPaddle.y = touch.globalY;
        
    }
    if (touch.phase == SPTouchPhaseEnded) {
        NSLog(@"end");
    }
}

- (void)onEnterFrame:(SPEnterFrameEvent *)event
{
    
    //for (SPDisplayObject *child in mContainer)
        //child.rotation += 0.05f;
    
    // Check for collision detection
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
