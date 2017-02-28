
#import "CBNewestMsgManager.h"

static CBNewestMsgManager* instance;

@implementation CBNewestMsgManager


+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [CBNewestMsgManager new];
    });
    
    return instance;
}

@end