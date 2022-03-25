//
//  File.swift
//  
//
//  Created by 老房东 on 2022-03-19.
//

import Foundation

import class Foundation.Bundle

private class CurrentBundleFinder {}

extension Foundation.Bundle {
    /// Returns the resource bundle associated with the current Swift module.
    static var swiftUIPreviewsCompatibleModule: Bundle = {
#if DEBUG
        let bundleNameIOS = "LocalPackages_CommomLibrary"
        let bundleNameMacOs = "CommomLibrary_CommomLibrary"
        
        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,
            
            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: CurrentBundleFinder.self).resourceURL,
            
            // For command-line tools.
            Bundle.main.bundleURL,
            
            // Bundle should be present here when running previews from a different package (this is the path to "…/Debug-iphonesimulator/").
            Bundle(for: CurrentBundleFinder.self).resourceURL?.deletingLastPathComponent().deletingLastPathComponent()
                .deletingLastPathComponent(),
            Bundle(for: CurrentBundleFinder.self).resourceURL?.deletingLastPathComponent().deletingLastPathComponent(),
        ]
        
        for candidate in candidates {
            let bundlePathiOS = candidate?.appendingPathComponent(bundleNameIOS + ".bundle")
            let bundlePath = candidate?.appendingPathComponent(bundleNameMacOs + ".bundle")
            
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }else if let bundle = bundlePathiOS.flatMap(Bundle.init(url:)){
                return bundle
            }
        }
        fatalError("unable to find bundle named LocalPackages_CommomLibrary")
#else
        return Bundle.module
#endif
    }()
}
