#import "DTCPhoto.h"
#import "AGTCoreDataStack.h"
@import UIKit;

@interface DTCPhoto ()

// Private interface goes here.

@property (strong,nonatomic) UIImage *defaultBookImage;
@property (strong,nonatomic) NSURL *bookImageURL;

@end

@implementation DTCPhoto

/**
    Tres casos donde hay que especificar con @synthesize/@dynamic que se quiere
    una variable de instancia:
    1. La propiedad viene de un protocolo.
    2. La propiedad tiene un setter/getter propio. El compilador considera que no
       vas a necesitar una variable de instancia.
    3. Quien crea una clase puede marcar una clase para que cualquiera que herede
       esa clase a especificar @synthesize/@dynamic. Eso pasa con NSManagedObject
       y por eso para clases que heredan de ella se utiliza @dynamic.
    
    Explicación en
    http://www.cocoaosx.com/2012/12/04/auto-synthesize-property-reglas-excepciones/
 */

//@synthesize bookImageURL = _bookImageURL;
@synthesize defaultBookImage = _defaultBookImage;
@synthesize bookImageURL = _bookImageURL;


#pragma mark - Properties
// We get an UIImage and set photoData with that UIImage
-(void) setAnnotationImage:(UIImage *) annotationImage{
    
    // Sincronizar con imageData
    self.photoData = UIImageJPEGRepresentation(annotationImage, 0.9);
}


// Lazy loading => return an UIImage from photoData in CoreData
// Only when needed
-(UIImage *) annotationImage{
    return [UIImage imageWithData:self.photoData];
}



// Lazy loading => return an UIImage from photoData in CoreData
// Only when needed
-(UIImage *) bookImage{
    if (self.photoData) {
        return [UIImage imageWithData:self.photoData];
    }
    return self.defaultBookImage;
}


#pragma mark - Class methods
// Photo for a book
+(instancetype) photoForBookWithURL:(NSURL *) url
                       defaultImage:(UIImage *) defaultImage
                              stack:(AGTCoreDataStack *) stack{

    DTCPhoto *photo = [DTCPhoto insertInManagedObjectContext:stack.context];
    photo.defaultBookImage = defaultImage;
    photo.bookImageURL = url;
    photo.photoData = nil;
    
    // Download remote image after a delay so we can see default image
    // for a while
    //[self performSelector:@selector(downloadBookImage) withObject:nil afterDelay:0.01];
    
    return photo;
    //return [[self alloc] initWithURL:url forBookImage:defaultImage stack:stack];
}


-(id) initWithURL:(NSURL *) remoteURL
     forBookImage:(UIImage *) defaultImage
            stack:(AGTCoreDataStack *) stack{
    
    DTCPhoto *photo = [DTCPhoto insertInManagedObjectContext:stack.context];
    photo.defaultBookImage = defaultImage;
    photo.bookImageURL = remoteURL;
    
    // Download remote image after a delay so we can see default image
    // for a while
    [self performSelector:@selector(downloadBookImage) withObject:nil afterDelay:0.01];
    
    /*
    if (!self.photoData) {
        // No photo. Set default while downloading remote image asynchronously
        DTCPhoto *photo = [DTCPhoto insertInManagedObjectContext:stack.context];
        photo.defaultBookImage = defaultImage;
        photo.bookImageURL = remoteURL;
        
        // Download remote image after a delay so we can see default image
        // for a while
        [self performSelector:@selector(downloadBookImage) withObject:nil afterDelay:0.01];
    }
    else{
    
    }
     */
    
    return self;
}


// Photo for an annotation
+(instancetype) photoForAnnotationWithImage:(UIImage *) image
                                      stack:(AGTCoreDataStack *) stack{

    DTCPhoto *photo = [DTCPhoto insertInManagedObjectContext:stack.context];
    photo.photoData = UIImageJPEGRepresentation(image, 0.9);
    
    return photo;
}


#pragma mark - Book remote image
-(void) downloadBookImage{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:self.bookImageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // All the notifications should be in main queue
            [self setNewBookImageWithData:data];
        });
    });
}


-(void) setNewBookImageWithData:(NSData *) data{

    // Save image data in property for CoreData
    self.photoData = data;
    
    NSLog(@"Cover book downloaded from %@",[self.bookImageURL path]);
}



@end
