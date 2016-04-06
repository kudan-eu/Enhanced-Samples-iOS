#import "AnimationOcclusionViewController.h"
#import "InstructionLabel.h"

@interface AnimationOcclusionViewController () {
    
    float __lastScale;
    
    BOOL __isSceneSetup;
}

@property (nonatomic) ARModelNode *calibrationNode;
@property (nonatomic) InstructionLabel *label;

@end

@implementation AnimationOcclusionViewController

- (void)setupContent
{
    [self setupTracker];
    [self setupModel];
    [self setupLabel];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(wasPinched:)];
    [self.view addGestureRecognizer:pinchGesture];
    [pinchGesture setDelegate:self];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wasTapped:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setDelegate:self];
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
    
    // Import the cylinder model to calibrate scale.
    ARModelImporter *importer = [[ARModelImporter alloc] initWithBundled:@"cylinder.armodel"];
    
    // Get a node representing the model's contents.
    ARModelNode *calibrationNode = [importer getNode];
    
    // Set up the model's material.
    ARLightMaterial *calibrationMaterial = [[ARLightMaterial alloc] init];
    calibrationMaterial.colour.value = [ARVector3 vectorWithValuesX:1.0 y:1.0 z:1.0];
    
    for (ARMeshNode *meshNode in calibrationNode.meshNodes) {
        
        meshNode.material = calibrationMaterial;
    }
    
    // Cylinder is modelled with y-axis up. Marker has z-axis up. Rotate around the x-axis to correct this. Scale the model to an approximately correct scale.
    [calibrationNode rotateByDegrees:90 axisX:1 y:0 z:0];
    [calibrationNode scaleByUniform:imageTrackable.height / 40.0];
    
    // Add model to the image.
    [imageTrackable.world addChild:calibrationNode];
    
    self.calibrationNode = calibrationNode;
    __lastScale = 1.0;
}

- (void)setupOcclusionScene
{
    // The marker we'll be adding to.
    ARImageTrackerManager *trackerManager = [ARImageTrackerManager getInstance];
    ARImageTrackable *imageTrackable = [trackerManager findTrackableByName:@"spaceMarker"];
    
    // Set up an occlusion material for obsuring virtual objects and add to the cylinder model.
    AROcclusionMaterial *occlusionMaterial = [[AROcclusionMaterial alloc] init];
    
    for (ARMeshNode *meshNode in self.calibrationNode.meshNodes) {
        meshNode.material = occlusionMaterial;
    }
    
    // Import the animated model.
    ARModelImporter *importer = [[ARModelImporter alloc] initWithBundled:@"jog_in_circle.armodel"];
    
    // Get a node representing the model's contents.
    ARModelNode *footballerNode = [importer getNode];
    
    // Start the animation and loop infinitely.
    [footballerNode start];
    footballerNode.shouldLoop = YES;
    
    // Modelled with y-axis up. Marker has z-axis up. Rotate around the x-axis to correct this.
    [footballerNode rotateByDegrees:90 axisX:1 y:0 z:0];
    [footballerNode scaleByUniform:0.5];
    
    // Set up and add the animated model's material.
    ARTexture *footballerTexture = [[ARTexture alloc] initWithUIImage:[UIImage imageNamed:@"footballer_tex.png"]];
    ARLightMaterial *footballerMaterial = [[ARLightMaterial alloc] init];
    
    footballerMaterial.colour.texture = footballerTexture;
    footballerMaterial.diffuse.value = [ARVector3 vectorWithValuesX:1 y:1 z:1];
    footballerMaterial.ambient.value = [ARVector3 vectorWithValuesX:0.5 y:0.5 z:0.5];
    
    for(ARMeshNode *meshNode in footballerNode.meshNodes) {
        
        meshNode.material = footballerMaterial;
    }
    
    // Add the model to the image.
    [imageTrackable.world addChild:footballerNode];
}

- (void)setupLabel
{
    // Set up the instructional label.
    dispatch_async(dispatch_get_main_queue(), ^{
        
        InstructionLabel *label = [[InstructionLabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        label.text = @"Place the cylinder over a can and touch the screen. Pinch to scale.";
        
        [self.view addSubview:label];
        
        [label constrainInView:self.view];
        
        self.label = label;
    });
}

#pragma mark - Gesture handling

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)wasPinched:(UIPinchGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        __lastScale = 1.0f;
        return;
    }
    
    float scale = 1.0 - (__lastScale - gesture.scale);
    
    [self.calibrationNode scaleByUniform: scale];
    
    __lastScale = gesture.scale;
}

- (void)wasTapped:(UITapGestureRecognizer *)gesture
{
    if (!__isSceneSetup) {
        
        [self setupOcclusionScene];
        
        self.label.hidden = YES;
        __isSceneSetup = YES;
    }
}

#pragma mark - Example IDs

+ (NSString *)getExampleName
{
    return @"ANIMATION + OCCLUSION";
}

+ (NSInteger)getExampleImportance
{
    return 7;
}

@end
