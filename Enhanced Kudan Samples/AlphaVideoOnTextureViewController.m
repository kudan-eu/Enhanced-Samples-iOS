#import "AlphaVideoOnTextureViewController.h"

@implementation AlphaVideoOnTextureViewController

- (void)setupContent
{
    [self setupTracker];
    [self setupVideo];
}

- (void)setupTracker
{
    ARImageTrackerManager *trackerManager = [ARImageTrackerManager getInstance];
    
    // Initialise the image tracker.
    [trackerManager initialise];
    
    // Create a trackable from a bundled file. Give it a unique name which we can use to locate it later.
    ARImageTrackable *imageTrackable = [[ARImageTrackable alloc] initWithImage:[UIImage imageNamed:@"space.marker.jpg"] name:@"spaceMarker"];
    
    // Add this new trackable to the tracker.
    [trackerManager addTrackable:imageTrackable];
}

- (void)setupVideo
{
    // The marker we'll be adding to.
    ARImageTrackerManager *trackerManager = [ARImageTrackerManager getInstance];
    ARImageTrackable *imageTrackable = [trackerManager findTrackableByName:@"spaceMarker"];
    
    // Create a video node associated with a video file.
    ARAlphaVideoNode *videoNode = [[ARAlphaVideoNode alloc] initWithBundledFile:@"kaboom_alpha_video.mp4"];
    
    // Add it to the marker.
    [imageTrackable.world addChild:videoNode];
    
    // Scale to fit the width of the marker and make explosion bigger!
    float scaleFactor = (float)imageTrackable.width / videoNode.videoTexture.width * 5;
    [videoNode scaleByUniform:scaleFactor];
    
    // Play the video.
    [videoNode.videoTexture play];
    
    // Reset the video if it hasn't been played for over two seconds.
    videoNode.videoTexture.resetThreshold = 2;
    
    // Register for touch events.
    [videoNode addTouchTarget:self withAction:@selector(videoWasTouched:)];
    
    //Adds delegate method for trackable detected
    [imageTrackable addTrackingEventTarget:self action:@selector(imageDetected:) forEvent:ARImageTrackableEventDetected];
}

- (void)videoWasTouched:(ARAlphaVideoNode *)alphaVideoNode
{
    // Reset the video when touched.
    [alphaVideoNode.videoTexture reset];
    [alphaVideoNode.videoTexture play];
}

// Resets and plays alpha video on detection
- (void)imageDetected:(ARImageTrackable *)trackable
{
    ARAlphaVideoNode *alphaVideoNode = [trackable.world.children objectAtIndex:0];
    [alphaVideoNode.videoTexture reset];
    [alphaVideoNode.videoTexture play];
}

+ (NSString *)getExampleName
{
    return @"ALPHA VIDEO ON TEXTURE";
}

+ (NSInteger)getExampleImportance
{
    return 2;
}

@end
