//
//  main.m
//  MFFileToHex
//
//  Created by mao on 10/25/15.
//  Copyright © 2015 Maokebing. All rights reserved.
//

#import <Foundation/Foundation.h>


NSString* Data2String(NSData *data) {
	NSString* string = data.description;
	
	string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
	string = [string stringByReplacingOccurrencesOfString:@"<" withString:@""];
	string = [string stringByReplacingOccurrencesOfString:@">" withString:@""];
	
	return string;
}

BOOL File2Hex(NSString* inFilePath, NSString* outFilePath, NSError **error) {
	if (![[NSFileManager defaultManager] fileExistsAtPath:inFilePath]) {
		*error = [NSError errorWithDomain:[NSString stringWithFormat:@"%@ not exist!", inFilePath] code:-1 userInfo:nil];
		return false;
	}
	
	NSData* data = [NSData dataWithContentsOfFile:inFilePath];
	NSString* string = Data2String(data);
	return [string writeToFile:outFilePath atomically:YES encoding:NSUTF8StringEncoding error:error];
}

int main(int argc, const char * argv[]) {
	@autoreleasepool {
		if (argc <= 2) {
			printf("usage: file2hex file hex_file\n");
			return 0;
		}
		
		NSString* fileIn = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
		NSString* fileOut = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
		NSError* error = nil;
		
		BOOL sucess = File2Hex(fileIn, fileOut, &error);
		
		if (!sucess) {
			printf("%s\n", [error.localizedDescription cStringUsingEncoding:NSUTF8StringEncoding]);
		}

	}
    return 0;
}
