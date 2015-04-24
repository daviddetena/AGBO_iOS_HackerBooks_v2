#import "_DTCAnnotation.h"
@class AGTCoreDataStack;
@class DTCBook;


@interface DTCAnnotation : _DTCAnnotation {}

#pragma mark - Factory init
+(instancetype) annotationWithName:(NSString *) name
                              book:(DTCBook *) book
                             stack:(AGTCoreDataStack *) stack;

@end
