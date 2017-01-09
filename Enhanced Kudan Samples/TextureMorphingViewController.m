#import "TextureMorphingViewController.h"

@implementation TextureMorphingViewController

- (void)setupContent
{
    [self setupTracker];
    [self setupPlane];
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

// Bone and morph animated 3D plane using the real camera image as a texture.
- (void)setupPlane
{
    // The marker we'll be adding to.
    ARImageTrackerManager *trackerManager = [ARImageTrackerManager getInstance];
    ARImageTrackable *spaceTrackable = [trackerManager findTrackableByName:@"lego"];
    
    // Import the model.
    ARModelImporter *importer = [[ARModelImporter alloc] initWithBundled:@"plane.armodel"];
    
    // Get a node representing the model's contents.
    ARModelNode *planeNode = [importer getNode];
    
    // Set up camera texture extractor to convert the marker to a usable texture. Texture dimensions can be arbitrary and need not match the aspect ratio of the source.
    ARExtractedCameraTexture *extracted = [[ARExtractedCameraTexture alloc] initWithWidth:512 height:512];
    
    // The marker is the region of interest. width x height in srcNode's coordinate space.
    extracted.srcWidth = spaceTrackable.width;
    extracted.srcHeight = spaceTrackable.height;
    
    // Create the source node and add it to the marker. Position such that srcWidth x srcWidth in srcNode's space cooresponds to the dimensions of the region of interest.
    extracted.srcNode = [ARNode nodeWithName:@"plane source node"];
    [spaceTrackable.world addChild:extracted.srcNode];
    
    // Create a textured material using the extracted texture.
    ARTextureMaterial *cameraMaterial = [[ARTextureMaterial alloc] initWithTexture:extracted.texture];
    
    // Assign cameraMaterial to every mesh in the model.
    for (ARMeshNode *meshNode in planeNode.meshNodes) {
        meshNode.material = cameraMaterial;
    }
    
    // Material that remains on the marker should be black.
    ARMeshNode *blackNode = [planeNode findMeshNode:@"occlusion"];
    blackNode.material = [[ARColourMaterial alloc] initWithRed:0 green:0 blue:0];
    
    // The height of the plane in object space is 22.652, scale it to match the height of the marker.
    float scaleFactor = spaceTrackable.height / 22.652;
    [planeNode scaleByUniform:scaleFactor];
    
    // Plane is modelled with y-axis up. Marker has z-axis up. Rotate around the x-axis to correct this.
    [planeNode rotateByDegrees:90 axisX:1 y:0 z:0];
    
    // Add the model to a marker.
    [spaceTrackable.world addChild:planeNode];
    
    // Play the animation.
    [planeNode start];
    
    // Loop infinitely.
    planeNode.shouldLoop = YES;
}

#pragma mark - Example IDs

+ (NSString *)getExampleName
{    
    return @"TEXTURE MORPHING";
}

+ (NSInteger)getExampleImportance
{
    return 4;
}

@end
