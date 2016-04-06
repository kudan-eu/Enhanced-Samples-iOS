#import "ThreeDModelOnMarkerViewController.h"

@implementation ThreeDModelOnMarkerViewController

- (void)setupContent
{
    [self setupTracker];
    [self setupModel];
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

- (void)setupModel
{
    // The marker we'll be adding to.
    ARImageTrackerManager *trackerManager = [ARImageTrackerManager getInstance];
    ARImageTrackable *imageTrackable = [trackerManager findTrackableByName:@"spaceMarker"];
    
    // Import the model.
    ARModelImporter *importer = [[ARModelImporter alloc] initWithBundled:@"bloodhound.armodel"];
    
    // Get a node representing the model's contents.
    ARModelNode *modelNode = [importer getNode];
    
    // Create the model texture from a UIImage.
    ARTexture *modelTexture = [[ARTexture alloc] initWithUIImage:[UIImage imageNamed:@"bloodhound.png"]];
    
    // Create a textured material using the texture.
    ARTextureMaterial *textureMaterial = [[ARTextureMaterial alloc] initWithTexture:modelTexture];
    
    // Assign textureMaterial to every mesh in the model.
    for (ARMeshNode *meshNode in modelNode.meshNodes) {
        
        meshNode.material = textureMaterial;
    }
    
    // Modelled with y-axis up. Marker has z-axis up. Rotate around the x-axis to correct this.
    [modelNode rotateByDegrees:90 axisX:1 y:0 z:0];
    [modelNode scaleByUniform:10];
    
    // Add the model to a marker.
    [imageTrackable.world addChild:modelNode];
}

#pragma mark - Example IDs

+ (NSString *)getExampleName
{
    return @"3D MODEL ON MARKER";
}

+ (NSInteger)getExampleImportance
{
    return 3;
}

@end
