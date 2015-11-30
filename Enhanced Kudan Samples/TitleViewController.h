#import <UIKit/UIKit.h>

@protocol KudanExamplesProtocol <NSObject>

@required

+ (NSString *)getExampleName;

+ (NSInteger)getExampleImportance;

@end



@interface TitleViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSMutableDictionary *codeExamples;

@end

