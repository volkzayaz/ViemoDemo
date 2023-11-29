# ViemoDemo

1. Perosnal access token 240938cd6b7544b3986082d58f007dff. If needed can be swapped in AppDelegate line #25
2. App uses RxDataSource to populate videoCells, RxCocoa to bind text input, RxSwift for networking/error handling
3. I used a simple collection of personal APIs I used over the years to simplify some of the tedious/usual iOS tasks like setting image from URL, image caching, saving Codable objects to disk, mutating BehaviourRelay... all of them are located in Toolbox SPM. All of those were created by me over the years and we can discuss them if neccessary.
4. I used Alamofire integration over the URL session for simpler Network mapping and error handling. The exact mapping can be found in BaseRequest.swift file of the Toolbox. 
5. I spent about 3 hours on the project with close to 2 hours of making sense of Vimeo APIs. I've never used it and it was not clear why video request takes about 10 seconds to complete. I looked for ways to optimise it, but eventually gave up, when seeing that it takes same 10 seconds if performed from their official playground: https://developer.vimeo.com/api/reference/videos#search_videos
    
    Additionally it was not clear why video stream was not directly available on /videos API and it was a bit unclear for me how to extract it from existing metadata.
