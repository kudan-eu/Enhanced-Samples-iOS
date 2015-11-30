#import "MapViewController.h"
#import "InstructionLabel.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // Init location manager and check permissions.
    self.locationManager = [[CLLocationManager alloc] init];
    self.mapView.delegate = self;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if (status == kCLAuthorizationStatusNotDetermined &&
        [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    
    // Add instructional label.
    InstructionLabel *label = [[InstructionLabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    label.text = @"Tap to place model, then press \"Done\"";
    [self.view addSubview:label];
    [label constrainInView:self.view];
    
    // Add gesture recogniser.
    UITapGestureRecognizer *tapGestureRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasTapped:)];
    [self.mapView addGestureRecognizer:tapGestureRecogniser];
}

- (void)viewWasTapped:(UIGestureRecognizer *)gesture
{
    //Remove touch pin if one already exists.
    if (self.touchPin) {
        [self.mapView removeAnnotation:self.touchPin];
    }
    
    //Setup touch pin and add to map.
    self.touchPin = [[MKPointAnnotation alloc] init];
    self.touchPin.title = @"Place object here.";
    
    CGPoint touchPoint = [gesture locationInView:self.mapView];
    CLLocationCoordinate2D touchCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    self.touchPin.coordinate = touchCoordinate;
    
    [self.mapView addAnnotation:self.touchPin];
}

- (IBAction)progressButton:(id)sender
{
    if (self.touchPin) {
        
        // Set model coordinate to position of the map pin.
        CLLocationCoordinate2D touchPinCoordinate = self.touchPin.coordinate;
        
        self.parentDelegate.objectCoordinate = [[CLLocation alloc] initWithLatitude:touchPinCoordinate.latitude longitude:touchPinCoordinate.longitude];
        
        [self.parentDelegate setupContent];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
