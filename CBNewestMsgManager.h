#import <Foundation/Foundation.h>

@interface CBNewestMsgManager : NSObject

+ (instancetype)sharedInstance;


@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) NSArray *webViewViewControllers;


@end