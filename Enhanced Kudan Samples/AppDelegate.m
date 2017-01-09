#import "AppDelegate.h"
#import <KudanAR/ARAPIKey.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    [[ARAPIKey sharedInstance] setAPIKey:@"sVmoznmKZ+4nFEHD6HoslwpC26PNuBZGHrikUwyon2BKSvza1yu2CqbSrae+pHPr1NHjhsf5pHQOZn8IEqXlqXFodGsrOJhxJANbMOdvnRLUi9/QWGqyRL9FViDmyohw6e5R7U4Ex8H7d7spLLvhfp5HFv56DgLr8c8sC2ipDtv9g1IjOTaY7UGxata3eulG2A/UkIdRv2NcotZXqan01xQUWFAislEwlGguParEYiwu11T4mqtU3dQBbfxpvxbczjdYz493YG3rAO2RHgT+5M5TJShJsz2irkNo71JD2Fzqf4AR2b4+7t1c55zKjegXzGS6Xa/rpNn9yiXUn7rUYIHNvN3cEQa9HsZiVxAV4vJgxFS+T/AxfWqKrEg1uj6xF5MsodZ2EkZ8mqliYIsxZqnFz+Re2HeWG8wvrEob0ZwRIO0TxppAemZc3HChTAPLcNt5gzeBk0oRP4wnrFAFFBDi8XjDocwTSVw++hWZb1qNHzt6bKLsMDRT057UVuuZB6M8f7EOQD79Oah0Vrx/3DUK6e9BEV8oGFNHtk1wyYEkg0i6RLhVSokGx//Qj36A4gCz3h1OjtfB0OuukbNq7xI1L/FcNQLmGYNGZwszARjGr9ESw1gVAkbQMxaV27uo/KoIq4+nR7RL8iT7t7NAaXCFIi24RR+7WGjTvKqWYjA="];
    
    return YES;
}

@end
