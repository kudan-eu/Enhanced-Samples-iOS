#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import "TitleViewController.h"
#import <KudanAR/KudanAR.h>

@interface ThreeDModelWithGPSViewController : ARCameraViewController <KudanExamplesProtocol>

/**
 Location the model will be placed at.
 */
@property (strong, nonatomic) CLLocation *objectCoordinate;

@end

