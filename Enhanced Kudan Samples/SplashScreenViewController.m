#import "SplashScreenViewController.h"

@interface SplashScreenViewController ()

@property (nonatomic) AVPlayerLayer *videoLayer;

@end

@implementation SplashScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.markerImage.hidden = YES;
    self.okayButton.hidden = YES;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *moviePath = [mainBundle pathForResource:@"splash_screen_video" ofType:@"mp4"];
    
    AVPlayerItem *videoItem = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:moviePath]];
    AVPlayer *videoPlayer = [AVPlayer playerWithPlayerItem:videoItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:videoItem];
    
    AVPlayerLayer *videoLayer = [AVPlayerLayer layer];
    
    [videoLayer setPlayer:videoPlayer];
    [videoLayer setFrame:self.view.frame];
    
    [self.view.layer addSublayer:videoLayer];
    
    self.videoLayer = videoLayer;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wasTapped:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[self.videoLayer player] play];
}

- (void)itemDidFinishPlaying:(NSNotification *)notification
{
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"firstRunCompleted"]) {
        
        self.videoLayer.hidden = YES;
        
        self.markerImage.hidden = NO;
        self.markerImage.layer.zPosition = -10;
        
        self.okayButton.hidden = NO;
        self.okayButton.layer.zPosition = 10;
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstRunCompleted"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    else {
        
        [self performSegueWithIdentifier:@"FirstRunSegue" sender:self];
    }
}

- (void)orientationChanged:(NSNotification *)note
{
    self.videoLayer.frame = self.view.frame;
}

- (void)wasTapped:(UITapGestureRecognizer *)gesture
{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"firstRunCompleted"]) {
        
        [[self.videoLayer player] pause];
        
        [self performSegueWithIdentifier:@"FirstRunSegue" sender:self];
    }
}

@end
