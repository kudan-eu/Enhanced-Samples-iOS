#import "AppDelegate.h"
#import <KudanAR/ARAPIKey.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    [[ARAPIKey sharedInstance] setAPIKey:@"GAWQE-F9ATK-DJADZ-DKDMP-Q2M7S-EB2LS-Q723Z-6XJWS-A9KCQ-KXTHP-GLAHS-TNF6Y-Q37FT-AWZD6-XTM6K-Q"];
    
    return YES;
}

@end
