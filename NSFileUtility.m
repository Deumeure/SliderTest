//
//  NSFileUtility.m
//  DupuisWeb
//
//  Created by mac1 on 10/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSFileUtility.h"


@implementation NSFileUtility

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
	int r = (hex >> 16) & 0xFF;
	int g = (hex >> 8) & 0xFF;
	int b = (hex) & 0xFF;
	
	return [UIColor colorWithRed:r / 255.0f
						   green:g / 255.0f
							blue:b / 255.0f
						   alpha:1.0f];
}

+ (UIColor *)colorWithString:(NSString*)rvb {
	NSArray *mesColor = [rvb componentsSeparatedByString:@"-"];
	if ([mesColor count] == 3) {
		return [UIColor colorWithRed:([[mesColor objectAtIndex:0] floatValue]/255.0) 
							   green:([[mesColor objectAtIndex:1] floatValue]/255.0)  
							   blue:([[mesColor objectAtIndex:2] floatValue]/255.0)  
							   alpha:1.0];
	} 
	return [UIColor blackColor];
}

+ (NSString*)retourneTime:(NSDate*)ladate format:(NSString*)format {
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:format];
	
	return [dateFormatter stringFromDate:ladate];
	
}

+ (void)createDirectoryAtPath:(NSString*)path {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

+ (void)removeDirectoryAtPath:(NSString*)path {
	if ([path length] < 15) {
		NSLog(@"WARNING CHECK PATH FOR REMOVING : %@",path);
		return;
	}
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:path error:nil];
}

+ (NSString*)retourneBundlePath {
    return [[NSBundle mainBundle] resourcePath];
}

+ (NSString*)retourneBundlePathForFile:(NSString *)file {
    return [[NSBundle mainBundle] pathForResource:file ofType:nil];
}

+ (NSString*)retourneBundlePathForFile:(NSString *)file inDirectory:(NSString*)directory {
    return [[NSBundle mainBundle] pathForResource:file ofType:nil inDirectory:directory];
}

+ (NSString*)retourneDocumentPath:(NSString *)file {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];	
    return [documentsDirectory stringByAppendingPathComponent:file];
}

+ (NSArray*)subpathsAtPath:(NSString*)path {
	NSFileManager *objFileManager = [NSFileManager defaultManager];
	return [objFileManager subpathsAtPath:path];
}

+ (NSArray *)contentsOfDirectoryAtPath:(NSString *)path {
	NSFileManager *objFileManager = [NSFileManager defaultManager];
	return [objFileManager contentsOfDirectoryAtPath:path error:nil];
}

+ (BOOL)verifyIfFileExistInBundle:(NSString*)filename {
    NSFileManager *fileManager = [NSFileManager defaultManager];
	return [fileManager fileExistsAtPath:[self retourneBundlePathForFile:filename]];
}

+ (BOOL)verifyIfFileExistInDocument:(NSString*)filename {
    NSFileManager *fileManager = [NSFileManager defaultManager];
	return [fileManager fileExistsAtPath:[self retourneDocumentPath:filename]];
}

+ (BOOL)verifyIfFileExistAtPath:(NSString*)path {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	return [fileManager fileExistsAtPath:path];
}

+ (NSString*)getFilenameFromURL:(NSURL*)url {
	NSString *filename = [url absoluteString];
	//int monint = [filename intValue];
	NSArray *decoupeur = [filename componentsSeparatedByString:@"/"];
	filename = [decoupeur lastObject];
	//NSLog(@"decoupeur : %@",filename);
	return filename;
}

+ (NSString*)getFilenameFromStringURL:(NSString*)url {
	NSString *filename = url;
	NSArray *decoupeur = [filename componentsSeparatedByString:@"/"];
	filename = [decoupeur lastObject];
	//NSLog(@"decoupeur : %@",filename);
	return filename;
}

+ (NSString*)getFilenameWithoutExtension:(NSString*)filename {
	NSString *file = filename;
	NSArray *decoupeur = [file componentsSeparatedByString:@"."];
	NSString *old_ext = [decoupeur lastObject];
	file = [file substringToIndex:[file length]-[old_ext length]-1];
	return file;
}

+ (NSString*)getFilenameWithNewExtension:(NSString*)filename ext:(NSString*)extension {
	NSString *file = filename;
	NSArray *decoupeur = [file componentsSeparatedByString:@"."];
	NSString *old_ext = [decoupeur lastObject];
	file = [file stringByReplacingOccurrencesOfString:old_ext withString:extension];
	return file;
}

+ (BOOL)moveFile:(NSString*)fileToMove FromPath:(NSString*)from ToDestination:(NSString*)destination {
    // First, test for existence.
    BOOL success; 
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
	
	if (![[from substringFromIndex:[from length]-1] isEqualToString:@"/"]) {
		from = [NSString stringWithFormat:@"%@/",from];
	}
	if (![[destination substringFromIndex:[destination length]-1] isEqualToString:@"/"]) {
		destination = [NSString stringWithFormat:@"%@/",destination];
	}
	
    NSString *fileToMovePath = [NSString stringWithFormat:@"%@%@",from ,fileToMove];
	NSString *destinationPath = [NSString stringWithFormat:@"%@%@",destination,fileToMove];
	
	success = [fileManager fileExistsAtPath:destination];
	
	if (success) 
		[fileManager removeItemAtPath:destinationPath error:&error];
		
	//NSLog(@"moving file %@ to %@",fileToMovePath,destinationPath);
    return [fileManager copyItemAtPath:fileToMovePath toPath:destinationPath error:&error];
	
	
}

+ (BOOL)createEditableCopyOfFileIfNeededWithPath:(NSString*)filePath toPath:(NSString*)destPath {
    // First, test for existence.
    BOOL success; 
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
	
	success = [fileManager fileExistsAtPath:destPath];
	
	if (success) 
		return NO;
	
    return [fileManager copyItemAtPath:filePath toPath:destPath error:&error];
}


+ (BOOL)createEditableCopyOfFileIfNeeded:(NSString*)fileToCopy {
    // First, test for existence.
    BOOL success; 
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *writableDBPath = [self retourneDocumentPath:fileToCopy];
	
	success = [fileManager fileExistsAtPath:writableDBPath];
	
#ifdef TEST
	if (success) [fileManager removeItemAtPath:writableDBPath error:&error];
#else
	if (success) return NO;
#endif
	
	//NSLog(@"copy ok");
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [self retourneBundlePathForFile:[NSFileUtility getFilenameFromStringURL:fileToCopy]];
    return [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
}

+ (void)createEditableCopyOfFileIfNeeded:(NSString*)fileToCopy withOtherFilename:(NSString*)filename {
    // First, test for existence.
    BOOL success; 
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
	
	success = [fileManager fileExistsAtPath:[self retourneDocumentPath:filename]];
	
#ifdef TEST
	if (success) [fileManager removeItemAtPath:[self retourneDocumentPath:filename] error:&error];
#else
	if (success) return;
#endif
	
	//NSLog(@"file copied : %@ to : %@",fileToCopy,filename);
    
	NSString *writableDBPath	= [self retourneDocumentPath:filename];
    NSString *defaultDBPath		= [self retourneBundlePathForFile:fileToCopy];
	
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
		//NSLog(@"error %@",fileToCopy);
		//NSLog(@"error %@",filename);
        //NSAssert1(0, @"Failed to create writable file file with message '%@'.", [error localizedDescription]);
    }
}

+ (void)createEditableDictionaryPlistIfNeeded:(NSString*)filename {
    BOOL success; 
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *writableDBPath = [self retourneDocumentPath:filename];	
	success = [fileManager fileExistsAtPath:writableDBPath];
	
	if (success) return;
	
	//NSLog(@"file created : %@",filename);

	NSMutableDictionary *mesFichiersDoc = [[NSMutableDictionary alloc] init];
	[mesFichiersDoc writeToFile:writableDBPath atomically:YES];
	[mesFichiersDoc release];
}

+ (void)removeFileFromDocuments:(NSString*)filename {
	NSMutableDictionary *mesFichiersDoc = [[NSMutableDictionary alloc] initWithContentsOfFile:[self retourneDocumentPath:@"FileList.plist"]];
	[mesFichiersDoc removeObjectForKey:filename];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
	[fileManager removeItemAtPath:[self retourneDocumentPath:filename] error:&error];
	
	[mesFichiersDoc writeToFile:[self retourneDocumentPath:@"FileList.plist"] atomically:YES];
	[mesFichiersDoc release];
}

+ (void)writeFileToList:(NSString*)filename {
	//[self createEditableFileIfNeeded:@"FileList.plist"];
	NSMutableDictionary *mesFichiersDoc = [[NSMutableDictionary alloc] initWithContentsOfFile:[self retourneDocumentPath:@"FileList.plist"]];
	[mesFichiersDoc setObject:@" " forKey:filename];
	[mesFichiersDoc writeToFile:[self retourneDocumentPath:@"FileList.plist"] atomically:YES];
	[mesFichiersDoc release];
}

+ (void)removeUnusedFiles:(NSDictionary*)newlist {
	NSMutableDictionary *mesFichiersDoc = [[NSMutableDictionary alloc] initWithContentsOfFile:[self retourneDocumentPath:@"FileList.plist"]];
	NSArray *allkeys = [mesFichiersDoc allKeys];
	for (int i = 0; i < [allkeys count]; i++) {
		NSString *filename = [allkeys objectAtIndex:i];
		if([newlist objectForKey:filename] == nil) {
			[self removeFileFromDocuments:filename];
			//NSLog(@"file removed : %@",filename);
		}
	}
	[mesFichiersDoc release];
}

+ (CGFloat)DegreesToRadians:(CGFloat)degrees {
	return degrees * M_PI / 180;
}
+ (CGFloat)RadiansToDegrees:(CGFloat)radians {
	return (radians * 180) / M_PI;
}

+ (float)getAngle:(CGPoint)v1 :(CGPoint)v2
{
	
	double v1Magnitude = sqrt( (v1.x * v1.x) + (v1.y * v1.y) );
	double v2Magnitude = sqrt( (v2.x * v2.x) + (v2.y * v2.y) );
	
	double v1Dotv2 = v1.x * v2.x + v1.y * v2.y;
	double v1Crossv2 = v1.x * v2.y - v1.y * v2.x;
	
	double angle = acos( v1Dotv2/(v1Magnitude * v2Magnitude) );
	
	if( v1Crossv2 > 0 )
		angle = -angle;
	
	return angle;	
}

+ (CGPoint)pointSurCercleDeRayon:(float)rayon AvecCentre:(CGPoint)centre EtAngle:(float)angle EtDecalage:(float)decalage {
	float centreX = rayon;//centre.x;
	float centreY = rayon;//centre.y;
	
	float angleRadian = angle - decalage;
	
	float positionXRecherche = centreX + (cos(angleRadian) * rayon);
	
	float positionYRecherche = centreY - (sin(angleRadian) * rayon);
	
	return CGPointMake(positionXRecherche, positionYRecherche);
}

CGPoint quatreCoin[4];

+ (bool)CGRectIntersectsCircle:(CGPoint)centre :(CGFloat)radius :(CGRect)rect {
	
	quatreCoin[0] = CGPointMake(rect.origin.x, rect.origin.y);
	quatreCoin[1] = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
	quatreCoin[2] = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
	quatreCoin[3] = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
	
	float distX, distY, hypo;
	for (int i = 0; i < 4; i++) {
		distX = abs(centre.x - quatreCoin[i].x);
		distY = abs(centre.y - quatreCoin[i].y);
		hypo = sqrt((distX*distX)+(distY*distY));
		if (hypo <= radius) {
			return YES;
		}
	}
	return NO;
}

@end
