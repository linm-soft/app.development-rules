# Script to recreate project.pbxproj file for SmartCallBlock
$projectContent = @'
// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 56;
	objects = {

/* Begin PBXBuildFile section */
		7B4F1C2A2C1B8F9D00123456 /* SmartCallBlockApp.swift in Sources */ = {isa = PBXBuildFile; fileRef = 7B4F1C292C1B8F9D00123456 /* SmartCallBlockApp.swift */; };
		7B4F1C2C2C1B8F9D00123456 /* ContentView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 7B4F1C2B2C1B8F9D00123456 /* ContentView.swift */; };
		7B4F1C2E2C1B8F9E00123456 /* Assets.xcassets in Resources */ = {isa = PBXBuildFile; fileRef = 7B4F1C2D2C1B8F9E00123456 /* Assets.xcassets */; };
		7B4F1C312C1B8F9E00123456 /* Preview Assets.xcassets in Resources */ = {isa = PBXBuildFile; fileRef = 7B4F1C302C1B8F9E00123456 /* Preview Assets.xcassets */; };
		7B4F1C332C1B8F9E00123456 /* DataModel.xcdatamodeld in Sources */ = {isa = PBXBuildFile; fileRef = 7B4F1C322C1B8F9E00123457 /* DataModel.xcdatamodeld */; };
		7B4F1C3A2C1B904800123456 /* CallBlockManager.swift in Sources */ = {isa = PBXBuildFile; fileRef = 7B4F1C392C1B904800123456 /* CallBlockManager.swift */; };
		7B4F1C3C2C1B905600123456 /* AddNumberView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 7B4F1C3B2C1B905600123456 /* AddNumberView.swift */; };
		7B4F1C3E2C1B906400123456 /* SettingsView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 7B4F1C3D2C1B906400123456 /* SettingsView.swift */; };
		7B4F1C402C1B907200123456 /* CallHistoryView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 7B4F1C3F2C1B907200123456 /* CallHistoryView.swift */; };
		7B4F1C422C1B908000123456 /* StatisticsView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 7B4F1C412C1B908000123456 /* StatisticsView.swift */; };
		7B4F1C502C1B911600123456 /* CallDirectoryHandler.swift in Sources */ = {isa = PBXBuildFile; fileRef = 7B4F1C4F2C1B911600123456 /* CallDirectoryHandler.swift */; };
		7B4F1C522C1B912400123456 /* CallDirectoryExtension.appex in Embed Foundation Extensions */ = {isa = PBXBuildFile; fileRef = 7B4F1C4D2C1B910500123456 /* CallDirectoryExtension.appex */; settings = {ATTRIBUTES = (RemoveHeadersOnCopy, ); }; };
/* End PBXBuildFile section */

/* Begin PBXContainerItemProxy section */
		7B4F1C542C1B912400123456 /* PBXContainerItemProxy */ = {
			isa = PBXContainerItemProxy;
			containerPortal = 7B4F1C1E2C1B8F9D00123456 /* Project object */;
			proxyType = 1;
			remoteGlobalIDString = 7B4F1C4C2C1B910500123456;
			remoteInfo = CallDirectoryExtension;
		};
/* End PBXContainerItemProxy section */

/* Begin PBXCopyFilesBuildPhase section */
		7B4F1C562C1B912400123456 /* Embed Foundation Extensions */ = {
			isa = PBXCopyFilesBuildPhase;
			buildActionMask = 2147483647;
			dstPath = "";
			dstSubfolderSpec = 13;
			files = (
				7B4F1C522C1B912400123456 /* CallDirectoryExtension.appex in Embed Foundation Extensions */,
			);
			name = "Embed Foundation Extensions";
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXCopyFilesBuildPhase section */

/* Begin PBXFileReference section */
		7B4F1C262C1B8F9D00123456 /* SmartCallBlock.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = SmartCallBlock.app; sourceTree = BUILT_PRODUCTS_DIR; };
		7B4F1C292C1B8F9D00123456 /* SmartCallBlockApp.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = SmartCallBlockApp.swift; sourceTree = "<group>"; };
		7B4F1C2B2C1B8F9D00123456 /* ContentView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ContentView.swift; sourceTree = "<group>"; };
		7B4F1C2D2C1B8F9E00123456 /* Assets.xcassets */ = {isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Assets.xcassets; sourceTree = "<group>"; };
		7B4F1C302C1B8F9E00123456 /* Preview Assets.xcassets */ = {isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = "Preview Assets.xcassets"; sourceTree = "<group>"; };
		7B4F1C322C1B8F9E00123457 /* DataModel.xcdatamodel */ = {isa = PBXFileReference; lastKnownFileType = wrapper.xcdatamodel; path = DataModel.xcdatamodel; sourceTree = "<group>"; };
		7B4F1C372C1B8F9E00123456 /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
		7B4F1C382C1B8F9E00123456 /* SmartCallBlock.entitlements */ = {isa = PBXFileReference; lastKnownFileType = text.plist.entitlements; path = SmartCallBlock.entitlements; sourceTree = "<group>"; };
		7B4F1C392C1B904800123456 /* CallBlockManager.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = CallBlockManager.swift; sourceTree = "<group>"; };
		7B4F1C3B2C1B905600123456 /* AddNumberView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = AddNumberView.swift; sourceTree = "<group>"; };
		7B4F1C3D2C1B906400123456 /* SettingsView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = SettingsView.swift; sourceTree = "<group>"; };
		7B4F1C3F2C1B907200123456 /* CallHistoryView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = CallHistoryView.swift; sourceTree = "<group>"; };
		7B4F1C412C1B908000123456 /* StatisticsView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = StatisticsView.swift; sourceTree = "<group>"; };
		7B4F1C4D2C1B910500123456 /* CallDirectoryExtension.appex */ = {isa = PBXFileReference; explicitFileType = "wrapper.app-extension"; includeInIndex = 0; path = CallDirectoryExtension.appex; sourceTree = BUILT_PRODUCTS_DIR; };
		7B4F1C4F2C1B911600123456 /* CallDirectoryHandler.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = CallDirectoryHandler.swift; sourceTree = "<group>"; };
		7B4F1C512C1B912400123456 /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		7B4F1C232C1B8F9D00123456 /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
		7B4F1C4A2C1B910500123456 /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		7B4F1C1D2C1B8F9D00123456 = {
			isa = PBXGroup;
			children = (
				7B4F1C282C1B8F9D00123456 /* SmartCallBlock */,
				7B4F1C4E2C1B911600123456 /* CallDirectoryExtension */,
				7B4F1C272C1B8F9D00123456 /* Products */,
			);
			sourceTree = "<group>";
		};
		7B4F1C272C1B8F9D00123456 /* Products */ = {
			isa = PBXGroup;
			children = (
				7B4F1C262C1B8F9D00123456 /* SmartCallBlock.app */,
				7B4F1C4D2C1B910500123456 /* CallDirectoryExtension.appex */,
			);
			name = Products;
			sourceTree = "<group>";
		};
		7B4F1C282C1B8F9D00123456 /* SmartCallBlock */ = {
			isa = PBXGroup;
			children = (
				7B4F1C292C1B8F9D00123456 /* SmartCallBlockApp.swift */,
				7B4F1C2B2C1B8F9D00123456 /* ContentView.swift */,
				7B4F1C392C1B904800123456 /* CallBlockManager.swift */,
				7B4F1C3B2C1B905600123456 /* AddNumberView.swift */,
				7B4F1C3D2C1B906400123456 /* SettingsView.swift */,
				7B4F1C3F2C1B907200123456 /* CallHistoryView.swift */,
				7B4F1C412C1B908000123456 /* StatisticsView.swift */,
				7B4F1C2D2C1B8F9E00123456 /* Assets.xcassets */,
				7B4F1C372C1B8F9E00123456 /* Info.plist */,
				7B4F1C382C1B8F9E00123456 /* SmartCallBlock.entitlements */,
				7B4F1C322C1B8F9E00123457 /* DataModel.xcdatamodeld */,
				7B4F1C2F2C1B8F9E00123456 /* Preview Content */,
			);
			path = SmartCallBlock;
			sourceTree = "<group>";
		};
		7B4F1C2F2C1B8F9E00123456 /* Preview Content */ = {
			isa = PBXGroup;
			children = (
				7B4F1C302C1B8F9E00123456 /* Preview Assets.xcassets */,
			);
			path = "Preview Content";
			sourceTree = "<group>";
		};
		7B4F1C4E2C1B911600123456 /* CallDirectoryExtension */ = {
			isa = PBXGroup;
			children = (
				7B4F1C4F2C1B911600123456 /* CallDirectoryHandler.swift */,
				7B4F1C512C1B912400123456 /* Info.plist */,
			);
			path = CallDirectoryExtension;
			sourceTree = "<group>";
		};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		7B4F1C252C1B8F9D00123456 /* SmartCallBlock */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = 7B4F1C3B2C1B8F9E00123458 /* Build configuration list for PBXNativeTarget "SmartCallBlock" */;
			buildPhases = (
				7B4F1C222C1B8F9D00123456 /* Sources */,
				7B4F1C232C1B8F9D00123456 /* Frameworks */,
				7B4F1C242C1B8F9D00123456 /* Resources */,
				7B4F1C562C1B912400123456 /* Embed Foundation Extensions */,
			);
			buildRules = (
			);
			dependencies = (
				7B4F1C542C1B912400123456 /* PBXTargetDependency */,
			);
			name = SmartCallBlock;
			productName = SmartCallBlock;
			productReference = 7B4F1C262C1B8F9D00123456 /* SmartCallBlock.app */;
			productType = "com.apple.product-type.application";
		};
		7B4F1C4C2C1B910500123456 /* CallDirectoryExtension */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = 7B4F1C552C1B912400123456 /* Build configuration list for PBXNativeTarget "CallDirectoryExtension" */;
			buildPhases = (
				7B4F1C492C1B910500123456 /* Sources */,
				7B4F1C4A2C1B910500123456 /* Frameworks */,
				7B4F1C4B2C1B910500123456 /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = CallDirectoryExtension;
			productName = CallDirectoryExtension;
			productReference = 7B4F1C4D2C1B910500123456 /* CallDirectoryExtension.appex */;
			productType = "com.apple.product-type.app-extension";
		};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		7B4F1C1E2C1B8F9D00123456 /* Project object */ = {
			isa = PBXProject;
			attributes = {
				BuildIndependentTargetsInParallel = 1;
				LastSwiftUpdateCheck = 1500;
				LastUpgradeCheck = 1500;
				TargetAttributes = {
					7B4F1C252C1B8F9D00123456 = {
						CreatedOnToolsVersion = 15.0;
					};
					7B4F1C4C2C1B910500123456 = {
						CreatedOnToolsVersion = 15.0;
					};
				};
			};
			buildConfigurationList = 7B4F1C212C1B8F9D00123456 /* Build configuration list for PBXProject "SmartCallBlock" */;
			compatibilityVersion = "Xcode 14.0";
			developmentRegion = en;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				Base,
			);
			mainGroup = 7B4F1C1D2C1B8F9D00123456;
			productRefGroup = 7B4F1C272C1B8F9D00123456 /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				7B4F1C252C1B8F9D00123456 /* SmartCallBlock */,
				7B4F1C4C2C1B910500123456 /* CallDirectoryExtension */,
			);
		};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		7B4F1C242C1B8F9D00123456 /* Resources */ = {
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				7B4F1C312C1B8F9E00123456 /* Preview Assets.xcassets in Resources */,
				7B4F1C2E2C1B8F9E00123456 /* Assets.xcassets in Resources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
		7B4F1C4B2C1B910500123456 /* Resources */ = {
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		7B4F1C222C1B8F9D00123456 /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				7B4F1C2C2C1B8F9D00123456 /* ContentView.swift in Sources */,
				7B4F1C332C1B8F9E00123456 /* DataModel.xcdatamodeld in Sources */,
				7B4F1C3A2C1B904800123456 /* CallBlockManager.swift in Sources */,
				7B4F1C3C2C1B905600123456 /* AddNumberView.swift in Sources */,
				7B4F1C3E2C1B906400123456 /* SettingsView.swift in Sources */,
				7B4F1C402C1B907200123456 /* CallHistoryView.swift in Sources */,
				7B4F1C422C1B908000123456 /* StatisticsView.swift in Sources */,
				7B4F1C2A2C1B8F9D00123456 /* SmartCallBlockApp.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
		7B4F1C492C1B910500123456 /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				7B4F1C502C1B911600123456 /* CallDirectoryHandler.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXSourcesBuildPhase section */

/* Begin PBXTargetDependency section */
		7B4F1C542C1B912400123456 /* PBXTargetDependency */ = {
			isa = PBXTargetDependency;
			target = 7B4F1C4C2C1B910500123456 /* CallDirectoryExtension */;
			targetProxy = 7B4F1C544C1B912400123456 /* PBXContainerItemProxy */;
		};
/* End PBXTargetDependency section */

/* Begin XCBuildConfiguration section */
		7B4F1C1F2C1B8F9D00123456 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_TESTABILITY = YES;
				ENABLE_USER_SCRIPT_SANDBOXING = YES;
				GCC_C_LANGUAGE_STANDARD = gnu17;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_OPTIMIZATION_LEVEL = 0;
				GCC_PREPROCESSOR_DEFINITIONS = (
					"DEBUG=1",
					"$(inherited)",
				);
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				LOCALIZATION_PREFERS_STRING_CATALOGS = YES;
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				MTL_FAST_MATH = YES;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = iphoneos;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = "DEBUG $(inherited)";
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
			};
			name = Debug;
		};
		7B4F1C202C1B8F9D00123456 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_NS_ASSERTIONS = NO;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_USER_SCRIPT_SANDBOXING = YES;
				GCC_C_LANGUAGE_STANDARD = gnu17;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				LOCALIZATION_PREFERS_STRING_CATALOGS = YES;
				MTL_ENABLE_DEBUG_INFO = NO;
				MTL_FAST_MATH = YES;
				SDKROOT = iphoneos;
				SWIFT_COMPILATION_MODE = wholemodule;
				VALIDATE_PRODUCT = YES;
			};
			name = Release;
		};
		7B4F1C3F2C1B8F9E00123458 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_ENTITLEMENTS = SmartCallBlock/SmartCallBlock.entitlements;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_ASSET_PATHS = "\"SmartCallBlock/Preview Content\"";
				DEVELOPMENT_TEAM = "";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_FILE = SmartCallBlock/Info.plist;
				INFOPLIST_KEY_NSContactsUsageDescription = "This app needs access to contacts to identify incoming calls";
				INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
				INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.smartcallblock.app;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			};
			name = Debug;
		};
		7B4F1C402C1B8F9E00123458 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_ENTITLEMENTS = SmartCallBlock/SmartCallBlock.entitlements;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_ASSET_PATHS = "\"SmartCallBlock/Preview Content\"";
				DEVELOPMENT_TEAM = "";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_FILE = SmartCallBlock/Info.plist;
				INFOPLIST_KEY_NSContactsUsageDescription = "This app needs access to contacts to identify incoming calls";
				INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
				INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				INFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.smartcallblock.app;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			};
			name = Release;
		};
		7B4F1C572C1B912400123456 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = "";
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_FILE = CallDirectoryExtension/Info.plist;
				INFOPLIST_KEY_CFBundleDisplayName = "Smart Call Block Extension";
				INFOPLIST_KEY_NSHumanReadableCopyright = "";
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
					"@executable_path/../../Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.smartcallblock.app.extension;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SKIP_INSTALL = YES;
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			};
			name = Debug;
		};
		7B4F1C582C1B912400123456 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = "";
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_FILE = CallDirectoryExtension/Info.plist;
				INFOPLIST_KEY_CFBundleDisplayName = "Smart Call Block Extension";
				INFOPLIST_KEY_NSHumanReadableCopyright = "";
				IPHONEOS_DEPLOYMENT_TARGET = 17.0;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
					"@executable_path/../../Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.smartcallblock.app.extension;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SKIP_INSTALL = YES;
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			};
			name = Release;
		};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		7B4F1C212C1B8F9D00123456 /* Build configuration list for PBXProject "SmartCallBlock" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				7B4F1C1F2C1B8F9D00123456 /* Debug */,
				7B4F1C202C1B8F9D00123456 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		7B4F1C3B2C1B8F9E00123458 /* Build configuration list for PBXNativeTarget "SmartCallBlock" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				7B4F1C3F2C1B8F9E00123458 /* Debug */,
				7B4F1C402C1B8F9E00123458 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		7B4F1C552C1B912400123456 /* Build configuration list for PBXNativeTarget "CallDirectoryExtension" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				7B4F1C572C1B912400123456 /* Debug */,
				7B4F1C582C1B912400123456 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
/* End XCConfigurationList section */

/* Begin XCVersionGroup section */
		7B4F1C322C1B8F9E00123457 /* DataModel.xcdatamodeld */ = {
			isa = XCVersionGroup;
			children = (
				7B4F1C322C1B8F9E00123457 /* DataModel.xcdatamodel */,
			);
			currentVersion = 7B4F1C322C1B8F9E00123457 /* DataModel.xcdatamodel */;
			path = DataModel.xcdatamodeld;
			sourceTree = "<group>";
			versionGroupType = wrapper.xcdatamodel;
		};
/* End XCVersionGroup section */
	};
	rootObject = 7B4F1C1E2C1B8F9D00123456 /* Project object */;
}
'@

$projectPath = "D:\MyRepo\AI-App\Source\smart-call-block\IOS\SmartCallBlock.xcodeproj\project.pbxproj"

# Remove existing file
Remove-Item $projectPath -Force -ErrorAction SilentlyContinue

# Write new content
$projectContent | Out-File -FilePath $projectPath -Encoding UTF8 -NoNewline

Write-Host "Project file recreated successfully!"