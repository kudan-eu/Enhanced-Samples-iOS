#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AVFoundation/AVFoundation.h"

@interface SplashScreenViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *markerImage;

@property (weak, nonatomic) IBOutlet UIButton *okayButton;
@property (weak, nonatomic) IBOutlet UILabel *headerText;

@end
