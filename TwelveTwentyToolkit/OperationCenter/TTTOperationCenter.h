#import <Foundation/Foundation.h>

@class TTTInjector;
@class TTTOperation;

@interface TTTOperationCenter : NSObject

@property NSInteger maxConcurrentOperationCount;

+ (TTTOperationCenter *)defaultCenter;

+ (TTTOperationCenter *)setDefaultCenterWithInjector:(TTTInjector *)injector;

+ (TTTOperationCenter *)setDefaultCenter:(TTTOperationCenter *)defaultCenter;

- (id)initWithInjector:(TTTInjector *)injector;

- (void)queueOperation:(TTTOperation *)operation;

- (void)inlineOperation:(TTTOperation *)operation;

@end