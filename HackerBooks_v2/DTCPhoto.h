#import "_DTCPhoto.h"
@import UIKit;
@class AGTCoreDataStack;

@interface DTCPhoto : _DTCPhoto {}

@property (strong,nonatomic) UIImage *bookImage;
@property (strong,nonatomic) UIImage *annotationImage;

#pragma mark - Init
-(id) initWithURL:(NSURL *) remoteURL
     forBookImage:(UIImage *) defaultImage
            stack:(AGTCoreDataStack *) stack;


#pragma mark - Class methods

// Photo for a book
+(instancetype) photoForBookWithURL:(NSURL *) url
                       defaultImage:(UIImage *) defaultImage
                              stack:(AGTCoreDataStack *) stack;

// Photo for an annotation
+(instancetype) photoForAnnotationWithImage:(UIImage *) image
                                      stack:(AGTCoreDataStack *) stack;

@end
