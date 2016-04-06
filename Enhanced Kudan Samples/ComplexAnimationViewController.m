#import "ComplexAnimationViewController.h"

@implementation ComplexAnimationViewController

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
    ARModelImporter *importer = [[ARModelImporter alloc] initWithBundled:@"samba_dancing.armodel"];
    
    // Get a node representing the model's contents.
    ARModelNode *footballerNode = [importer getNode];
    
    // Start the model's animation and loop indefinitely.
    [footballerNode start];
    footballerNode.shouldLoop = YES;
    
    // Set up and add the model material.
    ARTexture *footballerTexture = [[ARTexture alloc] initWithUIImage:[UIImage imageNamed:@"footballer_tex.png"]];
    ARLightMaterial *footballerMaterial = [[ARLightMaterial alloc] init];
    
    footballerMaterial.colour.texture = footballerTexture;
    footballerMaterial.diffuse.value = [ARVector3 vectorWithValuesX:1 y:1 z:1];
    footballerMaterial.ambient.value = [ARVector3 vectorWithValuesX:0.5 y:0.5 z:0.5];
    
    for(ARMeshNode *meshNode in footballerNode.meshNodes) {
        
        meshNode.material = footballerMaterial;
    }
    
    // Modelled with y-axis up. Marker has z-axis up. Rotate around the x-axis to correct this.
    [footballerNode rotateByDegrees:90 axisX:1 y:0 z:0];
    [footballerNode scaleByUniform:10];
    
    // Add the model to the image.
    [imageTrackable.world addChild:footballerNode];
}

#pragma mark - Example IDs

+ (NSString *)getExampleName
{
    return @"COMPLEX ANIMATIONS";
}

+ (NSInteger)getExampleImportance
{
    return 6;
}

@end
