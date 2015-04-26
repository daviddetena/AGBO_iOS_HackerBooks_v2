//
//  DTCAsyncImage.m
//  HackerBooks_v2
//
//  Created by David de Tena on 25/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCAsyncImage.h"

@interface DTCAsyncImage()

@property (nonatomic, strong) UIImage *defaultImage;
@property (nonatomic, strong) NSURL *remoteImageURL;

@end

@implementation DTCAsyncImage

#pragma mark - Factory init
+(instancetype) asyncImageWithURL:(NSURL *) url
                     defaultImage:(UIImage *) image{

    return [[self alloc]initWithURL:url defaultImage:image];
}

#pragma mark - Instance init
-(id) initWithURL:(NSURL *) url
     defaultImage:(UIImage *) image{

    if ([self urlPointsToFile:url]) {
        if (self = [super init]) {
            //_imageData = [NSData dataWithContentsOfURL:url];
//            _image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            
            // Download remote image after a delay so we can see default image
            // for a while
            [self performSelector:@selector(downloadImage) withObject:nil afterDelay:0.01];
        }
    }
    else{
        // Do not throw an exception here.
        self = nil;
    }
    return self;
}

#pragma mark - URL
-(BOOL) urlPointsToFile:(NSURL*) url{
    
    NSString *last = [url lastPathComponent];
    
    if ([last isEqualToString:@""] ||
        [last isEqualToString:@"/"]) {
        return NO;
    }else{
        // Por vagancia no compruebo que sea realmente una imagen
        // gif, png, jpg, etc... Ejercicio para el alumno con
        // más paciencia. Esto realmente deberia de ser labor de un test
        // en el backend: no enviar NUNCA info incorrecta.
        return YES;
    }
}

#pragma mark - Remote image in background
-(void) downloadImage{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:self.remoteImageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // All the notifications should be in main queue
            [self setNewImageData:data];
        });
    });
}

// Set new image as a representation of the NSData downloaded
-(void) setNewImageData:(NSData *) data{
    
    // Save image data in property for CoreData
    self.imageData = data;
    
    [self notifyChangeInImage];
}



#pragma mark - Notifications
// Let out delegate know (if exists)
// Set a notification so everyone can observe for it
-(void) notifyChangeInImage{
    // Inform through delegate
    [self.delegate asyncImageDidChange:self];
    
    // Inform through notifications
    NSNotification *notification = [NSNotification notificationWithName:IMAGE_DID_CHANGE_NOTIFICATION
                                                                 object:self
                                                               userInfo:@{IMAGE_CHANGE_KEY:self.imageData}];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    NSLog(@"Asyncimage avisa de que ha descargado la nueva iamgen");
}



@end
