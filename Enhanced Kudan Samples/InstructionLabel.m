#import "InstructionLabel.h"

@implementation InstructionLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:24];
    self.textColor =[UIColor whiteColor];
    self.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = [UIColor colorWithRed:0.27 green:0.33 blue:0.40 alpha:0.75];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8.0;
    self.adjustsFontSizeToFitWidth = YES;
    
    return self;
}

- (CGSize)intrinsicContentSize
{
    CGSize contentSize = [super intrinsicContentSize];
    return CGSizeMake(contentSize.width + 30, contentSize.height + 30);
}

- (void)constrainInView:(UIView *)view
{
    self.translatesAutoresizingMaskIntoConstraints = NO;

    [view addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:0.5
                                                      constant:0]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:(CGRectGetWidth(view.bounds) * 0.1)]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:-(CGRectGetWidth(view.bounds) * 0.1)]];
}

@end
