
import Foundation

print("start")

//let url = Bundle.main.url(forResource: "test", withExtension:"mp4")
let url = URL(fileURLWithPath: "/Users/tmori/temp/metal/sample-movie/1min/test.mp4")
let m = MovAna()

let startTime = CFAbsoluteTimeGetCurrent()
m.processMovie(url: url)
let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
print(timeElapsed)

print("end")
