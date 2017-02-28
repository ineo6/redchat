#import <UIKit/UIKit.h>

@interface CBMessageHud : NSObject

+ (UIButton *)showHUDInView:(UIView *)view text:(NSString *)text target:(id)target action:(SEL)selector;

+ (BOOL)showed;

@end