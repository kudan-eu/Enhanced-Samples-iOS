#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ThreeDModelWithGPSViewController.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>

/**
 MapView for displaying user and model location.
 */
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

/**
 Map pin to mark location the model should be drawn at.
 */
@property (strong, nonatomic) MKPointAnnotation *touchPin;

/**
 Location manager to update user position on map.
 */
@property (strong, nonatomic) CLLocationManager *locationManager;

/**
 Parent view controller delegate.
 */
@property (weak, nonatomic) ThreeDModelWithGPSViewController *parentDelegate;

/**
 Button to segue mapViewController into CameraViewController.
 */
- (IBAction)progressButton:(id)sender;

@end
