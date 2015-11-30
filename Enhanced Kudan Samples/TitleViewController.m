#import <objc/runtime.h>
#import "TitleViewController.h"

@implementation TitleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.codeExamples = [[NSMutableDictionary alloc] init];
    
    // Set up list of available examples.
    NSDictionary *unsortedExamples = [self getAllExampleViewControllers];
    
    // Sort example list based on importance.
    NSArray *sortedExamples = [unsortedExamples keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    // Populate list with buttons for each example.
    UIButton *prevButton;
    NSInteger counter = 0;
    
    for (Class example in sortedExamples) {
        
        NSString *exampleTitle = [example performSelector:@selector(getExampleName)];
        
        // Set up button format.
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        
        [button setTitle:exampleTitle forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:45];
        button.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.backgroundColor = [UIColor colorWithRed:0.27 green:0.33 blue:0.40 alpha:1.0];
        
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:button];
        
        // Add button constraints.
        NSMutableDictionary *viewsDict = [NSMutableDictionary dictionaryWithObject:button forKey:@"button"];
        [viewsDict setObject:self.scrollView forKey:@"scrollView"];
        NSString *horizontalConstraintsParam = @"H:|[button(==scrollView)]|";
        NSString *verticalConstraintsParam = @"V:|[button]";
        
        if (prevButton) {
            
            [viewsDict setObject:prevButton forKey:@"prevButton"];
            verticalConstraintsParam = @"V:[prevButton]-[button]";
            
            if (counter == sortedExamples.count - 1) {
                verticalConstraintsParam = @"V:[prevButton]-[button]|";
            }
        }
        
        [self.scrollView addConstraints:[NSLayoutConstraint
                                         constraintsWithVisualFormat:horizontalConstraintsParam
                                         options:NSLayoutFormatAlignAllCenterX
                                         metrics:nil
                                         views:viewsDict
                                         ]];
        
        [self.scrollView addConstraints:[NSLayoutConstraint
                                         constraintsWithVisualFormat:verticalConstraintsParam
                                         options:NSLayoutFormatAlignAllCenterX
                                         metrics:nil
                                         views:viewsDict
                                         ]];
        
        prevButton = button;
        counter++;
        
        // Add class to dictionary with name identifier.
        [self.codeExamples setObject:example forKey:exampleTitle];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
    [super viewWillAppear:animated];
}

- (void)buttonPressed:(UIButton *)sender
{
    Class exampleViewControllerClass = [self.codeExamples objectForKey:sender.titleLabel.text];
    
    UIViewController *newExample = [[exampleViewControllerClass alloc] init];
    
    [self.navigationController pushViewController:newExample animated:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (NSDictionary *)getAllExampleViewControllers
{    
    NSMutableDictionary *controllers = [[NSMutableDictionary alloc] init];
    
    unsigned int count = 0;
    const char** classes = objc_copyClassNamesForImage([[[NSBundle mainBundle] executablePath] UTF8String], &count);
    
    for (unsigned int i = 0; i < count; i++) {
        
        Class class = NSClassFromString ([NSString stringWithCString:classes[i] encoding:NSUTF8StringEncoding]);
        
        if ([class conformsToProtocol:@protocol(KudanExamplesProtocol)]) {
            
            NSNumber *exampleImportance = [NSNumber numberWithInt:(int)[class performSelector:@selector(getExampleImportance)]];
            
            [controllers setObject:exampleImportance forKey:(id <NSCopying>)class];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:controllers];
}

@end
