#import "VideoOnTextureViewController.h"

@implementation VideoOnTextureViewController

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
    ARImageTrackable *imageTrackable = [[ARImageTrackable alloc] initWithImage:[UIImage imageNamed:@"lego.jpg"] name:@"lego"];
    
    // Add this new trackable to the tracker.
    [trackerManager addTrackable:imageTrackable];
}

- (void)setupVideo
{
    // The marker we'll be adding to.
    ARImageTrackerManager *trackerManager = [ARImageTrackerManager getInstance];
    ARImageTrackable *imageTrackable = [trackerManager findTrackableByName:@"lego"];
    
    // Create a video node associated with a video file.
    ARVideoNode *videoNode = [[ARVideoNode alloc] initWithBundledFile:@"star_wars_trailer.mp4"];
    
    // Add it to the marker.
    [imageTrackable.world addChild:videoNode];
    
    // Scale and rotate to fit the height of the marker.
    float scaleFactor = (float)imageTrackable.width / videoNode.videoTexture.height;
    [videoNode scaleByUniform:scaleFactor];
    [videoNode rotateByDegrees:90 axisX:0 y:0 z:1];
    
    // Play the video.
    [videoNode play];
    
    // Fade the video in over 1 second.
    videoNode.videoTextureMaterial.fadeInTime = 1;
    
    // Reset the video if it hasn't been played for over two seconds.
    videoNode.videoTexture.resetThreshold = 2;
    
    // Register for touch events.
    [videoNode addTouchTarget:self withAction:@selector(videoWasTouched:)];
}

- (void)videoWasTouched:(ARVideoNode *)videoNode
{
    // Reset the video when touched.
    [videoNode reset];
    [videoNode play];
}

#pragma mark - Example IDs

+ (NSString *)getExampleName
{
    return @"VIDEO ON TEXTURE";
}

+ (NSInteger)getExampleImportance
{
    return 1;
}

@end
