#import <KudanAR/ARGPSManager.h>
#import <KudanAR/ARGPSNode.h>
#import "ThreeDModelWithGPSViewController.h"
#import "MapViewController.h"

@implementation ThreeDModelWithGPSViewController

- (void)setupContent
{
    // Get user defined coordinate if none exists.
    if (!self.objectCoordinate) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"GPSExample" bundle:nil];
            
            UIViewController *initialViewController = [storyBoard instantiateInitialViewController];
            
            if ([initialViewController isKindOfClass:[MapViewController class]]) {
            
                MapViewController *mapViewController = (MapViewController *) initialViewController;
                
                mapViewController.parentDelegate = self;
                
                [self.navigationController pushViewController:mapViewController animated:NO];
            }
        });
    } else {
        // Initialise and start the GPS Manager.
        ARGPSManager *GPSManager = [ARGPSManager getInstance];
        [GPSManager initialise];
        [GPSManager start];
        
        // Initialise a GPSNode with coordinate provided from the map.
        ARGPSNode *GPSNode = [[ARGPSNode alloc] initWithLocation:self.objectCoordinate];
        
        // Point the GPS Node due east.
        [GPSNode setBearing:90];
        
        // Must add GPSNode as a child to the GPS Manager world.
        [GPSManager.world addChild:GPSNode];
        
        // Import the model.
        ARModelImporter *modelImporter = [[ARModelImporter alloc] initWithBundled:@"ben.armodel"];
        
        // The ARModel node represents all external contents relating to the model e.g.animations, textures.
        ARModelNode *modelNode = [modelImporter getNode];
        
        // Add the modelNode as a child to the GPSNode.
        [GPSNode addChild:modelNode];
        
        // Add the texture to the 3D model.
        ARTexture *modelTexture = [[ARTexture alloc] initWithUIImage:[UIImage imageNamed:@"Big_Ben_diffuse.png"]];
        
        // Setup the object material.
        ARLightMaterial *modelMaterial = [[ARLightMaterial alloc] init];
        modelMaterial.colour.texture = modelTexture;
        modelMaterial.ambient.value = [ARVector3 vectorWithValuesX:0.5 y:0.5 z:0.5];
        modelMaterial.diffuse.value = [ARVector3 vectorWithValuesX:0.5 y:0.5 z:0.5];
        
        // Cover the model accordingly.
        for (ARMeshNode *meshNode in modelNode.meshNodes) {
            
            meshNode.material = modelMaterial;
        }
        
        // Scale the model to the correct height of Big Ben from model height. Units of the GPSManager world are meters.
        [modelNode scaleByUniform:(96.0 / 11008.0)];
    }
}

#pragma mark - Example IDs

+ (NSString *)getExampleName
{
    return @"3D MODEL WITH GPS";
}

+ (NSInteger)getExampleImportance
{    
    return 8;
}

@end
